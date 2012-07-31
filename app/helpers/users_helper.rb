module UsersHelper

  # avatar_for(@user, :photo_size => :thumb_small) will generate image_tag(@user.photo.url(:thumb_small))
  def avatar_for(user, size = :small, options = {})
    if size.is_a?(Hash) 
      photo_size = size.delete(:size)
      options    = size.merge(options)
      size       = photo_size
    end
    options[:class]
    if user && user.photo.present?
      return image_tag(user.photo.url(size), options)
    else
      avatar_url = ['v2/Avatars_01_V1.png',
                    'v2/Avatars_02_V1.png',
                    'v2/Avatars_03_V1.png',
                    'v2/Avatars_04_V1.png',
                    'v2/Avatars_05_V1.png' ].sample
      return image_tag(avatar_url, options)
    end
  end

  def link_to_avatar(user, options = {})
     link_to avatar_for(user, options), user
  end
  
end


# avatar_for(@user, :size => "75x75")
# avatar_for(@user, :large)
# avatar_for(@user)
