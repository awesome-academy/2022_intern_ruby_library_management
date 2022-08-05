module ApplicationHelper
  include Pagy::Frontend

  def current_translations
    @translations ||= I18n.backend.send(:translations)
    @translations[I18n.locale].with_indifferent_access
  end

  def show_datetime datetime
    datetime.strftime("%H:%M:%S | %d/%m/%Y")
  end
end
