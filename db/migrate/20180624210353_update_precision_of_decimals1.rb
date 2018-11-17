class UpdatePrecisionOfDecimals1 < ActiveRecord::Migration[5.0]
  def change
  	change_column :vendorasins, :packagewidth, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :packageheight, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :packagelength, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :packageweight, :decimal, :precision=>64, :scale=>2
  	change_column :vendorasins, :totalfbafee, :decimal, :precision=>64, :scale=>2
  end
end
