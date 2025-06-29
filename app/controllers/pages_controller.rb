class PagesController < ApplicationController
  def home
    @bouncehouses = Bouncehouse.where(active: true).limit(5)
  end

  def search
    # STEP 1: Handle the location search parameter
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    # STEP 2: Perform the search based on the location stored in the session
    if session[:loc_search] && session[:loc_search] != ""
      begin
        @bouncehouses_address = Bouncehouse.where(active: true).near(session[:loc_search], 5)
      rescue ArgumentError => e
        Rails.logger.error "Geocoder error: #{e.message}"
        @bouncehouses_address = Bouncehouse.where(active: true)
      end
    else
      @bouncehouses_address = Bouncehouse.where(active: true)
    end

    # STEP 3: Use Ransack for more advanced search functionality
    @search = @bouncehouses_address.ransack(params[:q])
    @bouncehouses = @search.result

    @arrBouncehouses = @bouncehouses.to_a

    # STEP 4: Filter by availability if date range is provided
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @arrBouncehouses.reject! do |bouncehouse|
        not_available = bouncehouse.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).exists?

        not_available_in_calendar = Calendar.where(
          "venue_id = ? AND status = ? AND day <= ? AND day >= ?",
          bouncehouse.id, 1, end_date, start_date
        ).exists?

        not_available || not_available_in_calendar
      end
    end
  end
end
