module Helpers
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Log in as a particular user.
  def log_in_as(user)
    request.session[:user_id] = user.id
  end

  def login_request_as(user)
    post login_path, params: { 
      session: { 
        email: user.email, 
        password: user.password 
        } 
      } 
  end
end