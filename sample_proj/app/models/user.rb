class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable #:encryptable
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :employee_comments, dependent: :destroy
  belongs_to :role
  attr_accessor :login
  belongs_to :manager

  validates :username,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  #validates_inclusion_of :admin, :in => [true, false]
  #validates_presence_of :admin, optional: true

  validate :validate_username

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def set_default_admin
    self.admin ||= false
  end

end
