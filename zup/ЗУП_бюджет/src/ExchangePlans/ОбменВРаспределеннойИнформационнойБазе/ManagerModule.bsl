#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет настройки, влияющие на использование плана обмена.
// 
// Параметры:
//  Настройки - Структура - настройки плана обмена по умолчанию, см. ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию,
//                          описание возвращаемого значения функции.
//
Процедура ПриПолученииНастроек(Настройки) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Настройки.НазначениеПланаОбмена = "РИБСФильтром";
	
	Настройки.Алгоритмы.ПриПолученииОписанияВариантаНастройки = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанных     = Истина;
	Настройки.Алгоритмы.ОписаниеОграниченийПередачиДанныхБазыКорреспондента = Истина;
	
КонецПроцедуры

// Заполняет набор параметров, определяющих вариант настройки обмена.
// 
// Параметры:
//  ОписаниеВарианта       - Структура - набор варианта настройки по умолчанию,
//                                       см. ОбменДаннымиСервер.ОписаниеВариантаНастройкиОбменаПоУмолчанию,
//                                       описание возвращаемого значения.
//  ИдентификаторНастройки - Строка    - идентификатор варианта настройки обмена.
//  ПараметрыКонтекста     - Структура - см. ОбменДаннымиСервер.ПараметрыКонтекстаПолученияОписанияВариантаНастройки,
//                                       описание возвращаемого значения функции.
//
Процедура ПриПолученииОписанияВариантаНастройки(ОписаниеВарианта, ИдентификаторНастройки, ПараметрыКонтекста) Экспорт
	
	КраткаяИнформацияПоОбмену = НСтр("ru = 'Распределенная информационная база представляет собой иерархическую структуру, 
	|состоящую из отдельных информационных баз системы «1С:Предприятие» - узлов распределенной информационной базы, между 
	|которыми организована синхронизация конфигурации и данных. Главной особенностью распределенных информационных баз 
	|является передача изменений конфигурации в подчиненные узлы. 
	|Имеется возможность настраивать ограничения миграции данных, например по организациям.'");
	КраткаяИнформацияПоОбмену = СтрЗаменить(КраткаяИнформацияПоОбмену, Символы.ПС, "");
	
	ПодробнаяИнформацияПоОбмену = "ПланОбмена.ОбменВРаспределеннойИнформационнойБазе.Форма.ПодробнаяИнформация";
	
	ОписаниеВарианта.КраткаяИнформацияПоОбмену   = КраткаяИнформацияПоОбмену;
	ОписаниеВарианта.ПодробнаяИнформацияПоОбмену = ПодробнаяИнформацияПоОбмену;
	
	ОписаниеВарианта.ИмяФайлаНастроекДляПриемника = НСтр("ru = 'Настройки синхронизации распределенной информационной базы'");
	
	ОписаниеВарианта.ЗаголовокКомандыДляСозданияНовогоОбменаДанными = НСтр("ru = 'Распределенная информационная база'");
	
	ОписаниеВарианта.ИмяФормыСозданияНачальногоОбраза = "ОбщаяФорма.СозданиеНачальногоОбразаСФайлами";
	
	ОписаниеВарианта.ОбщиеДанныеУзлов = "ИспользоватьОтборПоОрганизациям, Организации";
	
	// Отборы
	ОписаниеВарианта.Отборы = НастройкаОтборовНаУзле();
	ОписаниеВарианта.ОтборыКорреспондента = НастройкаОтборовНаУзлеБазыКорреспондента();
	
КонецПроцедуры

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//	НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//										 полученная при помощи функции НастройкаОтборовНаУзле().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
// Возвращаемое значение:
//	Строка - Строка описания ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	// отбор по организациям
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(
			НастройкаОтборовНаУзле.Организации.Организация, "; ");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Только по организациям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	// отбор по подразделениям
	ОграничениеОтборПоПодразделениям = "";
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоПодразделениям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(
			НастройкаОтборовНаУзле.Подразделения.Подразделение, "; ");
		ОграничениеОтборПоПодразделениям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Только по подразделениям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
			ОграничениеОтборПоПодразделениям = НСтр("ru = 'По всем подразделениям.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат (
		НСтр("ru = 'Выгружать документы и справочную информацию:'")
		+ Символы.ПС
		+ ОграничениеОтборПоОрганизациям
		+ Символы.ПС
		+ ОграничениеОтборПоПодразделениям);
	
КонецФункции

// Возвращает реквизиты объекта, которые не рекомендуется редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("РегистрироватьИзменения");
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Для работы через подключение к корреспонденту через внешнее соединение или веб-сервис.

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку
// описания ограничений  удобную для восприятия пользователем.
// 
// Параметры:
//	НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                       полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									описания ограничений передачи данных в зависимости от версии корреспондента.
// 
// Возвращаемое значение:
//	Строка - строка описания ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	// отбор по организациям
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоОрганизациям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(
			НастройкаОтборовНаУзле.Организации.Организация, "; ");
		ОграничениеОтборПоОрганизациям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Только по организациям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		ОграничениеОтборПоОрганизациям = НСтр("ru = 'По всем организациям'");
	КонецЕсли;
	
	// отбор по подразделениям
	ОграничениеОтборПоПодразделениям = "";
	Если НастройкаОтборовНаУзле.ИспользоватьОтборПоПодразделениям Тогда
		СтрокаПредставленияОтбора = СтрСоединить(
			НастройкаОтборовНаУзле.Подразделения.Подразделение, "; ");
		ОграничениеОтборПоПодразделениям = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Только по подразделениям: %1'"), СтрокаПредставленияОтбора);
	Иначе
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОрганизационнаяСтруктура") Тогда
			ОграничениеОтборПоПодразделениям = НСтр("ru = 'По всем подразделениям.'");
		КонецЕсли;
	КонецЕсли;
	
	Возврат (
		НСтр("ru = 'Выгружать документы и справочную информацию:'")
		+ Символы.ПС
		+ ОграничениеОтборПоОрганизациям
		+ Символы.ПС
		+ ОграничениеОтборПоПодразделениям);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//		ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//		ИдентификаторНастройки - Строка - Имя предопределенной настройки плана обмена.
// 
// Возвращаемое значение:
//	СтруктураНастроек - Структура - структура отборов на узле плана обмена.
// 
Функция НастройкаОтборовНаУзле()
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураТабличнойЧастиПодразделения = Новый Структура;
	СтруктураТабличнойЧастиПодразделения.Вставить("Подразделение", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",   Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоПодразделениям", Ложь);
	ГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	
	// Это подчиненный узел РИБ с отбором.
	Если ГлавныйУзел <> Неопределено И ТипЗнч(ГлавныйУзел) = Тип("ПланОбменаСсылка.ОбменВРаспределеннойИнформационнойБазе") Тогда
		НастройкиЦентральногоУзлаРИБ = ЭтотУзел();
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, НастройкиЦентральногоУзлаРИБ);
		СтруктураТабличнойЧастиОрганизации = Новый Структура;
		СтруктураТабличнойЧастиОрганизации.Вставить("Организация", НастройкиЦентральногоУзлаРИБ.Организации.ВыгрузитьКолонку("Организация"));
	КонецЕсли;
	СтруктураНастроек.Вставить("Организации",   СтруктураТабличнойЧастиОрганизации);
	СтруктураНастроек.Вставить("Подразделения", СтруктураТабличнойЧастиПодразделения);
	
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//		ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//		ИдентификаторНастройки - Строка - Имя предопределенной настройки плана обмена.
// 
// Возвращаемое значение:
//  СтруктураНастроек - Структура - структура отборов на узле плана обмена базы корреспондента.
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента()
	
	СтруктураТабличнойЧастиОрганизации = Новый Структура;
	СтруктураТабличнойЧастиОрганизации.Вставить("Организация", Новый Массив);
	
	СтруктураТабличнойЧастиПодразделения = Новый Структура;
	СтруктураТабличнойЧастиПодразделения.Вставить("Подразделение", Новый Массив);
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ИспользоватьОтборПоОрганизациям",   Ложь);
	СтруктураНастроек.Вставить("ИспользоватьОтборПоПодразделениям", Ложь);
	ГлавныйУзел = ПланыОбмена.ГлавныйУзел();
	
	// Это подчиненный узел РИБ с отбором.
	Если ГлавныйУзел <> Неопределено И ТипЗнч(ГлавныйУзел) = Тип("ПланОбменаСсылка.ОбменВРаспределеннойИнформационнойБазе") Тогда
		НастройкиЦентральногоУзлаРИБ = ЭтотУзел();
		ЗаполнитьЗначенияСвойств(СтруктураНастроек, НастройкиЦентральногоУзлаРИБ);
		СтруктураТабличнойЧастиОрганизации = Новый Структура;
		СтруктураТабличнойЧастиОрганизации.Вставить("Организация", НастройкиЦентральногоУзлаРИБ.Организации.ВыгрузитьКолонку("Организация"));
	КонецЕсли;
	
	СтруктураНастроек.Вставить("Организации",						СтруктураТабличнойЧастиОрганизации);
	СтруктураНастроек.Вставить("Подразделения",						СтруктураТабличнойЧастиПодразделения);
	
	Возврат СтруктураНастроек;
	
КонецФункции

#КонецОбласти

#КонецЕсли
