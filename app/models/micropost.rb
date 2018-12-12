class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.content_length}
  validate :picture_size
  scope :newest, ->{order created_at: :desc}

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size > Settings.micropost.maximum_size.megabytes
    errors.add(:picture, t("microposts.micropost.size_error"))
  end
end
