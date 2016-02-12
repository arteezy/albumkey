require 'rails_helper'

feature 'Visitor signs up' do
  scenario 'by navigating to the page' do
    visit new_user_session_path
    click_link 'Sign Up', match: :first

    expect(current_path).to eq new_user_registration_path
  end

  scenario 'with valid email and password' do
    sign_up_with 'valid@example.com', 'password'

    expect_user_to_be_signed_in
  end

  scenario 'tries with invalid email' do
    sign_up_with 'invalid_email', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with blank password' do
    sign_up_with 'valid@example.com', ''

    expect_user_to_be_signed_out
  end
end
