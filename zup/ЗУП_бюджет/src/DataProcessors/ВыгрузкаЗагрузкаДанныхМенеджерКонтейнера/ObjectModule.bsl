#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ВнутреннееСостояние

Перем ДляВыгрузки;
Перем ДляЗагрузки;

Перем КонтейнерИнициализирован;
Перем КорневойКаталог;
Перем КоличествоФайловПоВиду;
Перем ВремяНачалаВыгрузки;
Перем Состав;

Перем Параметры;

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// ВЫГРУЗКА

// Инициализирует выгрузку.
//
// Параметры:
//	КаталогВыгрузки - Строка - путь к каталогу выгрузки.
//
Процедура ИнициализироватьВыгрузку(Знач КаталогВыгрузки, Знач ПараметрыВыгрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	
	ВремяНачалаВыгрузки = ТекущаяДатаСеанса();	

	КаталогВыгрузки = СокрЛП(КаталогВыгрузки);
	Если СтрЗаканчиваетсяНа(КаталогВыгрузки, "\") Тогда
		КорневойКаталог = КаталогВыгрузки;
	Иначе
		КорневойКаталог = КаталогВыгрузки + "\";
	КонецЕсли;
	
	Параметры = ПараметрыВыгрузки;
	
	ДляВыгрузки = Истина;
	КонтейнерИнициализирован = Истина;
	
КонецПроцедуры

Функция ПараметрыВыгрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляВыгрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для выгрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыВыгрузки(ПараметрыВыгрузки) Экспорт
	
	Параметры = ПараметрыВыгрузки;
	
КонецПроцедуры

// Создает файл в каталоге выгрузке.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьФайл(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВидФайла, "xml", ТипДанных);
	
КонецФункции

// Создает произвольный файл выгрузки.
//
// Параметры:
//	Расширение - Строка - расширение файла.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	Строка - имя файла.
//
Функция СоздатьПроизвольныйФайл(Знач Расширение, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ДобавитьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), Расширение, ТипДанных);
	
КонецФункции

Процедура УстановитьКоличествоОбъектов(Знач ПолныйПутьКФайлу, Знач ЧислоОбъектов = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Фильтр = Новый Структура;
	Фильтр.Вставить("ПолноеИмя", ПолныйПутьКФайлу);
	ФайлыВСоставе = Состав.НайтиСтроки(Фильтр);
	Если ФайлыВСоставе.Количество() = 0 Или ФайлыВСоставе.Количество() > 1 Тогда 
		ВызватьИсключение НСтр("ru = 'Файл не найден'");
	КонецЕсли;
	
	ФайлыВСоставе[0].ЧислоОбъектов = ЧислоОбъектов;
	
КонецПроцедуры

Процедура ИсключитьФайл(Знач ПолныйПутьКФайлу) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = Состав.Найти(ПолныйПутьКФайлу, "ПолноеИмя");
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Файл %1 не найден в составе контейнера.'"), ПолныйПутьКФайлу);
	Иначе
		
		КоличествоФайлов = КоличествоФайловПоВиду[СтрокаСостава.ВидФайла];
		КоличествоФайловПоВиду.Вставить(СтрокаСостава.ВидФайла, КоличествоФайлов - 1);
		
		Состав.Удалить(СтрокаСостава);
		УдалитьФайлы(ПолныйПутьКФайлу);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаменитьФайл(Знач ИмяВКонтейнере, Знач ПолныйПутьКФайлу, Знач УдалятьФайлЗаменыСДиска = Ложь) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаИсходногоФайла = Состав.Найти(ИмяВКонтейнере, "Имя");
	Если СтрокаИсходногоФайла = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Файл с идентификатором %1 не найден в составе контейнера.'"), ИмяВКонтейнере);
	Иначе
		
		ИмяИсходногоФайла = СтрокаИсходногоФайла.ПолноеИмя;
		ПереместитьФайл(ПолныйПутьКФайлу, ИмяИсходногоФайла);
		
		Если УдалятьФайлЗаменыСДиска Тогда
			УдалитьФайлы(ПолныйПутьКФайлу);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Финализирует выгрузку. Записывает информацию о выгрузке в файл.
//
Процедура ФинализироватьВыгрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	ОбновитьСоставВыгружаемыхФайлов();
	ИмяФайла = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайла);
	
	ИмяФайлаДайджеста = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.Digest(), "CustomData");
	ЗаписатьДайджест(ИмяФайлаДайджеста);
	
	ИмяФайлаСодержимого = СоздатьФайл(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайлаСодержимого);
	
	
КонецПроцедуры

Процедура ОбновитьСоставВыгружаемыхФайлов()
	
	Для Каждого ТекущийФайл Из Состав Цикл 
		
		Файл = Новый Файл(ТекущийФайл.ПолноеИмя);
		Если Не Файл.Существует() Тогда 
			ВызватьИсключение НСтр("ru = 'Файл был удален'");
		КонецЕсли;
		
		ТекущийФайл.Размер = Файл.Размер();
		ТекущийФайл.Хеш    = РассчитатьХеш(Файл.ПолноеИмя);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАГРУЗКА

// Инициализирует загрузку.
//
// Параметры:
//	КаталогЗагрузки - Строка - путь к каталогу загрузки.
//
Процедура ИнициализироватьЗагрузку(Знач КаталогЗагрузки, Знач ПараметрыЗагрузки) Экспорт
	
	ПроверкаИнициализацииКонтейнера(Истина);
	
	КаталогЗагрузки = СокрЛП(КаталогЗагрузки);
	Если СтрЗаканчиваетсяНа(КаталогЗагрузки, "\") Тогда
		КорневойКаталог = КаталогЗагрузки;
	Иначе
		КорневойКаталог = КаталогЗагрузки + "\";
	КонецЕсли;
	
	ИмяФайлаСодержимого = КаталогЗагрузки + ПолучитьИмяФайла(ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents());
	
	ФайлСодержимого = Новый Файл(ИмяФайлаСодержимого);
	Если Не ФайлСодержимого.Существует() Тогда
		
		ВызватьИсключение НСтр("ru = 'Ошибка загрузки данных. Неверный формат файла. В архиве не обнаружен файл PackageContents.xml.
                                |Возможно, файл был получен из предыдущих версий программы или поврежден.'");
		
	КонецЕсли;
	
	ПотокЧтения = Новый ЧтениеXML();
	ПотокЧтения.ОткрытьФайл(ИмяФайлаСодержимого);
	ПотокЧтения.ПерейтиКСодержимому();
	
	Если ПотокЧтения.ТипУзла <> ТипУзлаXML.НачалоЭлемента
			Или ПотокЧтения.Имя <> "Data" Тогда
		
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Ошибка чтения XML. Неверный формат файла. Ожидается начало элемента %1.'"),
			"Data");
		
	КонецЕсли;
	
	Если НЕ ПотокЧтения.Прочитать() Тогда
		ВызватьИсключение НСтр("ru = 'Ошибка чтения XML. Обнаружено завершение файла.'");
	КонецЕсли;
	
	Пока ПотокЧтения.ТипУзла = ТипУзлаXML.НачалоЭлемента Цикл
		
		ЭлементКонтейнера = ФабрикаXDTO.ПрочитатьXML(ПотокЧтения, ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File"));
		ПрочитатьЭлементКонтейнера(ЭлементКонтейнера);
		
	КонецЦикла;
	
	ПотокЧтения.Закрыть();
	
	Для Каждого Элемент Из Состав Цикл
		Элемент.ПолноеИмя = КаталогЗагрузки + Элемент.Каталог + "\" + Элемент.Имя;
	КонецЦикла;
	
	Параметры = ПараметрыЗагрузки;
	
	ДляЗагрузки = Истина;
	КонтейнерИнициализирован = Истина;
	
КонецПроцедуры

Функция ПараметрыЗагрузки() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Если ДляЗагрузки Тогда
		Возврат Новый ФиксированнаяСтруктура(Параметры);
	Иначе
		ВызватьИсключение НСтр("ru = 'Контейнер не инициализирован для загрузки данных.'");
	КонецЕсли;
	
КонецФункции

Процедура УстановитьПараметрыЗагрузки(ПараметрыЗагрузки) Экспорт
	
	Параметры = ПараметрыЗагрузки;
	
КонецПроцедуры

// Получает файл из каталога.
//
// Параметры:
//	ВидФайла - Строка - вид файла выгрузки.
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - см. таблицу значений "Состав".
//
Функция ПолучитьФайлИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		Возврат Неопределено;
	ИначеЕсли Файлы.Количество() > 1 Тогда
		ВызватьИсключение НСтр("ru = 'В выгрузке содержится дублирующаяся информация'");
	КонецЕсли;
	
	Возврат Файлы[0].ПолноеИмя;
	
КонецФункции

// Получает произвольный файл из каталога.
//
// Параметры:
//	ТипДанных - Строка - тип данных.
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - см. таблицу значений "Состав".
//
Функция ПолучитьПроизвольныйФайл(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Файлы = ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData() , ТипДанных);
	Если Файлы.Количество() = 0 Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В выгрузке отсутствует произвольный файл с типом данным %1.'"),
			ТипДанных);
	ИначеЕсли Файлы.Количество() > 1 Тогда
		ВызватьИсключение НСтр("ru = 'В выгрузке содержится дублирующаяся информация'");
	КонецЕсли;
	
	Возврат Файлы[0].ПолноеИмя;
	
КонецФункции

Функция ПолучитьФайлыИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияФайловИзКаталога(ВидФайла, ТипДанных).ВыгрузитьКолонку("ПолноеИмя");
	
КонецФункции

Функция ПолучитьОписанияФайловИзКаталога(Знач ВидФайла, Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	ТаблицаСФайлами = Неопределено;
	
	Если ТипЗнч(ВидФайла) = Тип("Массив") Тогда 
		
		Для Каждого ОтдельныйВид Из ВидФайла Цикл
			ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, ПолучитьФайлыИзСостава(ОтдельныйВид , ТипДанных));
		КонецЦикла;
		Возврат ТаблицаСФайлами;
		
	ИначеЕсли ТипЗнч(ВидФайла) = Тип("Строка") Тогда 
		
		Возврат ПолучитьФайлыИзСостава(ВидФайла, ТипДанных);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Неизвестный вид файла'");
		
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПроизвольныеФайлы(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьОписанияПроизвольныхФайлов(ТипДанных).ВыгрузитьКолонку("ПолноеИмя");
	
КонецФункции

Функция ПолучитьОписанияПроизвольныхФайлов(Знач ТипДанных = Неопределено) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	Возврат ПолучитьФайлыИзСостава(ВыгрузкаЗагрузкаДанныхСлужебный.CustomData(), ТипДанных);
	
КонецФункции

Процедура ДописатьФайлыВТаблицуЗначений(ТаблицаСФайлами, Знач ФайлыИзСостава)
	
	Если ТаблицаСФайлами = Неопределено Тогда 
		ТаблицаСФайлами = ФайлыИзСостава;
		Возврат;
	КонецЕсли;
	
	ТехнологияСервисаИнтеграцияСБСП.ДополнитьТаблицу(ФайлыИзСостава, ТаблицаСФайлами);
	
КонецПроцедуры

Функция ПолучитьПолноеИмяФайла(Знач ОтносительноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = Состав.Найти(ОтносительноеИмяФайла, "Имя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл с относительным именем %1.'"),
			ОтносительноеИмяФайла);
	Иначе
		Возврат СтрокаСостава.ПолноеИмя;
	КонецЕсли;
	
КонецФункции

Функция ПолучитьОтносительноеИмяФайла(Знач ПолноеИмяФайла) Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
	СтрокаСостава = Состав.Найти(ПолноеИмяФайла, "ПолноеИмя");
	
	Если СтрокаСостава = Неопределено Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'В контейнере не обнаружен файл %1.'"),
			ПолноеИмяФайла);
	Иначе
		Возврат СтрокаСостава.Имя;
	КонецЕсли;
	
КонецФункции

Процедура ФинализироватьЗагрузку() Экспорт
	
	ПроверкаИнициализацииКонтейнера();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьФайлыИзСостава(Знач ВидФайла = Неопределено, Знач ТипДанных = Неопределено)
	
	Фильтр = Новый Структура;
	Если ВидФайла <> Неопределено Тогда
		Фильтр.Вставить("ВидФайла", ВидФайла);
	КонецЕсли;
	Если ТипДанных <> Неопределено Тогда
		Фильтр.Вставить("ТипДанных", ТипДанных);
	КонецЕсли;
	
	Возврат Состав.Скопировать(Фильтр);
	
КонецФункции

Процедура ПроверкаИнициализацииКонтейнера(Знач ПриИнициализации = Ложь)
	
	Если ДляВыгрузки И ДляЗагрузки Тогда
		ВызватьИсключение НСтр("ru = 'Некорректная инициализация контейнера.'");
	КонецЕсли;
	
	Если ПриИнициализации Тогда
		
		Если КонтейнерИнициализирован <> Неопределено И КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки уже был инициализирован ранее.'");
		КонецЕсли;
		
	Иначе
		
		Если Не КонтейнерИнициализирован Тогда
			ВызватьИсключение НСтр("ru = 'Контейнер выгрузки не инициализирован.'");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Работа с файлами в составе контейнера

Функция ДобавитьФайл(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	ИмяФайла = ПолучитьИмяФайла(ВидФайла, Расширение, ТипДанных);
	
	Каталог = "";
	
	// для дайджеста нет отдельного вида файла
	Если ВидФайла = "Digest" Тогда
		ВидФайла = "CustomData";
	КонецЕсли;
	
	Если Не ВыгрузкаЗагрузкаДанныхСлужебный.ПравилаФормированияСтруктурыКаталогов().Свойство(ВидФайла, Каталог) Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Вид файла %1 не поддерживается.'"), ВидФайла);
	КонецЕсли;
	
	Если ПустаяСтрока(Каталог) Тогда
		ПолноеИмя = КорневойКаталог + ИмяФайла;
	Иначе
			
		КоличествоФайлов = 0;
		Если Не КоличествоФайловПоВиду.Свойство(ВидФайла, КоличествоФайлов) Тогда
			КоличествоФайлов = 0;
		КонецЕсли;
		КоличествоФайлов = КоличествоФайлов + 1;
		КоличествоФайловПоВиду.Вставить(ВидФайла, КоличествоФайлов);
		
		МаксимальноеКоличествоФайловВКаталоге = 1000;
		
		НомерКаталога = Цел((КоличествоФайлов - 1) / МаксимальноеКоличествоФайловВКаталоге) + 1;
		Каталог = Каталог + ?(НомерКаталога = 1, "", Формат(НомерКаталога, "ЧГ=0"));
		
		Если КоличествоФайлов % МаксимальноеКоличествоФайловВКаталоге = 1 Тогда
			СоздатьКаталог(КорневойКаталог + Каталог);
		КонецЕсли;
		
		ПолноеИмя = КорневойКаталог + Каталог + "\" + ИмяФайла;
		
	КонецЕсли;
	
	Файл = Состав.Добавить();
	Файл.Имя = ИмяФайла;
	Файл.Каталог = Каталог;
	Файл.ПолноеИмя = ПолноеИмя;
	Файл.ТипДанных = ТипДанных;
	Файл.ВидФайла = ВидФайла;
	
	Возврат ПолноеИмя;
	
КонецФункции

Функция ПолучитьИмяФайла(Знач ВидФайла, Знач Расширение = "xml", Знач ТипДанных = Неопределено)
	
	Если ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.DumpInfo();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Digest();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.PackageContents();
	ИначеЕсли ВидФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users() Тогда
		ИмяФайла = ВыгрузкаЗагрузкаДанныхСлужебный.Users();
	Иначе
		ИмяФайла = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;
	
	Если Расширение <> "" Тогда
		
		ИмяФайла = ИмяФайла + "." + Расширение;
		
	КонецЕсли;
	
	Возврат ИмяФайла;
	
КонецФункции

// Работа с описанием содержимого контейнера

Процедура ЗаписатьСодержимоеКонтейнераВФайл(ИмяФайла)
	
	Правила = ПравилаСериализацииСодержимогоКонтейнера();
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Data");
	
	ТипFile = ФабрикаXDTO.Тип("http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1", "File");
	Для Каждого Строка Из Состав Цикл
		
		ДанныеОФайле = ФабрикаXDTO.Создать(ТипFile);
		
		Для Каждого Правило Из Правила Цикл
			
			Если ЗначениеЗаполнено(Строка[Правило.ПолеОбъекта]) Тогда
				ДанныеОФайле[Правило.ПолеОбъектаXDTO] = Строка[Правило.ПолеОбъекта];
			КонецЕсли;
			
		КонецЦикла;
		
		ФабрикаXDTO.ЗаписатьXML(ПотокЗаписи, ДанныеОФайле);
		
	КонецЦикла;
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры

Процедура ПрочитатьЭлементКонтейнера(Знач ОписаниеЭлементаКонтейнера)
	
	Правила = ПравилаСериализацииСодержимогоКонтейнера();
	
	Файл = Состав.Добавить();
	Для Каждого Правило Из Правила Цикл
		Файл[Правило.ПолеОбъекта] = ОписаниеЭлементаКонтейнера[Правило.ПолеОбъектаXDTO]
	КонецЦикла;
	
КонецПроцедуры

Функция ПравилаСериализацииСодержимогоКонтейнера()
	
	Правила = Новый ТаблицаЗначений();
	Правила.Колонки.Добавить("ПолеОбъекта", Новый ОписаниеТипов("Строка"));
	Правила.Колонки.Добавить("ПолеОбъектаXDTO", Новый ОписаниеТипов("Строка"));
	
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "Имя", "Name");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "Каталог", "Directory");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "Размер", "Size");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "ВидФайла", "Type");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "Хеш", "Hash");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "ЧислоОбъектов", "Count");
	ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, "ТипДанных", "DataType");
	
	Возврат Правила;
	
КонецФункции

Процедура ДобавитьПравилоСериализацииСодержимогоКонтейнера(Правила, Знач ПолеОбъекта, Знач ПолеОбъектаXDTO)
	
	Правило = Правила.Добавить();
	Правило.ПолеОбъекта = ПолеОбъекта;
	Правило.ПолеОбъектаXDTO = ПолеОбъектаXDTO;
	
КонецПроцедуры

Функция РассчитатьХеш(Знач ПутьКФайлу)
	
	Попытка
		УстановитьБезопасныйРежим(Истина);
		ФункцияMD5 = Вычислить("ХешФункция.MD5");
		УстановитьБезопасныйРежим(Ложь);
	Исключение
		Возврат "";
	КонецПопытки;
	
	ПараметрыТипа = Новый Массив;
	ПараметрыТипа.Добавить(ФункцияMD5);
	
	ИмяТипа = "ХешированиеДанных";
	ХешированиеДанных = Новый(ИмяТипа, ПараметрыТипа);
	ХешированиеДанных.ДобавитьФайл(ПутьКФайлу);
	Возврат MD5ВСтроку(ХешированиеДанных.ХешСумма);
	
КонецФункции

Функция MD5ВСтроку(Знач ДвоичныеДанные)
	
	Значение = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип("http://www.w3.org/2001/XMLSchema", "hexBinary"), ДвоичныеДанные);
	Возврат Значение.ЛексическоеЗначение;
	
КонецФункции

Процедура ЗаписатьДайджест(ИмяФайла)
	
	ИнформацияОКонфигурации = Новый СистемнаяИнформация();
	
	ЧислоОбъектов = Состав.Итог("ЧислоОбъектов");
	РазмерДанных  = Состав.Итог("Размер");
	
	ПродолжительностьВыгрузки = ТекущаяДатаСеанса() - ВремяНачалаВыгрузки;
	
	ПотокЗаписи = Новый ЗаписьXML();
	ПотокЗаписи.ОткрытьФайл(ИмяФайла);
	ПотокЗаписи.ЗаписатьОбъявлениеXML();
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Digest");
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Platform");
	ПотокЗаписи.ЗаписатьТекст(ИнформацияОКонфигурации.ВерсияПриложения);
	ПотокЗаписи.ЗаписатьКонецЭлемента(); 
	
	Если ТехнологияСервисаИнтеграцияСБСП.РазделениеВключено() Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("Zone");
		ПотокЗаписи.ЗаписатьТекст(XMLСтрока(ТехнологияСервисаИнтеграцияСБСП.ЗначениеРазделителяСеанса()));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли; 
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("ObjectCount");
	ПотокЗаписи.ЗаписатьТекст(Формат(ЧислоОбъектов, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("DataSize");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte");
	ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных, "ЧДЦ=1; ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	ПотокЗаписи.ЗаписатьНачалоЭлемента("Duration");
	ПотокЗаписи.ЗаписатьАтрибут("Measure", "Second");
	ПотокЗаписи.ЗаписатьТекст(Формат(ПродолжительностьВыгрузки, "ЧГ=0"));
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	
	Если ПродолжительностьВыгрузки <>0 Тогда
		ПотокЗаписи.ЗаписатьНачалоЭлемента("SerializationSpeed");
		ПотокЗаписи.ЗаписатьАтрибут("Measure", "Byte/Second");
		ПотокЗаписи.ЗаписатьТекст(Формат(РазмерДанных / ПродолжительностьВыгрузки, "ЧДЦ=1; ЧГ=0"));
		ПотокЗаписи.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	ПотокЗаписи.ЗаписатьКонецЭлемента();
	ПотокЗаписи.Закрыть();
	
КонецПроцедуры


#КонецОбласти


#Область Инициализация

// Инициализация состояния контейнера по умолчанию

ДополнительныеСвойства = Новый Структура();

КоличествоФайловПоВиду = Новый Структура();

ДляВыгрузки = Ложь;
ДляЗагрузки = Ложь;

Состав = Новый ТаблицаЗначений;
Состав.Колонки.Добавить("Имя", Новый ОписаниеТипов("Строка"));
Состав.Колонки.Добавить("Каталог", Новый ОписаниеТипов("Строка"));
Состав.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
Состав.Колонки.Добавить("Размер", Новый ОписаниеТипов("Число"));
Состав.Колонки.Добавить("ВидФайла", Новый ОписаниеТипов("Строка"));
Состав.Колонки.Добавить("Хеш", Новый ОписаниеТипов("Строка"));
Состав.Колонки.Добавить("ЧислоОбъектов", Новый ОписаниеТипов("Число"));
Состав.Колонки.Добавить("ТипДанных", Новый ОписаниеТипов("Строка"));

Состав.Индексы.Добавить("ВидФайла, ТипДанных");
Состав.Индексы.Добавить("ВидФайла");
Состав.Индексы.Добавить("ПолноеИмя");
Состав.Индексы.Добавить("Каталог");

#КонецОбласти

#КонецЕсли