class FriendMailer < ActionMailer::Base
  default from: "no_reply@wheresmymoney.com"

  def friend_email(user, contact)

    @user = user

    @contact = contact

    mail(
      to: "zipclang@gmail.com",
      subject: "#{@user.name.capitalize} just found your money!",
    )

  end
end

