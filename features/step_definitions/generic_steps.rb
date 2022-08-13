# frozen_string_literal: true

# include ApplicationHelper

Given('a user named {string}') do |username|
  if username.downcase.to_sym == :one_user
    @user = User.user_one
    @user.password = '12345678'
    @user.password_confirmation = '12345678'
    @user[:psw] = '12345678'
    @user.save
  elsif %i[global_plain_user global_admin_user dwtr_plain_user md_plain_user md_admin_user
           itg_plain_user itg_admin_user]
        .include?((factory = username.downcase.to_sym))
    if (@user = User.find_by(username: factory.to_s))
      @user.password = '12345678'
      @user.password_confirmation = '12345678'
      @user[:psw] = '12345678'
      @user.save
    else
      @user = FactoryBot.create(factory, :confirmed, :with_password)
    end
  else
    @user = User.find_by(username: username)
    @user ||= FactoryBot.create(:user, :confirmed, :with_password, username: username)
    @user.check_user
  end
end

Given('a user group named {string}') do |string|
  FactoryBot.create :user_group, name: string
end

Given('an ent_page named {string}') do |page|
  case page.downcase
  when 'homepage'
    FactoryBot.create :ent_page_home
  when 'info'
    FactoryBot.create :ent_page_info
  else
    FactoryBot.create :ent_page_public, name: page
  end
end

Given('There are {string} options in select field {string}') do |options, select_id|
  # find("##{select_id}").options
  page.all("select##{select_id} option").map(&:text).should == options.split(',')
end

Given('an ent_page named {string} for subdomain {string}') do |page, subdomain|
  case page.downcase
  when 'homepage'
    FactoryBot.create :ent_page_home, jsn_subdomain: subdomain
  when 'info'
    FactoryBot.create :ent_page_info, jsn_subdomain: subdomain
  else
    FactoryBot.create :ent_page_public, jsn_page_name: page, jsn_subdomain: subdomain, jsn_title: 'Σχετικά με μένα',
                                        jsn_body: 'Ονομάζομαι Ανδρέας Γκορτσίλας και είμαι'
  end
end

Given('the locale ent_pages named {string}') do |string|
  case string.downcase
  when 'homepage'
    FactoryBot.create :ent_page_home, language_code: 'el'
    FactoryBot.create :ent_page_home, language_code: 'en'
  when 'info'
    FactoryBot.create :ent_page_info, language_code: 'el'
    FactoryBot.create :ent_page_info, language_code: 'en'
  else
    FactoryBot.create :ent_page_public, name: string, language_code: 'el'
    FactoryBot.create :ent_page_public, name: string, language_code: 'en'
  end
end

Given('a private ent_page named {string}') do |page_name|
  step "a private ent_page named '#{page_name}' for subdomain 'default'"
end

Given('a private ent_page named {string} for subdomain {string}') do |page_name, subdomain|
  def_data = {
    jsn_descr: 'This is the A web page.',
    jsn_subdomain: subdomain,
    jsn_page_name: page_name,
    jsn_title: 'Web Page A',
    jsn_body: 'Welcome to my web page',
    jsn_public: false,
    jsn_published: false,
    jsn_image_url: 'xxxxx',
    jsn_image_width: 100,
    jsn_image_height: 100
  }

  if page_name.downcase == 'prive_mine'
    msg = "This is the private page of #{@user.username}"
    FactoryBot.create :ent_page_private,
                      name: page_name, owner: @user,
                      data: def_data.merge({ jsn_body: msg, jsn_published: true, jsn_public: false })
  elsif %w[homepage info].include?(page_name.downcase)
    FactoryBot.create(:user_group, code: subdomain) unless UserGroup.find_by(code: subdomain)
    FactoryBot.create :ent_page_private, name: page_name, context_code: subdomain,
                                         data: def_data.merge({ jsn_body: 'This is the private page of other user',
                                                                jsn_published: true, jsn_public: false })
  elsif page_name.downcase == 'prive_other_user_context_as_admin'
    # ug_list_as_admin = @user.context_list_as_role(:admin, true)
    # ITG_LOGGER_MAIN.pp ug_list_as_admin, "ug_list_as_admin", "=================="
    # fail("User #{@user.username} does not have admin role in any of the user groups.") if ug_list_as_admin.empty?
    ums = FactoryBot.create(:user_membership, :with_new_user, :with_new_user_group)
    FactoryBot.create(:user_membership, user: @user, user_group: ums.user_group, role: UserMembership.roles[:admin])
    # ITG_LOGGER_MAIN.info "||||||||||||||||||||||||||||||| beg"
    # ITG_LOGGER_MAIN.pp ums, "ums", "==="
    # ITG_LOGGER_MAIN.pp ums.user, "ums.user", "==="
    # ITG_LOGGER_MAIN.pp ums.user.user_group_members, "ums.user.user_group_members", "==="
    # ITG_LOGGER_MAIN.pp @user.user_group_members, "@user.user_group_members", "==="
    # ITG_LOGGER_MAIN.info "||||||||||||||||||||||||||||||| end"
    msg = "This is the private page of a user in context #{@user.memberships.last.code} in which I have the admin role"
    FactoryBot.create :ent_page_private, name: page_name, context_code: ums.user.personal_group.code,
                                         data: def_data.merge({ jsn_body: msg, jsn_published: true }, jsn_public: false)
  elsif page_name.downcase == 'prive_other_user_context_as_user'
    # ug_list_as_user = @user.context_list_as_role(:user, true)
    # ITG_LOGGER_MAIN.pp ug_list_as_user, "ug_list_as_user", "=================="
    # fail("User #{@user.username} does not have user role in any of the user groups.") if ug_list_as_user.empty?
    ums = FactoryBot.create(:user_membership, :with_new_user, :with_new_user_group)
    FactoryBot.create(:user_membership, user: @user, user_group_code: ums.user_group_code,
                                        role: UserMembership.roles[:user])
    body = "This is the private page of a user in context #{@user.user_group_members.last.code} " \
           'in which I have the admin role'
    FactoryBot.create :ent_page_private, name: page_name, context_code: ums.user.personal_group_code,
                                         data: def_data.merge({ jsn_body: body, jsn_published: true },
                                                              jsn_public: false)
  else # prive_other_user_other_context
    FactoryBot.create :ent_page_private, name: page_name,
                                         data: def_data.merge({ jsn_body: 'This is the private page of other user',
                                                                jsn_published: true, jsn_public: false })
  end
end

Given('a new user group which current user has {string} role') do |role|
  ug = FactoryBot.create(:user_group)
  FactoryBot.create(:user_membership, user: @user, user_group: ug, role: role)
end

Given('I am on the homepage') do
  # ITG_LOGGER_MAIN.info "----- [I am on the homepage] Capybara.default_host: #{Capybara.default_host}"
  visit '/'
end

Given(/^I am on the homepage as logged in$/) do
  visit '/'
  click_on 'log_in_link'
  step %(I should see the web site title of subdomain '' on the page)
  # Kernel.puts "=== login2 ==== @user: #{@user.inspect}"
  # Kernel.puts "======== @user[:email]: #{@user[:email]}"
  fill_in 'user_email', with: @user[:email]
  fill_in 'user_password', with: @user.data['psw']
  click_on 'Log in'
end

Given('I am on the login page') do
  visit '/users/sign_in'
end

Given('I am on the page {string}') do |string|
  visit "/#{string}"
end

Given('I am on the generic entity of another user in personal context') do
  u = FactoryBot.create(:user)
  @generic = FactoryBot.create(:ent_generic, owner: u, context_code: u.personal_context)
  visit "/entities/#{@generic.id}"
end

Given('I am on the generic entity of another user in another user group') do
  ums = FactoryBot.create(:user_membership, :with_new_user, :with_new_user_group)
  # log UserGroup.count
  # log UserGroup.all.inspect
  @generic = FactoryBot.create(:ent_generic, owner: ums.user, context_code: ums.user_group.code)
  visit "/entities/#{@generic.id}"
end

Given('I see the {string} title {string}') do |html_header, content|
  expect(page).to have_selector(html_header, text: content)
end

Given('I see the {string} locale title {string}') do |html_header, content|
  expect(page).to have_selector(html_header, text: I18n.t(content))
end

Given('I am on the generic entity of another user in common user group {string}') do |grp_name|
  # ITG_LOGGER_MAIN.pp grp_name, 'grp_name', '===========>>>>>>>>'
  if grp_name.empty?
    ums = FactoryBot.create(:user_membership, :with_new_user, :with_new_user_group)
  else
    FactoryBot.create(:user_group, code: grp_name)
    ums = FactoryBot.create(:user_membership, :with_new_user, user_group_code: grp_name)
  end
  # u = FactoryBot.create(:user)
  FactoryBot.create(:user_membership, user: @user, user_group_code: ums.user_group_code)
  @generic = FactoryBot.create(:ent_generic, owner: ums.user, context_code: ums.user_group.code)
  visit "/context?context=#{grp_name}"
  # ITG_LOGGER_MAIN.pp @generic, '@generic', '===========>>>>>>>>'
  visit "/entities/#{@generic.id}"
  # expect(page).to have_content(@generic[:name])
  # expect(page).to have_content(@generic[:notes])
end

Given('I enter {string} in field {string}') do |content, field_name|
  fill_in field_name, with: content
end

Given('I enter {string} in text field {string}') do |content, field_name|
  fill_in field_name, with: content
end

Given('I enter {string} in multiline editor {string}') do |content, field_name|
  fill_in_multiline_editor field_name, with: content
end

Given(/^I click on the "(.*?)" link$/) do |link_prefix|
  click_on "#{link_prefix.parameterize.underscore}_link"
end

Given(/^I click on the personal context link of current user$/) do
  click_on "#{@user.personal_context}_context_link"
end

Given(/^I click on the locale "(.*?)" link$/) do |content|
  # click_on I18n.t(content)
  click_on "#{content.parameterize.underscore}_link"
end

Given('I click on another context link') do
  @another_context = @user.context_list(:current).first[:code]
  click_on "#{@another_context.parameterize.underscore}_context_link"
end

Given('The form field {string} is hidden') do |field_name|
  expect(page).to have_field(field_name, type: :hidden)
end

Given('The form field {string} with value {string} is hidden') do |field_name, field_value|
  expect(page).to have_field(field_name, type: :hidden, with: field_value)
end

Then('I click on the {string} button') do |button_prefix|
  click_on "#{button_prefix.parameterize.underscore}_button"
end

Then('I select the {string} option from the {string}') do |option_name, select_name|
  select option_name, from: select_name
end

Then('I should not see any flash errors') do
  expect(page).to_not have_css('script', visible: false, text: 'toastr.error')
end

Then('I should see flash error {string}') do |error|
  expect(page).to have_css('script', visible: false, text: "toastr.error('#{error}')")
end

Then('I should see the web site title of subdomain {string} on the page') do |subdomain|
  subdomain = 'keeper' if subdomain.empty?

  title = ___cfg(subdomain)[:app_title]
  # TODO: If I use current_subdomain_config cucumber has problem with request:
  # ArgumentError: wrong number of arguments (given 0, expected 1..2)
  # /Users/aaon/.rbenv/versions/3.0.3/lib/ruby/gems/3.0.0/gems/rack-test-1.1.0/lib/rack/test.rb:116:in `request'
  # /Users/aaon/.rbenv/versions/3.0.3/lib/ruby/3.0.0/forwardable.rb:238:in `request'
  # title = current_subdomain_config[:app_title]

  if has_content?('BackOffice - Dashboard')
    # step %{I should see "#{I18n.t(subdomain)} BackOffice - Dashboard"}
    step %(I should see "Keeper BackOffice - Dashboard")
  else
    step %(I should see the web site title '#{I18n.t(title)}' on the page)
  end
end

Then('I should see the web site title {string} on the page') do |title|
  step %(I should see the "ws_title_link" with content "#{title}")
end

Then('I should see the locale welcome page') do
  expect(page).to have_content(I18n.t('Welcome'))
end

Then('I should not see the locale welcome page') do
  expect(page).to_not have_content(I18n.t('Welcome'))
end

Then('I should see the welcome page') do
  expect(page).to have_content('Welcome')
end

Then(/^I should see "(.*?)"/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not see "(.*?)"/) do |text|
  expect(page).to_not have_content(text)
end

Then(/^I should see the locale "(.*?)"/) do |text|
  expect(page).to have_content(I18n.t(text))
end

Then(/^I should see the locale title "(.*?)"/) do |text|
  expect(page).to have_xpath('//h2', text: I18n.t(text))
  # expect(page).to have_content(I18n.t(text))
end

Then('I should see my name on the page') do
  # save_and_open_page
  # expect(page).to have_content("joe")
  expect(page).to have_content(@user[:first_name])
end

Then('I should see my username on the page') do
  # save_and_open_page
  # expect(page).to have_content("joe")
  expect(page).to have_content(@user[:username])
end

Then('I should see the locale {string} link') do |link_content|
  expect(page).to have_link I18n.t(link_content)
end

Then('I should see the locale {string} dropdown menu') do |link_content|
  expect(page).to have_link I18n.t(link_content)
  # expect(page).to have_xpath("//*[@id='#{name.parameterize.underscore}_link']")
  # expect(page).to have_xpath("//*[@id='dropdown#{name.camelize}MenuLink']")
end

Then('I should see the locale {string} dropdown menu item') do |link_content|
  expect(page).to have_link I18n.t(link_content)
  expect(page).to have_xpath("//*[@id='#{name&.parameterize&.underscore}_link']")
  expect(page).to have_xpath("//*[@id='dropdown#{name&.camelize}MenuLink']")
end

Then('I should see the {string} link') do |link_content|
  expect(page).to have_link link_content
end

Then('I should see the {string} link in element with id {string}') do |link_content, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to have_link link_content
  end
end

Then('I should see the locale {string} link in element with id {string}') do |link_content, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to have_link I18n.t(link_content)
  end
end

Then('I should not see the {string} link') do |link_content|
  # expect(page).to_not have_link link_content
  step %("#{link_content}" link does not exist)
end

Then('I should not see the {string} link in element with id {string}') do |link_content, container|
  # expect(page).to_not have_link link_content
  step %("#{link_content}" link does not exist in element with id "#{container}")
end

Then('I should not see the locale {string} link in element with id {string}') do |link_content, container|
  # expect(page).to_not have_link link_content
  step %("#{link_content}" locale link does not exist in element with id "#{container}")
end

Then('I should not see the locale {string} link') do |link_content|
  # expect(page).to_not have_link link_content
  step %("#{I18n.t(link_content)}" link does not exist)
end

Then('{string} link does not exist') do |name|
  # have_link is case sensitive and matches substring
  expect(page).to_not have_link name
  expect(page).to_not have_xpath("//*[@id='#{name.parameterize.underscore}_link']")
  expect(page).to_not have_xpath("//*[@id='dropdown#{name.camelize}MenuLink']")
end

Then('{string} link does not exist in element with id {string}') do |name, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to_not have_link name
    expect(page).to_not have_xpath("//*[@id='#{name.parameterize.underscore}_link']")
    expect(page).to_not have_xpath("//*[@id='dropdown#{name.camelize}MenuLink']")
  end
end

Then('{string} locale link does not exist in element with id {string}') do |name, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to_not have_link I18n.t(name)
    expect(page).to_not have_xpath("//*[@id='#{name.parameterize.underscore}_link']")
    expect(page).to_not have_xpath("//*[@id='dropdown#{name.camelize}MenuLink']")
  end
end

Then('I should see the current user info') do
  expect(page).to have_link @user[:username]
  expect(page).to have_xpath("//li[@id='div_user_karma']")
end

Then('I should see the image with id {string}') do |id|
  expect(page).to have_xpath("//img[@id='#{id}']")
end

Then('I should not see the image with id {string}') do |id|
  expect(page).to_not have_xpath("//img[@id='#{id}']")
end

Then('I should see the element with id {string}') do |id|
  expect(page).to have_xpath("//*[@id='#{id}']")
end

Then('I should not see the element with id {string}') do |id|
  expect(page).to_not have_xpath("//*[@id='#{id}']")
end

Then('I should see the {string} content') do |text|
  expect(page).to have_content text
end

Then('I should see the locale {string} content') do |text|
  expect(page).to have_content I18n.t(text)
end

Then('I should see the {string} content in element with id {string}') do |text, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to have_content text
  end
end

Then('I should not see the {string} content') do |text|
  expect(page).to_not have_content text
end

Then('I should not see the {string} content in element with id {string}') do |text, container|
  within(:xpath, "//*[@id='#{container}']") do
    expect(page).to_not have_content text
  end
end

Then('I should not see the locale {string} content') do |text|
  expect(page).to_not have_content I18n.t(text)
end

When(/^I reload the page$/) do
  visit [current_path, page.driver.request.env['QUERY_STRING']].reject(&:blank?).join('?')
end

Then('Follow redirect if needed') do
  # Kernel.puts "11111"
  if have_content('You are being redirected.')
    # Kernel.puts "22222"
    click_on 'redirected'
    # TODO: Problem with redirect link of type: http://www.example.com/?locale=el use it with out the host-port info
    if have_content('You are being redirected.')
      # Kernel.puts "33333"
      visit '/'
    end
  end
end

Then(/^the page (?:should have|has) content (.+)$/) do |content|
  expect(page).to have_content(content)
end

Then(/^the page (?:should not have|has) content (.+)$/) do |content|
  expect(page).to_not have_content(content)
end

Then(/^the page should have status code (\d+)$/) do |status_code|
  expect(page.status_code).to eq(status_code)
end

Then(/^the page should not have status code (\d+)$/) do |status_code|
  expect(page.status_code).to_not eq(status_code)
end

Then(/^I should see an error$/) do
  expect(400..599).to include(page.status_code)
end

Then('I should see a create confirmation message for {string}') do |model|
  expect(page).to have_content("Entity #{model} was successfully created")
end

Then('I should see an update confirmation message for {string}') do |model|
  expect(page).to have_content("Entity #{model} was successfully updated")
end

Then('I should see the {string} with content {string}') do |element, content|
  expect(page).to have_xpath("//*[@id='#{element}']", text: content)
end

Then('I should see the {string} with this other context') do |element|
  expect(page).to have_xpath("//*[@id='#{element}']", text: @other_content)
end

Then('I see the web page title {string}') do |webtitle|
  expect(page).to have_title(webtitle)
end
