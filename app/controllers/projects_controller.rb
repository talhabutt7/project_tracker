class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @my_projects = Project
                     .left_outer_joins(:assignments)
                     .where("projects.user_id = :user_id OR assignments.user_id = :user_id", user_id: current_user.id)
                     .distinct

    @projects = Project.includes(:user).order(created_at: :desc)  end

  def show
    # New comment form object and timeline events for this project
    @comment = Comment.new
    @timeline_events = (@project.project_status_changes + @project.comments)
                         .sort_by(&:created_at)
  end

  def new
    @project = Project.new(status: "New")
  end

  def edit
  end

  def create
    @project = current_user.projects.new(project_params)
    @project.status ||= "New"
    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @project = Project.find(params[:id])
    old_status = @project.status

    respond_to do |format|
      if @project.update(project_params)
        if old_status != @project.status
          ProjectStatusChange.create!(
            project: @project,
            user: current_user,
            previous_status: old_status,
            new_status: @project.status
          )
        end

        format.html do
          redirect_to @project, notice: "Project was successfully updated."
        end

        format.turbo_stream do
          flash.now[:notice] = "Project status updated."  # For Turbo Flash, optional
        end
      else
        format.html do
          render :edit, status: :unprocessable_entity
        end

        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "project_form",
            partial: "projects/form",
            locals: { project: @project }
          )
        end
      end
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_url, notice: "Project was successfully deleted."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    # Only allow title, description, and status (owner is current_user)
    params.require(:project).permit(:title, :description, :status, assignee_ids: [])
  end
end
