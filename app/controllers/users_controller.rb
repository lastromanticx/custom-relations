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
    elseif !User.validate_password(params[:user][:password])
      redirect '/signup?error="Please use up to 16 alphanumeric characters and/or these symbols in your password, !@#$%&*"'
    else
      @user = User.create(params[:user])
      erb :'/users/show'
    end
  end

  get '/login' do
    @error_message = params[:error]
    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.slug}"
    else
      redirect '/login?error=We cannot find a match. Please check your username or password.'
    end
  end

  get '/users/:username' do
    user = User.find_by(username: params[:username])
  end

  get '/logout' do
    session.clear
    erb :index
  end
end
