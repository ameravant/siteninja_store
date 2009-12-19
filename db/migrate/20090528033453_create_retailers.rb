class CreateRetailers < ActiveRecord::Migration
  def self.up
    create_table :retailers do |t|
			t.string :name, :url, :permalink
			t.string :logo_file_name, :logo_content_type
      t.integer :logo_file_size
      t.boolean :featured
      t.datetime :logo_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :retailers
  end
end
