module UsersHelper

  def avatar_for(user)
    if @user.photo.exists?
      return image_tag(@user.photo.url(:small), :size => "190x120")
    else
      avatar_url = ['/images/v2/Avatars_01_V1.png',
                    '/images/v2/Avatars_02_V1.png',
                    '/images/v2/Avatars_03_V1.png',
                    '/images/v2/Avatars_04_V1.png',
                    '/images/v2/Avatars_05_V1.png' ].sample
      return image_tag(avatar_url, :class => "avatar-big")
    end
  end

end
