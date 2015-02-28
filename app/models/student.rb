class Student < ActiveRecord::Base
 # attr_accessible :first_name, :middle_name, :last_name, :email, :mobile, :parent_name, :p_mobile, :p_email, :address, :group, :rank

  #has_many
  has_many :exam_absents
  has_many :exam_results
  has_many :class_students
  has_many :jkci_classes, through: :class_students
  has_many :class_catlogs
  has_many :exam_catlogs
  has_many :exams, through: :exam_catlogs 
  
  def all_exams
    #Exam.where(std: std, is_active: true)
    Exam.where("jkci_class_id in (?)  or ?", self.jkci_classes.map(&:id), exam_query)
  end

  def name
    "#{first_name} #{last_name}"
  end
  
  def exam_query
    query = " "
    ids = self.jkci_classes.map(&:id)
    ids.each do |class_id|
      query << "class_ids like '%,#{class_id},%'"
      unless ids.last == class_id
        query << " or "
      end
    end
    query
  end

  def class_info
    jkci_classes.select([:id, :class_name, :class_start_time, :teacher_id]).includes([:teacher])
  end

  def learned_point(class_id= nil, min_date_filter = nil, max_date_filter = nil)
    jk_catlogs = class_catlogs.order('id desc')#.includes([:daily_teaching_points])

    if class_id.present?
      jk_catlogs = jk_catlogs.where(jkci_class_id: class_id)
    end

    if min_date_filter.present?
      jk_catlogs = jk_catlogs.where("date >= ?", min_date_filter)
    end

    if max_date_filter.present?
      jk_catlogs = jk_catlogs.where("date <= ?", max_date_filter)
    end
    return jk_catlogs
  end

  def class_exams(class_id= nil, min_date_filter = nil, max_date_filter = nil)
    ex_catlogs = exam_catlogs.includes([:exam]).completed.order('id desc')#.includes([:daily_teaching_points])
    
    if class_id.present?
      ex_catlogs = ex_catlogs.where(jkci_class_id: class_id)
    end
    
    if min_date_filter.present?
      ex_catlogs = ex_catlogs.where("date >= ?", min_date_filter)
    end
    
    if max_date_filter.present?
      ex_catlogs = ex_catlogs.where("date <= ?", max_date_filter)
    end
    return ex_catlogs
  end
end
