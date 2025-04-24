class User < ApplicationRecord
  # Devise modules: database authentication, registration, password recovery, remember me, validation
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :project_status_changes, dependent: :destroy
end
