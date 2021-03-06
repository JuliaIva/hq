class Entrance::ExamResult < ActiveRecord::Base
  # TODO XXX
  self.table_name_prefix = 'entrance_'

  # @!group Расширения

  # @!group Поля

  enum form: { use: 1, university: 2, payed_test: 3 }

  # @!group Ассоциации

  belongs_to :exam,    class_name: 'Entrance::Exam'
  belongs_to :entrant, class_name: 'Entrance::Entrant'

  # @!group Валидации

  # @!group Поведение

  # @!group Скоупы

  default_scope do
    includes(:entrant).joins(:entrant).
      order('entrance_entrants.last_name').
      order('entrance_entrants.first_name').
      order('entrance_entrants.patronym')
  end

  scope :in_competitive_group, -> competitive_group do
    joins('LEFT JOIN entrance_test_items ON entrance_test_items.exam_id = entrance_exam_results.exam_id').
    where('entrance_test_items.competitive_group_id = ?', competitive_group.id).
    where('entrance_test_items.id IS NOT NULL')
  end

  scope :by_exam, -> exam_id { where(exam_id: exam_id) }
  scope :by_exam_name, -> exam_name do
    joins(:exam).where("entrance_exams.name = '#{exam_name}'")
  end

  scope :use, -> { where(form: 1) }
  scope :internal, -> { where(form: 2) }

  # @!group Методы

  def exam_type
    case form
      when 'use'
        'ЕГЭ'
      when 'university'
        'ВИ'
    end
  end

  def to_fis(opts = {})
    unless opts[:competitive_group_id]
      raise 'Не указан идентификатор конкурсной группы.'
    end

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.EntranceTestResult do
        xml.UID                 id
        xml.ResultValue         score
        xml.ResultSourceTypeID  self[:form]
        xml.EntranceTestTypeID  exam[:form]
        xml.CompetitiveGroupID  opts[:competitive_group_id]
        xml.EntranceTestSubject { fis_entrance_test_subject(xml) }
      end
    end

    builder.doc
  end

  private

  def fis_entrance_test_subject(xml)
    if exam.use_subject_id
      xml.SubjectID exam.use_subject_id
    else
      xml.Subject_name exam.name
    end
  end
end
