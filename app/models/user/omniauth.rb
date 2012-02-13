module User::Omniauth
  extend ActiveSupport::Concern


  def update_facebook_from_oauth(auth_hash)
    fb_token_from_hash    = auth_hash["credentials"]["token"]
    facebook_id_from_hash = auth_hash["uid"]
    if (fb_token != fb_token_from_hash || facebook_id != facebook_id_from_hash)
      update_attributes(:fb_token => fb_token_from_hash, :facebook_id => facebook_id_from_hash)
    end
    self
  end

  def update_twitter_from_oauth(auth_hash)
    token_from_hash = auth_hash["credentials"]["token"]
    twitter_id_from_hash = auth_hash["user_info"]["nickname"]
    if (twitter_token != token_from_hash || twitter_id != twitter_id_from_hash)
      update_attributes(:twitter_token => token_from_hash, :twitter_id => twitter_id_from_hash)
    end
    self
  end

  module ClassMethods
    def find_for_facebook_oauth(auth_hash, signed_in_resource=nil)
      email =    auth_hash['extra']['user_hash']['email']
      user  =    User.where(:facebook_id => auth_hash["uid"]).first || User.find_by_email(email)
      user  ||=  User.create_fb_user_from_omniauth(auth_hash)
      user.update_facebook_from_oauth(auth_hash)
      user
    end

    def find_for_twitter_oauth(auth_hash, signed_in_resources=nil)
      user = User.where(:twitter_id => auth_hash["user_info"]["nickname"]).first
      user ||= User.create_tw_user_from_omniauth(auth_hash)
      user.update_twitter_from_oauth(auth_hash)
      user
    end


    def create_tw_user_from_omniauth(auth_hash)
      user_info = auth_hash['extra']['user_hash']
      User.create(
                   :password    => Devise.friendly_token[0,20],
                   :name        => user_info["name"],
                   :location    => user_info["location"].try(:[], "name"),
                   :twitter_token => auth_hash["credentials"]["token"],
                   :twitter_id => user_info["nickname"],
                   )
    end

    def create_fb_user_from_omniauth(auth_hash)
      user_info = auth_hash['extra']['user_hash']
      User.create( :email       => user_info["email"],
                   :password    => Devise.friendly_token[0,20],
                   :name        => user_info["name"],
                   :location    => user_info["location"].try(:[], "name"),
                   :fb_token    => auth_hash["credentials"]["token"],
                   :facebook_id => auth_hash["uid"],
                   :photo       => User.facebook_pic_from_omniauth(auth_hash))
    end


    def facebook_pic_from_omniauth(auth_hash, size = :large)
      return nil if auth_hash.blank? || auth_hash['user_info'].blank? || auth_hash['user_info']['image'].blank?
      image_url = URI.join(auth_hash['user_info']['image'], "?type=#{size}").to_s
      picture   = HTTParty.get(image_url)
      StringIO.new(picture)
    end
  end
end