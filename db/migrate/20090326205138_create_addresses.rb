class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :type
      t.integer :location_id, :order_id
      t.string :first_name, :last_name, :street_address, :street_address_2, :city, :postal_code
      t.string :phone, :email
      t.string :notes
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
