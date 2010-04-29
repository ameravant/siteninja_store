Given /^the following (.+) records$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

When /^I visit product page for "([^\"]*)"$/ do |name|
  product = Product.find_by_name!(name)
  visit products_path(product)
end

When /^I select$/ do
  pending # express the regexp above with the code you wish you had
end

