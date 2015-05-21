class UserMailer < ActionMailer::Base
  default from: "no_reply@wheresmymoney.com"

  def follow_up_email(user, email, state_code_results)


  	@user = user

  	@state_link = state_code_results

    mail(
      to: email,
      subject: "Hi #{user.first_name.capitalize}. Your money is waiting to be claimed.",
      )

  end
end
