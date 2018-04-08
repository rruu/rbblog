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

configure do
    init_db
    # таблица для постов
    @db.execute 'CREATE TABLE IF NOT EXISTS Posts ( id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT ) '
    # таблица для комментов
    @db.execute 'CREATE TABLE IF NOT EXISTS Comments ( id INTEGER PRIMARY KEY AUTOINCREMENT, created_date DATE, content TEXT, post_id integer) '
end

get '/' do
    @result = @db.execute 'select * from Posts order by id desc'
    erb :index
  end

get '/new' do
    erb :newpost
end

post '/new' do
    content = params[:content]
    if content.length <= 0
        @message = 'Error: You try send empty post'
        @type = 'danger'
        return erb :newpost
    end

    @db.execute 'INSERT INTO Posts (created_date, content) values (datetime(), ? )', [content]
    @message = 'Error: Your post created'
    @type = 'success'
    redirect to '/'
end

 get '/post/:post_id' do
     post_id = params[:post_id]
     erb "Display id #{post_id}"
     result = @db.execute 'select * from Posts where id = ?', [post_id]
     @row = result[0]

     @comments = @db.execute 'select * from comments where post_id = ? order by id', [post_id]
     erb :post
 end

post '/post/:post_id' do
    post_id = params[:post_id]
    content = params[:content]
    @db.execute 'insert into Comments (created_date, content, post_id) values (datetime(), ?, ?)', [content, post_id]
    redirect to ('/post/' + "#{post_id}")
end
