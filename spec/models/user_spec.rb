require 'rails_helper'

RSpec.describe User, type: :model do
  before(:example) do
    @user = User.new(email: 'email@example.com', password: 'foobar', password_confirmation: 'foobar')
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
    duplicate_user.email = @user.email.upcase
    @user.save
    expect(duplicate_user).not_to be_valid
  end

  it "save email in lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    expect(@user.reload.email).to be == mixed_case_email.downcase
  end

  it "is not valid when password is blank" do
    @user.password = @user.password_confirmation = " " * 6
    expect(@user).not_to be_valid
  end

  it "it not valid when password shorter than minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    expect(@user).not_to be_valid
  end
end
