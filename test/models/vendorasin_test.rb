# == Schema Information
#
# Table name: vendorasins
#
#  id                 :integer          not null, primary key
#  asin               :string(255)
#  brand_id           :integer
#  name               :text(65535)
#  salesrank          :integer
#  packagequantity    :integer
#  buyboxprice        :decimal(64, 2)   default(0.0)
#  referenceoffer     :decimal(64, 2)
#  referenceoffertype :string(255)
#  fbafee             :decimal(64, 2)   default(0.0)
#  storagefee         :decimal(64, 2)   default(0.0)
#  variableclosingfee :decimal(64, 2)   default(0.0)
#  commissionpct      :decimal(10, )    default(0)
#  commissiionfee     :decimal(64, 2)   default(0.0)
#  inboundshipping    :decimal(64, 2)
#  salespermonth      :decimal(10, )    default(0)
#  totaloffers        :integer          default(0)
#  fbaoffers          :integer          default(0)
#  fbmoffers          :integer          default(0)
#  lowestfbaoffer     :decimal(64, 2)   default(0.0)
#  lowestfbmoffer     :decimal(64, 2)   default(0.0)
#  isbuyboxfba        :boolean          default(FALSE)
#  product_type_id    :integer
#  ranked_category_id :integer
#  weight             :decimal(64, 2)
#  length             :decimal(64, 2)
#  width              :decimal(64, 2)
#  height             :decimal(64, 2)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  product_groups_id  :integer
#  packagewidth       :decimal(64, 2)
#  packageheight      :decimal(64, 2)
#  packagelength      :decimal(64, 2)
#  packageweight      :decimal(64, 2)
#  notes              :string(255)
#  review             :decimal(10, )    default(0)
#  numreview          :integer          default(0)
#  amazonoffer        :boolean          default(FALSE)
#  totalfbafee        :decimal(64, 2)   default(0.0)
#  mpn                :string(255)      default("")
#  ean                :string(255)      default("")
#  upc                :string(255)      default("")
#  invalidid          :boolean          default(FALSE)
#
# Indexes
#
#  index_vendorasins_on_asin                (asin) UNIQUE
#  index_vendorasins_on_brand_id            (brand_id)
#  index_vendorasins_on_product_groups_id   (product_groups_id)
#  index_vendorasins_on_product_type_id     (product_type_id)
#  index_vendorasins_on_ranked_category_id  (ranked_category_id)
#

require 'test_helper'

class VendorasinTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
