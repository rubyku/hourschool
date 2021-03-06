module PagesHelper


  # avatar_for(@user, :photo_size => :thumb_small) will generate image_tag(@user.photo.url(:thumb_small))
  def avatar_for(user, options = {})
    options[:class]||="avatar-big"
    size = options.delete(:photo_size)||:small
    if user && user.photo.present?
      return image_tag(user.photo.url(size), options)
    else
      avatar_url = ['/images/avatar.jpg',
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
