require 'rails_helper'

feature 'Top level site browsing' do
  scenario 'Visit Home page' do
    visit root_path
    expect(page).to have_content 'Discover the best music'
  end

  scenario 'Visit Albums page' do
    visit albums_path
    click_link 'Albums'
    expect(page).to have_content 'Music'
  end

  scenario 'Visit Stats page' do
    visit stats_path
    click_link 'Stats'
    expect(page).to have_content 'Total albums'
  end

  scenario 'Visit Users page' do
    admin = create(:admin)

    visit users_path

    click_link 'Log In'
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log In'

    click_link 'Users'
    expect(page).to have_content 'Admin'
  end

  scenario 'Visit Status page' do
    visit status_path
    expect(page).to have_content 'Rails:'
  end

  scenario 'Visit Robots page' do
    visit 'robots.txt'
    expect(page).to have_content 'User-Agent:'
  end
end
