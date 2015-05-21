class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    session[:request_token]  = auth["credentials"]["token"]
    user = User.find_by(email: auth["info"]["email"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    if params[:provider] == "google"
      QueryForGoogleContacts.new(user.id, session[:request_token]).enqueue
    end

    redirect_to user_path(user)
  end

  def destroy
    session[:user_id] = nil
    # url = "https://accounts.google.com/o/oauth2/revoke"
    # response = HTTParty.get(url, query:{token: session[:request_token]})
    # session[:request_token] = nil
    redirect_to root_url, :notice => "Signed out!"
  end
end
