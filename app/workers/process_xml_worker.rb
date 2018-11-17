require 'net/http'
require 'net/ftp'
require 'uri'
require 'filesize'
require 'saxerator'
require 'aws-sdk'

class ProcessXmlWorker
  include Sidekiq::Worker
  
  sidekiq_options :retry => true, :backtrace => true, :queue => :default

  def perform(xml_str)

    puts "Processing xml data in ProcessXmlWorker"

    # if Rails.env.production?
    #   S3_BUCKET.put_object({
    #     acl: 'public-read',
    #     body: xml_str,
    #     key: "uploads/local/insert_xml.txt"
    #   })
    # end
    
    begin
      parser = Saxerator.parser(xml_str)
      vendor_id = 0;
      asd = "Start"
      parser.for_tag("VendorId").each do |items|
        vendor_id = items.to_i
        asd = asd + items.to_s
      end

      # Much faster way to find the VendorId 
      # output = `"grep #{xml_str} " | awk -F">" '{print $2}' | awk -F"<" '{print $1}'` 
      # output = system "grep #{xml_str} 'VendorId' | awk -F\">\" '{print $2}' | awk -F\"<\" '{print $1}'"
      # output = output.to_i
      # vendor_id = output.to_id
      # asd = asd + vendor_id.to_s

      puts "Found vendor id #{vendor_id} from xml file"
    
      if Rails.env.production?
        S3_BUCKET.put_object({
            acl: 'public-read',
            body: asd,
            key: "uploads/local/import_xml.txt"
        })
      end

      if vendor_id > 0

        puts "Finding required vendor"
        vendor = Vendor.find(vendor_id)

        if !vendor.blank?
          parser.for_tag("OutputRowInProcess").each do |item|
            asintext = item['ASIN'].to_s
            if asintext.empty?
              next
            end
            puts asintext

            brandtext = item['Brand'].to_s
            mpn = item['MPN'].to_s
            ean = item['EAN'].to_s
            itemname = item['ItemName'].to_s
            rank = item['SalesRank'].to_s
            rankcategorytext = item['SalesRankCategory'].to_s
            packageqty = item['PackageQuantity'].to_s
            bbp = item['BuyBoxPrice'].to_s

            puts bbp

            
            amazonoffers = item['AmazonOffers'].to_s
            productgroup_text = item['ProductGroup'].to_s
            producttype_text = item['ProductTypeName'].to_s
            itemweight = item['ItemWeight'].to_s
            itemheight = item['ItemHeight'].to_s
            itemwidth = item['ItemWidth'].to_s
            itemlength = item['ItemLength'].to_s
            packageweight = item['PackageWeight'].to_s
            packagelength = item['PackageLength'].to_s
            packagewidth = item['PackageWidth'].to_s
            packageheight = item['PackageHeight'].to_s
            notes = item['Notes'].to_s
            fbafee = item['FBAFee'].to_s
            storagefee = item['StorageFee'].to_s
            variableclosingfee = item['VariableClosingFee'].to_s
            commissionfee = item['CommissionFee'].to_s
            commissionpct = item['CommissionPct'].to_s
            totalfbafee = item['TotalFBAFee'].to_s
            numtotaloffers = item['NumTotalOffers'].to_s
            numfbaoffer = item['NumFBAOffers'].to_s
            numfbmoffer = item['NumMFNOffers'].to_s
            lowestfbaoffer = item['LowestFBAOffer'].to_s
            lowestfbmoffer = item['LowestMFNOffer'].to_s
            purchaseprice = item['PurchasePrice'].to_s
            invalidid = item['InvalidId'].to_s
            estsalespermonth = item['EstSalesPerMonth'].to_s
            isbuyboxfba = item['IsBuyboxFBA'].to_s
            reviewrating = item['ReviewRating'].to_s
            reviews = item['NumReviews'].to_s
            upc = item['UPC'].to_s
            vendorsku =item['VendorSKU'].to_s

            rankcategory = RakedCategory.where(:name => rankcategorytext).first_or_create
            brand = Brand.where(:name => brandtext).first_or_create
            productgroup = ProductGroup.where(:name => productgroup_text).first_or_create
            producttype = ProductType.where(:name => producttype_text).first_or_create

            vendoritem = vendor.vendoritems.where(:asin => asintext).first_or_create

            asin = Vendorasin.where(:asin => asintext).first_or_create

            asin.brand_id= brand.id
            asin.name= itemname                             # vendorasin name : NAME
            asin.salesrank= rank.to_i
            asin.packagequantity= packageqty
            asin.buyboxprice= bbp.to_f                      # vendorasin bbp : BBP
            asin.amazonoffer= amazonoffers.to_i
            asin.totalfbafee = totalfbafee.to_f
            asin.fbafee= fbafee.to_f                             # vendorasin fbafee : FBAfee
            asin.storagefee= storagefee.to_f
            asin.variableclosingfee= variableclosingfee.to_f
            asin.commissionpct= commissionpct.to_i               # vendorasin commissionpct : ComPCT
            asin.commissiionfee= commissionfee.to_f              # vendorasin commissionfee : ComFee
            asin.salespermonth= estsalespermonth.to_i
            asin.totaloffers= numtotaloffers.to_i                # vendorasin totaloffers : OFFER
            asin.fbaoffers= numfbaoffer.to_i                     # vendorasin fbaoffers : FBA
            asin.fbmoffers= numfbmoffer.to_i                     # vendorasin fbmoffers : FBM
            asin.lowestfbaoffer= lowestfbaoffer.to_i
            asin.lowestfbmoffer= lowestfbmoffer.to_i
            
            asin.product_type_id= producttype.id
            asin.ranked_category_id= rankcategory.id
            asin.product_groups_id= productgroup.id
            asin.weight= itemweight.to_f
            asin.length= itemlength.to_f
            asin.width= itemwidth.to_f
            asin.height= itemheight.to_f
            asin.packageweight= packageweight.to_f
            asin.packageheight= packageheight.to_f
            asin.packagewidth= packagewidth.to_f
            asin.packagelength= packagelength.to_f
            asin.notes= notes
            asin.review= reviewrating.to_i
            asin.numreview= reviews.to_i
            asin.ean = ean;
            asin.mpn = mpn;

            if isbuyboxfba == 'true'
              asin.isbuyboxfba = true
            else
              asin.isbuyboxfba = false
            end

            if invalidid == 'true'
              asin.invalidid = true
            else
              asin.invalidid = false
            end

            asin.save

            vendoritem.vendorasin_id = asin.id                      # vendoritem id : ID
            vendoritem.vendortitle = itemname
            vendoritem.upc = upc                                    # vendoritem upc : UPC
            vendoritem.cost = purchaseprice.to_f                                  # vendoritem cost : COST
            vendoritem.vendorsku = vendorsku                        # vendoritem vendorsku : VendorSKU
            vendoritem.packcount = packageqty.to_i
            vendoritem.save!
          end
        else 
          puts "Vendor not found in database"
        end
      end
    rescue Exception => e

      if Rails.env.production?
        S3_BUCKET.put_object({
          acl: 'public-read',
          body: 'Error Occur',
          key: "uploads/local/import_xml.txt"
        })
      end
      puts "Failed worker with exception #{e}"
    end
  end
end

  