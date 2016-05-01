class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  has_secure_password
  has_many :links
  has_many :songs, through: :links
  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness:  { case_sensitive: false }, format: { with: VALID_EMAIL_REGEX }
end
