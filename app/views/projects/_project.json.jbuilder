json.extract! project, :id, :title, :description, :status, :user_id, :created_at, :updated_at
json.url project_url(project, format: :json)
