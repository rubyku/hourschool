module Course::Searchable
  extend ActiveSupport::Concern

  included do
    searchable do
      # Used when we want to say all spots _except_ for ...
      integer   :id
      text      :title, :teaser, :description

      integer   :max_seats
      integer   :min_seats

      date      :date
      boolean   :public

      time      :created_at

      string    :status

      float     :price

      float     :lat
      float     :lng
      location(:coordinates) do |course|
        Sunspot::Util::Coordinates.new(course.lat, course.lng)
      end
    end
  end

  module ClassMethods
    def search_live(query, options = {})
      search do
        fulltext query
        paginate :per_page => Course::DEFAULT_PER_PAGE
        paginate :page     => options[:page] if options[:page].present?

        with(:status).equal_to('live')

        # any_of do
        #   with(:date).greater_than(Date.tomorrow)
        # end
      end.results
    end
  end

end