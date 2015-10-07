class ClassStudent < ActiveRecord::Base
  belongs_to :jkci_class
  belongs_to :student


  def add_sub_class(sub_class_id)
    sub_classes = self.sub_class.split(',').map(&:to_i)
    sub_classes << sub_class_id
    self.update_attributes({sub_class: ",#{sub_classes.uniq.join(',')},"})
  end

  def remove_sub_class(sub_class_id)
    sub_classes = self.sub_class.split(',').map(&:to_i)
    sub_classes.delete(sub_class_id)
    self.update_attributes({sub_class: ",#{sub_classes.uniq.join(',')},"})
  end
end
