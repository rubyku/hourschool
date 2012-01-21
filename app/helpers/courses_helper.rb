module CoursesHelper

  def filter_params
    request.params
  end

  def add_filter(options)
    filter_params.merge(options)
  end

  def remove_filter(options)
    params = filter_params
    options.each do |key, value|
      params.delete(key)
    end
    params
  end

  def link_to_image_for_course(course)
    arrow = tag(:img, :src => '/v2/arrow_white_pointup.png', :class => 'class-arrow' )
    image = course.photo.exists? ? image_for_course(course) : default_image_for_course(course)
    (image + arrow).html_safe
  end

  def image_for_course(course)
    link_to(image_tag(course.photo.url(:small)), :size => "190x120")
  end

  def default_image_for_course(course)
    if !course.categories.blank?
      link_to image_tag("#{DEF_IMAGES[course.categories.first.name]}"), course
    else
      link_to image_tag("/v2-courses/DefaultClassPics_Generic.png"), course
    end
  end

end
