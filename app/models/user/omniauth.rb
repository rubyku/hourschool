module User::Omniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def find_for_facebook_oauth(auth_hash, signed_in_resource=nil)
      email =    auth_hash['extra']['user_hash']['email']
      user  =    User.find_by_email(email)
      user  ||=  User.create_from_omniauth(auth_hash)
      if user && (user.fb_token.blank? || user.facebook_id.blank?)
        user.update_attributes(:fb_token => auth_hash["credentials"]["token"], :facebook_id => auth_hash["uid"])
      end
      user
    end


    def create_from_omniauth(auth_hash)
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