class AddMoreFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :sku, :string
    add_column :product_categories, :body, :text
  end

  def self.down
    remove_column :products, :sku
    remove_column :product_categories, :body
  end
end
