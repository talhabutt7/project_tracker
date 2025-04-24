class Project < ApplicationRecord
  STATUSES = ["New", "In Progress", "Completed", "Reopened"]

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :project_status_changes, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :assignees, through: :assignments, source: :user

  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
