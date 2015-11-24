class User < ActiveRecord::Base
	has_secure_password
	has_many :ecalcs
	validates :password, length: {minimum:5}, presence: {on: :create}
	
end
