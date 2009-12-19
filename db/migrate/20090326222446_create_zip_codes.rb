class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string :zip, :state, :city, :long, :lat
    end
  end
#    
#    zip_codes = YAML.load_file("#{RAILS_ROOT}/vendor/plugins/siteninja/siteninja_store/config/us_zip_codes.yml")
#    zip_codes = zip_codes.to_a
#    
#    puts "Importing zip code data..."
#    zip_codes.each_with_index do |zip, i|
#      ZipCode.create(:zip => zip.first, :state => zip.last['state'], :city => zip.last['city'].to_s.titleize, :lat => zip.last['lat'], :long => zip.last['long'])
#      puts "#{i} of #{zip_codes.size}: #{zip.last['city'].to_s.titleize}, #{zip.last['state']}..." if i % 1000 == 0
#    end
#    puts "DONE!"
#  end

  def self.down
    drop_table :zip_codes
  end
end
