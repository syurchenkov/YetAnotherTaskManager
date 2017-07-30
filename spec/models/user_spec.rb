require 'rails_helper'

RSpec.describe User, type: :model do
  before(:example) do
    @user = User.new(email: 'email@example.com', password_digest: '')
  end

  it "is valid" do 
    expect(@user).to be_valid
  end

  it "validates presence of email" do 
    @user.email = "      "
    expect(@user).not_to be_valid
  end

  it "validates maximum length of email" do 
    @user.email = "e" * 244 + '@example.com'
    expect(@user).not_to be_valid
  end

  it "is not valid with invalid email format" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                   foo@bar_baz.com foo@bar+baz.com]
    addresses.each do |invalid_address|
      @user.email = invalid_address
      expect(@user).not_to be_valid
    end      
  end

  it "is valid with valid email format" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      expect(@user).to be_valid
    end
  end

  it "is not valid when email is not unique" do
    duplicate_user = @user.dup
    @user.save
    expect(duplicate_user).not_to be_valid
  end
end
