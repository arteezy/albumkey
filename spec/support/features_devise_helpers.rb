module Features
  module DeviseHelpers
    def sign_in
      password = 'password'
      user = FactoryGirl.create(:user, password: password)
      sign_in_with user.email, password
    end

    def sign_in_with(email, password)
      visit new_user_session_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      click_button 'Log In'
    end

    def sign_out
      click_link 'Log Out'
    end

    def sign_up_with(email, password)
      visit new_user_registration_path
      fill_in 'user_email', with: email
      fill_in 'user_password', with: password
      fill_in 'user_password_confirmation', with: password
      click_button 'Sign Up'
    end

    def expect_user_to_be_signed_in
      visit root_path
      expect(page).to have_link 'Log Out'
    end

    def expect_user_to_be_signed_out
      expect(page).to have_link 'Log In'
    end

    def reset_password_for(email)
      visit new_user_password_path
      fill_in 'user_email', with: email
      click_button 'Send me reset password instructions'
    end

    def user_with_reset_password
      user = FactoryGirl.create(:user)
      reset_password_for user.email
      user.reload
    end
  end
end
