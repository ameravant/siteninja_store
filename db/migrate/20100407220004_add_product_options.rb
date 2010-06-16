class AddProductOptions < ActiveRecord::Migration
  def self.up
    create_table :product_options do |t|
      t.string :product_id
      t.string :title
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :sale_price, :precision => 8, :scale => 2
      t.boolean :available
      t.timestamps
    end
    products = Product.all
    if !products.empty?
      products.each do |p|
        po = ProductOption.new(:price => p.price, :available => true)
        po.save
        p.product_options << po
        p.save
      end
    end
  end

  def self.down
    drop_table :product_options
  end
end
