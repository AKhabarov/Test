#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ГрантыНеоблагаемыеНДФЛ.УстановитьПараметрыНабораСвойствСправочников();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
