#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс

Процедура ПараметрыОбновленияИсточникаПодключаемыхХарактеристикЗарплатаКадры(ПараметрыОбновления) Экспорт
	
	ПараметрыОбновления.ИмяРегистра = "СвойстваДолжностейМедицинскихРаботников";
	ПараметрыОбновления.ИдентификаторИсточника = "Медик";
	ПараметрыОбновления.ИмяОбъекта = "Должность";
	ПараметрыОбновления.ИмяПланаВидовХарактеристик = Справочники.Должности.ИмяПланаВидовПодключаемыхХарактеристикЗарплатаКадры();
	
	Если ПараметрыОбновления.ОбновитьНаборХарактеристик Тогда
		ПараметрыОбновления.ПроверяемыеКонстанты.Добавить("РаботаВМедицинскомУчреждении");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли