
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.РежимВыбора И Параметры.ЗакрыватьПриВыборе = Ложь Тогда
		Элементы.Список.МножественныйВыбор = Истина;
		Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
	КонецЕсли;
	
	Если Элементы.Список.РежимВыбора И Не ЭтаФорма.ЗакрыватьПриВыборе Тогда
		
		Если Параметры.Свойство("РасширенияПрограммСтрахования") Тогда
			МассивПодобранных = Параметры.РасширенияПрограммСтрахования;
			СписокПодобранных.ЗагрузитьЗначения(МассивПодобранных);
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьСписокПодобранныхПрограмм();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыЗакрытия = Новый Структура;
	ПараметрыЗакрытия.Вставить("РасширенияПрограммСтрахования", СписокПодобранных.ВыгрузитьЗначения());
	
	Закрыть(ПараметрыЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	Если Элементы.Список.РежимВыбора Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ТипЗнч(Значение) = Тип("Массив") Тогда
			СписокЗначений = Значение;
		Иначе
			СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
		КонецЕсли;
		
		Если СписокЗначений.Количество() > 0 Тогда
			
			Если Элементы.Список.МножественныйВыбор Тогда
				
				ОбновитьСписокПодобранных(СписокЗначений);
				Если СписокЗначений.Количество() > 1 Тогда
					Закрыть();
				КонецЕсли; 
				
			Иначе
				
				Если СписокПодобранных.НайтиПоЗначению(СписокЗначений[0]) = Неопределено Тогда
					ОповеститьОВыборе(СписокЗначений[0]);
				Иначе
					Закрыть();
				КонецЕсли;
				
			КонецЕсли; 
			
		КонецЕсли; 
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьСписокПодобранныхПрограмм()
	
	ЭлементУсловногоОформления = Неопределено;
	Для каждого ЭлементОформления Из УсловноеОформление.Элементы Цикл
		Если ЭлементОформления.Представление = НСтр("ru='Выделение подобранных'") Тогда
			ЭлементУсловногоОформления = ЭлементОформления;
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ЭлементУсловногоОформления <> Неопределено Тогда
		ЭлементУсловногоОформления.Отбор.Элементы[0].ПравоеЗначение = СписокПодобранных;
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокПодобранных(Значение)
	
	Если ТипЗнч(Значение) = Тип("Массив") Тогда
		СписокЗначений = Значение;
	Иначе
		СписокЗначений = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Значение);
	КонецЕсли;
	
	Для каждого ВыбранноеЗначение Из СписокЗначений Цикл
		НайденноеЗначение = СписокПодобранных.НайтиПоЗначению(ВыбранноеЗначение);
		Если НайденноеЗначение = Неопределено Тогда
			СписокПодобранных.Добавить(ВыбранноеЗначение);
		Иначе
			СписокПодобранных.Удалить(НайденноеЗначение);
		КонецЕсли; 
	КонецЦикла;
	
	УстановитьСписокПодобранныхПрограмм();
	
КонецПроцедуры

#КонецОбласти
