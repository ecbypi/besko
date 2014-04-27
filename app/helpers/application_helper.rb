module ApplicationHelper
  PRIORITY_COUNTRIES = %w( US CA )

  def body_css_class
    css_class = "#{controller.controller_name} #{controller.controller_name}-#{controller.action_name}"

    if current_user && current_user.admin?
      css_class << ' admin'
    end

    css_class
  end
end
