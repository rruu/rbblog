#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


get '/' do
    erb :index
  end

get '/new' do
    erb "Hello World"
end