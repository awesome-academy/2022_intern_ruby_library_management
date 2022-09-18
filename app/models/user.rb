class User < ApplicationRecord
  enum role: {user: 0, super_admin: 1, manager: 2}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :omniauthable, omniauth_providers: [:facebook, :google_oauth2]

  before_save :downcase_email
  has_one_attached :image

  has_many :books, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :name, presence: true, length: {maximum: Settings.user.name_max}
  validates :email, presence: true, length: {maximum: Settings.user.email_max},
                    format: {with: Settings.user.email_regex},
                    uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.user.password_minimum},
                       allow_nil: true

  scope :latest_user, ->{order created_at: :desc}

  def remember
    self.remember_token = User.new_token
    update remember_digest: User.digest(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end

  def activate_admin
    update_columns admin: true
  end

  class << self
    def from_omniauth auth
      result = User.where(email: auth.info.email).first
      result || where(provider: auth.provider,
                      uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.avatar = auth.info.image
        user.uid = auth.uid
        user.provider = auth.provider
        user.user!
      end
    end
  end

  private

  def downcase_email
    email.downcase!
  end

  def send_devise_notification notification, *args
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
