class ApplicationController < ActionController::Base

   before_action :configure_permitted_parameters, if: :devise_controller?
   before_action :check_force_logout


   protected
      def configure_permitted_parameters
         devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation)}
         devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:avatar, :username, :email, :password, :current_password)}
      end

   private
      def check_force_logout
         if current_user && current_user.banned?
            sign_out(current_user)
         end
      end

end
