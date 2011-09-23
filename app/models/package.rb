class Package < ActiveRecord::Base
  belongs_to :worker, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User'
end
