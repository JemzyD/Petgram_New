class Post < ApplicationRecord

    acts_as_votable

    validates :user_id, presence: true
    mount_uploader :image, ImageUploader
    
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :notifications, dependent: :destroy
end
