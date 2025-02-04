class User < ApplicationRecord
	#	Future implementation
	# confirmable, lockable, omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
				 :trackable

	validates :username, presence: true, uniqueness: true
	validates :first_name, presence: true
	validates :last_name, presence: true

	has_many :suggestions, dependent: :destroy
	
end
