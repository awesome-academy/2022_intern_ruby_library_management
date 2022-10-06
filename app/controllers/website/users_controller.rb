class Website::UsersController < WebsiteController
  before_action :authenticate_user!
  before_action :find_user, only: :show

  def show; end

  def update
    current_user.update user_params
    redirect_to user_path(current_user)
  end

  private

  def user_params
    params.require(:user).permit :image, :name, :phone_number
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.no_user"
    redirect_to user_path(current_user)
  end
end
