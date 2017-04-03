#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'


def get_db
	return SQLite3::Database.new 'barbershop.db'
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

	# db.execute 'CREATE TABLE IF NOT EXISTS
	# 			Barbers (
	# 		    id         INTEGER PRIMARY KEY AUTOINCREMENT
	# 		                       NOT NULL,
	# 		    barber_name  TEXT  NOT NULL
	# 		)'
	# barber_name = ['Gus Fring', 'Jessie Pinkman', 'Walter White']
	# barber_name.each_index do |i|
	# db.execute 'INSERT INTO Barbers(barber_name)
	# VALUES(?)',
	# 			[barber_name[i]]
	# 		end
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
	@barbers_name = ['Gus Fring', 'Jessie Pinkman', 'Walter White', 'Robbin Gudd']
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

	@title_mess = 'Thank you!'

	@message = "Dear #{@user_name}, we'll waiting for you at #{@date_time} with #{@barber}, color: #{@color}"


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
