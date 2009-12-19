class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.string :ip_address
      t.string :billing_status, :default => "Unpaid"
      t.string :shipping_status, :default => "Not shipped yet."
      t.string :card_number, :card_type
      t.text :notes, :response, :order_notes
      t.integer :shipping_method_id, :shipping_address_id, :billing_address_id
      t.float :subtotal, :total
      t.float :taxes_total, :shipping_total, :default => 0.0
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
