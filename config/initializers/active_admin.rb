ActiveAdmin.setup do |config|
  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "BouncieHouse"
  
  config.site_title_image = "bounciehouse-logo.svg"

  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to.
  #
  # Default:
  # config.default_namespace = :admin
  # config.default_namespace = :dashboard

  # This setting changes the method which Active Admin calls
  # within the application controller.

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  config.authentication_method = :authenticate_admin_user!

  config.current_user_method = :current_admin_user
  
  config.logout_link_path = :destroy_admin_user_session_path

  # config.root_to = 'dashboard#index'

  config.batch_actions = true

  config.localize_format = :long
end
