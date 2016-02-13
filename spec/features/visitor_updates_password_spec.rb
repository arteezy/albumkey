require 'rails_helper'

feature 'Visitor updates password' do
  scenario 'with valid password' do
    user = user_with_reset_password
    update_password user, 'newpassword'

    expect_user_to_be_signed_in
  end

  scenario 'signs in with new password' do
    user = user_with_reset_password
    update_password user, 'newpassword'
    sign_out
    sign_in_with user.email, 'newpassword'

    expect_user_to_be_signed_in
  end

  scenario 'tries with a blank password' do
    user = user_with_reset_password
    visit_password_reset_page_for user
    change_password_to ''

    expect(page).to have_content 'Password can\'t be blank'
    expect_user_to_be_signed_out
  end

  private

  def update_password(user, password)
    visit_password_reset_page_for user
    change_password_to password
  end

  def visit_password_reset_page_for(user)
    visit edit_user_password_path(
      user_id: user,
      reset_password_token: user.send_reset_password_instructions
    )
  end

  def change_password_to(password)
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    click_button 'Change my password'
  end
end
