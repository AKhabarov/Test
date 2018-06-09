#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если ОблачныйАрхивВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		ЭтотОбъект.ДополнительныеСвойства.Вставить("ЗначениеПередЗаписью", Константы.НастройкиОблачногоАрхива.Получить());
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
