class ProductsRedux < ActiveRecord::Migration
  def self.up
    rename_column :products, :name, :title
    remove_column :products, :import_name
    remove_column :products, :size
    remove_column :products, :product_photo_id
    remove_column :products, :times_sold
    remove_column :products, :times_viewed
    remove_column :products, :product_line_id
    remove_column :products, :price
    remove_column :products, :sale_price
  end
  def self.down
    add_column :products, :sale_price, :float
    add_column :products, :price, :float
    rename_column :products, :title, :name
    add_column :products, :import_name, :string
    add_column :products, :size, :string
    add_column :products, :product_photo_id, :integer
    add_column :products, :times_sold, :integer
    add_column :products, :times_viewed, :integer
    add_column :products, :product_line_id, :integer
  end
end