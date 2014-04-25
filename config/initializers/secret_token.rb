# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Merikotkat::Application.config.secret_key_base = '42b0dc14ecb134b2b209a25ca99a1c6929fa235e0871a46c67bdbfff0e5f8b952462cfd7400354af44b964adbaa615bdc333a39864334bdf9e154578c345b29d' if Rails.env.prod?
Merikotkat::Application.config.secret_key_base = '42b0dc14ecb134b2b209a25ca99a1c6929fa235e0871a46c67bdbfff0e5f8b952462cfd7400354af44b964adbcd615bdc333a39864334bdf9e154578c345b29d' if !Rails.env.prod?
