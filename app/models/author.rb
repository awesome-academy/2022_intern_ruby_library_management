class Author < ApplicationRecord
  FIELD_PERMIT = %i(name gender dob description image).freeze
  enum gender: {male: 1, female: 0, other: 2}

  has_many :books, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true, length:
            {minimum: Settings.author.min, maximum: Settings.author.max}
  validates :gender, presence: true
  validates :dob, presence: true
  validates :description, presence: true, length:
            {minimum: Settings.author.min, maximum: Settings.author.max}
  validates :image, content_type: {in: Settings.author.image_type},
                    size: {less_than: Settings.author.image_size.megabytes}

  ransack_alias :name_desc, :name_or_description

  scope :latest, ->{order created_at: :desc}

  def display_image
    image.filename.present? ? image : Settings.user.avatar_default
  end

  ransacker :dob do
    Arel.sql("date(dob)")
  end
end
