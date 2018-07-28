class Manager < ApplicationRecord
  has_many :users
  validates_presence_of :email, :username
end
