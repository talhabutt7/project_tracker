module ApplicationHelper
  def time_ago(comment)
    time = time_ago_in_words(comment.created_at)
    comment.created_at > 1.minute.ago ? "just now" : "#{time} ago"
  end
end
