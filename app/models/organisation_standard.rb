class OrganisationStandard < ActiveRecord::Base

  validates_uniqueness_of :standard_id, scope: :organisation_id

  belongs_to :organisation
  belongs_to :standard


end
