module UsersHelper
  def render_admin
    html = []
    html << content_tag(:div, t("manager"), class: "badge bg-success")
    safe_join(html)
  end

  def render_user
    html = []
    html << content_tag(:div, t("user"), class: "badge bg-danger")
    safe_join(html)
  end

  def get_name_user user_id
    user = User.find_by(id: user_id)
    user.nil? ? "None" : user.name
  end
end
