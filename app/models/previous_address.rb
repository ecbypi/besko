class PreviousAddress < ActiveRecord::Base
  belongs_to :user

  has_one :followed_by, class_name: :PreviousAddress, foreign_key: :preceded_by_id
  belongs_to :preceded_by, class_name: :PreviousAddress, foreign_key: :preceded_by_id

  attr_accessible :address
end
