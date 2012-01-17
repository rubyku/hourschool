module Course::Searchable
  extend ActiveSupport::Concern

  included do
    searchable do
      text      :title, :teaser, :description

      # Used when we want to say all spots _except_ for ...
      integer   :id
      integer   :max_seats
      integer   :min_seats

      boolean   :public

      time      :created_at
      date      :date

      string    :status

      float     :price
      float     :lat
      float     :lng

      integer   :city_id do |c|
        c.city.try(:id)
      end

      location(:coordinates) do |c|
        Sunspot::Util::Coordinates.new(c.lat, c.lng)
      end

      integer(:categories, :multiple => true) do |c|
        c.categories.map(&:id)
      end

      text(:category_names_joined) do |c|
        c.categories.map(&:name).join(", ")
      end
    end
  end

  module ClassMethods

    # need to move out of Course if we want to search by another model (likely)
    def sanatize_solr_input(options = {})
      options = HashWithIndifferentAccess.new(options)
      if options.is_a? Hash
        query = options.delete(:query)||options.delete(:q)||options.delete(:id)
      else
        query   = options
        options = {}
      end


      options[:when] = options.delete(:when)||options.delete(:id)
      options[:when] = options[:when].downcase

      # Remove action and controller
      options.delete(:action)
      options.delete(:controller)

      ### Begin Course Specific Sanitizations ###

      # tags for categories
      # always want to return an array of ids
      options[:tags] ||= [options.delete(:tag)]
      options[:tags] = options[:tags].compact.map(&:to_i)

      # city
      # convert a text city into a city_id
      city = options.delete(:city)
      if city.present? && city.downcase != "all"
        cities = City.where("name like ?", city)
        options[:city_ids] = cities.map(&:id)
      end

      return query, options
    end

    # active_admin uses conflicting meta_search use solr_search instead
    def solr_search(*args, &block)
      Sunspot.search(Course, args, block)
    end


    # :city => "All"
    # :city => "Ann Arbor"
    # :tag => tag
    def search_live(options = {})
      query, options = sanatize_solr_input(options)

      solr_search do
        fulltext  query.to_s
        paginate :per_page => Course::DEFAULT_PER_PAGE
        paginate :page     => options[:page] if options[:page].present?

        with(:status).equal_to('live')

        # upcoming versus all
        if options[:when].present?
          any_of do
            with(:date).greater_than(Date.yesterday) if options[:when]
          end
        end

        # cities options[:city_ids]
        if options[:city_ids].present?
          any_of do
            with(:city_id).any_of(options[:city_ids])
          end
        end

        # categories options[:tags]
        if options[:tags].present?
          any_of do
            with(:categories).any_of(options[:tags])
          end
        end

      end.results
    end
  end

end