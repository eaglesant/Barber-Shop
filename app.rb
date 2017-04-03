#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barbers_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barbers_exists? db, barber
			db.execute 'insert into Barbers (name) values(?)', [barber]
		end
	end	
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end
before do
	db = get_db
	@barbers = db.execute 'select * from Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	Users (
	id         INTEGER PRIMARY KEY AUTOINCREMENT
	NOT NULL,
	user_name  TEXT  NOT NULL,
	user_email TEXT,
	user_phone TEXT    NOT NULL,
	date_time  TEXT    NOT NULL,
	barber     TEXT    NOT NULL,
	color      TEXT
	)'

	db.execute 'CREATE TABLE IF NOT EXISTS
	Barbers (
	id         INTEGER PRIMARY KEY AUTOINCREMENT
	NOT NULL,
	name  TEXT  NOT NULL
	)'
	seed_db db, ['Gus Fring', 'Jessie Pinkman', 'Walter White', 'Robbe Whiliams']
	
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end
get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end
get '/visit' do
	erb :visit
end
get '/show_users' do
	db = get_db
	@results = db.execute 'SELECT * FROM Users order by id desc'

	erb :show_users
end
post '/visit' do
	@user_name = params[:user_name]
	@user_email = params[:user_email]
	@user_phone = params[:user_phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:colorpicker]

	@message = "<h2>Fanks, you are anroll!! </h2>"


	hh = {:user_name => 'Enter name',
		:user_email => 'Enter email',
		:user_phone => 'Enter phone',
		:date_time => 'Enter date and time' }


		@error = hh.select {|key,value| params[key] == ""}.values.join(", ")
		if @error != ''
			return erb :visit
		end

		db = get_db
		db.execute 'insert into
		Users
		(
		user_name,
		user_email,
		user_phone,
		date_time,
		barber,
		color
		)
		values (?,?,?,?,?,?)',
		[@user_name, @user_email, @user_phone, @date_time,@barber, @color ]


		erb :message


	end
