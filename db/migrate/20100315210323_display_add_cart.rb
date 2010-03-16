class DisplayAddCart < ActiveRecord::Migration
  def self.up
    add_column :products, :display_add_cart, :boolean, :default => 1
  end

  def self.down
    remove_column :products, :display_add_cart
  end
end
