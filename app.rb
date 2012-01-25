require 'bundler/setup'
require 'data_mapper'
require 'sinatra'

if production?
  require 'dm-postgres-adapter'
end

if development?
  require 'dm-sqlite-adapter'
  require "sinatra/reloader"
  require 'pry'
end



DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

class Tex
  include DataMapper::Resource
  property :blob, String, :length => 1000
  property :bid, String, :key => true
end
DataMapper.auto_upgrade!


#  ROUTES
get '/' do
  erb :index
end

post '/save' do
  @tex = Tex.create(:blob => params[:tex], :bid => create_id)
  redirect to("/#{@tex.bid}")
end


get '/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)
  erb :raw
end

get '/:bid/edit' do
  @tex = Tex.get(params[:bid])
  erb :index
end



# HELPER METHODS
private

def create_id
  input = (48..57).to_a + (65..90).to_a + (97..120).to_a
  indeces = (Array.new(1, input.length) * 7).map {|i| rand(i)}
  chrs = indeces.map {|j| input[j].chr}.join()
  return chrs
end

