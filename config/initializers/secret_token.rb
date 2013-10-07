# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
JenkinsDaemon::Application.config.secret_key_base = 'bb80dc8abc258f6ba7aee23535359498d8b719b53822446c0358fc3b335481c92cbe660cb145023e0581e505946f8478c3eef4fbbfa0fd052391c89f98643794'
