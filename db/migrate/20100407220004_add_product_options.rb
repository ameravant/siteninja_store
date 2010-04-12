class AddProductOptions < ActiveRecord::Migration
  def self.up
    create_table :product_options do |t|
      t.string :product_id
      t.float :price
      t.boolean :available
      t.timestamps
    end
  end

  def self.down
    drop_table :product_options
  end
end
