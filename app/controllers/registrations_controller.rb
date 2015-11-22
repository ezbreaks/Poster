class RegistrationsController < Devise::RegistrationsController

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :time_zone)
  end

  def acccount_update_params
    params.require(:user).permit(:email, :password, :time_zone, :current_password)
  end

end
