class CreateProductCategoriesProductsTable < ActiveRecord::Migration
  def self.up
  	create_table :product_categories_products, :id => false do |t|
      t.integer :product_id, :product_category_id, :null => false
    end
  end

  def self.down
    drop_table :product_categories_products
  end
end
