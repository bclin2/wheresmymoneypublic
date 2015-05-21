class FriendEmailJob < ActiveJob::Base

  queue_as :FriendEmailJob

  def perform(contact_id, user_id)

    contact = User.find(contact_id)

    user = User.find(user_id)

    FriendMailer.friend_email(user, contact).deliver_now

  end

end
