Given /^I have videos named (.+)$/ do |video|
  video.split(", ").each do |name|
    Product.create!(:name => name)
  end
end