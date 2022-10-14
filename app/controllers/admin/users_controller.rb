class Admin::UsersController < AdminController
  before_action :find_user, except: %i(index)
  load_and_authorize_resource

  def index
    @pagy, @users = pagy User.latest_user,
                         items: Settings.max_page_user
  end

  def show
    render json: {user: @user.to_json(except: :password_digest), code: 200}
  end

  def update
    if @user.super_admin?
      render json: {message: t("users.activate_ff"), code: 404}
    else
      render json: {message: t("users.activate_ss"), code: 200}
    end
  end
end
