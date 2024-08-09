class AddEnablEmailToUsersAdminDashboard < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :enable_sms, :boolean, default: false
  end
end
