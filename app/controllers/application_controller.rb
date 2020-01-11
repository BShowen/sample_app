class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper # This is a helper for the Sessions Controller. I included it here in ApplicationController because all Rails controllers inherit form ApplicationController. Therefore by including SessionsHelper in here, we can now use the SessionsHelper methods in any Controller that inherits from ApplicationController: Since all controllers inherit form this ApplicationController we now have access to SessionsHelpers methods in all Controllers in this app. 

  def home
    render "static_pages/home"
  end
end
