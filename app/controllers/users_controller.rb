class UsersController < ApplicationController
  
  include SessionsHelper #課題　ここを追加
  
  before_action :set_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcom to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
   if logged_in? == false #課題　ここから追加
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    
   elsif @current_user != User.find(params[:id])
      store_location
      flash[:danger] = "You do not have permission to edit this user's Information"
      redirect_to user_path
   end #課題　ここまで追加
  end
  
  def update
   if logged_in? == false #課題　ここから追加
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    
  elsif @current_user[:id] != @user[:id]#User.find(params[:id])だと動かないので、@user[:id]に変更してみた
     store_location
     flash[:danger] = "You do not have permission to edit this user's Information"
     redirect_to user_path
      
   elsif @user.update(user_params)#ここまで変更
    redirect_to @user , notice:'ユーザー情報を編集しました'
   
   else
    # 保存に失敗した場合は編集画面へ戻す
    render 'edit'
   end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_comfirmation, :area, :profile)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
end
