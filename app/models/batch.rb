class Batch < ActiveRecord::Base

  has_many :jkci_classes
  default_scope  { where(is_active: true) } 
end
