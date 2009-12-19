class CreateProductsRetailersTable < ActiveRecord::Migration
  def self.up
  	create_table :products_retailers, :id => false do |t|
      t.integer :product_id, :retailer_id, :null => false
    end
  end

  def self.down
  	drop_table :products_retailers
  end
end
