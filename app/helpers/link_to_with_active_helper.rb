module LinkToWithActiveHelper
  def link_to_with_active_css_class(link_text, path, html_options = {})
    LinkToWithActiveCssClass.new(link_text, path, html_options.delete(:match), html_options, self).render
  end
end
