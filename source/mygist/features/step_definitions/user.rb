Given(/^user on list gist page$/) do
  @addgist_page = Gistpage.new
  @addgist_page.load
  @wait.until { @addgist_page.displayed? }
end

When(/^user create new gist$/) do
  @addgist_page.add_gist
end

Then(/^gist created$/) do
  @addgist_page.wait_until_view_gist_visible
  @addgist_page.view_list
  expect(@addgist_page.view_gist).to have_text('test1')
end

When(/^user edit gist$/) do
  @addgist_page.edit_gist
end

Then(/^gist name should be update$/) do
  @addgist_page.view_list
  @addgist_page.wait_until_view_gist_visible
  expect(@addgist_page.view_gist).to have_text('test2')

When(/^user deleted the gist$/) do
  @addgist_page.delete_gist
end

Then(/^success deleted gist$/) do
  @addgist_page = Gistpage.new
  @addgist_page.wait_until_view_gist_visible
  expect(@@addgist_page.view_gist).to have_text('')
end

Then(/^should be directed on list gist page$/) do
  @addgist_page = Gistpage.new
  @addgist_page.wait_until_view_gist_visible
  expect(@@addgist_page.view_gist).to have_text('test1')
end

end
