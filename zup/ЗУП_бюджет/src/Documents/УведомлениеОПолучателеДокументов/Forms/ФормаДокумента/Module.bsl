&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
			Элементы.Организация.ТолькоПросмотр = НЕ УчетПоВсемОрганизациям;
			
			ОргПоУмолчанию = РегламентированнаяОтчетность.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
			
			КонтекстЭДОСервер = КонтекстЭДОСервер();
			
			Если ЗначениеЗаполнено(ОргПоУмолчанию)
				И ?(КонтекстЭДОСервер = Неопределено, Истина, КонтекстЭДОСервер.СписокДопустимыхОрганизацийВОбъектахОбмена().Найти(ОргПоУмолчанию) <> Неопределено)
				И ((ЗначениеЗаполнено(ОргПоУмолчанию) И НЕ УчетПоВсемОрганизациям)
				ИЛИ (НЕ ЗначениеЗаполнено(Объект.Организация) И УчетПоВсемОрганизациям И (ЗначениеЗаполнено(ОргПоУмолчанию)))) Тогда
				Объект.Организация = ОргПоУмолчанию;
			КонецЕсли;
			
			СтруктураПараметров = Новый Структура("Организация, РегистрацияВНалоговомОргане");
			ЗаполнитьЗначенияСвойств(СтруктураПараметров, Параметры);
			ЗаполнитьДокументПоСтруктуре(СтруктураПараметров);
			
		КонецЕсли;
	КонецЕсли;
	
	ЭтоЮридическоеЛицоОтправитель = Неопределено;
	Если Параметры.Ключ.Пустая() И ЗначениеЗаполнено(Объект.Организация) И НЕ ЗначениеЗаполнено(Объект.Получатель) Тогда
		РеквизитыОрганизации = РеквизитыОрганизацииНаСервере(Объект.Организация);
		ЭтоЮридическоеЛицоОтправитель 	= РеквизитыОрганизации.ЭтоЮридическоеЛицо;
		Объект.Получатель 				= РеквизитыОрганизации.РегистрацияВНалоговомОргане;
	КонецЕсли;
	
	Если ЭтоЮридическоеЛицоОтправитель = Неопределено Тогда
		ЭтоЮридическоеЛицоОтправитель = НЕ ЗначениеЗаполнено(Объект.Организация) ИЛИ РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Объект.Организация);
	КонецЕсли;
	Элементы.ДляВсехПодразделений.Видимость = ЭтоЮридическоеЛицоОтправитель;
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.СкрытьЭлементыФормыПриИспользованииОднойОрганизации(ЭтаФорма, "Организация");
	
	УведомлениеОтправлено = УведомлениеОтправлено(Объект.Ссылка);
	
	УправлениеФормой(ЭтаФорма);
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииПослеПолученияКонтекстаЭДО", ЭтотОбъект);
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СохранитьСтатусОтправкиУведомления();
	
	Оповестить("Запись_УведомлениеОПолучателеДокументов",, Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	РеквизитыОрганизации = РеквизитыОрганизацииНаСервере(Объект.Организация);
	Элементы.ДляВсехПодразделений.Видимость = РеквизитыОрганизации.ЭтоЮридическоеЛицо;
	Объект.Получатель 						= РеквизитыОрганизации.РегистрацияВНалоговомОргане;
	
	ФамилияИмяОтчествоДолжностногоЛицаПредставление = "";
	
	ОпределитьПолучателяДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ДляВсехПодразделенийПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	ОпределитьПолучателяДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияДляОтбора = Новый Массив;
	Если Объект.Получатель <> Неопределено Тогда
		РеквизитыПолучателя = РеквизитыРегистрацииВНалоговомОрганеНаСервере(Объект.Получатель);
		ЗначенияДляОтбора.Добавить(Новый Структура("КодНО, КПП", РеквизитыПолучателя.Код, РеквизитыПолучателя.КПП));
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Организация", Объект.Организация);
	ПараметрыФормы.Вставить("ЗначенияДляОтбора", ЗначенияДляОтбора);
	
	ФормаВыбораНалоговогоОргана = РегламентированнаяОтчетностьКлиент.ПолучитьОбщуюФормуПоИмени("ФормаВыбораНалоговогоОргана", ПараметрыФормы, ЭтаФорма);
	
	Если ФормаВыбораНалоговогоОргана.ТаблицаНО.Количество() <> 0 Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолучательНачалоВыбораЗавершение", ЭтотОбъект);
		ФормаВыбораНалоговогоОргана.ОписаниеОповещенияОЗакрытии = ОписаниеОповещения;
		ФормаВыбораНалоговогоОргана.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		ФормаВыбораНалоговогоОргана.Открыть();
		
	ИначеЕсли Объект.Получатель = Неопределено ИЛИ НЕ ЗначениеЗаполнено(РеквизитыПолучателя.Код) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Код налогового органа необходимо задать в справочнике ""Организации"".'"));
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Для выбора инспекции, необходимо завести соответствующую запись в справочнике ""Регистрации в налоговом органе"".'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаданиеЯвноРеквизитовПолучателяДокументовПриИзменении(Элемент)
	
	ОпределитьПолучателяДокументов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательДокументовЯвляетсяФизическимЛицомВариантыПриИзменении(Элемент)
	
	Объект.ПолучательДокументовЯвляетсяФизическимЛицом = (ПолучательДокументовЯвляетсяФизическимЛицомВарианты = "1");
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выгрузить(Команда)
	
	Если Модифицированность ИЛИ Параметры.Ключ.Пустая() Тогда
		Записать();
	КонецЕсли;
	
	КонтекстЭДОКлиент.ВыгрузитьУведомлениеОПолучателеДокументовВФайл(Объект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	Если (Модифицированность ИЛИ Параметры.Ключ.Пустая()) 
		И Не Записать() ИЛИ Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОтправкиЗавершение", ЭтотОбъект);
	КонтекстЭДОКлиент.ОтправкаРегламентированногоОтчетаВФНС(Объект.Ссылка, ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПриОткрытииПослеПолученияКонтекстаЭДО(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) ИЛИ Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов ИЛИ УведомлениеОтправлено Тогда
		Возврат;
	КонецЕсли;
	
	СвойстваПолучателяДокументов = КонтекстЭДОКлиент.СвойстваПолучателяДокументовПоУведомлению(Объект);
	
	Если СвойстваПолучателяДокументов.ЭтоПолучательДокументовИзДоверенности Тогда
		Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов = Истина;
	КонецЕсли;
	
	ОпределитьПолучателяДокументов(СвойстваПолучателяДокументов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтправкиЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ИмяВидаОбъекта = НСтр("ru = 'уведомление'");
	УведомлениеОтправлено = ПослеОтправкиЗавершениеНаСервере();
	
	// Перерисовка статуса отправки в форме Отчетность
	ПараметрыОповещения = Новый Структура(); 
	ПараметрыОповещения.Вставить("Ссылка", Объект.Ссылка);
	ПараметрыОповещения.Вставить("Организация", Объект.Организация);
	Оповестить("Завершение отправки", ПараметрыОповещения, Объект.Ссылка);
	
	Если Открыта() И УведомлениеОтправлено Тогда
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		Объект.Получатель = РезультатВыбора.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьПолучателяДокументов(СвойстваПолучателяДокументов = Неопределено, ОповещениеОЗавершении = Неопределено)
	
	ФамилияИмяОтчествоДолжностногоЛица = Неопределено;
	
	ПолучательДокументовНеЗаполнен = (НЕ ЗначениеЗаполнено(Объект.ИдентификаторАбонента)
		И НЕ ЗначениеЗаполнено(Объект.НаименованиеПолучателяДокументов)
		И НЕ ЗначениеЗаполнено(Объект.ИННПолучателяДокументов)
		И НЕ ЗначениеЗаполнено(Объект.КПППолучателяДокументов)
		И НЕ Объект.ПолучательДокументовЯвляетсяФизическимЛицом
		И НЕ ЗначениеЗаполнено(Объект.ФамилияПолучателяДокументов)
		И НЕ ЗначениеЗаполнено(Объект.ИмяПолучателяДокументов)
		И НЕ ЗначениеЗаполнено(Объект.ОтчествоПолучателяДокументов)
		И Объект.ДолжностныеЛицаПолучателяДокументов.Количество() = 0);
	
	ДополнительныеПараметры = Новый Структура();
	ДополнительныеПараметры.Вставить("ПолучательДокументовНеЗаполнен", ПолучательДокументовНеЗаполнен);
	ДополнительныеПараметры.Вставить("ОповещениеОЗавершении", ОповещениеОЗавершении);
	
	Оповещение = Новый ОписаниеОповещения(
		"ОпределитьПолучателяДокументовПослеПоискаСертификатаДляШифрования",
		ЭтотОбъект,
		ДополнительныеПараметры);
	
	Если НЕ УведомлениеОтправлено И ЗначениеЗаполнено(Объект.Организация)
		И ((Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов И ПолучательДокументовНеЗаполнен)
		ИЛИ НЕ ЗначениеЗаполнено(ФамилияИмяОтчествоДолжностногоЛицаПредставление)) Тогда
		
		Если СвойстваПолучателяДокументов = Неопределено Тогда
			СвойстваПолучателяДокументов = КонтекстЭДОКлиент.СвойстваПолучателяДокументовПоУведомлению(Объект);
		КонецЕсли;
		
		Если Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов И ПолучательДокументовНеЗаполнен Тогда
			ЗаполнитьЗначенияСвойств(Объект, СвойстваПолучателяДокументов);
		КонецЕсли;
		
		Если НЕ СвойстваПолучателяДокументов.ЭтоЭлектроннаяПодписьВМоделиСервиса
			И ЗначениеЗаполнено(СвойстваПолучателяДокументов.ОтпечатокСертификатаДляШифрования) Тогда
			
			СвойстваСертификатаДляШифроания = Новый Структура("Отпечаток",
				СвойстваПолучателяДокументов.ОтпечатокСертификатаДляШифрования);
			КриптографияЭДКОКлиент.НайтиСертификат(Оповещение, СвойстваСертификатаДляШифроания,, Ложь);
			Возврат;
			
		Иначе
			ФамилияИмяОтчествоДолжностногоЛица = Новый Структура("Фамилия, Имя, Отчество",
				СвойстваПолучателяДокументов.ФамилияДолжностногоЛица,
				СвойстваПолучателяДокументов.ИмяДолжностногоЛица,
				СвойстваПолучателяДокументов.ОтчествоДолжностногоЛица);
		КонецЕсли;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Оповещение, ФамилияИмяОтчествоДолжностногоЛица);
	
КонецПроцедуры

&НаКлиенте
Процедура ОпределитьПолучателяДокументовПослеПоискаСертификатаДляШифрования(Результат, ДополнительныеПараметры) Экспорт
	
	ПолучательДокументовНеЗаполнен 	= ДополнительныеПараметры.ПолучательДокументовНеЗаполнен;
	ОповещениеОЗавершении 			= ДополнительныеПараметры.ОповещениеОЗавершении;
	
	Если Результат <> Неопределено И Результат.Свойство("Выполнено") Тогда
		ФамилияИмяОтчествоДолжностногоЛица = ?(Результат.Выполнено И Результат.СертификатНайден,
			КонтекстЭДОКлиент.ФамилияИмяОтчествоВладельцаСертификата(Результат.СвойстваСертификата),
			Неопределено);
		
	Иначе
		ФамилияИмяОтчествоДолжностногоЛица = Результат;
	КонецЕсли;
	
	Если ФамилияИмяОтчествоДолжностногоЛица <> Неопределено Тогда
		Если Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов И ПолучательДокументовНеЗаполнен И НЕ УведомлениеОтправлено Тогда
			ДолжностноеЛицоПолучателяДокументов = Объект.ДолжностныеЛицаПолучателяДокументов.Добавить();
			ЗаполнитьЗначенияСвойств(ДолжностноеЛицоПолучателяДокументов, ФамилияИмяОтчествоДолжностногоЛица);
		КонецЕсли;
		
		ФамилияИмяОтчествоДолжностногоЛицаПредставление = СокрЛП(ФамилияИмяОтчествоДолжностногоЛица.Фамилия
			+ " " + ФамилияИмяОтчествоДолжностногоЛица.Имя) + " " + ФамилияИмяОтчествоДолжностногоЛица.Отчество;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
	Если ОповещениеОЗавершении <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДокументПоСтруктуре(СтруктураПараметров)
	
	Если ЗначениеЗаполнено(СтруктураПараметров.Организация) Тогда
		Объект.Организация = СтруктураПараметров.Организация;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураПараметров.РегистрацияВНалоговомОргане) Тогда
		Объект.Получатель = СтруктураПараметров.РегистрацияВНалоговомОргане;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПослеОтправкиЗавершениеНаСервере()
	
	УведомлениеОтправлено = УведомлениеОтправлено(Объект.Ссылка);
	УправлениеФормой(ЭтаФорма);
	
	Возврат УведомлениеОтправлено;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПрорисоватьСтатус(Форма)
	
	ПараметрыПрорисовкиПанелиОтправки = ДокументооборотСКОВызовСервера.ПараметрыПрорисовкиПанелиОтправки(Форма.Объект.Ссылка, Форма.Объект.Организация, "ФНС");
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.ПрименитьПараметрыПрорисовкиПанелиОтправки(Форма, ПараметрыПрорисовкиПанелиОтправки);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Элементы.Отправить.Видимость = НЕ Форма.УведомлениеОтправлено;
	Элементы.Записать.Видимость = НЕ Форма.УведомлениеОтправлено;
	
	Элементы.ГруппаПолучательДокументов.Видимость = Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов;
	Элементы.ГруппаЮридическоеЛицо.Видимость = НЕ Объект.ПолучательДокументовЯвляетсяФизическимЛицом;
	Элементы.ГруппаФизическоеЛицо.Видимость = Объект.ПолучательДокументовЯвляетсяФизическимЛицом;
	Элементы.ГруппаДолжностныеЛица.Видимость = Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов;
	
	Элементы.ДолжностныеЛицаПолучателяДокументов.ТолькоПросмотр = Форма.УведомлениеОтправлено;
	
	Если Форма.УведомлениеОтправлено Тогда
		Форма.ЗаданиеЯвноРеквизитовПолучателяДокументовПредставление = ?(НЕ Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов,
			НСтр("ru = 'На учетную запись отправителя уведомления'"),
			НСтр("ru = 'Задать вручную реквизиты получателя документов'"));
		Форма.ПолучательДокументовЯвляетсяФизическимЛицомПредставление = ?(Объект.ПолучательДокументовЯвляетсяФизическимЛицом,
			НСтр("ru = 'Юридическое лицо'"),
			НСтр("ru = 'Физическое лицо'"));
		
		Элементы.Организация.Вид 													= ВидПоляФормы.ПолеНадписи;
		Элементы.ДляВсехПодразделений.Вид 											= ВидПоляФормы.ПолеНадписи;
		Элементы.ДляВсехПодразделений.ПоложениеЗаголовка 							= ПоложениеЗаголовкаЭлементаФормы.Лево;
		Элементы.Получатель.Вид 													= ВидПоляФормы.ПолеНадписи;
		Элементы.ЗаданиеЯвноРеквизитовПолучателяДокументов.Видимость 				= Ложь;
		Элементы.ЗаданиеЯвноРеквизитовПолучателяДокументовПредставление.Видимость 	= Истина;
		Элементы.ДолжностныеЛицаПолучателяДокументов.ПоложениеКоманднойПанели 		= ПоложениеКоманднойПанелиЭлементаФормы.Нет;
		Элементы.ИдентификаторАбонента.Вид 											= ВидПоляФормы.ПолеНадписи;
		Элементы.ПолучательДокументовЯвляетсяФизическимЛицомВарианты.Видимость 		= Ложь;
		Элементы.ПолучательДокументовЯвляетсяФизическимЛицомПредставление.Видимость = Истина;
		Элементы.НаименованиеПолучателяДокументов.Вид 								= ВидПоляФормы.ПолеНадписи;
		Элементы.НаименованиеПолучателяДокументов.Подсказка							= Объект.НаименованиеПолучателяДокументов;
		Элементы.ИННПолучателяДокументов.Вид 										= ВидПоляФормы.ПолеНадписи;
		Элементы.КПППолучателяДокументов.Вид 										= ВидПоляФормы.ПолеНадписи;
		Элементы.ФамилияПолучателяДокументов.Вид 									= ВидПоляФормы.ПолеНадписи;
		Элементы.ИмяПолучателяДокументов.Вид 										= ВидПоляФормы.ПолеНадписи;
		Элементы.ОтчествоПолучателяДокументов.Вид 									= ВидПоляФормы.ПолеНадписи;
		Элементы.ИННФизическогоЛицаПолучателяДокументов.Вид 						= ВидПоляФормы.ПолеНадписи;
	КонецЕсли;
	
	Если НЕ Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов Тогда
		ЭтоЮрЛицо = Элементы.ДляВсехПодразделений.Видимость;
		
		Если ЭтоЮрЛицо Тогда
			Если Объект.ДляВсехПодразделений Тогда
				ТекстСообщения =
					НСтр("ru = 'После отправки уведомления все входящие сообщения, в том числе требования, от налогового органа
							   |будут приходить на учетную запись организации - отправителя уведомления.'");
			Иначе
				ТекстСообщения =
					НСтр("ru = 'После отправки уведомления все входящие сообщения, в том числе требования, по указанной регистрации
							   |будут приходить на учетную запись организации - отправителя уведомления.'");
			КонецЕсли;
		Иначе
			ТекстСообщения =
				НСтр("ru = 'После отправки уведомления все входящие сообщения, в том числе требования, от налогового органа
						   |будут приходить на учетную запись индивидуального предпринимателя - отправителя уведомления.'");
		КонецЕсли;
	Иначе
		Если Объект.ДляВсехПодразделений Тогда
			ТекстСообщения =
				НСтр("ru = 'После отправки уведомления все входящие сообщения, в том числе требования, от налогового органа
						   |будут приходить на заданную учетную запись абонента.'");
		Иначе
			ТекстСообщения =
				НСтр("ru = 'После отправки уведомления все входящие сообщения, в том числе требования, по указанной регистрации
						   |будут приходить на заданную учетную запись абонента.'");
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ДекорацияИнформация.Заголовок = ТекстСообщения;
	
	Если НЕ Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов Тогда
		Если НЕ Форма.УведомлениеОтправлено Тогда
			ДолжностноеЛицоПредставление = ?(ЗначениеЗаполнено(Форма.ФамилияИмяОтчествоДолжностногоЛицаПредставление),
				СокрЛП(Форма.ФамилияИмяОтчествоДолжностногоЛицаПредставление), НСтр("ru = '(не определено)'"));
			ТекстДолжностноеЛицо = НСтр("ru = 'Должностное лицо получателя: %1.
											  |'");
			ТекстДолжностноеЛицо = СтрШаблон(ТекстДолжностноеЛицо, ДолжностноеЛицоПредставление);
		Иначе
			ТекстДолжностноеЛицо = "";
		КонецЕсли;
		
		ТекстСообщения = ТекстДолжностноеЛицо
			+ НСтр("ru = 'Обратите внимание, при смене должностного лица необходимо отправить уведомление заново.'");
		
		Элементы.ДекорацияИнформацияДолжностноеЛицо.Заголовок = ТекстСообщения;
	КонецЕсли;
	
	Элементы.ДекорацияИнформацияДолжностноеЛицо.Видимость = (НЕ Объект.ЗаданиеЯвноРеквизитовПолучателяДокументов);
	
	Форма.ПолучательДокументовЯвляетсяФизическимЛицомВарианты = ?(Объект.ПолучательДокументовЯвляетсяФизическимЛицом, "1", "0");
	
	ПрорисоватьСтатус(Форма);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция КонтекстЭДОСервер()
	
	Возврат ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	
КонецФункции

&НаСервереБезКонтекста
Функция УведомлениеОтправлено(Ссылка)
	
	СтатусОтправки = КонтекстЭДОСервер().ПолучитьСтатусОтправкиОбъекта(Ссылка);
	
	УведомлениеОтправлено =
		ЗначениеЗаполнено(СтатусОтправки) И СтатусОтправки <> Перечисления.СтатусыОтправки.ВКонверте;
	
	Возврат УведомлениеОтправлено;
	
КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыОрганизацииНаСервере(Организация)
	
	Результат = Новый Структура("ЭтоЮридическоеЛицо, РегистрацияВНалоговомОргане", Истина, Неопределено);
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Результат.ЭтоЮридическоеЛицо = РегламентированнаяОтчетностьВызовСервера.ЭтоЮридическоеЛицо(Организация);
	
	Если Результат.ЭтоЮридическоеЛицо Тогда
		СвойстваОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, , "КППЮЛ, КодНО");
		КПП = СокрЛП(СвойстваОрганизации.КППЮЛ);
	Иначе
		СвойстваОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Организация, , "КодНО");
		КПП = "";
	КонецЕсли;
	
	КодНалоговогоОргана = СокрЛП(СвойстваОрганизации.КодНО);
	Результат.РегистрацияВНалоговомОргане = КонтекстЭДОСервер().РегистрацияВИФНСПоОрганизацииИКодуНО(Организация, КодНалоговогоОргана, КПП);
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция РеквизитыРегистрацииВНалоговомОрганеНаСервере(РегистрацияВНалоговомОргане)
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "Код, КПП");
	
КонецФункции

&НаСервере
Процедура СохранитьСтатусОтправкиУведомления()
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти