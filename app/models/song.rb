class Song < ActiveRecord::Base
	has_many :links
	has_many :users, through: :links
	validates :title, :artist, presence: true
	validates :title, :artist, length: { minimum: 2 }
end
