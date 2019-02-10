Before do |scenario|
  # maintain backward compatible
  @wait = Selenium::WebDriver::Wait.new timeout: 10
  @driver = page.driver
  # page.driver.browser.manage.window.maximize
  page.driver.browser.manage.window.resize_to(1366, 768)
  p "Scenario to run: #{scenario.name}"
end

After do |scenario|
  if scenario.failed?
    p "test failed!"
    p "Getting screen shoot in session #{Capybara.session_name}"
    Capybara.using_session_with_screenshot(Capybara.session_name.to_s) do
      # screenshots will work and use the correct session
    end
  end
  Capybara.session_name = :default
end
