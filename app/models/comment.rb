class Comment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :body, presence: true

  # Broadcast new comments to project's timeline stream
  after_create_commit -> {
    broadcast_append_to project,
                        target: "project_#{project.id}_timeline",
                        partial: "comments/comment", locals: { comment: self }
  }
end
