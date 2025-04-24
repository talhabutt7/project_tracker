class Project < ApplicationRecord
  STATUSES = ["New", "In Progress", "Completed"]

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :project_status_changes, dependent: :destroy

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  # Broadcast changes in status via timeline events (handled in ProjectStatusChange model)
end
