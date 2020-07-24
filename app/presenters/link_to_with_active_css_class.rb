class LinkToWithActiveCssClass
  def initialize(link_text, path, match_strategy, html_options, view_context)
    @link_text = link_text
    @match_strategy = match_strategy || :exact
    @html_options = html_options
    @view_context = view_context

    @path = @view_context.url_for(path)
  end

  def render
    @view_context.link_to(@link_text, @path, html_options)
  end

  private

  def html_options
    @html_options[:class] = [@html_options[:class]].flatten.compact

    if path_matches?
      @html_options[:class] << "current-path-link"
    end

    @html_options
  end

  def path_matches?
    case @match_strategy
    when :exact
      @view_context.request.fullpath == @path
    when :path_only
      # builds URI::Generic that can separate the path from query params
      uri = URI.parse(@path)

      @view_context.request.path == uri.path
    else
      raise ArgumentError, "invalid match strategy #{@match_strategy.inspect}"
    end
  end
end
