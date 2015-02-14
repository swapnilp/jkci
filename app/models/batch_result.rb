class BatchResult < ActiveRecord::Base
  has_many :results

  scope :published, -> {where(is_published: true).order("id DESC")}
end
