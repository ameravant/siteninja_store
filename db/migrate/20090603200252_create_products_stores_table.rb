class CreateProductsStoresTable < ActiveRecord::Migration
  def self.up
  	create_table :products_stores, :id => false do |t|
      t.integer :product_id, :store_id, :null => false
    end
  end

  def self.down
    drop_table :products_stores
  end
end
