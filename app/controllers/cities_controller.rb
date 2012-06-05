class CitiesController < ActionController::Base
  def index
    city = params[:q]
    if city.include?(',')
      state = city.split(',')[1].strip
      city = city.split(',')[0].strip
      response = City.where('name ilike ?', city).where('state ilike ?', state).limit(10)
    else
      response = City.where('name ilike ?', city).limit(10)
    end
    logger.info("RESPONSE:#{response.to_json}")
    render :json => response
  end
end