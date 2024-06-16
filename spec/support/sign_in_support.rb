module SignInSupport
  def sign_in(user)
    root_path
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    find('input[name="commit"]').click
    expect(current_path).to eq(posts_path)
  end
end