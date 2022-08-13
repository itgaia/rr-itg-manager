# frozen_string_literal: true

Then(/^I debug$/) do
  breakpoint
  0
end

And('I write to log {string}') do |msg|
  ITG_LOGGER_MAIN.info msg
end

And(/^I open the page \(debug\)$/) do
  save_and_open_page
end
