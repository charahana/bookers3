class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :prepare_book_form, if: :user_signed_in?

  def after_sign_in_path_for(resource)
    flash[:notice] = "Logged in successfully"
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    flash[:notice] = "Logged out successfully"
    root_path
  end

  def after_sign_up_path_for(resource)
    flash[:notice] = "Signed up successfully"
    user_path(resource)
  end

  protected

  def prepare_book_form
    @book ||= Book.new
    @user ||= current_user 
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
  end
end
