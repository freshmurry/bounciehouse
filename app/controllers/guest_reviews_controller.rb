class GuestReviewsController < ApplicationController

  def create
    @reservation = Reservation.find_by(
      id: guest_review_params[:reservation_id],
      bouncehouse_id: guest_review_params[:bouncehouse_id]
    )

    if @reservation && @reservation.bouncehouse.user.id == guest_review_params[:host_id].to_i
      @has_reviewed = GuestReview.find_by(
        reservation_id: @reservation.id,
        host_id: guest_review_params[:host_id]
      )

      if @has_reviewed.nil?
        @guest_review = current_user.guest_reviews.create(guest_review_params)
        flash[:success] = "Review created successfully."
      else
        flash[:alert] = "You have already reviewed this reservation."
      end
    else
      flash[:alert] = "Reservation or host not found."
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = GuestReview.find_by(id: params[:id])
    
    if @guest_review
      @guest_review.destroy
      flash[:notice] = "Review removed successfully."
    else
      flash[:alert] = "Review not found."
    end
    
    redirect_back(fallback_location: request.referer)
  end

  private

  def guest_review_params
    params.require(:guest_review).permit(:comment, :star, :bouncehouse_id, :reservation_id, :host_id)
  end
end
