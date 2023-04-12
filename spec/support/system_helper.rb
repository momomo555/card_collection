module SystemHelper
  def login_as(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end
end
