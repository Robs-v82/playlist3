class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      session[:user_id] =  User.last.id
      redirect_to '/songs'
    else
      @errors = @user.errors.full_messages
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
    songs = Link.where("user_id=#{params[:id]}").pluck(:song_id).uniq
    @table_info = []
    songs.each do |x|
      song_info = []
      song_info << Song.find(x).artist
      song_info << Song.find(x).title
      song_info << Link.where("user_id=#{params[:id]} and song_id=#{x}").count
      @table_info << song_info
    end
  end

  def login
    @user = User.find_by_email(login_params[:email])
    if @user
      if @user.authenticate(login_params[:password])
        session[:user_id] = @user.id
        redirect_to '/songs'
      else
        @login_errors = ["Wrong password"]
        render :new
      end
    else
      @login_errors = ["Email is not registered"]
      render :new
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to '/users/new'
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end

    def login_params
      params.require(:user).permit(:email, :password)
    end

end
