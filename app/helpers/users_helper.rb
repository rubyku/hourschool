module UsersHelper

  def avatar_for(user, options = {})
    options[:class]||="avatar-big"
    if user.photo.exists?
      return image_tag(user.photo.url(:small), options)
    else
      avatar_url = ['/images/v2/Avatars_01_V1.png',
                    '/images/v2/Avatars_02_V1.png',
                    '/images/v2/Avatars_03_V1.png',
                    '/images/v2/Avatars_04_V1.png',
                    '/images/v2/Avatars_05_V1.png' ].sample
      return image_tag(avatar_url, options)
    end
  end

  def link_to_avatar(user, options = {})
     link_to avatar_for(user, options), user
  end
  
end
