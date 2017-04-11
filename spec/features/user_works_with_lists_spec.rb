require 'rails_helper'

feature 'User works with lists' do
  before(:each) do
    sign_in
    visit lists_path
    click_link 'Create List'
  end

  scenario 'creates list' do
    expect(current_path).to eq new_list_path

    fill_in 'list_title', with: 'Awesome List'
    choose 'list_category_personal'
    click_button 'Create List'

    expect(page).to have_content 'List was successfully created'
    expect(page).to have_content 'Awesome List'
  end

  scenario 'edits list' do
    fill_in 'list_title', with: 'Wrong List'
    choose 'list_category_personal'
    click_button 'Create List'

    find('a:has(.glyphicon-pencil)').click
    fill_in 'list_title', with: 'Right List'
    click_button 'Update List'
    expect(page).to have_content 'List was successfully updated'

    visit lists_path
    expect(page).not_to have_content 'Wrong List'
    expect(page).to have_content 'Right List'
  end

  scenario 'deletes list' do
    fill_in 'list_title', with: 'Bad List'
    choose 'list_category_personal'
    click_button 'Create List'

    find('a:has(.glyphicon-remove)').click

    visit lists_path
    expect(page).not_to have_content 'Bad List'
  end

  scenario 'adds album to list' do
    fill_in 'list_title', with: 'Awesome List'
    choose 'list_category_personal'
    click_button 'Create List'

    FactoryGirl.create(:album, title: 'Cool Album')
    visit albums_path
    first('.card h3 > a').click
    select 'Awesome List', from: 'album_list_id'
    click_button 'Add to List'

    expect(page).to have_content 'Album was successfully added to this List'

    visit lists_path
    click_link 'Awesome List'
    expect(page).to have_content 'Cool Album'
  end

  scenario 'deletes album from list' do
    fill_in 'list_title', with: 'Awesome List'
    choose 'list_category_personal'
    click_button 'Create List'

    FactoryGirl.create(:album, title: 'Bad Album')
    visit albums_path
    first('.card h3 > a').click
    select 'Awesome List', from: 'album_list_id'
    click_button 'Add to List'

    visit lists_path
    click_link 'Awesome List'
    click_link 'Delete'
    expect(page).not_to have_content 'Bad Album'
  end

  scenario 'moves album position in list' do
    fill_in 'list_title', with: 'Awesome List'
    choose 'list_category_personal'
    click_button 'Create List'

    a1 = FactoryGirl.create(:album, title: 'First Album')
    a2 = FactoryGirl.create(:album, title: 'Second Album')

    visit album_path(a1)
    select 'Awesome List', from: 'album_list_id'
    click_button 'Add to List'

    visit album_path(a2)
    select 'Awesome List', from: 'album_list_id'
    click_button 'Add to List'

    visit lists_path
    click_link 'Awesome List'
    expect('First').to appear_before 'Second'

    within '.well:last-child' do
      click_button 'Up'
    end
    expect('First').to appear_after 'Second'

    within '.well:first-child' do
      click_button 'Down'
    end
    expect('First').to appear_before 'Second'
  end
end
