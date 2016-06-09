# coding: utf-8
require "sinatra"
require "warden"
require "omniauth"
require "omniauth-twitter"
# require "warden_omniauth"

enable :sessions

Warden::Manager.serialize_into_session do |user|
  user
end
Warden::Manager.serialize_from_session do |user|
  user
end

use Warden::Manager do |config|
  config.failure_app = Sinatra::Application

  config.default_strategies :omni_twitter
end

use OmniAuth::Builder do
  provider :twitter, "api key", "secret"
end

# use WardenOmniAuth do |config|
#   config.redirect_after_callback = "/warden/callback"
# end

helpers do
  def warden
    request.env["warden"]
  end

  def current_user
    warden.user
  end
end

get "/" do
  erb :index
end

get "/warden/callback" do
  erb :home
end

get "/logout" do
  request.env["warden"].logout
  redirect "/"
end

get "/auth/failure" do
  params[:message]
end


get "/auth/twitter/callback" do
  warden.set_user env['omniauth.auth']['uid']
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
<a href="/auth/twitter">Twitter でログイン</a>

@@home
<h1>Wellcome</h1>
<pre>
    <%= current_user %>
</pre>
