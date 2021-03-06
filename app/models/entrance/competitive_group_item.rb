class Entrance::CompetitiveGroupItem < ActiveRecord::Base

  belongs_to :competitive_group, class_name: Entrance::CompetitiveGroup
  belongs_to :direction
  belongs_to :education_level

  scope :from_direction, -> direction_id { where(direction_id: direction_id) }

  def direction_name
    direction.name
  end

  def form
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 11 : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 12 : 10)
  end

  def form_name
    (number_budget_o > 0 || number_paid_o > 0 || number_quota_o > 0) ? 'очная' : ((number_budget_oz > 0 || number_paid_oz > 0 || number_quota_oz > 0) ? 'очно-заочная' : 'заочная')
  end

  def payed?
    number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0
  end

  def budget_name
    (number_paid_o > 0 || number_paid_oz > 0 || number_paid_z > 0) ? 'договор' : 'бюджет'
  end

  def distance?
    number_budget_z > 0 || number_paid_z > 0 || number_quota_z > 0
  end

  def total_number
    number_budget_o + number_budget_oz + number_budget_z + number_paid_o + number_paid_oz + number_paid_z
  end

  def quota_number
    number_quota_o + number_quota_oz + number_quota_z
  end

  def matrix_form
    case form
      when 11
        101
      when 12
        102
      else 10
        103
    end
  end
end