class CreateStores < ActiveRecord::Migration
  def self.up
    create_table :stores do |t|
      t.string :name, :email, :address, :address2, :city, :state, :zip, :country, :phone, :fax, :website, :contact_name, :contact_position, :store_type
      t.integer :retailer_id
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :stores
  end
end
