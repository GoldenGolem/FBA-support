class ChangeColumnTypeOfVendorItem < ActiveRecord::Migration[5.0]
  def change
  	change_column :vendoritems, :name, :text
  	rename_column :vendoritems, :name, :vendortitle
  end
end
