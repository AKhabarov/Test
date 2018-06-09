#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда 
		// Сверхурочные суммированного учета.
		ЗаписатьЗначенияПоказателейРасчетаЗарплаты(Движения, Отказ);
		// Отгулы
		УчетРабочегоВремениРасширенный.ЗарегистрироватьДниЧасыОтгуловСотрудников(Движения, ДанныеОбОтгулах());
	КонецЕсли;
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьМесяца(Ссылка, ПериодСуммированногоУчетаНачало, "ПериодСуммированногоУчетаНачало", Отказ, НСтр("ru='Начало периода'"), , , Ложь);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоМесяца(ПериодСуммированногоУчетаНачало);
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= КонецМесяца(ПериодСуммированногоУчетаОкончание);
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	Ошибки = Неопределено;
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Для каждого Сотрудник Из Сотрудники Цикл
		ОбщееКоличествоПереработок = Сотрудник.ОтработаноЧасов-Сотрудник.НормаЧасов;
		СуммаВведенныхПереработок = Сотрудник.ОтработаноЧасов-Сотрудник.НормаЧасов;
		Если ОбщееКоличествоПереработок <> СуммаВведенныхПереработок Тогда
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(
				Ошибки, "Объект.Сотрудники[%1].ОтработаноЧасов",
				НСтр("ru ='Сумма сверхурочных часов не равна разнице между отработанным и нормо временем.'"), "", Сотрудники.Индекс(Сотрудник));
		КонецЕсли;
	КонецЦикла; 
	
	МассивНепроверяемыхРеквизитов.Добавить("Сотрудники.НормаЧасов");
	МассивНепроверяемыхРеквизитов.Добавить("Сотрудники.ОтработаноЧасов");
	
	Если НЕ Ошибки = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты,МассивНепроверяемыхРеквизитов);
	
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
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ПериодСуммированногоУчетаНачало);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьЗначенияПоказателейРасчетаЗарплаты(Движения, Отказ)
	
	ПереработаноПоСуммированномуУчетуВПределах2Часов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.ПереработаноПоСуммированномуУчетуВПределах2Часов");
	ПереработаноПоСуммированномуУчету = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.ПереработаноПоСуммированномуУчету");

	Если ПереработаноПоСуммированномуУчетуВПределах2Часов = Неопределено Или ПереработаноПоСуммированномуУчету = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ЗначенияПоказателей = Новый ТаблицаЗначений;
	ЗначенияПоказателей.Колонки.Добавить("ПериодДействия", Новый ОписаниеТипов("Дата"));
	ЗначенияПоказателей.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ЗначенияПоказателей.Колонки.Добавить("Показатель", Новый ОписаниеТипов("СправочникСсылка.ПоказателиРасчетаЗарплаты"));
	ЗначенияПоказателей.Колонки.Добавить("Значение", Новый ОписаниеТипов("Число"));
	
	Для каждого Сотрудник Из Сотрудники Цикл
		Если Сотрудник.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда
			Продолжить;
		КонецЕсли;
		Если Сотрудник.Сверхурочно1_5 > 0 Тогда
			НоваяСтрока = ЗначенияПоказателей.Добавить();
			НоваяСтрока.ПериодДействия = ПериодСуммированногоУчетаОкончание;
			НоваяСтрока.Сотрудник = Сотрудник.Сотрудник;
			НоваяСтрока.Показатель = ПереработаноПоСуммированномуУчетуВПределах2Часов;
			НоваяСтрока.Значение = Сотрудник.Сверхурочно1_5;
		КонецЕсли;
		Если Сотрудник.Сверхурочно1_5 + Сотрудник.Сверхурочно2 > 0 Тогда
			НоваяСтрока = ЗначенияПоказателей.Добавить();
			НоваяСтрока.ПериодДействия = ПериодСуммированногоУчетаОкончание;
			НоваяСтрока.Сотрудник = Сотрудник.Сотрудник;
			НоваяСтрока.Показатель = ПереработаноПоСуммированномуУчету;
			НоваяСтрока.Значение = Сотрудник.Сверхурочно1_5 + Сотрудник.Сверхурочно2;
		КонецЕсли;
	КонецЦикла; 	
	
	РасчетЗарплатыРасширенный.ЗарегистрироватьЗначенияРазовыхПоказателейСотрудников(Движения, Организация, ЗначенияПоказателей);
	
КонецПроцедуры

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	ТаблицаДокумента.Сотрудник,
		|	ТаблицаДокумента.Ссылка.Дата КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.РегистрацияПереработок.Сотрудники КАК ТаблицаДокумента
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор";
		
	Запрос.Выполнить();
	
КонецПроцедуры

Функция ДанныеОбОтгулах()

	ТаблицаОтгулов = Новый ТаблицаЗначений;
	ТаблицаОтгулов.Колонки.Добавить("Организация", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	ТаблицаОтгулов.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаОтгулов.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	ТаблицаОтгулов.Колонки.Добавить("ВидДвижения", Новый ОписаниеТипов("ВидДвиженияНакопления"));
	ТаблицаОтгулов.Колонки.Добавить("Дни", Новый ОписаниеТипов("Число"));
	ТаблицаОтгулов.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
	
	Для Каждого СтрокаТаблицы Из Сотрудники Цикл
		Если НЕ СтрокаТаблицы.СпособКомпенсацииПереработки = ПредопределенноеЗначение("Перечисление.СпособыКомпенсацииПереработки.Отгул") Тогда 
			Продолжить;
		КонецЕсли;
		НоваяСтрока = ТаблицаОтгулов.Добавить();
		НоваяСтрока.Период = КонецМесяца(ПериодСуммированногоУчетаОкончание);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Организация = Организация;
		НоваяСтрока.Сотрудник = СтрокаТаблицы.Сотрудник;
		НоваяСтрока.Дни = 0; 
		НоваяСтрока.Часы = СтрокаТаблицы.Сверхурочно1_5 + СтрокаТаблицы.Сверхурочно2;
	КонецЦикла;

	Возврат ТаблицаОтгулов;
	
КонецФункции

#КонецОбласти

#КонецЕсли