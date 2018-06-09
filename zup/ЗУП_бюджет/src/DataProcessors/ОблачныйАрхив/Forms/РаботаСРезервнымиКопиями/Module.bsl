#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ОблачныйАрхивПовтИсп.РазрешенаРаботаСОблачнымАрхивом() Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	// Сбор информации запускается сразу, а не фоновым заданием.
	ЗагрузитьСтатистику(300);

	// Настройки Авторизации.
	// Не устанавливать привилегированный режим, чтобы читать / сохранять эти настройки мог только полноправный пользователь.
	ПараметрыАвторизацииИПП = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыАвторизацииИПП");
	ЭтотОбъект.Логин  = ПараметрыАвторизацииИПП.Логин;
	Элементы.ДекорацияГиперссылкаКабинетКлиента.Подсказка =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Логин: %1'"),
			?(ПустаяСтрока(ЭтотОбъект.Логин), НСтр("ru='не введен, будет запрошен в браузере.'"), ЭтотОбъект.Логин));

	// Настройки ПараметрыОкруженияСервер.
	ПараметрыОкруженияСервер = ОблачныйАрхив.ПолучитьНастройкиОблачногоАрхива("ПараметрыОкруженияСервер");

	// Установить значение идентификатора ИБ в отбор.
	// В ОблачномАрхиве хранятся архивы с идентификатором ИБ плюс суффикс.
	ЭтотОбъект.ИдентификаторИБ = ПараметрыОкруженияСервер.ИдентификаторИБ;
	ЭтотОбъект.ФильтрПоЭтойИБ = Истина;
	УстановитьФильтрПоЭтойИБНаСервере(); // Оттуда же вызовется "УправлениеФормой".
	Элементы.ФильтрПоЭтойИБ.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Идентификатор ИБ: %1'"),
		ЭтотОбъект.ИдентификаторИБ);

	ОбновитьИнформационныеСтроки();

	// УправлениеФормой(Форма) вызвалась ранее из УстановитьФильтрПоЭтойИБНаСервере().

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ПустаяСтрока(ЭтотОбъект.Логин) Тогда
		Отказ = Истина;
		// Чтобы появилось окно ввода логина / пароля ВебИТС.
		ОблачныйАрхивКлиент.ПодключитьСервисОблачныйАрхив();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияГиперссылкаНажатие(Элемент)

	СтандартнаяОбработка = Ложь;
	Если Элемент.Имя = "ДекорацияГиперссылкаКабинетКлиента" Тогда
		НавигационнаяСсылкаФорматированнойСтроки = "backup1C:OpenWebPersonalAccount_Backups";
	ИначеЕсли Элемент.Имя = "ДекорацияГиперссылкаОСервисе" Тогда
		НавигационнаяСсылкаФорматированнойСтроки = "backup1C:OpenWebAboutCloudArchive";
	Иначе
		Возврат;
	КонецЕсли;

	ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)

	ОблачныйАрхивКлиент.ОбработкаНавигационнойСсылки(
		ЭтотОбъект,
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка,
		Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура ФильтрПоЭтойИБПриИзменении(Элемент)

	УстановитьФильтрПоЭтойИБНаСервере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаУдалитьФайл(Команда)

	ТекущиеДанные = Элементы.ФайлыРезервныхКопий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		СписокКнопок = Новый СписокЗначений;
		СписокКнопок.Добавить(НСтр("ru='Удалить'")); // Идентификатор
		СписокКнопок.Добавить(НСтр("ru='Отмена'")); // Идентификатор
		ОписаниеОповещенияПослеВопроса = Новый ОписаниеОповещения(
			"УдалитьФайл_НаКлиенте",
			ЭтотОбъект,
			Новый Структура("ИдентификаторФайла",
				ТекущиеДанные.ИдентификаторФайла));
		ПоказатьВопрос(
			ОписаниеОповещенияПослеВопроса,
			НСтр("ru='Удалить файл с сервера?'"),
			СписокКнопок,
			0,
			НСтр("ru='Отмена'"), // Идентификатор
			НСтр("ru='Запрос на удаление файла с сервера'"));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВосстановитьИзФайла(Команда)

	ТекущиеДанные = Элементы.ФайлыРезервныхКопий.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("authKey", ""); // Получать authKey каждый раз заново.
		ПараметрыОткрытия.Вставить("DBName", ТекущиеДанные.ИмяИБ);
		ПараметрыОткрытия.Вставить("filesize", ТекущиеДанные.РазмерФайлаБайт);
		ПараметрыОткрытия.Вставить("UIDFile", ТекущиеДанные.ИдентификаторФайла);
		ПараметрыОткрытия.Вставить("UIDName", ТекущиеДанные.ИдентификаторИБ);
		ПараметрыОткрытия.Вставить("Логин", ЭтотОбъект.Логин);
		ПараметрыОткрытия.Вставить("ЛогинДоступаКБэкап1СПриватный", ""); // Получать ЛогинДоступаКБэкап1СПриватный каждый раз заново.
		ПараметрыОткрытия.Вставить("ПарольДоступаКБэкап1СПриватный", ""); // Получать ПарольДоступаКБэкап1СПриватный каждый раз заново.

		ОткрытьФорму(
			"Обработка.ОблачныйАрхив.Форма.МастерВосстановленияИзРезервнойКопии", // ИмяФормы.
			ПараметрыОткрытия,
			ЭтотОбъект, // Владелец.
			"", // Уникальность.
			, // Окно.
			, // НавигационнаяСсылка.
			, // ОписаниеОповещенияОЗакрытии.
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); // РежимОткрытияОкна.
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УдалитьФайл_НаКлиенте(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Если РезультатВопроса = НСтр("ru='Удалить'") Тогда // Идентификатор
		УдалитьФайл_НаСервере(ДополнительныеПараметры.ИдентификаторФайла);
		Элементы.ФайлыРезервныхКопий.Обновить();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УдалитьФайл_НаСервере(ИдентификаторФайла)

	// Удаление файла с сервера.
	КонтекстВыполнения = ИнтернетПоддержкаПользователейКлиентСервер.НоваяЗаписьРезультатовВыполненияОпераций();
	КонтекстВыполнения.Вставить("ИдентификаторФайла", ИдентификаторФайла);
	ОблачныйАрхив.УдалитьРезервнуюКопию(КонтекстВыполнения);

	// Обновление статистики (списка резервных копий).
	ЗагрузитьСтатистику(0); // После удаления файла обновлять статистику принудительно.

КонецПроцедуры

&НаСервере
Процедура УстановитьФильтрПоЭтойИБНаСервере()

	ВсеНастройкиКомпоновщикаДанных = ЭтотОбъект.ФайлыРезервныхКопий.КомпоновщикНастроек.ПолучитьНастройки();

		ВсеОтборы = ВсеНастройкиКомпоновщикаДанных.Отбор.Элементы;
		Для Каждого ТекущийОтбор Из ВсеОтборы Цикл
			Если ТекущийОтбор.Представление = "ОтборПоИдентификаторуИБ" Тогда // Идентификатор
				ТекущийОтбор.ПравоеЗначение = ЭтотОбъект.ИдентификаторИБ;
				ТекущийОтбор.Использование  = ЭтотОбъект.ФильтрПоЭтойИБ;
			КонецЕсли;
		КонецЦикла;

	ЭтотОбъект.ФайлыРезервныхКопий.КомпоновщикНастроек.ЗагрузитьНастройки(ВсеНастройкиКомпоновщикаДанных);

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

// Управляет видимостью и доступностью элементов управления.
//
// Параметры:
//  Форма  - Управляемая форма - форма, в которой необходимо установить видимость / доступность.
//
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Элементы = Форма.Элементы;
	Если Форма.ФильтрПоЭтойИБ = Истина Тогда
		Элементы.ФайлыРезервныхКопийИдентификаторИБ.Видимость = Ложь;
	Иначе
		Элементы.ФайлыРезервныхКопийИдентификаторИБ.Видимость = Истина;
	КонецЕсли;

КонецПроцедуры

// Загружает из веб-сервисов статистику и список резервных копий и собирает информацию о клиентском компьютере.
//
// Параметры:
//  СрокЖизниСтатистики - Число - количество секунд, сколько собранная статистика считается актуальной,
//                        если 0 - обновить принудительно.
//
&НаСервере
Процедура ЗагрузитьСтатистику(СрокЖизниСтатистики = 300)

	МассивШагов = Новый Массив;

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "СвойстваХранилищаОблачногоАрхива"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации об использовании облачного хранилища'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "СписокРезервныхКопий"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Получение списка резервных копий'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

		ШагСбораДанных = ОблачныйАрхивКлиентСервер.ПолучитьОписаниеШагаСбораДанных();
			ШагСбораДанных.КодШага               = "ИнформацияОКлиенте"; // Идентификатор
			ШагСбораДанных.ОписаниеШага          = НСтр("ru='Сбор информации о клиентском компьютере'");
			ШагСбораДанных.СрокУстареванияСекунд = СрокЖизниСтатистики; // Обновлять только если данные были собраны > 5 минут назад.
		МассивШагов.Добавить(ШагСбораДанных);

	ОблачныйАрхив.СобратьДанныеПоОблачномуАрхиву(Новый Структура("МассивШагов", МассивШагов), "");

КонецПроцедуры

// Заполняет все информационные строки.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ОбновитьИнформационныеСтроки()

	БайтКуплено     = 0;
	БайтДоступно    = 0;
	ПроцентДоступно = "0%";

	Запись = РегистрыСведений.СвойстваХранилищаОблачногоАрхива.СоздатьМенеджерЗаписи();
	Запись.Свойство = "Объем байт, куплено"; // Идентификатор
	Запись.Прочитать(); // Только чтение, без последующей записи.
	Если Запись.Выбран() Тогда
		БайтКуплено = Запись.Значение;
	КонецЕсли;

	Запись = РегистрыСведений.СвойстваХранилищаОблачногоАрхива.СоздатьМенеджерЗаписи();
	Запись.Свойство = "Объем байт, доступно"; // Идентификатор
	Запись.Прочитать(); // Только чтение, без последующей записи.
	Если Запись.Выбран() Тогда
		БайтДоступно = Запись.Значение;
	КонецЕсли;

	Если БайтКуплено > 0 Тогда
		ПроцентДоступно = "" + Окр(БайтДоступно / БайтКуплено * 100, 0, РежимОкругления.Окр15как20) + "%";
	КонецЕсли;

	Элементы.ДекорацияСтатистика.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Всего доступно %1 из %2 Мбайт (%3)'"),
		Формат(БайтДоступно, "ЧЦ=20; ЧДЦ=; ЧС=6; ЧН=0; ЧГ=3,0"),
		Формат(БайтКуплено, "ЧЦ=20; ЧДЦ=; ЧС=6; ЧН=0; ЧГ=3,0"),
		ПроцентДоступно);

КонецПроцедуры

#КонецОбласти
