class UsersController < ApplicationController
  get '/signup' do
    @error_message = params[:error]
    erb :'users/new'
  end

  post '/signup' do
    error_message = User.validate(params[:user][:username],params[:user][:password])
    if error_message
      redirect "/signup?error=#{error_message}"
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
