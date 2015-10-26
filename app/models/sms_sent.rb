class SmsSent < ActiveRecord::Base
  self.inheritance_column = :obj_type
end
