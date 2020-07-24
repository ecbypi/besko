module PageHeadingHelper
  def page_heading(title_or_i18n_options = t(".page_heading"))
    title = case title_or_i18n_options
            when String
              title_or_i18n_options
            when nil
              t(".page_heading")
            when Hash
              t(".page_heading", title_or_i18n_options)
            end

    content_for(:title, title)
    content_tag(:h1, title)
  end
end
