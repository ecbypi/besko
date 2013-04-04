module AutocompleteSteps
  def fill_in_autocomplete(options = {})
    fill_in 'autocomplete-search', options
  end

  def autocomplete_result(text)
    find('.autocomplete-result', text: text)
  end

  def have_autocomplete_input(options = {})
    have_field 'autocomplete-search', options
  end
end
