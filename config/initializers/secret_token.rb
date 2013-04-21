# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Besko::Application.config.secret_token = ENV['SECRET_TOKEN'] || '8763c22ff834e68dfd910c33ab40468aa37481b9c24cd8a754b6f37a19f281f33d31093cdcf7a0296642d444a9ff5b67f4e3ff31ce965d060e710dc47240a81b'
