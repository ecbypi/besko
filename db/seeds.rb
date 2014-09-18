if ENV['SEED']
  require 'demo_data'
  DemoData.new.seed!
end
