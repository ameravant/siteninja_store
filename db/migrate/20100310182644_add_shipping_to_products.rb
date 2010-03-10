class AddShippingToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :shipping, :float
  end

  def self.down
    remove_column :products, :shipping
  end
end
