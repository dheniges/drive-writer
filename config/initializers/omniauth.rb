
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_SECRET_KEY"],
    name: 'google',
    prompt: 'select_account',
    image_aspect_ratio: 'square',
    image_size: 30,
    scope: 'email,profile,drive'
end