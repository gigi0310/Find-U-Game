def logged_in?
      !!current_user
    end

    def login(username, password)
      user = User.find_by(:username => username)

      if user && user.authenticate(password)
        session[:username] = user.username
        session[:user_id] = user.id
      else
        redirect '/login'
      end
    end

    def current_user
      @current_user ||= User.find_by(:username => session[:username]) if session[:username]
    end

    def logout
      session.clear
    end
    
  end

end


# Find-U-Game
