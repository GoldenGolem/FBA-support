# == Schema Information
#
# Table name: vendoritems
#
#  id            :integer          not null, primary key
#  cost          :decimal(64, 2)   default(0.0)
#  vendortitle   :text(65535)
#  vendorasin_id :integer
#  vendor_id     :integer
#  asin          :string(255)
#  upc           :string(255)
#  isbn          :string(255)
#  ean           :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  vendorsku     :string(255)      default("")
#  packcount     :integer          default(1)
#
# Indexes
#
#  index_vendoritems_on_vendor_id      (vendor_id)
#  index_vendoritems_on_vendorasin_id  (vendorasin_id)
#

class Vendoritem < ApplicationRecord
  belongs_to :vendorasin

  include PgSearch
  
  accepts_nested_attributes_for :vendorasin, reject_if: proc { |attributes| attributes['name'].blank? }

  pg_search_scope :search_columns,
    :against => {
        :asin => 'A',
        :vendortitle => 'B',
        :upc => 'C',
      },
    :associated_against => {
      :vendor => :name,
    },
    :using => {
      :tsearch => {:prefix => true}
    }

  belongs_to :vendor
  belongs_to :vendorasin


  def profit
    if vendorasin.buyboxprice.nil? || cost.nil? || vendorasin.totalfbafee.nil?
      return nil      
    else
      return (vendorasin.buyboxprice-cost-vendorasin.totalfbafee).to_f.round(2)
    end
    # vendorasin.buyboxprice-cost-vendorasin.fbafee
  end

  def margin
    if vendorasin.buyboxprice.nil? || cost.nil? || vendorasin.totalfbafee.nil?
      return nil      
    else
      return (profit / cost * 100).to_f.round(2)
    end
  end

  def packcost
    packcount*cost  
  end

  def self.sorted_by_margin
    all.order(:cost)
  end

  def as_json(options={})
    {
      id: id,
      asin: asin,
      vendortitle: vendortitle,
      vendor: vendor.name,
      upc: upc,
      cost: cost,
      buyboxprice: vendorasin.buyboxprice,
      fbafee: vendorasin.fbafee,
      storagefee: vendorasin.storagefee,
      variableclosingfee: vendorasin.variableclosingfee,
      commissionpct: vendorasin.commissionpct,
      commissiionfee: vendorasin.commissiionfee,
      salespermonth: vendorasin.salespermonth,
      packagequantity: vendorasin.packagequantity,
      totaloffers: vendorasin.totaloffers,
      fbaoffers: vendorasin.fbaoffers,
      fbmoffers: vendorasin.fbmoffers,
      margin: margin,
      profit: profit,
      packcount: packcount,
      packcost: packcost,
      vendorsku: vendorsku,
      salesrank: vendorasin.salesrank,
      product_groups_id: vendorasin.product_groups_id
    }
  end

  def self.profit(op, value)
    if op == '='
      where("(vendorasins.buyboxprice-cost-vendorasins.totalfbafee) = #{value}")
    elsif op == '<'
      
      where("(vendorasins.buyboxprice-cost-vendorasins.totalfbafee) < #{value}")
    end
  end

  def self.number_compare(op, value, field)
    if field == 'profit'
      where("(vendorasins.buyboxprice-cost-vendorasins.totalfbafee) #{op} #{value}")
    elsif field == 'margin'
      where("(vendorasins.buyboxprice-cost-vendorasins.totalfbafee)/cost*100 #{op} #{value}")
    else
        where("#{field} #{op} #{value}")
    end
  end
end
