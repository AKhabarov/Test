////////////////////////////////////////////////////////////////////////////////
// Подсистема "Медицинское страхование"
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяФормыНастройкиМедицинскогоСтрахования() Экспорт
	Возврат "Обработка.МедицинскоеСтрахование.Форма.ФормаНастройки";
КонецФункции

Процедура ПрограммыСтрахованияРедактировать(Форма, ТекущиеДанные, ИмяТаблицы, ИмяПоля, ДатаНачала, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктурПрограмм = Новый Массив;
	
	СтруктураОтбора = Новый Структура(ИмяПоля, ТекущиеДанные[ИмяПоля]);
	НайденныеСтроки = Форма.Объект[ИмяТаблицы].НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		СтруктураПрограммы = Новый Структура("ПрограммаСтрахования, СтраховаяПремия", СтрокаТаблицы.ПрограммаСтрахования, СтрокаТаблицы.СтраховаяПремия);
		МассивСтруктурПрограмм.Добавить(СтруктураПрограммы);
	КонецЦикла;
	
	ЭтоСотрудник = ИмяПоля = "Сотрудник";
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить(ИмяПоля, ТекущиеДанные[ИмяПоля]);
	ПараметрыОткрытия.Вставить("МассивСтруктурПрограмм", МассивСтруктурПрограмм);
	ПараметрыОткрытия.Вставить("ДатаНачалаСтрахования", Форма.Объект.ДатаНачалаСтрахования);
	ПараметрыОткрытия.Вставить("ДатаОкончанияСтрахования", Форма.Объект.ДатаОкончанияСтрахования);
	ПараметрыОткрытия.Вставить("ДатаНачала", ДатаНачала);
	Если ЭтоСотрудник Тогда
		ПараметрыОткрытия.Вставить("ДатаОкончания", Форма.Объект.ДатаОкончанияСтрахования);
	Иначе
		ПараметрыОткрытия.Вставить("ДатаОкончания", ТекущиеДанные.ДатаОкончания);
	КонецЕсли;
	ПараметрыОткрытия.Вставить("ДатаРождения", ТекущиеДанные.ДатаРождения);
	ПараметрыОткрытия.Вставить("ШкалаВозрастов", Форма.ШкалаВозрастов);
	ПараметрыОткрытия.Вставить("Страхователь", ТекущиеДанные[ИмяПоля]);
	ПараметрыОткрытия.Вставить("СтраховаяКомпания",  Форма.Объект.СтраховаяКомпания);
	ПараметрыОткрытия.Вставить("ЭтоСотрудник",  ЭтоСотрудник);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПрограммыМедицинскогоСтрахованияОкончаниеВыбора", ЭтотОбъект, ОповещениеЗавершения);
	ОткрытьФорму("Справочник.ПрограммыМедицинскогоСтрахования.Форма.ФормаПодбора", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура РасширенияПрограммСтрахованияРедактировать(Форма, ТекущиеДанные, ИмяТаблицы, ИмяПоля, ДатаНачала, ОповещениеЗавершения = Неопределено) Экспорт
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивСтруктурРасширений = Новый Массив;
	
	СтруктураОтбора = Новый Структура(ИмяПоля, ТекущиеДанные[ИмяПоля]);
	НайденныеСтроки = Форма.Объект[ИмяТаблицы].НайтиСтроки(СтруктураОтбора);
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		СтруктураРасширения = Новый Структура("РасширениеСтрахования, СтраховаяПремия", СтрокаТаблицы.РасширениеСтрахования, СтрокаТаблицы.СтраховаяПремия);
		МассивСтруктурРасширений.Добавить(СтруктураРасширения);
	КонецЦикла;
	
	ЭтоСотрудник = ИмяПоля = "Сотрудник";
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить(ИмяПоля, ТекущиеДанные[ИмяПоля]);
	ПараметрыОткрытия.Вставить("МассивСтруктурРасширений", МассивСтруктурРасширений);
	ПараметрыОткрытия.Вставить("ДатаНачалаСтрахования", Форма.Объект.ДатаНачалаСтрахования);
	ПараметрыОткрытия.Вставить("ДатаОкончанияСтрахования", Форма.Объект.ДатаОкончанияСтрахования);
	ПараметрыОткрытия.Вставить("ДатаНачала", ДатаНачала);
	Если ЭтоСотрудник Тогда
		ПараметрыОткрытия.Вставить("ДатаОкончания", Форма.Объект.ДатаОкончанияСтрахования);
	Иначе
		ПараметрыОткрытия.Вставить("ДатаОкончания", ТекущиеДанные.ДатаОкончания);
	КонецЕсли;
	ПараметрыОткрытия.Вставить("ДатаРождения", ТекущиеДанные.ДатаРождения);
	ПараметрыОткрытия.Вставить("ШкалаВозрастов", Форма.ШкалаВозрастов);
	ПараметрыОткрытия.Вставить("Страхователь", ТекущиеДанные[ИмяПоля]);
	ПараметрыОткрытия.Вставить("СтраховаяКомпания",  Форма.Объект.СтраховаяКомпания);
	ПараметрыОткрытия.Вставить("ЭтоСотрудник",  ЭтоСотрудник);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("РасширенияПрограммМедицинскогоСтрахованияОкончаниеВыбора", ЭтотОбъект, ОповещениеЗавершения);
	ОткрытьФорму("Справочник.РасширенияПрограммМедицинскогоСтрахования.Форма.ФормаПодбора", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещенияОЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

Процедура ЭлементКонтактнойИнформацииНачалоВыбора(Форма, Элемент, ИмяТаблицы, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	ИмяСведения = СтрЗаменить(Элемент.Имя, ИмяТаблицы, "");
	
	ВидКонтактнойИнформации = Неопределено;
	ПараметрыОтбора = Новый Структура("ИмяЭлемента", Элемент.Имя);
	НайденныеСтроки = Форма.ПараметрыПередаваемыхСведений.НайтиСтроки(ПараметрыОтбора);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
		ВидКонтактнойИнформации = НайденнаяСтрока.ВидКонтактнойИнформации;
	КонецЦикла;
	Если ВидКонтактнойИнформации = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЭлемента = Новый Структура;
	ПараметрыЭлемента.Вставить("ВидКонтактнойИнформации", ВидКонтактнойИнформации);
	ПараметрыЭлемента.Вставить("ИмяКИ", ИмяСведения);
	ПараметрыЭлемента.Вставить("ИмяКИПредставление", ИмяСведения + "Представление");
	ПараметрыЭлемента.Вставить("ИмяТаблицы", ИмяТаблицы);
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Форма.Элементы[ПараметрыЭлемента.ИмяТаблицы].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ПараметрыЭлемента.ВидКонтактнойИнформации);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", ТекущиеДанные[ПараметрыЭлемента.ИмяКИ]);
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("ТекущиеДанные", ТекущиеДанные);
	ПараметрыОповещения.Вставить("ПараметрыЭлемента", ПараметрыЭлемента);
	
	Оповещение = Новый ОписаниеОповещения("ЗавершениеВыбораКИ", ЭтотОбъект, ПараметрыОповещения);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, ЭтотОбъект, Оповещение);
	
КонецПроцедуры

Процедура ДокументУдостоверяющийЛичностьНачалоВыбора(Форма, Элемент, ИмяТаблицы, ИмяПоля, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	ТекущиеДанные = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОрганизацияСсылка", Форма.Объект.Организация);
	ПараметрыОткрытия.Вставить("Сотрудник", ТекущиеДанные[ИмяПоля]);
	ПараметрыОткрытия.Вставить("ВидДокумента", ТекущиеДанные.ДокументВид);
	ПараметрыОткрытия.Вставить("Серия", ТекущиеДанные.ДокументСерия);
	ПараметрыОткрытия.Вставить("Номер", ТекущиеДанные.ДокументНомер);
	ПараметрыОткрытия.Вставить("ДатаВыдачи", ТекущиеДанные.ДокументДатаВыдачи);
	ПараметрыОткрытия.Вставить("КемВыдан", ТекущиеДанные.ДокументКемВыдан);
	ПараметрыОткрытия.Вставить("КодПодразделения", ТекущиеДанные.ДокументКодПодразделения);
	ПараметрыОткрытия.Вставить("СрокДействия", ТекущиеДанные.ДокументСрокДействия);
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("ЗавершениеВыбораДокументаУдостоверяющегоЛичность", ЭтотОбъект, ТекущиеДанные);
	ОткрытьФорму("Обработка.МедицинскоеСтрахование.Форма.ФормаДокументУдостоверяющийЛичность", ПараметрыОткрытия, ЭтотОбъект, , , , ОповещениеЗавершения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПрограммыМедицинскогоСтрахованияОкончаниеВыбора(Результат, ОповещениеЗавершения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура РасширенияПрограммМедицинскогоСтрахованияОкончаниеВыбора(Результат, ОповещениеЗавершения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения, Результат);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершениеВыбораКИ(РезультатОткрытияФормы, ПараметрыОповещения) Экспорт 
	
	Если ТипЗнч(РезультатОткрытияФормы) <> Тип("Структура") Тогда
		// не было изменений в данных
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = ПараметрыОповещения.ТекущиеДанные;
	ПараметрыЭлемента = ПараметрыОповещения.ПараметрыЭлемента;
	
	ТекущиеДанные[ПараметрыЭлемента.ИмяКИ] = РезультатОткрытияФормы.КонтактнаяИнформация;
	ТекущиеДанные[ПараметрыЭлемента.ИмяКИПредставление] = РезультатОткрытияФормы.Представление;
	
КонецПроцедуры

Процедура ЗавершениеВыбораДокументаУдостоверяющегоЛичность(Результат, ТекущиеДанные) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ТекущиеДанные.ДокументВид = Результат.ВидДокумента;
		ТекущиеДанные.ДокументСерия = Результат.Серия;
		ТекущиеДанные.ДокументНомер = Результат.Номер;
		ТекущиеДанные.ДокументДатаВыдачи = Результат.ДатаВыдачи;
		ТекущиеДанные.ДокументКемВыдан = Результат.КемВыдан;
		ТекущиеДанные.ДокументКодПодразделения = Результат.КодПодразделения;
		ТекущиеДанные.ДокументСрокДействия = Результат.СрокДействия;
		
		ТекстСерия				= НСтр("ru = ', серия: %1'");
		ТекстНомер				= НСтр("ru = ', № %1'");
		ТекстДатаВыдачи			= НСтр("ru = ', выдан: %1 года'");
		ТекстСрокДействия		= НСтр("ru = ', действует до: %1 года'");
		ТекстКодПодразделения	= НСтр("ru = ', № подр. %1'");
		
		Если ТекущиеДанные.ДокументВид.Пустая() Тогда
			ТекущиеДанные.ДокументПредставление = "";
			
		Иначе
			ТекущиеДанные.ДокументПредставление = ""
				+ ТекущиеДанные.ДокументВид
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументСерия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСерия, ТекущиеДанные.ДокументСерия), "")
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументНомер), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстНомер, ТекущиеДанные.ДокументНомер), "")
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументДатаВыдачи), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстДатаВыдачи, Формат(Дата(ТекущиеДанные.ДокументДатаВыдачи),"ДЛФ=ДД")), "")
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументСрокДействия), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСрокДействия, Формат(Дата(ТекущиеДанные.ДокументСрокДействия),"ДЛФ=ДД")), "")
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументКемВыдан), ", " + ТекущиеДанные.ДокументКемВыдан, "")
				+ ?(ЗначениеЗаполнено(ТекущиеДанные.ДокументКодПодразделения) И ТекущиеДанные.ДокументВид = ПредопределенноеЗначение("Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ"), СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстКодПодразделения, ТекущиеДанные.ДокументКодПодразделения), "");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
