class User < ActiveRecord::Base
  validates :name, presence: true
  validates :uid, uniqueness: {scope: :auth_provider}
end