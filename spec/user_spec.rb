require 'user'
require 'database_helpers'

describe User do
  before(:each) do
    @user = User.create(first_name: 'Test',
      last_name: 'McTest',
      username: 'Testannosaurus',
      email: 'test@example.com',
      password: 'password123')
  end

  describe '#create' do
    it 'creates a new user' do

      persisted_data = persisted_data(table: 'users', id: @user.id)

      expect(@user).to be_a User
      expect(@user.id).to eq persisted_data['id']
      expect(@user.first_name).to eq 'Test'
      expect(@user.last_name).to eq 'McTest'
      expect(@user.username).to eq 'Testannosaurus'
      expect(@user.email).to eq 'test@example.com'
    end
  end

  describe '#find' do
    it 'finds a user by ID' do

      result = User.find(@user.id)

      expect(result.id).to eq @user.id
      expect(result.first_name).to eq @user.first_name
      expect(result.last_name).to eq @user.last_name
      expect(result.username).to eq @user.username
      expect(result.email).to eq @user.email
    end

    it 'returns nil if there is no ID given' do
      expect(User.find(nil)).to eq nil
    end
  end

  describe '#authenticate' do
    it 'returns nil given an incorrect email address' do
      expect(User.authenticate(email: 'nottherightemail@me.com', password: 'password123')).to be_nil
    end

    it 'returns nil given an incorrect password' do
      expect(User.authenticate(email: 'test@example.com', password: 'wrongpassword')).to be_nil
    end

    it 'returns a user given a correct username and password, if one exists' do

      authenticated_user = User.authenticate(email: 'test@example.com', password: 'password123')

      expect(authenticated_user.id).to eq @user.id
    end
  end

  describe '#already_registered?' do
    it 'returns true if account is already registered' do
      expect(User.already_registered?(email: 'test@example.com', username: 'cookiemonster')).to eq true

      expect(User.already_registered?(email: 'test@gmail.com', username: 'Testannosaurus')).to eq true

      expect(User.already_registered?(email: 'test@gmail.com', username: 'cookiemonster')).to eq false
    end
  end
end
