require 'rails_helper'

feature 'Site Browsing' do
  scenario 'Visit Home page' do
    visit root_path
    expect(page).to have_content 'Richfork'
  end

  scenario 'Visit Albums page' do
    visit root_path
    click_link 'Albums'
    expect(page).to have_content 'Music'
  end

  scenario 'Visit Stats page' do
    visit root_path
    click_link 'Stats'
    expect(page).to have_content 'Total albums'
  end

  scenario 'Visit Users page' do
    admin = create(:admin)

    visit root_path

    click_link 'Log In'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'

    click_link 'Users'
    expect(page).to have_content 'Admin'
  end
end
