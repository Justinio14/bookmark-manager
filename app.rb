
ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
#require './models/link'
#require './models/tag'
require './models/data_mapper_setup'

class BookmarkManager < Sinatra::Base

# sets the view directory correctly
set :views, Proc.new { File.join(root, "views") }

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all # try to access a property

    erb :links
  end

  post '/links' do
    link = Link.new(url: params[:url],
                    title: params[:title])
    params[:tags].split.each do |tag|
    link.tags << Tag.create(name: tag)
   end
    link.save
    redirect '/links'
  end

  get '/new' do
    erb :new
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links'
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
