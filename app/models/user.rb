class User < ActiveRecord::Base

  attr_accessor :auth

  def self.from_omniauth(auth)
    if user = User.find_by_email(auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid # Does this change? Save the user? Why reset it?
      user
    else
      where(auth.slice(:provider, :uid)).create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.name = auth.info.name
        user.email = auth.info.email
        user.last_sign_in_at = Time.now
      end
    end
  end

  # Callback for sign-in
  def track
    self.last_sign_in_at = self.current_sign_in_at if self.current_sign_in_at
    self.current_sign_in_at = Time.now
    self.sign_in_count += 1
    self.save
  end

  # Cleanup to run if user signs out
  def sign_out
    Rails.cache.delete(keyring(:documents))
  end

  def keyring(key)
    case key.to_sym
    when :documents then "#{cache_prefix}documents"
    else
      nil
    end
  end

  protected

  def cache_prefix
    "#{self.uid}:"
  end

end
