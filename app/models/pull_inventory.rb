# == Schema Information
#
# Table name: pull_inventories
#
#  id                :integer          not null, primary key
#  inputfileurl      :string(255)
#  inputfilename     :string(255)
#  idcolumn          :integer          default(-1)
#  costcolumn        :integer          default(-1)
#  skucolumn         :integer          default(-1)
#  getestimatesales  :boolean          default(TRUE)
#  getisamazonsale   :boolean          default(TRUE)
#  user_id           :integer
#  vendor_id         :integer
#  skynet_id_type_id :integer
#  skynet_status_id  :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_pull_inventories_on_inputfileurl       (inputfileurl) UNIQUE
#  index_pull_inventories_on_skynet_id_type_id  (skynet_id_type_id)
#  index_pull_inventories_on_skynet_status_id   (skynet_status_id)
#  index_pull_inventories_on_user_id            (user_id)
#  index_pull_inventories_on_vendor_id          (vendor_id)
#

class PullInventory < ApplicationRecord
end
