{
  en: {
    time: {
      formats: translations.dig(:en, :time, :formats).tap do |formats|
        formats[:full] = "%l:%M %p on %b %d, %Y"
      end
    }
  }
}
