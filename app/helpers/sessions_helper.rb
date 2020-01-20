module SessionsHelper
    # Logs in the given user.
    def log_in(this_user)
        session[:user_id] = this_user.id
    end

    # Tries to find a user to login if one isnt logged in already. 
    def current_user(forget: nil)
        if forget
            @current_user = nil
        else
            @current_user ? @current_user : find_user
        end
    end

    # Finds and logs in a user corresponding to the remember token cookie. 
    def find_user
        if (user_id = session[:user_id])
            @current_user ||= User.find_by(id: user_id)
        elsif (user_id = cookies.signed[:user_id])
            this_user = User.find_by(id: user_id)
            if this_user && this_user.authenticated?(cookies[:remember_token])
                log_in(this_user)
                @current_user = this_user
            end
        end
    end

    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        !current_user.nil?
    end

    #Forgets a permanent session
    def forget(user)
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    # Logs out the current user
    def log_out
        forget(current_user)
        session.delete(:user_id)
        current_user(forget: true)
    end

    def remember(this_user)
        this_user.remember
        cookies.permanent.signed[:user_id] = this_user.id
        cookies.permanent[:remember_token] = this_user.remember_token
    end

    def current_user?(user)
        user == current_user
    end

    def redirect_back_or(default)
        redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end

    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end

end