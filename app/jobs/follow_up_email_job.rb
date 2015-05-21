class FollowUpEmailJob < ActiveJob::Base

  queue_as :FollowUpEmailJob

  def perform(info)
    info["state_link"].each do |state_code|
      state_link = state_code
      user = User.find(info["user_id"])

      email = if Rails.env.production?
        user.email
      else
        "zipclang@gmail.com"
      end
      UserMailer.follow_up_email(user, email, state_link).deliver_now
    end
  end
end
