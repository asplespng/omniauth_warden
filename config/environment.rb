configure :development do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/omniauth_warden_dev')

  ActiveRecord::Base.establish_connection(
      adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
  )
  set :pony_defaults, {from: "admin@example.com", via: :smtp, via_options: { address: "localhost", port: 1025 }}
end

configure :test do
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/omniauth_warden_test')

  ActiveRecord::Base.establish_connection(
      adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      host: db.host,
      username: db.user,
      password: db.password,
      database: db.path[1..-1],
      encoding: 'utf8'
  )
  set :pony_defaults, {from: "admin@example.com", via: :smtp, via_options: { address: "localhost", port: 1025 }}
end