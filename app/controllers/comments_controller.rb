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

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
