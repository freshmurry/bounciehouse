module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_admin_user!

    def index
      @user_count = User.count
    end
  end
end
