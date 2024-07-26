class HostReviewsController < ApplicationController

  def create
    @reservation = Reservation.find_by(
      id: host_review_params[:reservation_id],
      bouncehouse_id: host_review_params[:bouncehouse_id],
      user_id: host_review_params[:guest_id]
    )

    if @reservation
      @has_reviewed = HostReview.find_by(
        reservation_id: @reservation.id,
        guest_id: host_review_params[:guest_id]
      )

      if @has_reviewed.nil?
        @host_review = current_user.host_reviews.create(host_review_params)
        flash[:success] = "Review created successfully."
      else
        flash[:alert] = "You have already reviewed this reservation."
      end
    else
      flash[:alert] = "Reservation not found."
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = HostReview.find_by(id: params[:id])
    
    if @host_review
      @host_review.destroy
      flash[:notice] = "Review removed successfully."
    else
      flash[:alert] = "Review not found."
    end
    
    redirect_back(fallback_location: request.referer)
  end

  private

  def host_review_params
    params.require(:host_review).permit(:comment, :star, :bouncehouse_id, :reservation_id, :guest_id)
  end
end
