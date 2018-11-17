require 'net/http'
require 'net/ftp'
require 'uri'
require 'filesize'
require 'saxerator'
require 'no_proxy_fix'


class SkynetsController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :authenticate_user!, only: [:new, :create, :index, :show, :download, :history]
  skip_before_action :verify_authenticity_token, :only => [:updateskynetstatus, :testxml]
  before_action :s3_bucket_url, only: [:new, :create, :updateskynetstatus, :download, :testxml]

  skip_params_parsing ['testxml','/skynets/testxml']
  def new    
    @vendor_id = params[:vendor]

    if @vendor_id.nil? || @vendor_id.empty?
      if current_user.get_vendors.present?
        @vendor_id = current_user.get_vendors.first.id
      else
        redirect_to vendors_path(:user => current_user), :flash => { :notice => "Please create Vendor first." }
      end
    end

    @vendoritems = nil
    @skynet = Skynet.new
    @row = ['None']
    @tempfile = params[:file]
    @name = params[:name]
    @file_type = params[:file_type]
    @file_size = params[:file_size]

    unless !@tempfile || @tempfile.blank?
      obj = S3_BUCKET.object("uploads/#{@tempfile}")
      case File.extname(@tempfile)
        when ".csv" then data = Roo::CSV.new(obj.public_url, csv_options: {encoding: Encoding::ISO_8859_1, :row_sep => :auto, :force_quotes => true})
        when ".xls" then data = Roo::Excel.new(obj.public_url)
        when ".xlsx" then data = Roo::Excelx.new(obj.public_url)
        else raise "Unknown file type: #{@name}"
      end
      @row = data.row(1)
      if @row == false
        @row = ['None']
        @name = "File format is not supported."
      else
        @row.unshift("None")  
      end
    end

    api_key_params = {
        "SellerId": "string",
        "MarketplaceId": current_user.company_id,
        "AccountName": "string",
        "AuthenticationToken": "string",
        "UserId": current_user.id,
        "MWSKey": "string",
        "MWSSecret": "string",
        "AWSKey": ENV['AWS_ACCESS_KEY_ID'],
        "AWSSecret": ENV['AWS_SECRET_ACCESS_KEY'],
        "Enabled": true
      }
    # user_api_key = create_api_key(api_key_params.to_json)

    if params[:vendors_all] == 'all'
      @skynets = Skynet.where(:user_id => current_user.id).order('created_at DESC')
    else
      @skynets = Skynet.where(:user_id => current_user.id).order('created_at DESC').limit(4)
    end

    if params[:delete_vendors] == 'all'
      vendoritems = Vendoritem.where(:vendor_id => @vendor_id)
      if vendoritems.empty? || vendoritems.blank?
        flash[:error] = "There is no items to delete."
        redirect_to :back
      else
        vendoritems.destroy_all
        # vendoritems.each do |vendoritem|
        #   vendoritem.delete
        # end
        # skynets = Skynet.where(:user_id => current_user.id).destroy_all
        # skynets.each do |skynet|
        #   skynet.delete
        # end
        flash[:success] = "Deleted all items successfully."
        redirect_to vendors_path(:user => current_user.id)
      end
    end
    
    if delete_vendor_item_id = params[:delete_vendor_item_id]
      vendoritem = Vendoritem.find_by id: delete_vendor_item_id
      if vendoritem.nil? || vendoritem.blank?
        flash[:error] = "Vendor(id=#{delete_vendor_item_id}) is blank."
        redirect_to :back
      else
        if vendoritem.delete
          flash[:success] = "Vendor(id=#{delete_vendor_item_id}) was deleted successfully."
          redirect_to new_skynet_path
        else
          flash[:error] = "Failed delete."
          redirect_to :back
        end
      end
    end
  end

  def create
    formtype = params[:form_type]
    if formtype == 'fileupload'
      @file_field = params[:file_field]
      @original_filename = @file_field.original_filename
      restored_filename = Digest::SHA1.hexdigest Time.now.to_s
      extension = File.extname(@original_filename)
      restored_filename = restored_filename + extension
      if extension == '.xls' || extension == '.xlsx'
        obj = S3_BUCKET.put_object({
            key: "uploads/#{restored_filename}",
            body: @file_field.to_io,
            acl: 'public-read'
        })
        @file_type = "File Type : Excel file"
        unpretty_size = obj.content_length
        @file_size = human_size unpretty_size
      elsif extension == '.csv' 
        obj = S3_BUCKET.put_object({
            key: "uploads/#{restored_filename}",
            body: @file_field.to_io,
            acl: 'public-read'
        })
        @file_type = "File Type : text/csv file"
        unpretty_size = obj.content_length
        @file_size = human_size unpretty_size
      else
        flash[:error] = "File format is invalid. Please choose EXCEL and CSV file."
        redirect_to :back
        return
      end      
      redirect_to new_skynet_path :file=>restored_filename, :name=>@original_filename, :file_type => @file_type, :file_size => @file_size

    elsif formtype == 'selectheader'      
      if params[:file_name].blank? || params[:file_name].empty?
        flash[:error] = "Warning! Firstly you must select File."
        redirect_to :back
        return
      else
        @skynet = Skynet.new(skynet_params)
        restored_filename = params[:file_path]
        filename = params[:file_name]

        @skynet.inputfileurl = restored_filename
        @skynet.inputfilename = filename
        @skynet.user_id = current_user.id
        @skynet.vendor_id = params[:vendor_id]
        @skynet.skynet_id_type_id = params[:skynet][:skynet_id_type_id]
        
        id_header = params[:index_header]
        if id_header == "None"
          flash[:notice] = 'Id is not selected.'
          redirect_to :back
          return
        end

        cost_header = params[:cost_header]
        if cost_header == "None"
          flash[:notice] = 'COST is not selected.'
          redirect_to :back
          return
        end

        sku_header = params[:vendorsku_header]
        if sku_header == "None"
          flash[:notice] = 'SKU is not selected.'
          redirect_to :back
          return
        end
        skynetparams = {
            "InputfileUrl"                => 'https://fba-skynets-csvs.s3.amazonaws.com/uploads/'+restored_filename,
            "InputfileName"               => filename, 
            "IdType"                      => params[:skynet][:skynet_id_type_id], 
            "IdHeaderName"                => id_header, 
            "CostHeaderName"              => cost_header, 
            "VendorSKUHeaderName"         => sku_header, 
            "ShippingCostPerLb"           => 0,
            "VendorId"                    => params[:vendor_id],
            "VendorName"                  => @skynet.vendor.name,
            "GetEstimatedSales"           => true,
            "GetIsAmazonSelling"          => true,
            "WebhookForProgress"          => "#{request.protocol}#{request.host}/updateskynetstatus", 
            "NeedBuyboxEligibleOffers"    => true, 
            "WebhookForComplete"          => "#{request.protocol}#{request.host}/testxml"
            # "WebhookForComplete"          => 'https://wraithco.com/mwsoi/import_skynet_to_echelon.php'
          }
        create_skynet_task(skynetparams.to_json)
        @skynet.task_id =  @created['TaskId']
        @skynet.skynet_status_id = 0
        if @created['Message'] == 'An error has occurred.'
          flash[:notice] = 'TaskId was not generated'
          redirect_to :back
          return
        else
          if @skynet.save
            flash[:notice] = "File Upload Processing! We'll email you when its done to check back!"
            redirect_to new_skynet_path

            @email = current_user.email
            @message = "Succesfully uploaded #{params[:file_name]} to FBA.SUPPORT!"
            UserMailer.welcome_email(@email, @message).deliver_later

            return
          else
            flash[:notice] = 'Skynet was not created. Please check the information'
            redirect_to new_skynet_path
            # @email = current_user.email
            # @message = "Sorry. Failed to upload #{params[:file_name]}."
            # UserMailer.welcome_email(@email, @message).deliver_later
            return
          end
        end
      end
    end

  end

  def index
    @skynets = current_user.skynets
    @skynet = Skynet.new
  end

  def show
    filename = params[:name]
  end

  def download
    filename = params[:name]
    out = params[:out]
    if out
      if filename != nil
        send_file (filename), :x_sendfile=>true
      else
        redirect_to :back        
      end
    else 
      send_file File.join('public','skynets',filename), :type=>"text/csv", :x_sendfile=>true
    end
  end

  def history
    # skynets = current_user.skynets
    # respond_to do |fmt|
    #   fmt.html
    #   fmt.json
    # end
    render file: "app/assets/api/datatable.json"
  end

  def updateskynetstatus
    taskid = params[:Id]

    Rails.logger.info "task_id: #{taskid}"
    if taskid.nil?
      progressstatus = "No TaskId#{taskid}"
      
      S3_BUCKET.put_object({
        acl: 'public-read',
        body: progressstatus.to_s,
        key: "uploads/local/import_xml.txt"
      })

      render json: {
          status: 'No Task Id',
          todo_list: params
        }.to_json
    else

      skynet_obj = Skynet.find_by(:task_id => taskid)
      # find_by task_id: taskid
      if  skynet_obj != nil
        skynet_obj.skynet_status_id = params[:ProcessingStatus]
        skynet_obj.outputfileurl = params[:OutputFileUrl]
        skynet_obj.statusmessage = params[:StatusMessage]
        # skynet.percent = params[:StatusPercentage]
        skynet_obj.save

        progressstatus = params[:StatusMessage].to_s
        
        S3_BUCKET.put_object({
          acl: 'public-read',
          body: progressstatus,
          key: "uploads/local/import_xml.txt"
        })

        if skynet_obj.skynet_status_id > 2
          UserMailer.send_skynetnotification(skynet_obj.user, skynet_obj).deliver_now
        end
        render json: {
          status: 'OK',
        }.to_json
      else
        S3_BUCKET.put_object({
          acl: 'public-read',
          body: taskid,
          key: "uploads/local/import_xml.txt"
        })
        render json: {
          status: 'Invalid Task Id',
          todo_list: params
        }.to_json
      end
    end
    
  end

  def testxml
    # puts "*** BEGIN RAW REQUEST HEADERS ***"
    # request.env.each do |header|
    #   puts "HEADER KEY: #{header[0]}"
    #   puts "HEADER VAL: #{header[1]}"
    # end
    # puts "*** END RAW REQUEST HEADERS ***"


    # puts request.raw_post
    if params.empty?
      puts 'params is nil'
      render json: {
        status: 'Error, params is nil'
      }.to_json
    else
      if request.post?

        puts "*** FBA_Request is Valid ****"
        # xml_str = request.body.read.to_s
        # xml_str = request.raw_post.to_s
        
        xml_str = request.env["rack.request.form_vars"].to_s
        xml_str = xml_str.force_encoding('utf-8')

        
        if Rails.env.production?
          S3_BUCKET.put_object({
            acl: 'public-read',
            body: xml_str,
            key: "uploads/local/insert_xml.txt"
          })
        end

        puts "*** ProcessXMLWorker is called ****"

        ProcessXmlWorker.perform_async(xml_str)
      else
        puts 'post is nil'
        render json: {
          status: 'Error, Post is nil'
        }.to_json
      end
    end
    render json: {
        status: request.env["RAW_POST_DATA"]
      }.to_json
  end

  private
  
  def skynet_params
    params.require(:skynet).permit(:skynet_id_type_id, :vendor_id)
  end

  def create_skynet_task(params)
    @created = HTTParty.post(
        'http://skynet2.azurewebsites.net/api/ProfitSourcing/CreateTask', 
        :body => params,
        :headers => {
          'Content-Type' => 'application/json',
          'apikey'       => 'BC6418E5-D86D-4822-BFEE-E154CB145EB5'
        }
      )
  end

  def create_api_key(params)
    @created_api = HTTParty.post(
      'http://skynet2.azurewebsites.net/api/Admin/CreateApiAccount',
      :body => params,
      :headers => {
        'Content-Type' => 'application/json',
        'apikey' => '9A38277F-721A-4473-90B9-9780BC02996A'
        }
      )
  end

  def convertExceltoCSV(excelfile,target)    
    ItemIngestion.to_csv(excelfile,target)
  end

  def s3_bucket_url
    @bucket_url = 'https://fba-skynets-csvs.s3.amazonaws.com/uploads/'
  end

  def csv_content(sheet = nil, separator = ",")
    
    return unless sheet.first_row # The sheet is empty
    result = ''
    1.upto(sheet.last_row) do |row|
      1.upto(sheet.last_column) do |col|
        # TODO: use CSV.generate_line
        result += separator if col > 1
        result += cell_to_csv(row, col, sheet)
        # logger.debug sheet.celltype(row, col)
      end
      result += "\n"
    end

    return result 
  end

  def cell_to_csv(row, col, sheet)
    
    onecell = sheet.cell(row, col)

    return '' if onecell.nil?

    case sheet.celltype(row, col)
    when :string
      %("#{onecell.gsub('"', '""')}") unless onecell.empty?
    when :boolean
      # TODO: this only works for excelx
      onecell = self.sheet_for(sheet).cells[[row, col]].formatted_value
      %("#{onecell.gsub('"', '""').downcase}")
    when :float, :percentage
      if onecell == onecell.to_i
        onecell.to_i.to_s
      else
        onecell.to_s
      end
    when :formula
      case onecell
      when String
        %("#{onecell.gsub('"', '""')}") unless onecell.empty?
      when Integer
        onecell.to_s
      when Float
        if onecell == onecell.to_i
          onecell.to_i.to_s
        else
          onecell.to_s
        end
      when Date, DateTime, TrueClass, FalseClass
        onecell.to_s
      else
        fail "unhandled onecell-class #{onecell.class}"
      end
    when :date, :datetime
      onecell.to_s
    when :time
      integer_to_timestring(onecell)
    when :link
      %("#{onecell.url.gsub('"', '""')}")
    else
      fail "unhandled celltype #{sheet.celltype(row, col)}"
    end || ""
  end

  def sort_column
    Vendoritem.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc, desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def human_size unpretty
    unpretty_size = Filesize.from("#{unpretty} B").pretty
    two_part_hash = unpretty_size.delete("i[]").split
    int_size = two_part_hash[0].to_f.round(2)
    readable_byte_size = "( #{unpretty} bytes )"
    if( two_part_hash[1].length == 1 )
      return readable_byte_size = "File Size : #{unpretty} bytes"
    end
    return "File Size : #{int_size}#{two_part_hash[1][0]}B"
  end
end
