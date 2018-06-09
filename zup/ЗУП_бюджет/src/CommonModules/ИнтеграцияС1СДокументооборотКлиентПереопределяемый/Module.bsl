////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Документооборотом"
// Модуль ИнтеграцияС1СДокументооборотКлиентПереопределяемый: клиент
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Раскладывает полное имя файла на составляющие.
//
// Параметры:
//  ПолноеИмяФайла - Строка - полный путь к файлу.
//  ЭтоПапка - Булево - признак того, что требуется разложить полное имя папки, а не файла.
//
// Возвращаемое значение:
//   Структура - имя файла, разложенное на составные части(аналогично свойствам объекта Файл):
//		ПолноеИмя - Содержит полный путь к файлу, т.е. полностью соответствует входному параметру ПолноеИмяФайла.
//		Путь - Содержит путь к каталогу, в котором лежит файл.
//		Имя - Содержит имя файла с расширением, без пути к файлу.
//		Расширение - Содержит расширение файла.
//		ИмяБезРасширения - Содержит имя файла без расширения и без пути к файлу.
//			Пример: если ПолноеИмяФайла = "c:\temp\test.txt", то структура заполнится следующим образом:
//				ПолноеИмя: "c:\temp\test.txt".
//				Путь: "c:\temp\"
//				Имя: "test.txt"
//				Расширение: ".txt"
//				ИмяБезРасширения: "test".
//
Функция РазложитьПолноеИмяФайла(Знач ПолноеИмяФайла, ЭтоПапка = Ложь) Экспорт
	
	Возврат ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяФайла, ЭтоПапка);
	
КонецФункции

// Возвращает разделитель пути файловой системы.
//
// Параметры:
//   Платформа - Неопределено:
//   На клиенте - разделитель пути клиентской файловой системы.
//   На сервере - разделитель пути серверной  файловой системы.
//            - ТипПлатформы - разделитель пути файловой системы для
//                             указанного типа платформы.
//
Функция РазделительПути(Платформа = Неопределено) Экспорт
	
	Возврат ПолучитьРазделительПутиКлиента(); 
	
КонецФункции

// Сохраняет массив пользовательских настроек МассивСтруктур. 
// Может применяться для случаев вызова с клиента.
// 
// Параметры:
//    МассивСтруктур - Массив - массив структур с полями "Объект", "Настройка", "Значение".
//    НужноОбновитьПовторноИспользуемыеЗначения - Булево - требуется обновить повторно используемые значения
//
Процедура ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, НужноОбновитьПовторноИспользуемыеЗначения);

КонецПроцедуры

// Устанавливает отбор при выборе объекта ДО, связанного с объектом ИС.
//
// Параметры:
//   СвязываемыйОбъект - ЛюбаяСсылка - объект ИС, связываемый с объектом ДО
//   ТипОбъектаДокументооборота - Строка - тип выбираемого объекта ДО
//
// Возвращаемое значение:
//   Неопределено или Структура - структура отбора, накладываемого перед предъявлением пользователю
//
Функция ОтборПриВыбореСвязанногоОбъекта(СвязываемыйОбъект, ТипОбъектаДокументооборота) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Вызывается при изменении состояния согласования в ДО. Предназначен для изменения формы
// согласуемого объекта, если доработка самого модуля формы нежелательна.
//
// Параметры:
//   ПредметСогласования - ЛюбаяСсылка - согласуемый объект.
//   Источник - УправляемаяФорма - форма-источник вызова.
//   Состояние - ПеречислениеСсылка.СостоянияСогласованияВДокументообороте.
//   ВызовИзФормыОбъекта - Булево - Истина, если изменение состояния вызвано пользователем из формы объекта.
//
Процедура ПриИзмененииСостоянияСогласования(ПредметСогласования, Источник, Состояние, 
		ВызовИзФормыОбъекта) Экспорт

	

КонецПроцедуры

// Вызывается из форм согласуемых объектов. Предназначена для вывода листа согласования в случаях,
// когда добавление команды в подменю печати невозможно или нежелательно, а также для внедрения в конфигурации
// без подсистемы БСП УправлениеПечатью.
//
// Параметры:
//   ПредметСогласования - ЛюбаяСсылка - согласуемый объект.
//   ВладелецФормы - УправляемаяФорма - необязательный, форма-источник команды.
//
Процедура ВыполнитьКомандуПечатиЛистаСогласования(ПредметСогласования, ВладелецФормы = Неопределено) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ИнтеграцияС1СДокументооборот", "ЛистСогласования", 
		ПредметСогласования, ВладелецФормы);
	
КонецПроцедуры

// Вызывается из форм обработки, соответствующих процессам, документам и задачам ДО. Предназначена для обработки
// команд, добавленных программно при вызове процедуры ДополнительнаяОбработкаФормы<...> переопределяемого модуля.
//
// Параметры:
//   Команда - КомандаФормы - вызванная пользователем команда.
//   ЭтаФорма - УправляемаяФорма - форма обработки, откуда вызвана команда.
//
Процедура ВыполнитьПрограммноДобавленнуюКоманду(Команда, ЭтаФорма) Экспорт

	

КонецПроцедуры

// Запоминает факт показа окна авторизации, чтобы больше не беспокоить пользователя в пределах сеанса.
//
Процедура СохранитьАвторизацияПредложена() Экспорт
	
	Если ПараметрыПриложения["ИнтеграцияС1СДокументооборот.АвторизацияПредложена"] = Неопределено Тогда
		ПараметрыПриложения.Вставить("ИнтеграцияС1СДокументооборот.АвторизацияПредложена", Истина);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает сохраненный ранее признак состоявшегося показа окна авторизации.
//
// Возвращаемое значение:
//   Булево - Истина, если авторизация была предложена в этом сеансе, и Ложь в противном случае.
//
Функция АвторизацияПредложена() Экспорт
	
	Возврат (ПараметрыПриложения["ИнтеграцияС1СДокументооборот.АвторизацияПредложена"] = Истина);
	
КонецФункции

// Вызывается при выборе автоматической настройки интеграции из списка интегрируемых объектов.
//
// Параметры:
//   ИмяТипаОбъекта - Строка - полное имя типа объекта ИС, как в метаданных.
//   ОписаниеОповещения - ОписаниеОповещения - обработчик, вызываемый после успешной настройки.
//
Процедура НачатьАвтоматическуюНастройкуИнтеграции(ИмяТипаОбъекта) Экспорт
	
	
	
КонецПроцедуры

// Вызывается перед созданием бизнес-процесса и позволяет отказаться от запуска.
//
// Параметры:
//   Предмет - ЛюбаяСсылка - ссылка на объект интегрируемой системы, или
//           - Структура - описание объекта ДО, со свойствами:
//               id - Строка - идентификатор;
//               type - Строка - тип;
//               name - Строка - наименование предмета.
//   Отказ - Булево - при установке в Истина процесс запущен не будет.
//
// Пример реализации:
//	Если ТипЗнч(Предмет) = Тип("ДокументСсылка._ДемоЗаказПокупателя") Тогда
//		ТекстСообщения = "";
//		Если Не ПродажиВызовСервера.ЗаказЗаполненКорректно(Предмет, ТекстСообщения) Тогда
//			Отказ = Истина;
//			ПоказатьПредупреждение(, ТекстСообщения);
//		КонецЕсли;
//	КонецЕсли;
//
Процедура ПередСозданиемБизнесПроцесса(Предмет, Отказ) Экспорт
	
	
КонецПроцедуры

#КонецОбласти
