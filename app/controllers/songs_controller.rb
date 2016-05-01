class SongsController < ApplicationController

	def index
		@user = User.find(session[:user_id])
		reverse_songs = Song.all.reverse_order
		songs = reverse_songs.pluck(:id)
		@table_info = []
		songs.each do |x|
			song_info = []
			song_info << Song.find(x).artist
			song_info << Song.find(x).title
			song_info << Link.where("song_id=#{x}").count	
			song_info << x
			@table_info << song_info		
		end
	end
	
	def create
		@song = Song.new(song_params)
		if @song.valid?
			@song.save
			Link.create(user_id:session[:user_id],song_id:Song.last.id)
			redirect_to '/songs'
		else
			flash[:errors] = @song.errors.full_messages
			redirect_to '/songs'
		end
	end

	def add_link
		Link.create(user_id:session[:user_id],song_id:params[:id])
		redirect_to '/songs'
	end

	def show
		@song = Song.find(params[:id])
		@users = Link.where("song_id='#{params[:id]}'").pluck(:user_id).uniq
		@table_info =[]
		users = Link.where("song_id='#{params[:id]}'").pluck(:user_id).uniq
		users.each do |x|
			user_info = []
			user_info << User.find(x).first_name 
			user_info << User.find(x).last_name 
			user_info << Link.where(user_id:x,song_id:params[:id]).count
			user_info << x
			@table_info << user_info
		end
	end

	private
		def song_params
			params.require(:song).permit(:title, :artist)
		end

end
