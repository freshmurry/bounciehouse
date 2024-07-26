class SettingsController < ApplicationController
  before_action :set_setting

  def edit
    # @setting is already set by the before_action
  end

  def update
    if @setting.update(setting_params)
      flash[:notice] = "Settings saved successfully."
      redirect_to edit_settings_path
    else
      flash[:alert] = "Unable to save settings. Please try again."
      render 'edit'
    end
  end

  private

    def set_setting
      @setting = current_user.setting
    end

    def setting_params
      params.require(:setting).permit(:enable_sms, :enable_email)
    end
end