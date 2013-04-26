# Update addresses every month
every :week, at: '12:00 am' do
  runner 'UpdateAddressWorker.update_addresses'
end
