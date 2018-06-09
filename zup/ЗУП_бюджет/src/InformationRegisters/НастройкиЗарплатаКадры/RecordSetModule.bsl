#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Организации = Новый Массив;
	Для Каждого Строка Из ЭтотОбъект Цикл
		Организации.Добавить(Строка.Организация);
	КонецЦикла;
	ЕстьОбособленныеОрганизаций = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(Организации, "ЕстьОбособленныеПодразделения");
	Для Каждого Строка Из ЭтотОбъект Цикл
		Строка.ПрименятьРайонныйКоэффициентВПодразделениях = Строка.ПрименятьРайонныйКоэффициент И ЕстьОбособленныеОрганизаций[Строка.Организация];
		Строка.ПрименятьСевернуюНадбавкуВПодразделениях = Строка.ПрименятьСевернуюНадбавку И ЕстьОбособленныеОрганизаций[Строка.Организация];
	КонецЦикла;
	
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
	ИменаПолей.Организации = "Организация";
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииРегистраСведений(ЭтотОбъект, ИменаПолей);
	
КонецФункции

#КонецОбласти 

#КонецЕсли
