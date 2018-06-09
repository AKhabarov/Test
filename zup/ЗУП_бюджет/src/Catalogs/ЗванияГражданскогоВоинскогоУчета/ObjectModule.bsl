#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		
		Запрос = Новый Запрос;
		
		Запрос.Текст =
			"ВЫБРАТЬ
			|	МАКСИМУМ(ЗванияГражданскогоВоинскогоУчета.РеквизитДопУпорядочивания) КАК РеквизитДопУпорядочивания
			|ПОМЕСТИТЬ ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания
			|ИЗ
			|	Справочник.ЗванияГражданскогоВоинскогоУчета КАК ЗванияГражданскогоВоинскогоУчета
			|ГДЕ
			|	ЗванияГражданскогоВоинскогоУчета.ОбщевойсковоеЗвание = &ОбщевойсковоеЗвание
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания.РеквизитДопУпорядочивания + 1 КАК РеквизитДопУпорядочивания
			|ИЗ
			|	ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания КАК ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЗванияГражданскогоВоинскогоУчета.Ссылка,
			|	ЗванияГражданскогоВоинскогоУчета.РеквизитДопУпорядочивания + 1 КАК РеквизитДопУпорядочивания
			|ИЗ
			|	Справочник.ЗванияГражданскогоВоинскогоУчета КАК ЗванияГражданскогоВоинскогоУчета
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания КАК ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания
			|		ПО ЗванияГражданскогоВоинскогоУчета.РеквизитДопУпорядочивания > ВТМаксимальноеЗначениеРеквизитаДопУпорядочивания.РеквизитДопУпорядочивания";
			
		Запрос.УстановитьПараметр("ОбщевойсковоеЗвание", ОбщевойсковоеЗвание);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Если НЕ РезультатЗапроса[1].Пустой() Тогда
			
			ВыборкаДляТекущегоОбъекта = РезультатЗапроса[1].Выбрать();
			ВыборкаДляТекущегоОбъекта.Следующий();
			РеквизитДопУпорядочивания = ВыборкаДляТекущегоОбъекта.РеквизитДопУпорядочивания;
			
			ВыборкаСдвигаемых = РезультатЗапроса[2].Выбрать();
			Пока ВыборкаСдвигаемых.Следующий() Цикл
				
				СправочникОбъект = ВыборкаСдвигаемых.Ссылка.ПолучитьОбъект();
				СправочникОбъект.РеквизитДопУпорядочивания = ВыборкаСдвигаемых.РеквизитДопУпорядочивания;
				СправочникОбъект.Записать();
				
			КонецЦикла;
				
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли