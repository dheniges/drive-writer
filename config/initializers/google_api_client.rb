
require 'google/api_client'

client = Google::APIClient.new(
  :application_name => 'Writer',
  :application_version => '1.0.0'
)

client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
client.authorization.client_secret = ENV['GOOGLE_SECRET_KEY']
client.authorization.scope = 'https://www.googleapis.com/auth/drive'

GOOGLE_API_CLIENT = client
GOOGLE_API_DRIVE = client.discovered_api('drive', 'v2')