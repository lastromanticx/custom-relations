class User < ActiveRecord::Base
  has_secure_password
  has_many :items

  def self.validate_username username
    username.match(/^[a-zA-Z0-9]{1,16}$/)
  end

  def self.validate_password password
    password.match(/^[a-zA-Z0-9!@#$%&*]{4,16}$/)
  end
end
