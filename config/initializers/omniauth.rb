OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_CLIENT_KEY'], ENV['TWITTER_SECRET_KEY']
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
  {
    :name => "google",
    :scope => "plus.me, https://www.googleapis.com/auth/contacts.readonly, profile, email",
    :prompt => "select_account",
    :image_aspect_ratio => "square",
    :image_size => 50
  }
end
