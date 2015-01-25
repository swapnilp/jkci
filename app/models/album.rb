class Album < ActiveRecord::Base
  has_many :galleries
end
