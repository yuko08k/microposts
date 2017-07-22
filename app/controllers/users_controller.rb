class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]

  # 一覧ページ
  def index
     @users = User.all.page(params[:page])
  end

  # 個別ページ
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  # new と create はセット
  # new ... 新規登録画面を表示するだけで、ボタンを押すと create に飛ぶ！
  # create ... 新規登録を実際に行うアクション（だから、create には view が存在しなくて、さっき手動で消した）
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end