module User::Oauthable
  extend ActiveSupport::Concern

  included do
    has_many :access_grants, :class_name => 'Oauth::AccessGrant'
  end

  module ClassMethods
    def find_for_token_authentication(options = {})
      joins(:access_grants).where(["access_grants.access_token = ? AND (access_grants.access_token_expires_at IS NULL OR access_grants.access_token_expires_at > ?)", options["access_token"], Time.now]).first
    end
  end
end