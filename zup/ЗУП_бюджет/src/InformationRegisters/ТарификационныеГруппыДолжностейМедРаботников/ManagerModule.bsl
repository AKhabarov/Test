#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПараметрыОбновленияИсточникаПодключаемыхХарактеристикЗарплатаКадры(ПараметрыОбновления) Экспорт
	
	ПараметрыОбновления.ИмяРегистра = "ТарификационныеГруппыДолжностейМедРаботников";
	ПараметрыОбновления.ИдентификаторИсточника = "ГруппыМедРаб";
	ПараметрыОбновления.ИмяОбъекта = "Должность";
	ПараметрыОбновления.ИмяПланаВидовХарактеристик = Справочники.Должности.ИмяПланаВидовПодключаемыхХарактеристикЗарплатаКадры();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПервоначальногоЗаполненияИОбновленияИБ

Процедура ДобавитьЗаписи(ПараметрыОбновления = НеОпределено) Экспорт
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьТарификационнуюОтчетностьУчрежденийФМБА") Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Должности.Ссылка КАК Должность,
	|	ТарификационныеГруппы.ТарификационнаяГруппа КАК ТарификационнаяГруппа
	|ПОМЕСТИТЬ ВТТарификационныеГруппы
	|ИЗ
	|	Справочник.Должности КАК Должности
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТарификационныеГруппыДолжностейМедРаботников КАК ТарификационныеГруппы
	|		ПО Должности.Ссылка = ТарификационныеГруппы.Должность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1000
	|	ШтатноеРасписание.Ссылка КАК Должность,
	|	ТарификационныеГруппы.ТарификационнаяГруппа
	|ИЗ
	|	Справочник.ШтатноеРасписание КАК ШтатноеРасписание
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТТарификационныеГруппы КАК ТарификационныеГруппы
	|		ПО ШтатноеРасписание.Должность = ТарификационныеГруппы.Должность
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТарификационныеГруппыДолжностейМедРаботников КАК ТарификационныеГруппыДолжностейМедРаботников
	|		ПО (ТарификационныеГруппыДолжностейМедРаботников.Должность = ШтатноеРасписание.Ссылка)
	|ГДЕ
	|	ТарификационныеГруппыДолжностейМедРаботников.ТарификационнаяГруппа ЕСТЬ NULL";
	
	Если ПараметрыОбновления = НеОпределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, " ПЕРВЫЕ 1000", "");
	КонецЕсли;

	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда 
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
	Иначе
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
		
		ТаблицаТарификационныхГрупп = РезультатЗапроса.Выгрузить();
		
		ПространствоБлокировки = "РегистрСведений.ТарификационныеГруппыДолжностейМедРаботников";
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить(ПространствоБлокировки);
		ЭлементБлокировки.ИсточникДанных = ТаблицаТарификационныхГрупп;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Должность", "Должность");
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			Набор = РегистрыСведений.ТарификационныеГруппыДолжностейМедРаботников.СоздатьНаборЗаписей();
			Для каждого СтрокаГруппы Из ТаблицаТарификационныхГрупп Цикл
				ЗаполнитьЗначенияСвойств(Набор.Добавить(), СтрокаГруппы);
			КонецЦикла;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(Набор, Ложь);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Обновление информационной базы.Ошибка блокировки'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Предупреждение, Метаданные.РегистрыСведений.ТарификационныеГруппыДолжностейМедРаботников, , ПространствоБлокировки);
			
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

Процедура ОбновитьПодключаемыеХарактеристики(ИспользоватьПодключаемыеХарактеристики, ПараметрыОбновления = Неопределено) Экспорт
	
	ИсточникиХарактеристик = Новый Массив;
	ИсточникиХарактеристик.Добавить("ТарификационныеГруппыДолжностейМедРаботников");
	
	ПодключаемыеХарактеристикиЗарплатаКадры.ОбновитьНаборыПодключаемыхХарактеристик(
		ИспользоватьПодключаемыеХарактеристики, ИсточникиХарактеристик, ПараметрыОбновления);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли




