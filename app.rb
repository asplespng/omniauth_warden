require 'sinatra'
require 'warden'
require 'omniauth-twitter'
require 'sinatra/activerecord'
require_relative 'config/environments'
require_relative 'models'

enable :sessions

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
  provider :twitter, ENV['TWITTER_OMNIAUTH'], ENV['TWITTER_OMNIAUTH_SECRET']
end

helpers do
  def warden
    env["warden"]
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
  auth = env['omniauth.auth']
  user = User.where( uid: auth['uid'], auth_provider: auth['provider']).first_or_initialize
  name = nil
  if auth['info']['name'].present?
    name = auth['info']['name']
  else
    if auth['info']['first_name'].present?
      name = auth['info']['first_name']
      name += " #{auth['info']['last_name']}" if auth['info']['last_name'].present?
    end
  end
  user.attributes = {uid: auth['uid'], name: name, auth_provider: auth['provider']}
  user.save!
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
