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
    # active_admin uses conflicting meta_search use solr_search instead
    def solr_search(*args, &block)
      Sunspot.search(Course, args, block)
    end

    def search_live(query, options = {})
      solr_search do
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