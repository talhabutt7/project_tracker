class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :project_status_changes, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :assigned_projects, through: :assignments, source: :project

  def full_name
    "#{first_name} #{last_name}".strip.presence || email
  end
end
