Given /^the following (.+) records$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Then /^I should see "([^\"]*)" and "([^\"]*)"$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
