require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'pry'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/test2.db" )

class Tex
  include DataMapper::Resource

  property :blob, String
  property :id, String, :key => true
end

get '/' do
  erb :index
end

get '/id/:blog_id' do
  id = params[:blog_id]
  @tex = Tex.get(id)
  erb :raw
end
