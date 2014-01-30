require 'spec_helper'

feature 'Просмотр дисциплин' do
  background 'Преподаватель' do
    fd = create(:department, name: 'First Department', abbreviation: 'FD', department_role: 'faculty')
    ffs = create(:speciality, name: 'Empty', suffix: 'fdf', faculty: fd)
    fss = create(:speciality, name: 'First department second speciality', suffix: 'fdf', faculty: fd)
    @group = create(:group, speciality: fss)
    @user = create(:user, :lecturer)
    as_user(@user)
  end
  scenario 'Просмотр списка дисциплин' do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    visit study_disciplines_path
    within 'h1' do
      page.should have_content 'Балльно-рейтинговая система'
    end
    within 'h4' do
      page.should have_content discipline.name
    end
  end
  scenario 'Добавление новой дисциплины' do
    visit study_disciplines_path
    click_link 'Добавить дисциплину'
    page.should have_selector '#new_study_discipline'
  end
  scenario 'Внесение данных для дисциплины без контрольных точек' do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    visit study_disciplines_path
    page.should have_selector '.add_marks .glyphicon-calendar'
    click_link 'Внести данные'
    within 'h1' do
      page.should have_content 'Расписание занятий и контрольных точек'
    end
    page.should have_content  discipline.name
  end
  scenario 'Внесение данных для дисциплины с контрольными точками' do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    control = create(:checkpoint, :checkpoint_control, discipline: discipline)
    visit study_disciplines_path
    page.should have_selector '.add_marks .glyphicon-list-alt'
    click_link 'Внести данные'
    within 'h1' do
      page.should have_content  discipline.name
    end
    page.should have_content control.name
  end
  scenario 'Редактирование дисциплины' do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    visit study_disciplines_path
    click_link 'Редактировать'
    page.should have_selector "#edit_study_discipline_#{discipline.id}"
  end
  scenario 'Удаление дисциплины без контрольных точек', js: true, driver: :webkit do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    visit study_disciplines_path
    click_link 'Удалить'
    page.driver.browser.accept_js_confirms
    page.should_not have_content  discipline.name
  end
  scenario 'Нельзя удалить дисциплину с контрольными точками' do
    discipline = create(:discipline, lead_teacher: @user, group: @group)
    create(:checkpoint, :checkpoint_control, discipline: discipline)
    visit study_disciplines_path
    page.should_not have_selector '.delete_empty_discipline'
  end
end