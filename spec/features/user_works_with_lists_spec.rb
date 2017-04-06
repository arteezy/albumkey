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
end
