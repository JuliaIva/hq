class Speciality < ActiveRecord::Base
  self.table_name = 'speciality'

  alias_attribute :id, :speciality_id
  alias_attribute :code, :speciality_code
  alias_attribute :name, :speciality_name
  alias_attribute :type, :speciality_ntype

  belongs_to :faculty, class_name: Department, primary_key: :department_id, foreign_key: :speciality_faculty

  has_many :groups, foreign_key: :group_speciality

  def bachelor?
    1 == type
  end

  def master?
    2 == type
  end

  def specialist?
    0 == type
  end
end