# Pulled and modified from orderly gem
# https://github.com/jmondo/orderly
RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    begin
      current_scope.text.index(earlier_content) < current_scope.text.index(later_content)
    rescue ArgumentError
      raise "Could not locate later content on page: #{later_content}"
    rescue NoMethodError
      raise "Could not locate earlier content on page: #{earlier_content}"
    end
  end
end
