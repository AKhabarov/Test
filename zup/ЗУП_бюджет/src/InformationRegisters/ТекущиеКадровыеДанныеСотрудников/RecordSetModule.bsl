#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("УстановитьОсновноеРабочееМесто") Тогда
		
		РегистрыСведений.ТекущиеКадровыеДанныеСотрудников.УстановитьОсновноеРабочееМестоВОрганизации(ЭтотОбъект);
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.УстановитьПараметр("Сотрудники", ВыгрузитьКолонку("Сотрудник"));
		
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
			|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация КАК Организация
			|ПОМЕСТИТЬ ВТОрагнизацииСотрудников
			|ИЗ
			|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
			|ГДЕ
			|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)";
		
		Запрос.Выполнить();
		
		ДополнительныеСвойства.Вставить("ОрагнизацииСотрудников", Запрос.МенеджерВременныхТаблиц);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьКадровыйУчет") Тогда
		
		Если ДополнительныеСвойства.Свойство("ОрагнизацииСотрудников") Тогда
			
			Запрос = Новый Запрос;
			Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.ОрагнизацииСотрудников;
			Запрос.УстановитьПараметр("Сотрудники", ВыгрузитьКолонку("Сотрудник"));
			
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	ТекущиеКадровыеДанныеСотрудников.Сотрудник КАК Сотрудник,
				|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация КАК Организация
				|ПОМЕСТИТЬ ВТТекущиеОрагнизацииСотрудников
				|ИЗ
				|	РегистрСведений.ТекущиеКадровыеДанныеСотрудников КАК ТекущиеКадровыеДанныеСотрудников
				|ГДЕ
				|	ТекущиеКадровыеДанныеСотрудников.ТекущаяОрганизация <> ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ЕСТЬNULL(ТекущиеОрагнизацииСотрудников.Сотрудник, ОрагнизацииСотрудников.Сотрудник) КАК Сотрудник,
				|	ЕСТЬNULL(ТекущиеОрагнизацииСотрудников.Организация, ОрагнизацииСотрудников.Организация) КАК Организация,
				|	ВЫБОР
				|		КОГДА ТекущиеОрагнизацииСотрудников.Сотрудник ЕСТЬ NULL
				|			ТОГДА -1
				|		ИНАЧЕ 1
				|	КОНЕЦ КАК ФлагИзменений
				|ИЗ
				|	ВТТекущиеОрагнизацииСотрудников КАК ТекущиеОрагнизацииСотрудников
				|		ПОЛНОЕ СОЕДИНЕНИЕ ВТОрагнизацииСотрудников КАК ОрагнизацииСотрудников
				|		ПО ТекущиеОрагнизацииСотрудников.Сотрудник = ОрагнизацииСотрудников.Сотрудник
				|			И ТекущиеОрагнизацииСотрудников.Организация = ОрагнизацииСотрудников.Организация
				|ГДЕ
				|	ЕСТЬNULL(ОрагнизацииСотрудников.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) <> ЕСТЬNULL(ТекущиеОрагнизацииСотрудников.Организация, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))";
			
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				
				ТаблицаАнализаИзменений = КадровыйУчет.ТаблицаАнализаИзменений();
				
				Выборка = РезультатЗапроса.Выбрать();
				Пока Выборка.Следующий() Цикл
					ЗаполнитьЗначенияСвойств(ТаблицаАнализаИзменений.Добавить(), Выборка);
				КонецЦикла;
				
				КадровыйУчет.ОбработатьИзменениеОрганизацийВНабореПоТаблицеИзменений(ТаблицаАнализаИзменений);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	ИменаПолей = ОбменДаннымиЗарплатаКадры.ИменаПолейОграниченияРегистрацииРегистраСведений();
	ИменаПолей.Сотрудники = "Сотрудник";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти

#КонецЕсли
