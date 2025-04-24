class CommentsController < ApplicationController
  before_action :set_project

  def create
    @comment = @project.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.turbo_stream   # see app/views/comments/create.turbo_stream.slim
        format.html { redirect_to @project, notice: "Comment added." }
      end
    else
      respond_to do |format|
        format.turbo_stream   # handle validation errors via Turbo Stream
        format.html { redirect_to @project, alert: "Failed to add comment." }
      end
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
