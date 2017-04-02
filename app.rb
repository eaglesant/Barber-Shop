#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
	@db = SQLite3::Database.new 'barbershop.db'
	@db.execute 'CREATE TABLE IF NOT EXISTS
				Users (
			    id         INTEGER PRIMARY KEY AUTOINCREMENT
			                       NOT NULL,
			    user_name  STRING  NOT NULL,
			    user_email TEXT,
			    user_phone TEXT    NOT NULL,
			    date_time  TEXT    NOT NULL,
			    barber     TEXT    NOT NULL,
			    color      TEXT
			)'
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

	# hh.each do |key, value|
	# 	if params[key] == ''
	# 		@error = hh[key]
	# 		return erb :visit
	# 	end
	# end

	@error = hh.select {|key,value| params[key] == ""}.values.join(", ")
	if @error != ''
		return erb :visit
	end

	# f = File.open "./public/users.txt", "a"

	# f.write "\nUser: #{@user_name}, phone: #{@user_phone}, Email: #{@user_email}, date and time: #{@date_time}, barber: #{@barber}, color: #{@color}"
	# f.close
	
	erb :message


end