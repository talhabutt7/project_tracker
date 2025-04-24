class ApplicationController < ActionController::Base
  # Require authentication for all actions by default
  before_action :authenticate_user!
end
