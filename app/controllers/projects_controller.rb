class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = Project.all.includes(:user).order(created_at: :desc)
  end

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
    old_status = @project.status
    if @project.update(project_params)
      # Log status change if status was updated
      if old_status != @project.status
        ProjectStatusChange.create!(
          project: @project,
          user: current_user,
          previous_status: old_status,
          new_status: @project.status
        )
      end
      respond_to do |format|
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.turbo_stream   # see app/views/projects/update.turbo_stream.slim
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream   # handle validation errors via Turbo Stream
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
    params.require(:project).permit(:title, :description, :status)
  end
end
