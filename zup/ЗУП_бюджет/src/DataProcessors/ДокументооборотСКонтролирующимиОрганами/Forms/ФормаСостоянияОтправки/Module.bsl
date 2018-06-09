&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Параметры.Ссылка;
	
	ОтметитьПрочтенным(Ссылка);
	ОпределитьСвойстваОтправки();
	ЗаполнитьДанныеВШапкеФормы();
	УстановитьШиринуТаблицыДляФТС();
	УправлениеЭУ(Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПротоколНажатие(Элемент)
	
	НомерЭтапа = Число(Прав(Элемент.Имя, 1)) - 1;
	Протокол = ЭтапыСостояния[НомерЭтапа].Протокол;
	
	КонтекстЭДОКлиент.ОткрытьПротокол(Ссылка, ВидКонтролирующегоОргана, Протокол);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодробнаяИнформацияНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Отправка) Тогда
		ПоказатьЗначение(, Отправка);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Подробная информация отсутствует'"));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура НадписьОтветПоказатьНажатие(Элемент)
	
	КонтекстЭДОКлиент.НажатиеНаКнопкуПоказатьОтветыПоТребованию(Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыгрузитьПакетДокументовДляПредставления(Команда)
	
	Если ЗначениеЗаполнено(Отправка) Тогда
		
		ТекстВопроса = НСтр("ru = 'Выгрузить пакет документов для представления по месту требования?'");
		
		Оповещение = Новый ОписаниеОповещения("ВыгрузитьПакетыПоДокументооборотамСдачиОтчетностиВФНС",ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтправитьЗавершение", ЭтотОбъект);
	КонтекстЭДОКлиент.ОтправитьНеотправленныеИзвещенияОПриеме(Ссылка, Организация, ВидКонтролирующегоОргана, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		
		ОписаниеОповещения 	= Новый ОписаниеОповещения("ОбновитьЗавершение", ЭтотОбъект);
		
		КонтекстЭДОКлиент.ОбновитьСтатусЗаявленияАбонента_ИзПанелиОтправки(
			ОписаниеОповещения,
			ЭтаФорма,
			Ссылка);
			
	Иначе
		
		Если НЕ ДокументооборотСКОКлиент.ОрганизацияПодключенаКНаправлению(Организация, КонтролирующийОрган) Тогда
			Возврат;
		КонецЕсли;
		
		ВыбранныеОрганизации = Новый Массив;
		ВыбранныеОрганизации.Добавить(Организация);
		
		ВыводитьПроценты = КонтролирующийОрган <> "ФСС" 
			И КонтролирующийОрган <> "ФСРАР"
			И КонтролирующийОрган <> "РПН"
			И КонтролирующийОрган <> "ФТС"
			И КонтролирующийОрган <> "БанкРоссии";
			
		ПараметрыДлительногоОбмена = ДлительнаяОтправкаКлиент.ПараметрыДлительногоОбмена();
		ПараметрыДлительногоОбмена.Организации 				= ВыбранныеОрганизации;
		ПараметрыДлительногоОбмена.ВыводитьПроценты 		= ВыводитьПроценты;
		ПараметрыДлительногоОбмена.ЭтоОбменИзЭтаповОтправки = Истина;
		ПараметрыДлительногоОбмена.ОтчетСсылка 				= Ссылка;
		
		Если НЕ ДлительнаяОтправкаКлиент.ПоказатьФормуДлительногоОбмена(ПараметрыДлительногоОбмена) Тогда // Обновить из формы этапов отправки.
			Возврат;
		КонецЕсли;
		
		ПодключитьОбработчикОжидания("Подключаемый_ОсуществитьОбменПоОрганизацииИзЭтаповОтправки", 0.1, Истина);
		
	КонецЕСли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВсеФайлыИПодписи(Команда)
	
	Если ЗначениеЗаполнено(Отправка) Тогда
		ВыгрузитьЦиклыОбмена();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьОтправленныйПакетДокументов(Команда)
	
	Если ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС")
		И ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСРАР")
		И ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.РПН")
		И ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС")
		ИЛИ НЕ ЗначениеЗаполнено(ВидКонтролирующегоОргана) Тогда
		Возврат;
	КонецЕсли;
	
	ВАрхиве = Ложь;
	ИмяФайлаПакета = "";
	Адрес = ПолучитьАдресФайлаПакета(Отправка, ИмяФайлаПакета, ВАрхиве);
	Если ВАрхиве Тогда 
		ПоказатьПредупреждение(, "Файл перемещен в архив. Продолжение выгрузки невозможно!");
		Возврат;
	КонецЕсли;
	ПолучитьФайл(Адрес, ИмяФайлаПакета);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьПолученнуюКвитанцию(Команда)
	
	Если ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФСС")
		И ВидКонтролирующегоОргана <> ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФТС")
		ИЛИ НЕ ЗначениеЗаполнено(ВидКонтролирующегоОргана) Тогда
		Возврат;
	КонецЕсли;
	
	ВАрхиве = Ложь;
	ИмяФайлаКвитанции = "";
	Адрес = ПолучитьАдресФайлаКвитанции(Отправка, ИмяФайлаКвитанции, ВАрхиве);
	Если ВАрхиве Тогда 
		ПоказатьПредупреждение(, "Файл перемещен в архив. Продолжение выгрузки невозможно!");
		Возврат;
	КонецЕсли;
	ПолучитьФайл(Адрес, ИмяФайлаКвитанции);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПодтвердитьПрием(Команда)    
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
		
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Ссылка, Истина, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтказатьВПриеме(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПослеПодтвержденияПриемаИлиОтказаВПриеме", 
		ЭтотОбъект);
	
	КонтекстЭДОКлиент.СоздатьРезультатПриемаВходящейОписиИнтерактивноПоДокументуОписи(Ссылка, Ложь, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ОсуществитьОбменПоОрганизацииИзЭтаповОтправки() Экспорт
	
	ОписаниеОповещения 	= Новый ОписаниеОповещения("ОбновитьЗавершение", ЭтотОбъект);
	
	КонтекстЭДОКлиент.ОсуществитьОбменПоОрганизации(
		ЭтаФорма,
		Организация,
		ОписаниеОповещения,
		КонтролирующийОрган,
		Ссылка);
		
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеЭУ();
	
	// Перерисовываем другие формы при необходимости
	ОповеститьОбОкончанииОтправки();
	
	ДлительнаяОтправкаКлиент.ОповеститьОЗавершенииОбмена(); // Из формы этапов отправки.
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтметитьПрочтенным(Ссылка)

	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Ссылка);

КонецПроцедуры 

&НаСервере
Процедура УстановитьШиринуТаблицыДляФТС()

	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		Элементы.СведенияПоРезультатуЭтапа1.Ширина = 50;
		Элементы.СведенияПоРезультатуЭтапа2.Ширина = 50;
		Элементы.СведенияПоРезультатуЭтапа3.Ширина = 50;
		Элементы.СведенияПоРезультатуЭтапа4.Ширина = 50;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОпределитьСвойстваОтправки()

	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	Если Параметры.Свойство("Отправка") Тогда
		// Все нужные свойства переданы в параметрах.
		СведенияПоОбъекту	= Параметры;
	Иначе
		// Определеяем текущие данные.
		СведенияПоОбъекту 	= КонтекстЭДОСервер.СведенияПоОтправляемымОбъектам(Ссылка);
	КонецЕсли;
	
	Наименование				= СведенияПоОбъекту.Наименование;
	Организация					= СведенияПоОбъекту.Организация;
	ВидКонтролирующегоОргана	= КонтекстЭДОСервер.ТипКонтролирующегоОргана(СведенияПоОбъекту.ВидКонтролирующегоОргана);
	КодКонтролирующегоОргана	= СведенияПоОбъекту.КодКонтролирующегоОргана;
	ПредставлениеГосОргана		= СведенияПоОбъекту.ПредставлениеКонтролирующегоОргана;
	ПредставлениеПериода		= СведенияПоОбъекту.ПредставлениеПериода;
	СтраницаЖурнала				= СведенияПоОбъекту.СтраницаЖурнала;
	
	// Строкой, а не перечислением
	КонтролирующийОрган 		= ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ИмяПеречисления(ВидКонтролирующегоОргана);
	
	Если Параметры.Свойство("Отправка") Тогда
		// Все нужные свойства переданы в параметрах.
		Отправка = Параметры.Отправка;
	Иначе
		// Определеяем последнюю отправку.
		Отправка = КонтекстЭДОСервер.ПолучитьПоследнююОтправкуОтчета(ВидКонтролирующегоОргана, Ссылка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Отправка) И ЗначениеЗаполнено(Отправка.Организация) Тогда
		Организация = Отправка.Организация;
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ПослеПодтвержденияПриемаИлиОтказаВПриеме(Результат, ВходящийКонтекст) Экспорт
	
	УправлениеЭУ();
	
	// Перерисовываем другие формы при необходимости
	ОповеститьОбОкончанииОтправки();
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьВидимостьКнопкиОбновить(КонтекстЭДОСервер, ТекущееСостояниеОтправки)

	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЗаявлениеАбонентаСпецоператораСвязи") Тогда
		Элементы.ФормаОбновить.Видимость = КонтекстЭДОСервер.КнопкаОбновленияВЗаявленииНаПодключениеДоступна(Ссылка);
		Элементы.ПодробнаяИнформация.Видимость = Ложь;
	Иначе
		ТекущийЭтап = ТекущееСостояниеОтправки.ТекущийЭтапОтправки;
		Если ТекущийЭтап <> Неопределено Тогда
			КонтролирующийОрган = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ИмяПеречисления(ТекущееСостояниеОтправки.КонтролирующийОрган);
			СостояниеСдачи = ТекущийЭтап.СостояниеСдачиОтчетности;
			Элементы.ФормаОбновить.Видимость = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ВидимостьКнопкиОтправкаПоСостоянию(СостояниеСдачи, КонтролирующийОрган);
		КонецЕсли;
		Элементы.ПодробнаяИнформация.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВсеОтправкиНажатие(Элемент)
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("Ссылка", 			Ссылка);
	ДополнительныеПараметры.Вставить("Наименование", 	Наименование);
	ДополнительныеПараметры.Вставить("Организация", 	Организация);
	ДополнительныеПараметры.Вставить("ЗаголовокФормы", 	ЗаголовокФормы);
	ДополнительныеПараметры.Вставить("СтраницаЖурнала", СтраницаЖурнала);
	 
	ОткрытьФорму(КонтекстЭДОКлиент.ПутьКОбъекту + ".Форма.ВсеОтправки",
		ДополнительныеПараметры,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	УправлениеЭУ();
	
	// Перерисовываем другие формы при необходимости
	ОповеститьОбОкончанииОтправки();
	
КонецПроцедуры

&НаСервере
Функция ЭлементНаименованиеЭтапа(НомерСтроки)
	Возврат Элементы["НаименованиеЭтапа" + Строка(НомерСтроки)];
КонецФункции

&НаСервере
Функция ЭлементДатаСовершенияЭтапа(НомерСтроки)
	Возврат Элементы["ДатаСовершенияЭтапа" + Строка(НомерСтроки)];
КонецФункции

&НаСервере
Функция ЭлементКомментарийЭтапа(НомерСтроки)
	Возврат Элементы["КомментарийЭтапа" + Строка(НомерСтроки)];
КонецФункции

&НаСервере
Функция ЭлементПротоколЭтапа(НомерСтроки)
	Возврат Элементы["ПротоколЭтапа" + Строка(НомерСтроки)];
КонецФункции

&НаКлиенте
Процедура ВыгрузитьПакетыПоДокументооборотамСдачиОтчетностиВФНС(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.ВыгрузитьПакетыПоДокументооборотамСдачиОтчетностиВФНС(Отправка)
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьЦиклыОбмена()
	
	ТекстВопроса = НСтр("ru = 'Выгрузить все файлы и подписи?'");
	Оповещение = Новый ОписаниеОповещения("ПродолжитьВыгрузкуЦикловОбмена", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыгрузкуЦикловОбмена(Ответ, Параметры) Экспорт
	
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЭДОКлиент.ВыгрузитьЦиклыОбмена(Отправка, Истина, Истина);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеЭУ(Отказ = Ложь)
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
	ТекущееСостояниеОтправки =  ОпределитьТекущееСостояние(КонтекстЭДОСервер);
	
	Если ТекущееСостояниеОтправки = Неопределено Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	УстановитьВидимостьКнопкиОбновить(КонтекстЭДОСервер, ТекущееСостояниеОтправки);
	ОтпределитьСоставМенюВыгрузка();
	ПрорисоватьКритическиеОшибки(ТекущееСостояниеОтправки);
	ПрорисоватьНеотправленныеИзвещения(ТекущееСостояниеОтправки);
	ПрорисоватьТаблицу(ТекущееСостояниеОтправки);
	ПрорисоватьИсториюОтправок();
	
КонецПроцедуры

&НаСервере
Функция ОпределитьТекущееСостояние(КонтекстЭДОСервер)

	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ВозвращатьТаблицуЭтаповОтправки", Истина);
	ДополнительныеПараметры.Вставить("ПолучатьОшибкиОтправки", 			Истина);
	ДополнительныеПараметры.Вставить("ПолучатьДаты", 					Истина);
	ДополнительныеПараметры.Вставить("Отправка", 						Отправка);
	ДополнительныеПараметры.Вставить("ПоказыватьПомеченныеНаУдаление", 	Истина);
	
	ТекущееСостояниеОтправки = КонтекстЭДОСервер.ТекущееСостояниеОтправки(Ссылка, ВидКонтролирующегоОргана, ДополнительныеПараметры);
	
	ТекущееСостояние = ТекущееСостояниеОтправки.ТекущийЭтапОтправки.ТекстСтатуса;
	
	Возврат ТекущееСостояниеОтправки;

КонецФункции 

&НаСервере
Процедура ПрорисоватьНеотправленныеИзвещения(ТекущееСостояниеОтправки)

	Элементы.БлокНеотправленныхСообщений.Видимость = ТекущееСостояниеОтправки.НеотправленныеИзвещения.ЕстьНеотправленныеИзвещения;

КонецПроцедуры

&НаСервере
Процедура ПрорисоватьКритическиеОшибки(ТекущееСостояниеОтправки)

	// Критические сообщения
	ЕстьКритическиеОшибки = ТекущееСостояниеОтправки.ЕстьКритическиеОшибки;
	Элементы.БлокКритическихОшибок.Видимость 	= ЕстьКритическиеОшибки;
	Элементы.ЗначокКритическойОшибки.Видимость 	= ЕстьКритическиеОшибки;

КонецПроцедуры 

&НаСервере
Процедура ПрорисоватьТаблицу(ТекущееСостояниеОтправки)

	// Таблица состояний
	ТаблицаЭтаповОтправки = ТекущееСостояниеОтправки.ТаблицаЭтаповОтправки;
	
	УдалитьСтрокиТаблицыСостоянияСоСтатусомНеОтправлено(ТаблицаЭтаповОтправки);
	ЗначениеВРеквизитФормы(ТаблицаЭтаповОтправки, "ЭтапыСостояния");
	
	ТаблицаСостояний = РеквизитФормыВЗначение("ЭтапыСостояния");
	
	ЭтоДокументыРеализации = ТипЗнч(Ссылка) = Тип("СправочникСсылка.ДокументыРеализацииПолномочийНалоговыхОрганов");
	Элементы.БлокЭтаповДокументовРеализацииПолномочий.Видимость = ЭтоДокументыРеализации;
		
	Если ЭтоДокументыРеализации Тогда
		// У требований свои этапы с кнопками
		СкрытьВсеСостоянияНаФормеКромеПервого();
		ПрорисоватьБлокЭтаповДокументовРеализацииПолномочий(ТекущееСостояниеОтправки);
	Иначе
		СкрытьЛишниеИлиПоказатьНовыеСостоянияНаФорме(ТаблицаСостояний);
	КонецЕсли;
	ПрорисоватьТаблицуСостояний(ТаблицаСостояний);
	
	Если ЭтоДокументыРеализации
		И ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.ЭтоТребованиеФНС(Ссылка) Тогда
		
		Элементы.ЗаголовокНеотправленныхСообщений.Заголовок = 
			НСтр("ru = 'Оператору не отправлено извещение о получении документа'");
		
	КонецЕсли;

КонецПроцедуры 

&НаСервере
Процедура ПрорисоватьИсториюОтправок()

	ВсеОтправки = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ВсеОтправки(Ссылка);
	Элементы.ВсеОтправки.Видимость = ВсеОтправки.Количество() > 1;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеВШапкеФормы()

	Период = ПредставлениеПериода;
	Если СтрНайти(Период, "0001") > 0 Тогда
		Период = "";
	КонецЕсли;
	Период = ?(ЗначениеЗаполнено(Период)," (" + Период + ")", "");
	
	ЗаголовокФормы = Наименование + Период;
	
	Элементы.Наименование.Заголовок	= ЗаголовокФормы;
	
	Получатель 	= ПредставлениеГосОргана;
	Отправитель = Организация;
	
	// Если это входящая переписка заполняем получателя и отправителя наоборот
	Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ПерепискаСКонтролирующимиОрганами") Тогда
		Если Ссылка.Статус = Перечисления.СтатусыПисем.Полученное Тогда
			Получатель 	= Организация;
			Отправитель = ПредставлениеГосОргана;
		КонецЕсли;
	КонецЕсли;
	
	// Отправитель
	Если ЗначениеЗаполнено(Отправитель) Тогда
		Элементы.ОтКого.Заголовок = Отправитель;
	Иначе
		Элементы.ЗаголовокОтКого.Видимость 	= Ложь;
		Элементы.ОтКого.Видимость 			= Ложь;
	КонецЕсли;
	
	// Получатель
	Если ЗначениеЗаполнено(Получатель) Тогда
		Элементы.Кому.Заголовок	= Получатель;
	Иначе
		Элементы.ЗаголовокКому.Видимость 	= Ложь;
		Элементы.Кому.Видимость 			= Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиТаблицыСостоянияСоСтатусомНеОтправлено(ТаблицаСостояний)
	
	// Удаление строки со статусом "Не отправлено" (либо другим
	// значением, установленным вручную до начала процесса отправки).
	
	СтатусыОбъектов
	= РегламентированнаяОтчетностьКлиентСервер.СтатусыОбъектовРеглОтчетностиПриРучномВводе(Ссылка);
	
	Для каждого СтрокаТаблицыСостояний Из ТаблицаСостояний Цикл
		
		ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1'"), СтрокаТаблицыСостояний.ТекстНадписи);
		
		Если СтатусыОбъектов.Найти(ТекстНадписи) <> Неопределено Тогда
			ТаблицаСостояний.Удалить(СтрокаТаблицыСостояний);
			Прервать;
		КонецЕсли;
		
		Если ТекстНадписи = НСтр("ru = 'Не отправлено'") Тогда
			ТаблицаСостояний.Удалить(СтрокаТаблицыСостояний);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СкрытьЛишниеИлиПоказатьНовыеСостоянияНаФорме(ТаблицаСостояний)
	
	// Скрываем лишние блоки
	ЭлементыТаблицыЭтапов = Элементы.ОбщийБлокЭтапов.ПодчиненныеЭлементы;
	Для каждого ЭлементФормы Из ЭлементыТаблицыЭтапов Цикл
		ИмяЭлемента = ЭлементФормы.Имя;
		Если СтрНайти(ИмяЭлемента, "БлокЭтапаОтправки") > 0 Тогда
			НомерБлока = Число(СтрЗаменить(ИмяЭлемента, "БлокЭтапаОтправки",""));
			ВидимостьБлока = (НомерБлока <= ТаблицаСостояний.Количество());
			Если ВидимостьБлока <> ЭлементФормы.Видимость Тогда
				ЭлементФормы.Видимость = ВидимостьБлока;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура СкрытьВсеСостоянияНаФормеКромеПервого()
	
	// Скрываем лишние блоки
	ЭлементыТаблицыЭтапов = Элементы.ОбщийБлокЭтапов.ПодчиненныеЭлементы;
	Для каждого ЭлементФормы Из ЭлементыТаблицыЭтапов Цикл
		ИмяЭлемента = ЭлементФормы.Имя;
		Если СтрНайти(ИмяЭлемента, "БлокЭтапаОтправки") > 0 Тогда
			НомерБлока = Число(СтрЗаменить(ИмяЭлемента, "БлокЭтапаОтправки",""));
			Если НомерБлока > 1 Тогда
				ЭлементФормы.Видимость = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция НомерТекущегоСостоянияВТаблицеСостояний(ТаблицаСостояний)
	
	НомерТекущегоЭтапа = 0;
	Для каждого СтрокаТаблицыСостояний Из ТаблицаСостояний Цикл
		
		НомерСтроки = ТаблицаСостояний.Индекс(СтрокаТаблицыСостояний) + 1;
		Если СтрокаТаблицыСостояний.ЭтапПройден Тогда
			 НомерТекущегоЭтапа = НомерСтроки;
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат НомерТекущегоЭтапа;

КонецФункции

&НаСервере
Процедура ПрорисоватьТаблицуСостояний(ТаблицаСостояний)
	
	// Определяем номер текущего этапа
	НомерТекущегоЭтапа = НомерТекущегоСостоянияВТаблицеСостояний(ТаблицаСостояний);
	
	// Заполняем данные в состояниях
	Для каждого СтрокаТаблицыСостояний Из ТаблицаСостояний Цикл
		
		НомерСтроки = ТаблицаСостояний.Индекс(СтрокаТаблицыСостояний) + 1;
		
		// Определяем текст надписей
		
		// Наименование
		ЭлементНаименованиеЭтапа(НомерСтроки).Заголовок = СтрокаТаблицыСостояний.ТекстНадписи;
		
		// Дата
		Если ЗначениеЗаполнено(СтрокаТаблицыСостояний.Дата) Тогда
			
			// Подбираем нужный формат
			Если ТипЗнч(СтрокаТаблицыСостояний.Дата) = Тип("Дата")
				И СтрокаТаблицыСостояний.Дата = НачалоДня(СтрокаТаблицыСостояний.Дата) Тогда
				ДатаНаступленияЭтапа = Формат(СтрокаТаблицыСостояний.Дата,"ДЛФ=D");
			Иначе
				ДатаНаступленияЭтапа = Строка(СтрокаТаблицыСостояний.Дата);
			КонецЕсли;
				
			ЭлементДатаСовершенияЭтапа(НомерСтроки).Заголовок = ДатаНаступленияЭтапа;
			
		Иначе
			ЭлементДатаСовершенияЭтапа(НомерСтроки).Заголовок = "";
		КонецЕсли;
		
		// Комментарий выводим только для текущего состояния
		Если ЗначениеЗаполнено(СтрокаТаблицыСостояний.КомментарийКСостоянию) И НомерСтроки = НомерТекущегоЭтапа Тогда
			ЭлементКомментарийЭтапа(НомерСтроки).Заголовок = СтрокаТаблицыСостояний.КомментарийКСостоянию;
			ЭлементКомментарийЭтапа(НомерСтроки).Видимость = Истина;
		Иначе
			ЭлементКомментарийЭтапа(НомерСтроки).Видимость = Ложь;
		КонецЕсли;
		
		// Протокол выводим все время
		Если ЗначениеЗаполнено(СтрокаТаблицыСостояний.НаименованиеПротокола) Тогда 
			 ЭлементПротоколЭтапа(НомерСтроки).Заголовок = СтрокаТаблицыСостояний.НаименованиеПротокола;
			 ЭлементПротоколЭтапа(НомерСтроки).Видимость = Истина;
		 Иначе
			// Если протокол отсуствует, то комментарий должен подняться на место протокола
			Если ЗначениеЗаполнено(СтрокаТаблицыСостояний.КомментарийКСостоянию) И НомерСтроки = НомерТекущегоЭтапа Тогда // обход ошибки платформы
				ЭлементПротоколЭтапа(НомерСтроки).Видимость = Ложь;
			Иначе
				ЭлементПротоколЭтапа(НомерСтроки).Заголовок = "";
				ЭлементПротоколЭтапа(НомерСтроки).Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
		
		// Определяем фон и доступность
		СостояниеСдачиОтчетности 	= СтрокаТаблицыСостояний.СостояниеСдачиОтчетности;
		ЭтапПройден 				= СтрокаТаблицыСостояний.ЭтапПройден;
		ЭлементыБлокЭтапа 			= Элементы["БлокЭтапа" + Строка(НомерСтроки)];
		ЭлементыПротоколЭтапа		= Элементы["ПротоколЭтапа" + Строка(НомерСтроки)];
		ЭлементыНаименованиеЭтапа	= Элементы["НаименованиеЭтапа" + Строка(НомерСтроки)];
		
		Если ЭтапПройден И НомерСтроки = НомерТекущегоЭтапа Тогда
			
			// Определяем цвет фона
			ЦветФона = ЦветаСтиля.ЦветФонаНеначавшейсяОтправки;
			
			Если СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ДокументооборотНачат Тогда
				ЦветФона = ЦветаСтиля.ЦветФонаТекущейОтправки;
			ИначеЕсли СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ОтрицательныйРезультатДокументооборота Тогда
				ЦветФона = ЦветаСтиля.ЦветФонаОшибкиОтправки;
			ИначеЕсли СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ПоложительныйРезультатДокументооборота Тогда
				ЦветФона = ЦветаСтиля.ЦветФонаУдачнойОтправки;
			Иначе
				ЦветФона = ЦветаСтиля.ЦветФонаНеначавшейсяОтправки;
			КонецЕсли;
			
			ЭлементыБлокЭтапа.ЦветФона = ЦветФона; 
			ЭлементыБлокЭтапа.Доступность = Истина;
			
			ЭлементыПротоколЭтапа.ЦветТекста = ЦветаСтиля.ЦветГиперссылкиБРО;
			ЭлементыНаименованиеЭтапа.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
			
		ИначеЕсли НЕ ЭтапПройден Тогда
			
			// Делаем непройденные этапы недоступными
			ЭлементыБлокЭтапа.ЦветФона 		= ЦветаСтиля.БазовыйЦветФонаЭтапаОтправки;
			ЭлементыБлокЭтапа.Доступность 	= Ложь;
			// Гиперссылки протоколов делаем серыми
			ЭлементыПротоколЭтапа.ЦветТекста = ЦветаСтиля.ЦветШрифтаНенаступившегоЭтапа;
			// Наименование этапа делаем серым
			ЭлементыНаименованиеЭтапа.ЦветТекста = ЦветаСтиля.ЦветШрифтаНенаступившегоЭтапа;
			
		ИначеЕсли ЭтапПройден Тогда
			
			// Делаем непройденные этапы недоступными
			ЭлементыБлокЭтапа.ЦветФона 		= ЦветаСтиля.БазовыйЦветФонаЭтапаОтправки;
			ЭлементыБлокЭтапа.Доступность 	= Истина;
			// Гиперссылки протоколов делаем серыми
			ЭлементыПротоколЭтапа.ЦветТекста = ЦветаСтиля.ЦветГиперссылкиБРО;
			// Наименование этапа делаем серым
			ЭлементыНаименованиеЭтапа.ЦветТекста = ЦветаСтиля.ЦветТекстаФормы;
			
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ПрорисоватьБлокЭтаповДокументовРеализацииПолномочий(ТекущееСостояниеОтправки)
	
	НадписьОтветПоказатьЗаголовок 	= "";
	НадписьПанелиПриемаЗаголовок 	= "";
	ГруппаКнопкиПриемаВидимость 	= Ложь;
	ГруппаПанельОтправкиЦветФона	= ЦветаСтиля.ЦветФонаПодтвержденногоПолучения;	//серый
	
	Если ТекущееСостояниеОтправки <> Неопределено Тогда
		ТекущийЭтапОтправки = ТекущееСостояниеОтправки.ТекущийЭтапОтправки;
		Если ТекущийЭтапОтправки <> Неопределено Тогда
			
			ТекстДатаПриемаОписиНами 		= Формат(ТекущийЭтапОтправки.Дата, "ДЛФ=DT; ДП=' '");
			НадписьСтатусаЗаголовок 		= ТекущийЭтапОтправки.ТекстНадписи;
			НадписьОтветПоказатьЗаголовок 	= ТекущийЭтапОтправки.НаименованиеПротокола;
			НадписьПанелиПриемаЗаголовок 	= ТекущийЭтапОтправки.КомментарийКСостоянию;
			
			СостояниеСдачиОтчетности = ТекущийЭтапОтправки.СостояниеСдачиОтчетности;
			
			ГруппаКнопкиПриемаВидимость 	= СостояниеСдачиОтчетности = Перечисления.СостояниеСдачиОтчетности.ТребуетсяПодтверждениеПриема; 
			ГруппаПанельОтправкиЦветФона 	= ДокументооборотСКОВызовСервера.ЦветФонаПанелиОтправкиПоСтатусу(СостояниеСдачиОтчетности);
			
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ГруппаПанельОтправки.ЦветФона = ГруппаПанельОтправкиЦветФона;
	Элементы.НадписьСтатуса.Заголовок = НадписьСтатусаЗаголовок;
	
	Если НадписьОтветПоказатьЗаголовок = "" Тогда
		Элементы.НадписьОтветПоказать.Видимость = Ложь;
	Иначе
		Элементы.НадписьОтветПоказать.Заголовок = НадписьОтветПоказатьЗаголовок;
	КонецЕсли;
	
	Если НадписьПанелиПриемаЗаголовок = "" Тогда
		Элементы.НадписьПанелиПриема.Видимость = Ложь;
	Иначе
		Элементы.НадписьПанелиПриема.Заголовок 	= НадписьПанелиПриемаЗаголовок;	
	КонецЕсли;
	
	Элементы.ГруппаКнопкиПриема.Видимость 	= ГруппаКнопкиПриемаВидимость;
	Элементы.ДатаСовершенияЭтапа.Видимость  = НЕ ГруппаКнопкиПриемаВидимость;
	Элементы.ДатаСовершенияЭтапа.Заголовок 	= ТекстДатаПриемаОписиНами;
	
КонецПроцедуры

&НаСервере
Процедура ОтпределитьСоставМенюВыгрузка()

	Элементы.ВыгрузитьПакетДокументовДляПредставления.Видимость = Ложь;
	Элементы.ВыгрузитьВсеФайлыИПодписи.Видимость 				= Ложь;
	Элементы.ВыгрузитьОтправленныйПакетДокументов.Видимость 	= Ложь;
	Элементы.ВыгрузитьПолученнуюКвитанцию.Видимость 			= Ложь;
	
	// Выгрузить пакет документов для представления по месту требования
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФНС Тогда
		Если ЗначениеЗаполнено(Отправка) Тогда
			Если Отправка.Тип = Перечисления.ТипыЦикловОбмена.НалоговаяИлиБухгалтерскаяОтчетность Тогда
				Элементы.ВыгрузитьПакетДокументовДляПредставления.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Все файлы и подписи
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФНС
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ПФР
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСГС Тогда
		Элементы.ВыгрузитьВсеФайлыИПодписи.Видимость = Истина;
	КонецЕсли;
	
	// Отправленный пакет документов
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСРАР
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.РПН
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		Элементы.ВыгрузитьОтправленныйПакетДокументов.Видимость = Истина;
	КонецЕсли;
	
	// Полученную квитанцию
	Если ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФСС
		ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС Тогда
		Если ЗначениеЗаполнено(Отправка) Тогда
			Если Отправка.СтатусОтправки <> Перечисления.СтатусыОтправки.Отправлен
				И (Отправка.СтатусОтправки <> Перечисления.СтатусыОтправки.НеПринят
				ИЛИ ВидКонтролирующегоОргана = Перечисления.ТипыКонтролирующихОрганов.ФТС) Тогда
				Элементы.ВыгрузитьПолученнуюКвитанцию.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбъектВАрхиве(Знач ОбъектОтправки, Знач ИмяФайла)
	
	КонтекстМодуля = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстМодуля.ОбъектВАрхиве(ОбъектОтправки, ИмяФайла);
	
КонецФункции
	
&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаПакета(ОтправкаСсылка, ИмяФайлаПакета, ВАрхиве = Ложь)
			
	Если ТипЗнч(ОтправкаСсылка) <> Тип("СправочникСсылка.ОтправкиФТС") Тогда
		
		ВАрхиве = ОбъектВАрхиве(ОтправкаСсылка, "ЗашифрованныйПакет");	
		Если ВАрхиве Тогда 
			Возврат "";
		КонецЕсли;
	
		ИмяФайлаПакета = ОтправкаСсылка.ИмяФайлаПакета;
		Возврат ПоместитьВоВременноеХранилище(ОтправкаСсылка.ЗашифрованныйПакет.Получить());
		
	Иначе
		
		ВАрхиве = ОбъектВАрхиве(ОтправкаСсылка, "Подпись");	
		Если ВАрхиве Тогда 
			Возврат "";
		КонецЕсли;
		
		ИмяФайлаПакета = НСтр("ru = 'Подпись'") + ОтправкаСсылка.ИмяФайлаВыгрузки;
		Возврат ПоместитьВоВременноеХранилище(ОтправкаСсылка.Подпись.Получить());
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьАдресФайлаКвитанции(ОтправкаСсылка, ИмяФайлаКвитанции, ВАрхиве = Ложь)
	
	ВАрхиве = ОбъектВАрхиве(ОтправкаСсылка, "Квитанция");	
	Если ВАрхиве Тогда 
		Возврат "";
	КонецЕсли;
		
	Если ТипЗнч(ОтправкаСсылка) <> Тип("СправочникСсылка.ОтправкиФТС") Тогда
					
		ИмяФайлаКвитанции = ОтправкаСсылка.ИдентификаторОтправкиНаСервере + ".p7e";
		Возврат ПоместитьВоВременноеХранилище(ОтправкаСсылка.Квитанция.Получить());
		
	Иначе
		ИмяФайлаКвитанции = НСтр("ru = 'Квитанция'") + ОтправкаСсылка.ИмяФайлаВыгрузки;
		
		СтрКвитанция = ОтправкаСсылка.Квитанция.Получить();
		ВременныйФайл = ПолучитьИмяВременногоФайла();
		Текст = Новый ЗаписьТекста(ВременныйФайл, КодировкаТекста.UTF8);
		Текст.Записать(СтрКвитанция);
		Текст.Закрыть();
		
		Возврат ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ВременныйФайл));
	КонецЕсли;
	
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	Оповестить("Пометка прочтенным", , Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОбОкончанииОтправки()
	
	ПараметрыОповещения = Новый Структура;
	ПараметрыОповещения.Вставить("Организация", Организация);
	ПараметрыОповещения.Вставить("Ссылка", 		Ссылка);
	
	Оповестить("Завершение отправки", ПараметрыОповещения, Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	КонтекстЭДОКлиент.ПоказатьКритическиеОшибкиПоСсылке(Ссылка);
КонецПроцедуры

#КонецОбласти