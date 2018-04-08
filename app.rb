#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
    @db = SQLite3::Database.new 'rbblog.db'
    @db.results_as_hash = true
end

before do
    init_db
end

get '/' do
    erb :index
  end

get '/new' do
    erb :newpost
end

post '/new' do
    #erb :newpost
    content = params[:content]
    erb "You tuped: #{content}"
end