class User < ActiveRecord::Base
  has_secure_password
  has_many :items

  def self.validate(username,password)
    existing = find_by(username: username)
    if existing
      return 'Sorry, that username is taken.'
    elsif !validate_username(username)
      return 'Please use up to 16 alphanumeric characters for the username.'
    elsif !validate_password(password)
      return 'Please use between 4 and 16 alphanumeric characters and/or these symbols in your password, !@#$%&*")}'
    else
      return nil
    end
  end

  def self.validate_username username
    username.match(/^[a-zA-Z0-9]{1,16}$/)
  end

  def self.validate_password password
    password.match(/^[a-zA-Z0-9!@#$%&*]{4,16}$/)
  end

  def viewable_items
    items.select{|item| item.share != "private"}
  end
end
