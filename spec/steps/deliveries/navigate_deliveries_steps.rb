steps_for :deliveries do
  step "I go to the previous day of deliveries" do
    click_button 'Previous Day'
  end

  step "I go to the next day of deliveries" do
    click_button 'Next Day'
  end

  step "I navigate to view the deliveries delivered on :date" do  |date|
    click_button 'Change'
    day = Time.zone.parse(date)
    within 'div#ui-datepicker-div' do
      find("select.ui-datepicker-year option:contains('#{day.year}')").select_option
      find("select.ui-datepicker-month option:contains('#{day.strftime('%b')}')").select_option
      find("a.ui-state-default:contains('#{day.day}')").click
    end
  end
end
