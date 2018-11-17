class Api::VendoritemController < ActionController::Base

  def getitemlist
    vendoritem_columns = ['id','cost','upc','created_at','vendorsku','packcount']
    express_columns = ['profit','margin','salespermonth'];
    notsearch_columns = ['packcost']

    start = params[:iDisplayStart].to_i
    limit = params[:iDisplayLength].to_i
    vendor_id = params[:vendor]

    inventories = Vendoritem.where('vendor_id = ?',vendor_id).joins(:vendorasin);
    # inventories = Vendoritem.all
    total = inventories.count

    sort_columnIndex = params[:iSortCol_0].to_i;
    sort_columnName = params["mDataProp_#{sort_columnIndex}"]

    sort_order = params[:sSortDir_0]


    
    iColumns = params[:iColumns].to_i

    i=0
    true_search = ""

    search = params["sSearch"]
    unless params["sSearch"].nil? || params["sSearch"] == ''
      # inventories = inventories.joins(:vendorasin).where(:vendorasins => {:upc like "%#{search}%"}).or(inventories.where(:vendorasins => {:asin like "%#{search}%"}))
      inventories = inventories.where("vendorasins.asin like :l_search or vendoritems.upc like :l_search or vendorasins.name like :l_search", {:l_search =>"%#{search}%"})
    end

    while i < iColumns do
      search = params["sSearch_#{i}"]
      unless search.nil? || search == ''
        true_search = search
        search_column = params["mDataProp_#{i}"]

        unless notsearch_columns.include? search_column
          if vendoritem_columns.include? search_column
            # inventories = inventories.where("cast(vendoritems.#{search_column} AS text) LIKE :l_name",{:l_name => "%#{search}%"}) unless search.blank?
            inventories = inventories.where("vendoritems.#{search_column} LIKE :l_name",{:l_name => "%#{search}%"}) unless search.blank?
          elsif express_columns.include? search_column
            exp = search[0]
            search[0] = ''
            inventories = inventories.number_compare(exp,search, search_column)
          else            
            inventories = inventories.where("vendorasins.#{search_column} LIKE :l_name",{:l_name => "%#{search}%"}) unless search.blank?
          end
        end
       
      end
      i = i + 1
    end
    

    if sort_columnName == 'margin'
      inventories = inventories.order("(vendorasins.buyboxprice-cost-vendorasins.totalfbafee) / vendoritems.cost #{sort_order}")
      # inventories = inventories.order("vendoritems.margin #{sort_order}")
      filtered = inventories.count
      inventories =inventories.limit(limit).offset(start)
    elsif sort_columnName == 'profit'
      inventories = inventories.order("vendorasins.buyboxprice-cost-vendorasins.totalfbafee #{sort_order}")
      # inventories = inventories.order("vendoritems.margin #{sort_order}")
      filtered = inventories.count
      inventories =inventories.limit(limit).offset(start)
    elsif sort_columnName == 'packcost'
      inventories = inventories.order("vendoritems.cost*vendoritems.packcount #{sort_order}")
      filtered = inventories.count
      inventories =inventories.limit(limit).offset(start)
    else
      if vendoritem_columns.include? sort_columnName
        inventories = inventories.order("vendoritems.#{sort_columnName} #{sort_order}")
        filtered = inventories.count
        inventories =inventories.limit(limit).offset(start)
      else
        inventories = inventories.order("vendorasins.#{sort_columnName} #{sort_order}")
        filtered = inventories.count
        inventories =inventories.limit(limit).offset(start)    
      end
    end
    render json: {'aaData'=>inventories,"iTotalRecords": total,"iTotalDisplayRecords": filtered}
  end

end

# query = {name: 'a', asin: 'b'}

# @items = VendorItem.all
# query.each do |key, q|
#   @items = @items.where("? like ?", key, q)

# end