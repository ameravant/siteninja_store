class AddTemplateIdToProductCategories < ActiveRecord::Migration
  def self.up
    add_column :product_categories, :template_id, :integer
    add_column :product_categories, :column_id, :integer
  end

  def self.down
    remove_column :product_categories, :column_id
    remove_column :product_categories, :template_id
  end
end