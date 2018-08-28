class ProfilesController < ApplicationController
  before_action :set_user
  before_action :authenticate_user!
  before_action :owned_profile, only: [:edit, :update]

  def show
    @user = User.find_by(user_name: params[:user_name])
    @posts = User.find_by(user_name: params[:user_name]).posts.order('created_at DESC')
  end

  def edit
    @user = User.find_by(user_name: params[:user_name])
  end

  def update
    @user = User.find_by(user_name: params[:user_name])
    if @user.update(profile_params)
      redirect_to profile_path(@user.user_name)
    else
      render :edit
    end
    # render plain: params[:user].inspect
  end

  private

  def profile_params
    params.require(:user).permit(:avatar, :bio)
  end

  def owned_profile
    @user = User.find_by(user_name: params[:user_name])
    unless current_user == @user
      respond_to do |format|
        format.html { redirect_to posts_url, notice: "That profile doesn't belong to you!" }
        format.json { head :no_content }
      # flash[:alert] = "That profile doesn't belong to you!"
      # redirect_to root_path
      end
    end
  end

  def set_user
    @user = User.find_by(user_name: params[:user_name])
   end

end
