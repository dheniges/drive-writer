module ApplicationHelper

  def sign_in_path
    '/auth/google'
  end

  def from_auth(key)
    find_in_auth(key.to_s)
  end

  # Deep searches oauth2 hash from google
  def find_in_auth(key)
    auth = session[:auth]
    return auth[key] if auth.has_key?(key)
    auth.keys.each do |root_key|
      next unless auth[root_key].is_a?(Hash)
      return auth[root_key][key] if auth[root_key].has_key?(key)
    end
    return nil
  end

end
