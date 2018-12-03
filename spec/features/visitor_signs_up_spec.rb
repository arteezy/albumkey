require 'rails_helper'

feature 'Visitor signs up' do
  scenario 'by navigating to the page' do
    visit new_user_session_path
    click_link 'Sign Up', match: :first

    expect(current_path).to eq new_user_registration_path
  end

  scenario 'with valid email and password' do
    sign_up_with 'username', 'valid@example.com', 'password'

    expect_user_to_be_signed_in
  end

  scenario 'tries with invalid email' do
    sign_up_with 'username', 'invalid_email', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with blank password' do
    sign_up_with 'username', 'valid@example.com', ''

    expect_user_to_be_signed_out
  end

  scenario 'tries with blank username' do
    sign_up_with '', 'valid@example.com', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with very short username' do
    sign_up_with 'az', 'valid@example.com', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with very long username' do
    sign_up_with 'abc' *11, 'valid@example.com', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with non-unique username' do
    FactoryBot.create(:user, username: 'xXx_1337h4xxor_xXx')
    sign_up_with 'xXx_1337h4xxor_xXx', 'valid@example.com', 'password'

    expect_user_to_be_signed_out
  end

  scenario 'tries with non-unique username, but with different case' do
    FactoryBot.create(:user, username: 'maxim')
    sign_up_with 'MaXiM', 'valid@example.com', 'password'

    expect_user_to_be_signed_out
  end
end
