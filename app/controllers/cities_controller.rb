class CitiesController < ActionController::Base
  def index
    city = params[:q]||params[:term]

    if (city_state = city.split(','))[1].present?
      city  = city_state.first.try(:strip)
      state = city_state.last.try(:strip)
    end
    logger.info("== #{city_state.inspect}")

    logger.info("== #{state.inspect}")

    if state.present?
      response = City.where("name ilike ?", "#{city}%").where("state ilike ?", "#{state}%").limit(10)
    else
      response = City.where("name ilike ?", "#{city}%").limit(10)
    end

    response = response.collect {|c| {:name => "#{c.name}, #{c.state}", :id => c.id}}
    logger.info("RESPONSE:#{response.to_json}")

    render :json => response
  end
end