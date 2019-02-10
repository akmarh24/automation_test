require 'base64'

class Gistpage < SitePrism::Page
  set_url ''

  element :add_new, :xpath, '//summary[@class="HeaderNavlink"]'
  element :new_gist, :xpath, '//a[contains(text(),"New gist")]'
  element :name_gist, :xpath, '//input[@placeholder="Filename including extension…"]'
  element :gist_description, :xpath, '//input[@placeholder="Gist description…"]'
  element :text_area, :xpath, '//pre[contains(@class,"CodeMirror-line")]'
  element :submit_public, :xpath, '//button[@value="1"]'
  element :submit_update, :xpath, '//button[contains(text(),"Update public gist")]'
  
  element :view_gist, :xpath, '//strong[@class="user-select-contain gist-blob-name css-truncate-target"]'
  element :select_gist, :xpath, '//strong[@class="css-truncate-target"][contains(text(),"test1")]'
  element :delete_gist, :xpath, '//*[@id="gist-pjax-container"]/div[1]/div/div[1]/ul/li[2]/form/button'
  #(.//*[normalize-space(text()) and normalize-space(.)='Sign out'])[1]/following::button[1]
  element :edit, :link, 'Edit'
  element :dropdown_profile, :xpath, '//summary[@class="HeaderNavlink name mt-1"]'
  element :your_gist, :xpath, '//a[contains(text(),"Your gists")]'
  element :see_all_gist, :xpath, '//a[contains(text(),"See all of your gists")]'
  

  def add_gist
    add_new.click
    new_gist.click
    gist_description.set('test1')
    name_gist.set('test1')
    text_area.set('hello world')
    submit_public.click
  end

  def edit_gist
    dropdown_profile.click
    your_gist.click
    see_all_gist.click
    select_gist.click
    edit.click
    gist_description.set('test2')
    name_gist.set('test2')
    text_area.set('hello world2')
    submit_update.click
  end

  def delete_gist
    dropdown_profile.click
    your_gist.click
    see_all_gist.click
    select_gist.click
    delete_gist.click
  end

  def view_list
    view_gist.click
  end

end
