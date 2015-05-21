class UserController < ApplicationController

  def show
    @user = if params[:id].to_i < 0
      name = [params[:user][:first_name], params[:user][:last_name]].join(" ")
      # User.find_or_create_by(name: name, email: params[:user][:email])
      User.find_or_create_by(name: name, email: params[:user][:email])
    else
      User.find(params[:id])
    end
    session[:user_id] = @user.id
    Result.factory(@user)

    render "results"
  end

  def sendemail
    unless params[:contacts] == nil then
      params[:contacts].each do |contact_id|
        FriendEmailJob.new(contact_id, session[:user_id]).enqueue
      end
    end
    render 'thankyou'
  end

end
