class Entrance::Campaign < ActiveRecord::Base
  CURRENT = 2014
  CRIMEA = 12014

  # TODO Почему-то не получается перенести table_name_prefix в entrance.rb
  self.table_name_prefix = 'entrance_'

  enum status: { not_started: 0, started: 1, finished: 2 }

  has_many :dates, class_name: 'Entrance::Date'
  has_many :events, class_name: 'Entrance::Event'
  has_many :min_scores, class_name: Entrance::MinScore
  has_many :exams, class_name: 'Entrance::Exam'
  has_many :entrants, class_name: 'Entrance::Entrant'
  has_many :applications, class_name: 'Entrance::Application'
  has_many :contracts, class_name: 'Entrance::Contract', through: :applications
  has_and_belongs_to_many :education_forms
  has_many :competitive_groups, class_name: 'Entrance::CompetitiveGroup'
  has_many :checks, through: :entrants
end
