class UpdatePrecisionOfDecimals < ActiveRecord::Migration[5.0]
  def change
  	change_column :vendorasins, :buyboxprice, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :referenceoffer, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :fbafee, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :storagefee, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :variableclosingfee, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :commissiionfee, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :inboundshipping, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :lowestfbaoffer, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :lowestfbmoffer, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :weight, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :length, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :width, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :height, :decimal, :precision=>64, :scale=>2

	change_column :vendoritems, :cost, :decimal, :precision=>64, :scale=>2  	
  end
end
