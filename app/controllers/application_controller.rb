class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper #this is a helper for the Sessions Controller. I included it here in ApplicationComntroller because all Rails controllers inherit form ApplicationController. Therefore by including SessionsHelper in here, we can now use the SessionsHelper in any Controller that inherits from ApplicationController: Which is any Controller because they all inherit form this controller. 

  def home
    render "static_pages/home"
  end
end
