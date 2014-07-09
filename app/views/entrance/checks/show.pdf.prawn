prawn_document margin: [28.34645669291339, 28.34645669291339,
                        28.34645669291339, 56.692913386],
               page_size: 'A4', page_layout: :portrait do |pdf|

  render 'pdf/font', pdf: pdf

  pdf.font_size 14 do
    pdf.text 'СПРАВКА', style: :bold, align: :center
    pdf.text 'о результатах единого государственного экзамена', style: :bold, align: :center
  end

  pdf.move_down 15

  if @check.results.empty?
    pdf.font_size 11 do
      pdf.text @entrant.full_name, align: :center
      pdf.text "Паспорт #{@entrant.pseries} №#{@entrant.pnumber}", align: :center
    end

    pdf.move_down 10

    pdf.font_size 11 do
      pdf.move_down 10
      pdf.text 'Проверка в АИС «Федеральная база свидетельств о результатах ЕГЭ» (Свидетельство о государственной регистрации базы данных №2010620233), действующей на основании Приказа Минобрнауки России от 15 апреля 2009 года №133 для образовательного учреждения'
      pdf.text 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»'
      pdf.text 'не обнаружила действительных свидетельств по результатам сдачи единого государственного экзамена.'
    end
  else
    pdf.font_size 11 do
      pdf.text 'В соответствии со свидетельством', align: :center
      pdf.text "#{'№ '+@check.number+' ' if @check.number}статус: Действительно", align: :center
      pdf.text "#{@entrant.full_name} по результатам сдачи единого государственного экзамена в #{@check.year} году обнаружил#{'а' if @entrant.female?} следующие знания по общеобразовательным предметам", align: :center
    end

    pdf.move_down 10

    data = [
        ['Наименование общеобразовательных предметов', 'Баллы']
    ]
    @check.results.each do |result|
      data << [result.exam_name, result.score]
    end

    pdf.font_size 11 do
      pdf.table data, header: true
      pdf.move_down 10
      pdf.text 'Справка для личного дела абитуриента сформирована из подсистемы ФИС «Результаты ЕГЭ» для образовательного учреждения:'
      pdf.text 'федеральное государственное бюджетное образовательное учреждение высшего профессионального образования «Московский государственный университет печати имени Ивана Федорова»'
    end
  end

  pdf.font_size 11 do
    pdf.move_down 30
    pdf.text 'Лицо, сформировавшее справку:'
    pdf.text '______________________________________                                                    ___________________ / ___________________ /'
    pdf.font_size 8 do
      pdf.indent 50 do
        pdf.text 'должность                                                                                                                               подпись                           расшифровка'
      end
    end
    pdf.move_down 15
    pdf.text 'Ответственное лицо приёмной комиссии:'
    pdf.text '<u> Ответственный секретарь </u>                                                                ___________________ / <u>Е. Л. Хохлогорская</u> /', inline_format: true
    pdf.font_size 8 do
      pdf.indent 50 do
        pdf.text 'должность                                                                                                                               подпись                           расшифровка'
      end
    end

    pdf.move_down 30
    pdf.text 'М. П.', align: :center

    pdf.move_down 30
    pdf.text "Дата выдачи: #{l Date.today}     Регистрационный № #{@check.id}", align: :center
  end
end