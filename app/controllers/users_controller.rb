class UsersController < ApplicationController
  before_action :admin_user,     only: [:destroy, :index] 
  before_action :correct_user, only: [:show]
  before_action :redirect_if_not_trusted, only: [:create, :new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to EVE Penny"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def destroy
    @user =  User.find(params[:id])
    if @user.admin?
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:email, :password,
                                   :password_confirmation, :character_id,
                                   :character_name)
    end

    def redirect_if_not_trusted
      redirect_to trust_path unless site_trusted?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.try(:admin?)
    end
end
