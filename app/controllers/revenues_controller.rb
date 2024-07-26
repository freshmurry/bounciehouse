class RevenuesController < ApplicationController
  before_action :authenticate_user!

  def index
    # Fetch reservations for the current week
    @reservations = Reservation.current_week_revenue(current_user)

    # Calculate total revenue for each day
    revenue_by_date = @reservations.each_with_object(Hash.new(0)) do |reservation, hash|
      date_key = reservation.updated_at.strftime("%Y-%m-%d")
      hash[date_key] += reservation.total
    end

    # Prepare data for the view
    @this_week_revenue = Date.today.all_week.map do |date|
      formatted_date = date.strftime("%Y-%m-%d")
      [date.strftime("%a"), revenue_by_date[formatted_date] || 0]
    end
  end
end
