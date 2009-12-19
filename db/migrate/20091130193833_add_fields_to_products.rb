class AddFieldsToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :featured_position, :integer, :default => 1
    add_column :product_categories, :parent_id, :integer
    add_column :product_categories, :position, :integer, :default => 1
    add_column :products, :cart_code, :text
    add_column :products, :features_count, :integer, :default => 0
  end

  def self.down
    remove_column :products, :featured_position
    remove_column :product_categories, :parent_id
    remove_column :product_categories, :position
    remove_column :products, :cart_code
    remove_column :products, :features_count
  end
end
