Процедура ОбработкаПроведения(Отказ, Режим)
	
	Движения.ТоварыНаСкладах.Записывать = Истина;
	
	Для Каждого ТекСтрокаТовары Из Товары Цикл
		Движение = Движения.ТоварыНаСкладах.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Номенклатура = ТекСтрокаТовары.Товар;
		Движение.Склад = Склад;
		Движение.Количество = ТекСтрокаТовары.Количество;
		Движение.ЕдиницаИзмерения = ТекСтрокаТовары.ЕдиницаИзмерения;
	КонецЦикла;
	
	Движения.Записать();
	
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТоварыНаСкладахОстатки.Номенклатура КАК Номенклатура,
		|	ТоварыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ТоварыНаСкладах.Остатки(
		|			,
		|			Склад = &Склад
		|				И Номенклатура В (&МассивТоваров)) КАК ТоварыНаСкладахОстатки
		|ГДЕ
		|	ТоварыНаСкладахОстатки.КоличествоОстаток < 0";
		
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("МассивТоваров", Товары.ВыгрузитьКолонку("Товар"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		Отказ = Истина;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			Сообщить("На складе ''" + Склад + "'' не хватает товара ''" + Выборка.Номенклатура + "'' в количестве " + Выборка.КоличествоОстаток*(-1) + "!");
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры