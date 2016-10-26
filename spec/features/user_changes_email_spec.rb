require 'rails_helper'

feature 'User changes email' do
  scenario 'sees that his comments have new email' do
    FactoryGirl.create(:album)
    FactoryGirl.create(:user, email: 'email@mail.com', password: 'password')
    sign_in_with 'email@mail.com', 'password'

    first('.card h3 > a').click
    fill_in 'comment_body', with: 'Lorem Ipsum'
    click_button 'Send'

    click_link 'Edit Profile'
    fill_in 'user_email', with: 'new@mail.com'
    fill_in 'user_current_password', with: 'password'
    click_button 'Update'

    visit albums_path
    first('.card h3 > a').click
    expect(page).to have_content 'new@mail.com'
  end
end
