class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bouncehouses = current_user.bouncehouses
    @favorite_bouncehouses = current_user.favorite_bouncehouses || []
  end
end