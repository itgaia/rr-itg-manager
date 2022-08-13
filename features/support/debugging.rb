# frozen_string_literal: true

# `FAST=1 cucumber` to stop on first failure
After do |scenario|
  Cucumber.wants_to_quit = ENV['FAST'] && scenario.failed?
end

# `LAUNCHY=1 cucumber` to open save screenshot after every step
After do |scenario|
  next unless (ENV['LAUNCHY'] || ENV['CI']) && scenario.failed?

  # puts "Opening snapshot for #{scenario.name}"
  # begin
  #   puts '*** save and open screenshot....'
  #   save_and_open_screenshot
  # rescue StandardError
  #   puts "Can't save screenshot"
  # end
  begin
    puts '*** save and open page....'
    # rubocop:disable Lint/Debugger
    save_and_open_page
    # rubocop:enable Lint/Debugger
  rescue StandardError
    puts "Can't save page"
  end
end

# # `DEBUG=1 cucumber` to drop into debugger on failure
# Cucumber::Core::Test::Action.class_eval do
#   ## first make sure we don't lose original accept method
#   unless instance_methods.include?(:orig_failed)
#     alias_method :orig_failed, :failed
#   end
#
#   ## wrap original accept method to catch errors in executed step
#   def failed(*args)
#     begin
#       CucumberCounters.error_counter += 1
#       file_name = format('tmp/capybara/error_%03d.png',
#                          CucumberCounters.error_counter)
#       puts '*** save screenshot....'
#       Capybara.page.save_screenshot(file_name, full: true)
#     rescue
#       Rails.logger.info('[Cucumber] Can not make screenshot of failure')
#     end
#     if ENV['DEBUG']
#       puts ">>>> Debugging scenario: #{scenario.title}"
#       if respond_to? :debugger
#         debugger
#       elsif binding.respond_to? :pry
#         binding.pry
#       else
#         puts "Can't find debugger or pry to debug"
#       end
#     end
#     orig_failed(*args)
#   end
# end
#
# # `STEP=1 cucumber` to pause after each step
# AfterStep do |scenario|
#   next unless ENV['STEP']
#
#   unless defined?(@counter)
#     puts "*** Stepping through #{scenario.title}"
#     @counter = 0
#   end
#   @counter += 1
#   print "At step ##{@counter} of #{scenario.steps.count}. Press Return to"\
#         ' execute...'
#   STDIN.getc
# end
#
# ---rubocop:disable Lint/Debugger
# class CucumberCounters
#   @error_counter = 0
#   @step_counter = 0
#   @screenshot_counter = 0
#   class << self
#     attr_accessor :error_counter, :step_counter, :screenshot_counter
#   end
# end
#
# # Store the current scenario name as an instance variable, to make it
# # available to the other hooks.
# Before do |scenario|
#   # case scenario
#   # when Cucumber::Ast::Scenario
#   #   @scenario_name = scenario.name
#   # when Cucumber::Ast::OutlineTable::ExampleRow
#   #   @scenario_name = scenario.scenario_outline.name
#   # end
#   # try to bypass problem: "uninitialized constant Cucumber::Ast"
#   @scenario_name = scenario.name
#   Rails.logger.info("[Cucumber] starting the #{@scenario_name}")
# end
#
# # `STEP=1 cucumber` to pause after each step
# AfterStep do |scenario|
#   next unless ENV['STEP']
#
#   unless defined?(@counter)
#     puts "Stepping through #{@scenario_name}"
#     @counter = 0
#   end
#   @counter += 1
#   print "After step ##{@counter}/#{scenario.send(:steps).try(:count)}: "\
#         "#{scenario.send(:steps).to_a[@counter].try(:name) ||
#     '[RETURN to continue]'}..."
#   STDIN.getc
# end
#
# AfterStep do |scenario|
#   CucumberCounters.step_counter += 1
#   step = CucumberCounters.step_counter
#   file_name = format('tmp/capybara/step_%03d.png', step)
#   Rails.logger.info("[Cucumber] after step: #{@scenario_name}, step: #{step}")
#
#   # TODO: NoMethodError: undefined method `source_tag_names' for
#           #<Cucumber::Core::Test::Result::Passed:0x00007fe6b15f3080
#           @duration=#<Cucumber::Core::Test::Result::Duration:0x00007fe6b15f30a8
#           @nanoseconds=308024000>>
#   next unless scenario.source_tag_names.include?('@intermittent')
#
#   puts "[Cucumber] Screenshot #{step}......!"
#   begin
#     Capybara.page.save_screenshot(file_name, full: true)
#     Rails.logger.info("[Cucumber] Screenshot #{step} saved")
#   rescue
#     Rails.logger.info("[Cucumber] Can not make screenshot of #{step}")
#   end
# end
#
# AfterStep do
#   begin
#     execute_script "$(window).unbind('beforeunload')"
#   rescue => e
#     Rails.logger.error('An error was encountered and rescued')
#     Rails.logger.error(e.backtrace)
#   end
# end
#
# def dismiss_nav_warning
#   execute_script "$(window).unbind('beforeunload')"
#   wait_until_jquery_inactive
# end
#
# def wait_until_jquery_inactive
#   Capybara.using_wait_time(Capybara.default_max_wait_time) do
#     page.evaluate_script('jQuery.active').zero?
#   end
# end
