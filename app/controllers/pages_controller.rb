class PagesController < ApplicationController
  def home
    @bouncehouses = Bouncehouse.where(active: true).limit(3)
  end

  def search
    # STEP 1: Handle the location search parameter
    if params[:search].present?
      session[:loc_search] = params[:search].strip
    end

    # Debugging: Check the value of session[:loc_search]
    Rails.logger.debug "Location search: #{session[:loc_search].inspect}"

    # STEP 2: Perform the search based on the location stored in the session
    if session[:loc_search].present?
      begin
        @bouncehouses_address = Bouncehouse.where(active: true).near(session[:loc_search], 5)
      rescue ArgumentError => e
        Rails.logger.error "Geocoder error: #{e.message}"
        @bouncehouses_address = Bouncehouse.where(active: true)
      end
    else
      @bouncehouses_address = Bouncehouse.where(active: true)
    end

    # STEP 3: Use Ransack for more advanced search functionality if needed
    @search = @bouncehouses_address.ransack(params[:q])
    @bouncehouses = @search.result

    @arrBouncehouses = @bouncehouses.to_a
  end
end
