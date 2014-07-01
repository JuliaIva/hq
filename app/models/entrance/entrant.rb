class Entrance::Entrant < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  enum gender: { male: 1, female: 2 }
  enum citizenship: { russian: 1, other_citizenship: 2 }
  enum acountry: { russia: 0, cis: 1, other_countries: 2 }
  enum military_service: { not: 1, conscript: 2, reservist: 6,
                           free_of_service: 7, too_young: 8 }
  enum foreign_language: { english: 24, german: 12, french: 13, spanish: 14 }

  belongs_to :identity_document_type
  belongs_to :nationality_type

  belongs_to :campaign, class_name: Entrance::Campaign

  has_many :exam_results, class_name: Entrance::ExamResult, dependent: :destroy
  accepts_nested_attributes_for :exam_results, allow_destroy: true

  has_one :edu_document, class_name: 'Entrance::EduDocument', dependent: :destroy
  accepts_nested_attributes_for :edu_document, update_only: true

  has_many :papers, class_name: 'Entrance::Paper', foreign_key: :entrance_entrant_id, dependent: :destroy
  accepts_nested_attributes_for :papers, allow_destroy: true

  has_many :applications, class_name: Entrance::Application, dependent: :destroy
  accepts_nested_attributes_for :applications, allow_destroy: true

  has_many :event_entrants, class_name: Entrance::EventEntrant, foreign_key: :entrance_entrant_id
  accepts_nested_attributes_for :event_entrants, allow_destroy: true
  has_many :events, class_name: Entrance::Event, through: :event_entrants

  scope :aspirants, -> { joins(:edu_document).where('entrance_edu_documents.direction_id IS NOT NULL') }

  before_create do |entrant|
    entrant.build_edu_document
  end

  after_create do |entrant|
    Entrance::Log.create entrant_id: entrant.id, user_id: User.current.id,
                         comment: 'Добавлена информация об абитуриенте.'
  end

  after_update do |entrant|
    Entrance::Log.create entrant_id: entrant.id, user_id: User.current.id,
                         comment: 'Обновлена информация об абитуриенте.'
  end

  default_scope do
    order(:last_name, :first_name, :patronym)
  end

  def full_name
    [last_name, first_name, patronym].join(' ')
  end

  def short_name
    "#{last_name} #{first_name[0]}. #{patronym[0]}."
  end

  def citizen_name
    case citizenship
      when 'russian'
        'Российская Федерация'
      else
        'зарубежье'
    end
  end

  def military_status
    case military_service
      when 'not'
        'невоеннообязанный'
      when 'conscript'
        'призывник'
      when 'reservist'
        'военнообязанный'
      when 'free_of_service'
        'освобождён от воинской обязанности'
      when 'too_young'
        'не достигший возраста призывника'
    end
  end

  def contacts
    [azip, aaddress, phone].join(', ')
  end
end
