class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :post_id, presence: true
  acts_as_tree order: "created_at ASC"
end
