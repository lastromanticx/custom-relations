require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "custom_secret"
  end

  get '/' do
    if is_logged_in?
      redirect '/users'
    else
      erb :index
    end
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

    # https://www.ruby-forum.com/topic/62095
    def nl2br(string)
      string.gsub("\n\r","<br>").gsub("\r", "").gsub("\n", "<br />")
    end
  end

end
