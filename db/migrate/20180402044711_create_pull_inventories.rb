class CreatePullInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :pull_inventories do |t|
      	t.string :inputfileurl
		t.string :inputfilename
	    t.integer :idcolumn, default: -1
	    t.integer :costcolumn, default: -1
	    t.integer :skucolumn, default: -1
	    t.boolean :getestimatesales, default: true
	    t.boolean :getisamazonsale, default: true
	    t.references :user, index: true
	    t.references :vendor, index: true
	    t.references :skynet_id_type, index: true
	    t.references :skynet_status, index: true      
	    t.timestamps
	end
	add_index :pull_inventories, :inputfileurl,                unique: true
    end
end
