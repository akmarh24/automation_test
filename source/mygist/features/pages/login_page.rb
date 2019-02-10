require 'base64'

class LoginPage < SitePrism::Page
  set_url '/login'

  element :user_email, :xpath, '//input[@id="login_field"]'
  element :user_password, :xpath, '//input[@id="password"]'
  element :submit_signin, :xpath, '//input[@value="Sign in"]'
  element :signin_buttom, :xpath, '//a[@class="HeaderMenu-link no-underline mr-3"]'
  element :welcome, :xpath, '//div[@class="border-bottom py-3 mt-3 mb-4"]//span[@class="css-truncate css-truncate-target"][contains(text(),"akmarh24")]'


  def login_as_user(user_detail)
    # credentials =  data_for "secrets/#{user_detail}"
    password = Base64.decode64(user_detail['password'])
    #signin_buttom.click
    wait_until_user_email_visible 40
    user_email.set user_detail['email']
    user_password.set password
    submit_signin.click
  end
end
