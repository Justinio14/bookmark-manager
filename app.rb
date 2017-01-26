
ENV["RACK_ENV"] ||= "development" # ensures app runs in development mode by default

require 'sinatra/base'
require './models/data_mapper_setup'

class BookmarkManager < Sinatra::Base

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
  # start the server if ruby file executed directly
  run! if app_file == $0
end
