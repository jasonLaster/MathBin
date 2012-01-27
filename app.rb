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


#  ROUTES: (/, /:bid, /embed/:bid, /raw/:bid)

get '/' do
  bid = create_id
  redirect to("/#{bid}")
end

get '/:bid' do
  @bid = params[:bid]
  @tex = Tex.get(@bid)
  @embed_url = embed_url(@tex || @bid) 
  erb :index
end

get '/embed/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)

  content_type 'text/javascript'
  html = erb(:embed).inspect
  return "document.write(#{html})"
end

get '/raw/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)
  @url = embed_url(@tex)
  erb :raw
end

post '/save' do
  
  @tex =
    if Tex.get(params[:bid]) then Tex.create(:blob => params[:tex], :bid => create_id)
    else Tex.create(:blob => params[:tex], :bid => params[:bid])
    end
  redirect to("/#{@tex.bid}")
end


helpers do
  def domain
    development? ? "http://localhost:4555" : "http://mathbin.heroku.com"
  end
end

def embed_url(e)
  domain = development? ? "http://localhost:4555" : "http://mathbin.heroku.com"
    
  if e.nil? then ""
  elsif e.respond_to?(:bid) then "#{domain}/embed/#{e.bid}"
  else "#{domain}/embed/#{e}"
  end
end

# HELPER METHODS
private

def create_id
  input = (48..57).to_a + (65..90).to_a + (97..120).to_a
  indeces = (Array.new(1, input.length) * 7).map {|i| rand(i)}
  chrs = indeces.map {|j| input[j].chr}.join()
  return chrs
end

