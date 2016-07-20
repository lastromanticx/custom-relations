class UsersController < ApplicationController
  get '/signup' do
    @error_message = params[:error]
    erb :'users/new'
  end

  post '/signup' do
    existing = User.find_by(username: params[:user][:username])
    if existing
      redirect '/signup?error=Sorry, that username is taken.'
    elsif !User.validate_username(params[:user][:username])
      redirect '/signup?error=Please use up to 16 alphanumeric characters for the username.'
    elsif !User.validate_password(params[:user][:password])
      redirect "/signup?error=#{CGI.escape("Please use between 4 and 16 alphanumeric characters and/or these symbols in your password, !@#$%&*")}"
    else
      @user = User.create(params[:user])
      session[:user_id] = @user.id
      redirect "/users/#{@user.username}"
    end
  end

  get '/login' do
    @error_message = params[:error]
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:user][:username])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect "/users"
    else
      redirect '/login?error=Could not log in. Please check your username or password.'
    end
  end

  get '/users' do
    redirect_if_not_logged_in

    @users = User.all
    erb :'/users/index'
  end

  get '/users/:username' do
    @user = User.find_by(username: params[:username])
    erb :'/users/show'
  end

  get '/logout' do
    session.clear
    erb :index
  end
end
