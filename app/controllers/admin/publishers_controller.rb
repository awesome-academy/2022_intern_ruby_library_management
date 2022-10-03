class Admin::PublishersController < AdminController
  layout "admin"
  before_action :find_by_id, except: %i(new create index)
  load_and_authorize_resource

  def index
    @pagy, @publishers = pagy Publisher.latest,
                              items: Settings.publishers.max_page
  end

  def show; end

  def new
    @publisher = Publisher.new
    respond_to do |format|
      format.js do
        render :show_form, locals: {action: params[:action]}
      end
    end
  end

  def create
    @publisher = Publisher.new publisher_params
    if @publisher.save
      respond_to do |format|
        @pagy, @publishers = pagy Publisher.latest,
                                  items: Settings.publishers.max_page

        format.js do
          render :update, locals: {status: Settings.status.success,
                                   action: params[:action]}
        end
      end
    else
      render :update, locals: {status: Settings.status.internal_server_error,
                               action: params[:action]}
    end
  end

  def edit
    respond_to do |format|
      format.js do
        render :show_form, locals: {action: params[:action]}
      end
    end
  end

  def update
    if @publisher.update publisher_params
      @pagy, @publishers = pagy Publisher.latest,
                                items: Settings.publishers.max_page
      respond_to do |format|
        format.js do
          render :update, locals: {status: Settings.status.success,
                                   action: params[:action]}
        end
      end
    else
      render :update, locals: {status: Settings.status.internal_server_error,
                               action: params[:action]}
    end
  end

  def destroy
    if @publisher.destroy
      render json: {message: t(".deleted"), code: Settings.status.success}
    else
      render json: {message: t(".deleted_fails"),
                    code: Settings.status.not_found}
    end
  end

  private

  def find_by_id
    @publisher = Publisher.find_by id: params[:id]
    return if @publisher

    flash[:danger] = t "admin.publishers.not_found_publisher"
    redirect_to admin_publisher_path
  end

  def publisher_params
    params.require(:publisher).permit Publisher::FIELD_PERMIT
  end
end
