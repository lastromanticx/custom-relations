require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "custom_secret"
  end

  get '/' do
    erb :index
  end

  helpers do
    def redirect_if_not_logged_in
      if !is_logged_in?
        redirect "/login?error=Please login or signup."
      end
    end

    def is_logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
