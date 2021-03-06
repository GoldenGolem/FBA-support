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

require 'test_helper'

class VendoritemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
