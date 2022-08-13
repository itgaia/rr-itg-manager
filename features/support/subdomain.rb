# frozen_string_literal: true

Given(/^I visit subdomain (.+)$/) do |sub|
  # ITG_LOGGER_MAIN.info ">>>> [I visit subdomain] #{sub}, Capybara.default_host (before): #{Capybara.default_host}"
  Capybara.default_host = "http://#{sub}.#{TEST_DOMAIN}"
  step %(I am on the homepage)
end

Given(/^I visit now$/) do
  # ITG_LOGGER_MAIN.info ">>>> [I visit subdomain] #{sub}, Capybara.default_host (before): #{Capybara.default_host}"
  Capybara.default_host = "http://#{TEST_DOMAIN}"
  step %(I am on the homepage)
end

Given(/^I visit main domain$/) do
  step %(I visit now)
end

Given('I am on the homepage of subdomain {string} as logged in') do |subdomain|
  Capybara.default_host = "http://#{subdomain}.#{TEST_DOMAIN}"
  step %(I am on the homepage)
  click_on 'log_in_link'
  step %(I should see the web site title of subdomain "#{subdomain}" on the page)
  # Kernel.puts "=== login2 ==== @user: #{@user.inspect}"
  # Kernel.puts "======== @user[:email]: #{@user[:email]}"
  fill_in 'user_email', with: @user[:email]
  fill_in 'user_password', with: @user.data['psw']
  click_on 'Log in'
end
