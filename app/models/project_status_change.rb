class ProjectStatusChange < ApplicationRecord
  belongs_to :project
  belongs_to :user

  # Broadcast new status changes to project's timeline stream
  after_create_commit -> {
    broadcast_append_to project,
                        target: "project_#{project.id}_timeline",
                        partial: "project_status_changes/project_status_change", locals: { project_status_change: self }
  }
end
