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

  def image_for_course(course)
    link_to image_tag(course.photo.url(:small), :size => "190x120"), course
  end

end
