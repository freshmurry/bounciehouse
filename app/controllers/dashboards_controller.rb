class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @bouncehouses = current_user.bouncehouses
<<<<<<< HEAD
=======
    @favorite_bouncehouses = current_user.favorite_bouncehouses || []
  end

  def dashboard
    @favorite_bouncehouses = current_user.favorite_bouncehouses
>>>>>>> 16de8cb7 (Updated App to Ruby 3.2.3 and Rails 7)
  end
end