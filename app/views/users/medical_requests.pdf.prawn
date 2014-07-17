names = []
@data.each_with_index do |d, i|
  #if 0 == i
  #  d[0][0] = ''
  #end

  names << [d[1], d[3], d[5], d[6]] unless d[1].blank? || d[2].blank?
  #break
end

prawn_document size: :A4, page_layout: :portrait, margin: [10,10,10,10] do |pdf|
  names.each_with_index do |name, index|
    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}н", base_size: 8
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в наркологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 1

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 5

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold
    pdf.move_down 20

    pdf.stroke_horizontal_rule
    pdf.move_down 10

    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}п", base_size: 8
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в психоневрологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 1

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 5

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold
    pdf.move_down 20

    pdf.stroke_horizontal_rule
    pdf.move_down 10

    render 'pdf/header', pdf: pdf, title: "ЗАПРОС № #{index + 1}к", base_size: 9
    pdf.move_up 15
    pdf.font_size 11
    pdf.text 'в кожно-венерологический диспансер по месту жительства или временной регистрации.', align: :center, style: :bold
    pdf.move_down 14

    pdf.font_size 10
    pdf.text 'Просим вас провести освидетельствование работника'
    pdf.text 'Ф.И.О. (полностью) _____________________________________________________________________________________________________________'
    pdf.text 'должность  ______________________________________________________________________________________________________________________'
    pdf.text 'в целях прохождения периодического медицинского осмотра в соответствии с приказом Минздравсоцразвития РФ от 12.04.2011 г. № 302н, для допуска к работе. '
    pdf.text 'Дата __________________'

    pdf.move_down 10

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold


    n = name[0].squish
    d = Unicode::downcase(name[2].squish)

    [
        [93, 662, 446, 10],
        [93, 439, 446, 10]
    ].each do |x, y, w, h|
      #pdf.bounding_box [x, y], width: w, height: h do
      #  pdf.text n
      #  pdf.stroke_bounds
      #end
      #pdf.bounding_box [x - 37, y - 13], width: w + 37, height: h do
      #  pdf.text d
      #  pdf.stroke_bounds
      #end

      pdf.text_box n, at: [x, y], width: w, height: h, overflow: :shrink_to_fit
      pdf.text_box d, at: [x - 37, y - 13], width: w + 37, height: h, overflow: :shrink_to_fit
      pdf.text_box '17.12.13 г.', at: [x - 67, y - 52], width: w + 37, height: h
    end

    render 'pdf/header', pdf: pdf, title: "НАПРАВЛЕНИЕ НА ПЕРИОДИЧЕСКИЙ МЕДИЦИНСКИЙ ОСМОТР (ОБСЛЕДОВАНИЕ) №#{index + 1} от 17.12.2013", base_size: 7

    pdf.font_size 9
    pdf.move_up 10
    pdf.text 'Направляется в ГБУЗ «КДЦ №6» ДЗ г. Москвы __________________'
    pdf.text '1. Ф.И.О. _______________________________________________________________________________________________________________________'
    pdf.text '2. Дата рождения _____________________________________________________________________________________________________________'
    pdf.font_size 7 do
      pdf.indent 50 do
        pdf.text '(число, месяц, год)'
      end
    end
    pdf.text '3. Поступающий на работу/<u>работающий</u> (нужное подчеркнуть)', inline_format: true
    pdf.text '4. Цех, участок: _______________________________________________________________________________________________________________'
    pdf.text '5. Вид работы, в которой работник освидетельствуется __________________________________________________________________'
    pdf.text '6. Стаж работы в том виде работы, в котором работник освидетельствуется ___________________________________________'
    pdf.text '7. Предшествующие профессии (работы), должность и стаж работы в них  _____________________________________________'
    pdf.text '8. Вредные и (или) опасные вещества и производственные факторы:'
    pdf.indent 12 do
      pdf.text '8.1 Химические факторы _________________________________________________________________________________________________'
      pdf.font_size 6 do
        pdf.indent 50 do
          pdf.text '(номер пункта или пунктов Перечня*, перечислить)'
        end
      end
      pdf.text '8.2 Физические факторы  _________________________________________________________________________________________________'
      pdf.font_size 6 do
        pdf.indent 50 do
          pdf.text '(номер строки, пункта или пунктов Перечня*, перечислить)'
        end
      end
      pdf.text '8.3 Биологические факторы  ______________________________________________________________________________________________'
      pdf.text '8.4 Тяжесть труда (физические перегрузки) _____________________________________________________________________________'
      pdf.font_size 6 do
        pdf.indent 50 do
          pdf.text '(номер пункта или пунктов Перечня*, перечислить)'
        end
      pdf.text '9. Профессия (работа) ________________________________________________________________________________________________________'

       pdf.move_down 10

      pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold

      academic_i = name[1].squish.index('кафедр') || name[1].squish.index('институт')
      academic = name[1].squish[academic_i..-1].split
      academic[0] = 'кафедра' if name[1].squish.index('кафедр')
      academic[0] = 'институт' if name[1].squish.index('институт')
      job = Unicode::downcase(name[1].squish[0..(academic_i-2)])
      job += ' кафедрой' if name[1].squish.index('аведующ')
      [
        [name[0].squish, 50, 608, 446, 10],
        [academic.join(' '), 80, 561, 446, 10],
        [job, 265, 547, 446, 10],
        ['работа в образовательной организации прил. 2, п. 18.', 112, 421, 446, 10],
      ].each do |n, x, y, w, h|
        pdf.text_box n, at: [x, y], width: w, height: h, overflow: :shrink_to_fit
      end
    end
    pdf.text '9. Профессия (работа) ________________________________________________________________________________________________________'

     pdf.move_down 10

    pdf.text 'Начальник отдела кадров                                                                                                        Гончарова Н. С.', style: :bold

    academic_i = name[2].squish.index('кафедр') || name[2].squish.index('институт')
    academic = name[2].squish[academic_i..-1].split
    academic[0] = 'кафедра' if name[2].squish.index('кафедр')
    academic[0] = 'институт' if name[2].squish.index('институт')
    job = Unicode::downcase(name[2].squish[0..(academic_i-2)])
    [
      [name[0].squish, 50, 236, 446, 10],
      [name[1].squish, 80, 225, 446, 10],
      [academic.join(' '), 80, 192, 446, 10],
      [job, 265, 180, 446, 10],
      ["работа в образовательной организации #{Unicode::downcase(name[3])}", 112, 64, 446, 10],
    ].each do |n, x, y, w, h|
      pdf.text_box n, at: [x, y], width: w, height: h, overflow: :shrink_to_fit
    end

    pdf.start_new_page
  end
end