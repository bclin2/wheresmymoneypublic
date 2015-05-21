class EmailerController < ApplicationController

	include EmailerHelper

  def email
    state_code_results = get_state_link(params[:state_code])
    @user = User.find(session[:user_id])
    info = {
      "state_link" => state_code_results,
      "user_id" => @user.id,
    }
    FollowUpEmailJob.new(info).enqueue
    contacts = @user.provider == "google" ? true : false
    send_hash = {contacts: contacts, user_id: @user.id}
    render :json => send_hash.to_json
  end
end
