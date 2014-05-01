class Capybara::Poltergeist::Browser
  def current_url
    CGI.unescape(command 'current_url')
  end
end
