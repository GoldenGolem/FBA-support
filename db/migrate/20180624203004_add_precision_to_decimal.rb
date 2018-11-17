class AddPrecisionToDecimal < ActiveRecord::Migration[5.0]
  def change
  	change_column :vendorasins, :buyboxprice, :double, :precision=>64, :scale=>12
  end
end
