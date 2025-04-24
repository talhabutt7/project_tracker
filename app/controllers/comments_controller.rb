class CommentsController < ApplicationController
  before_action :set_project

  def create
    @project = Project.find(params[:project_id])
    @comment = @project.comments.new(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.html { redirect_to @project }
      end
    else
      render partial: "comments/form", locals: { project: @project, comment: @comment }, status: :unprocessable_entity
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @comment = @project.comments.find(params[:id])
    render partial: "comments/comment", locals: { comment: @comment, editing_comment: @comment }
  end

  def update
    @project = Project.find(params[:project_id])
    @comment = @project.comments.find(params[:id])
    if @comment.update(comment_params)
      render partial: "comments/comment", locals: { comment: @comment }
    else
      render partial: "comments/comment", locals: { comment: @comment, editing_comment: @comment }, status: :unprocessable_entity
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
