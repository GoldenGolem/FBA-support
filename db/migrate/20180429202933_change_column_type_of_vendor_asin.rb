class ChangeColumnTypeOfVendorAsin < ActiveRecord::Migration[5.0]
  def change
  	change_column :vendorasins, :name, :text
  end
end
