require 'sinatra'
require 'warden'
require 'omniauth-twitter'
require 'sinatra/activerecord'
require_relative 'config/environment'
require_relative 'models'

enable :sessions
set :session_secret, 'some_secret'

Warden::Manager.serialize_into_session do |user|
  user.id
end

Warden::Manager.serialize_from_session do |id|
  User.find_by_id(id)
end

use Warden::Manager do |config|
  config.failure_app = Sinatra::Application

  config.default_strategies :omni_twitter
end

use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_OMNIAUTH_KEY'], ENV['TWITTER_OMNIAUTH_SECRET']
end

helpers do
  def warden
    env["warden"]
  end

  def omniauth
    env['omniauth.auth']
  end

  def current_user
    warden.user
  end
end

get "/" do
  erb :index
end

get "/warden/callback" do
  erb :home if warden.authenticated?
end

get "/logout" do
  warden.logout
  redirect "/"
end

get "/auth/failure" do
  params[:message]
end



get "/auth/*/callback" do
  user = User.where( uid: omniauth['uid'], auth_provider: omniauth['provider']).first_or_initialize
  name = nil
  if omniauth['info']['name'].present?
    name = omniauth['info']['name']
  else
    if omniauth['info']['first_name'].present?
      name = omniauth['info']['first_name']
      name += " #{omniauth['info']['last_name']}" if omniauth['info']['last_name'].present?
    end
  end
  user.attributes = {uid: omniauth['uid'], name: name, auth_provider: omniauth['provider']}
  user.save! if user.changed.any?
  warden.set_user user
  redirect "/warden/callback"
end

__END__
@@layout
<!DOCTYPE html>
<html>
    <head>
        <title>Warden-OmniAuth</title>
    </head>
    <body>
        <%= yield %>
    </body>
</html>

@@index
<a href="/auth/twitter">Twitter</a>

@@home
<h1>Wellcome</h1>
<pre>
    <%= current_user.name %>
</pre>
