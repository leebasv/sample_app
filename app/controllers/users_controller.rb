class UsersController < ApplicationController
  before_action :get_user, except: [:index, :new, :create]
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
      log_in @user
      flash[:success] = t "users.create.success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.users_controller.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "users.users_controller.user_deleted"
      redirect_to users_path
    else
      flash[:warning] = t "users.users_controller.failed"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def get_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:warning] = t "users.users_controller.not_found"
    redirect_to root_path
  end
end
