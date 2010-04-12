Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit admin_path
  fill_in "login", :with => username
  fill_in "password", :with => password
  click_button "Sign in"
end
