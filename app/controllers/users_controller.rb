class UsersController < ApplicationController
  before_action :load_user, except: [:index, :new, :create]
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :is_admin?, only: :destroy

  def index
    @users = User.paginate page: params[:page],
      per_page: Settings.users.page_items_count
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.create.success"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.private.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.private.user_deleted"
      redirect_to users_path
    else
      flash[:warning] = t "users.private.failed"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users.private.not_found"
    redirect_to root_path
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "users.private.pls_log_in"
    redirect_to login_path
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def is_admin?
    redirect_to root_path unless current_user.admin?
  end
end
