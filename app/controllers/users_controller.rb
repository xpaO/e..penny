class UsersController < ApplicationController

  before_action :redirect_if_not_trusted, only: [:create, :new]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      #sign_in @user
      flash[:success] = "Welcome to EVE Penny"
      redirect_to root_path
    else
      render 'new'
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
end
