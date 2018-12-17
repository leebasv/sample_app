class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      check_activated user
    else
      danger_flash
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
