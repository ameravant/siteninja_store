class AddProductOptions < ActiveRecord::Migration
  def self.up
    create_table :product_options do |t|
      t.string :product_id
      t.string :title
      t.float :price
      t.float :sale_price
      t.boolean :available
      t.timestamps
    end
  end

  def self.down
    drop_table :product_options
  end
end
