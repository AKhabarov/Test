////////////////////////////////////////////////////////////////////////////////
// Константа.НастройкиНовостей: Модуль менеджера.
//
////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ)

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		// Чтение константы "НастройкиНовостей".
		ЗначениеКонстанты = Неопределено;
		Запрос = Новый Запрос;
		Запрос.Текст = "
			|ВЫБРАТЬ
			|	НастройкиНовостей.Значение КАК Значение
			|ИЗ
			|	Константа.НастройкиНовостей КАК НастройкиНовостей
			|";
		РезультатЗапроса = Запрос.Выполнить();
		Если НЕ РезультатЗапроса.Пустой() Тогда
			Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.Прямой);
			Если Выборка.Следующий() Тогда
				ЗначениеКонстанты = Выборка.Значение;
			КонецЕсли;
		КонецЕсли;
		Если ЗначениеКонстанты <> Неопределено Тогда
			ЭтотОбъект.ДополнительныеСвойства.Вставить("ЗначениеПередЗаписью", ЗначениеКонстанты);
		КонецЕсли;
	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)

	ТипСтруктура         = Тип("Структура");
	ТипХранилищеЗначения = Тип("ХранилищеЗначения");

	// Получение функциональных опций "РазрешенаРаботаСНовостями"
	//  и "РазрешенаРаботаСНовостямиЧерезИнтернет" осуществляется через
	//  общий модуль "ОбработкаНовостейПовтИсп", поэтому после установки
	//  константы необходимо сбросить кэш.
	// Есть исключение: при начале работы системы, если происходит создание базы из cf, то сбрасывать кэш не нужно,
	//  т.к. это может привести к таким последствиям:
	//  - основная конфигурация (куда внедрена подсистема БИП:Новости) рассчитывает сложный код в модуле ПовтИсп;
	//  - БИП:Новости определяет, что константа "НастройкиНовостей" пустая (а в ней хранится в том числе номер версии платформы),
	//      записывает константу и сбрасывает кэш;
	//  - основной конфигурации (куда внедрена подсистема БИП:Новости) придется рассчитывать сложный код в модуле ПовтИсп заново.
	УстановитьПривилегированныйРежим(Истина);
		СостояниеПриНачалеРаботыСистемы = Ложь;
		ПараметрыОкруженияБИП_Новости = ПараметрыСеанса.ПараметрыОкруженияБИП_Новости.Получить();
		Если ТипЗнч(ПараметрыОкруженияБИП_Новости) = ТипСтруктура Тогда
			Если (ПараметрыОкруженияБИП_Новости.Свойство("СостояниеПриНачалеРаботыСистемы"))
					И (ПараметрыОкруженияБИП_Новости.СостояниеПриНачалеРаботыСистемы = Истина) Тогда
				СостояниеПриНачалеРаботыСистемы = Истина;
			КонецЕсли;
		КонецЕсли;
	УстановитьПривилегированныйРежим(Ложь);
	Если СостояниеПриНачалеРаботыСистемы = Ложь Тогда
		ОбновитьПовторноИспользуемыеЗначения();
	КонецЕсли;

	Если ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации() Тогда
		// Запись в журнал регистрации
		ТекстСообщения = НСтр("ru='Записана константа НастройкиНовостей
			|Предыдущее значение:
			|%ПредыдущееЗначение%
			|
			|Новое значение:
			|%НовоеЗначение%'");

		лкПредыдущееЗначение_Строка = "Неопределено";
		Если ЭтотОбъект.ДополнительныеСвойства.Свойство("ЗначениеПередЗаписью") Тогда
			лкСтароеЗначение = ЭтотОбъект.ДополнительныеСвойства.ЗначениеПередЗаписью;
			Если ТипЗнч(лкСтароеЗначение) = ТипХранилищеЗначения Тогда
				Если ТипЗнч(лкСтароеЗначение.Получить()) = ТипСтруктура Тогда
					лкПредыдущееЗначение_Строка = ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(
						лкСтароеЗначение.Получить(),
						": ",
						Символы.ПС);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

		лкНовоеЗначение_Строка = "Неопределено";
		Если ТипЗнч(ЭтотОбъект.Значение) = ТипХранилищеЗначения Тогда
			Если ТипЗнч(ЭтотОбъект.Значение.Получить()) = ТипСтруктура Тогда
				лкНовоеЗначение_Строка  = ИнтернетПоддержкаПользователейКлиентСервер.ПредставлениеЗначения(
					ЭтотОбъект.Значение.Получить(),
					": ",
					Символы.ПС);
			КонецЕсли;
		КонецЕсли;

		#Если ТолстыйКлиентОбычноеПриложение ИЛИ ВнешнееСоединение Тогда
			ОбъектМетаданных = Неопределено;
		#Иначе
			ОбъектМетаданных = Метаданные.Константы.НастройкиНовостей;
		#КонецЕсли

		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредыдущееЗначение%", лкПредыдущееЗначение_Строка);
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НовоеЗначение%", лкНовоеЗначение_Строка);
		// Запись в журнал регистрации
		ИнтернетПоддержкаПользователейВызовСервера.ЗаписатьСообщениеВЖурналРегистрации(
			НСтр("ru='БИП:Новости.Изменение данных'"), // ИмяСобытия
			НСтр("ru='Новости. Изменение данных. Константы. НастройкиНовостей'"), // ИдентификаторШага
			"Информация", // УровеньЖурналаРегистрации.*
			ОбъектМетаданных, // ОбъектМетаданных
			, // Данные
			ТекстСообщения, // Комментарий
			ОбработкаНовостейВызовСервера.ВестиПодробныйЖурналРегистрации()); // ВестиПодробныйЖурналРегистрации

	КонецЕсли;

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
