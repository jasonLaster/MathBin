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
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/test3.db")

class Tex
  include DataMapper::Resource
  property :blob, String, :length => 1000
  property :bid, String, :key => true
end
DataMapper.auto_upgrade!


#  ROUTES
get '/embed/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)
  content_type 'text/javascript'
  html = erb(:embed).inspect
  
  puts "\n"*20 + html
  return "document.write(#{html})"
end


get '/' do
  erb :index
end

post %r{save} do
  @tex = Tex.create(:blob => params[:tex], :bid => create_id)
  redirect to("/#{@tex.bid}")
end


get '/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)
  @url = embed_url(@tex)
  erb :raw
end

get '/:bid/edit' do
  @tex = Tex.get(params[:bid])
  erb :index
end


def embed_url(tex)
  return "" if tex.nil?
  domain = development? ? "localhost:4555" : "mathbin.heroku.com"
  "http://#{domain}/embed/#{tex.bid}"
end

# HELPER METHODS
private

def create_id
  input = (48..57).to_a + (65..90).to_a + (97..120).to_a
  indeces = (Array.new(1, input.length) * 7).map {|i| rand(i)}
  chrs = indeces.map {|j| input[j].chr}.join()
  return chrs
end

