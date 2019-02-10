module BrowserSessionHelper
  def in_browser(name, credentials)
    page.driver.browser.manage.window.maximize
    old_session = Capybara.session_name

    p "old session: #{old_session}"
    Capybara.session_name = name
    p "after overide : #{Capybara.session_name}"

    p "#{name} has log in........."
    $LOGGED_IN_SCENARIOS ||= []
    page.driver.browser.manage.window.maximize
    if name == :admin and !($LOGGED_IN_SCENARIOS.include? self.object_id)
      @login_page = LoginPage.new
      @login_page.load
      @login_page.login_as_user(credentials)
      @admin_dash_page = AdminDashboardPage.new
      @wait.until { @admin_dash_page.displayed? }
      $LOGGED_IN_SCENARIOS.push self.object_id
    elsif name == :staff and !($LOGGED_IN_SCENARIOS.include? self.object_id)
      @login_page = LoginPage.new
      @login_page.load
      @login_page.login_as_user(credentials)
      @staff_dash_page = StaffDashboardPage.new
      @wait.until { @staff_dash_page.displayed? }
      $LOGGED_IN_SCENARIOS.push self.object_id
    end
    yield
    p "===== After yield ======"
    Capybara.session_name = old_session
    # Capybara.reset_session!
    # Capybara.session_name = :default
    p "current session:"
    p Capybara.session_name
  end
end

World(BrowserSessionHelper)
