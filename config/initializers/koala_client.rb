require_relative '../../lib/koala_client'

KoalaClient.configure do |config|
 config.session_expires_after = 15 #minutes from now
 config.public_key_file = ::Rails.root.join('config','lintuvaara_public_key.pem')
end