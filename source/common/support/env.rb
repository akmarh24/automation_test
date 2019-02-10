require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'site_prism'
require 'dotenv'
require 'rspec/expectations'
require 'data_magic'
require 'byebug'

#   require "parallel_tests"

Dotenv.load
browser = (ENV['BROWSER'] || 'chrome').to_sym
base_url = ENV['BASE_URL'] || 'https://talenta.co'
wait_time = 30

DataMagic.yml_directory = './features/config/data'

DataMagic.yml_directory = if base_url.include? 'https://talenta.co'
                            './features/config/data/prod'
                          else
                            './features/config/data/uat'
                          end

# clear report files
report_root = File.absolute_path('./report')
ENV['REPORT_PATH'] ||= Time.now.strftime('%F_%H-%M-%S')
path = "#{report_root}/#{ENV['REPORT_PATH']}"
FileUtils.mkdir_p path

Capybara.register_driver :firefox do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['general.useragent.override'] = 'selenium'
  options = Selenium::WebDriver::Firefox::Options.new
  options.profile = profile
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options,
    http_client: client
  )
end

Capybara.register_driver :selenium do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => { 'args' => ['window-size=1366,768'] })
  options = { browser: browser,
              url: "http://#{ENV['REMOTE_SELENIUM']}:4444/wd/hub",
              desired_capabilities: caps }
  Capybara::Selenium::Driver.new(app, options)
end

Capybara.register_driver :chrome_headless do |app|
  capabilities = {
    chromeOptions: {
      args: [
        '--no-sandbox',
        '--headless',
        '--disable-gpu',
        '--window-size=1366,768'
      ]
    }
  }

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--user-agent=selenium')
  client = Selenium::WebDriver::Remote::Http::Default.new
  client.open_timeout = wait_time
  client.read_timeout = wait_time
  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: options,
    http_client: client
  )
end

Capybara::Screenshot.register_driver(browser) do |driver, path|
  driver.browser.save_screenshot path
end

if ENV['CI'] == 'true'
  p "about to run on #{browser} remotes #{base_url}"
  Capybara.default_driver = :selenium
else
  p "about to run on #{browser} to #{base_url}"
  Capybara.default_driver = browser
end

Capybara.app_host = ENV['BASE_URL']
Capybara.default_max_wait_time = 10
Capybara::Screenshot.autosave_on_failure = true
Capybara::Screenshot.prune_strategy = { keep: 50 }
Capybara::Screenshot.append_timestamp = true
Capybara::Screenshot.webkit_options = {
  width: 1366,
  height: 768
}
Capybara.save_path = "#{path}/screenshots"
