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
get '/examples' do
  erb :examples
end

get '/' do
  bid = create_id
  redirect to("/#{bid}")
end

get '/:bid' do
  @bid = params[:bid]
  @tex = Tex.get(@bid) || Tex.new(:bid => @bid, :blob => cool_eq)
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

get '/tex/:bid' do
  id = params[:bid]
  @tex = Tex.get(id)
  @url = embed_url(@tex)
  erb :tex
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

def cool_eq 
  write_here = "<!-- Write Here -->"
  eqs = %w{$-1=e^{i\pi}$  $e=\lim_{n\rightarrow \infty}{(1+\frac{1}{n})^n}$  $\pi=\frac{c}{d}$ $\frac{d}{dx}e^x=e^x$ $a^2+b^2=c^2$ $\frac{d}{dx}\int_a^x{f(s)ds}=f(x)$ $f(x)=\sum_{i=0}^\infty{\frac{f^{(i)}(0)}{i!}x^i}$}
  eq = eqs[rand(eqs.length)]
  write_here + "\n"+ eq
end


def embed_url(e)
  domain = development? ? "http://localhost:4555" : "http://mathbins.com"
    
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

