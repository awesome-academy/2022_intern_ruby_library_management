class User < ApplicationRecord
  enum role: {user: 0, super_admin: 1, manager: 2}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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

  private

  def downcase_email
    email.downcase!
  end

  def send_devise_notification notification, *args
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
