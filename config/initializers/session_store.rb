# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_maor_session',
  :secret      => 'f608ce403a0a2dcca9ad07ec4e5efa5ba6f95ab4d943a8b8d3f62a7339ae78e0aa4661503a287cb299dca74d7fe8210b7b3c9f3a931763a64855aab353b2d7cb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
