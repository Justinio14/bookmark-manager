
ENV["RACK_ENV"] ||= "development" # ensures app runs in development mode by default

require 'sinatra/base'
require './models/data_mapper_setup'
require 'sinatra/flash'

class BookmarkManager < Sinatra::Base

use Rack::MethodOverride

enable :sessions
set :session_secret, 'super secret'

register Sinatra::Flash
# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") }
# helper method

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all # try to access a property

    erb :links
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      redirect to("/links")
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session[:user_id] = nil
    flash.keep[:notice] = 'goodbye!'
    redirect to '/links'
  end

  post '/links' do
    link = Link.create(url: params[:url], title: params[:title])
    # tag  = Tag.first_or_create(name: params[:tags])
    # link.tags << tag
    params[:tags].split.each do |tag|
    link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect to('/links')
  end

  get '/new' do
    erb :new
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :links
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
    session[:user_id] = @user.id
    redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages #"Password and confirmation password do not match"
      erb :'users/new'
    end
  end

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
