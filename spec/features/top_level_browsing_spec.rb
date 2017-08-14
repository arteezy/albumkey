require 'rails_helper'

feature 'Top Level site browsing' do
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
    visit stats_albums_path
    click_link 'Stats'
    expect(page).to have_content 'Total albums'
  end

  scenario 'Visit Users page' do
    sign_in_as_admin

    click_link 'Users'
    expect(page).to have_content 'Admin'
  end

  scenario 'Visit Lists page' do
    visit lists_path
    expect(page).to have_content 'Community'
  end

  scenario 'Visit Status page' do
    sign_in_as_admin

    visit status_path
    expect(page).to have_content 'Puma:'
  end

  scenario 'Visit Robots page' do
    visit 'robots.txt'
    expect(page).to have_content 'User-Agent:'
  end
end
