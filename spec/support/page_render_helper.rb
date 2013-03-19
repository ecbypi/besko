module PageRenderHelper
  def render_page_to_png
    page.driver.render(File.join(ENV['HOME'], 'Desktop', 'page.png'), full: true)
  end
end
