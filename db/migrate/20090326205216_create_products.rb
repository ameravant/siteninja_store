class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name, :permalink, :import_name, :size
      t.float :price, :sale_price
      t.text :description, :blurb
      t.integer :product_photo_id # primary photo
      t.integer :images_count, :times_sold, :times_viewed, :default => 0
      t.integer :position, :default => 1
      t.integer :product_line_id
      t.boolean :active, :default => true
      t.boolean :featured, :deleted, :default => false
      t.integer :testimonials_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :products
  end
end
