Given(/^user is on login page$/) do
  @login_page = LoginPage.new
  @login_page.load
  #@login_page.wait_until_user_email_invisible 10
end

When(/^login as user (.*)$/) do |user_type_details|
  @user = LoginRequirenment.new.load_user(user_type_details)
  @login_page.login_as_user(@user)
end

Then(/^user should be redirected to git dashboard page$/) do
  @login_page = LoginPage.new
  @login_page.wait_until_welcome_visible
  expect(@login_page.welcome).to have_text('Learn Git and GitHub without any code!')

  sleep 5
end
