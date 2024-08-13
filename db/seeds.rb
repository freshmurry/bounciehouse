# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Create an AdminUser for development only
if Rails.env.development?
  AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
end

# Create an AdminUser for all environments, ensuring it does not duplicate
begin
  AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.name = 'Admin Name'
    admin.description = 'Admin Description'
    admin.password = 'password'
    admin.password_confirmation = 'password'
  end
rescue => e
  Rails.logger.error "Failed to seed AdminUser: #{e.message}"
end
