Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_KEY"], ENV["TWITTER_SECRET"]
  provider :facebook, ENV['FACEBOOK_KEY'], ENV["FACEBOOK_SECRET"], display: 'popup', scope: 'email,publish_actions,user_likes,manage_pages,user_friends,publish_pages'
end

OmniAuth.config.on_failure = Proc.new do |env|
  ConnectionsController.action(:omniauth_failure).call(env)
end
