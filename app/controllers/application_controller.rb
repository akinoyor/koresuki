class ApplicationController < ActionController::Base
  before_action :authenticate_admin!, if: :admin_controller?
  # before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def admin_controller?
    self.class.module_parent_name == 'Admin'
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_image, :name, :number,  :profile])
  end
end
