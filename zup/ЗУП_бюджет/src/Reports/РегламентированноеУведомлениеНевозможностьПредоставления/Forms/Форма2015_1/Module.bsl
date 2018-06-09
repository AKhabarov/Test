&НаСервере
Процедура ЗагрузитьДанные()
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПараметров = Объект.Ссылка.ДанныеУведомления.Получить();
	СтруктураРеквизитов = СтруктураПараметров.СтруктураРеквизитов;
	Реквизиты = ПолучитьРеквизиты();
	Для Каждого Рекв Из Реквизиты Цикл 
		Если СтруктураРеквизитов.Свойство(Рекв.Имя) Тогда 
			Если ТипЗнч(СтруктураРеквизитов[Рекв.Имя]) = Тип("ТаблицаЗначений")
				Или ТипЗнч(СтруктураРеквизитов[Рекв.Имя]) = Тип("ДеревоЗначений") Тогда 
				ЗначениеВРеквизитФормы(СтруктураРеквизитов[Рекв.Имя], Рекв.Имя);
			Иначе
				ЭтотОбъект[Рекв.Имя] = СтруктураРеквизитов[Рекв.Имя];
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов;
		Объект.Организация = Организация;
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	Реквизиты = ПолучитьРеквизиты();
	СтруктураРеквизитов = Новый Структура();
	Для Каждого Рекв Из Реквизиты Цикл 
		Если СтрНачинаетсяС(Рекв.Имя, "_") Тогда 
			Если ТипЗнч(ЭтотОбъект[Рекв.Имя]) = Тип("ДанныеФормыКоллекция")
				Или ТипЗнч(ЭтотОбъект[Рекв.Имя]) = Тип("ДанныеФормыДерево") Тогда 
				СтруктураРеквизитов.Вставить(Рекв.Имя, РеквизитФормыВЗначение(Рекв.Имя));
			Иначе
				СтруктураРеквизитов.Вставить(Рекв.Имя, ЭтотОбъект[Рекв.Имя]);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура("СтруктураРеквизитов, РазрешитьВыгружатьСОшибками", СтруктураРеквизитов, РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
	
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		Организация = Объект.Организация;
	Иначе
		Организация = Параметры.Организация;
		Объект.Организация = Параметры.Организация;
		Если Параметры.Свойство("НалоговыйОрган") И ЗначениеЗаполнено(Параметры.НалоговыйОрган) Тогда 
			Объект.РегистрацияВИФНС = Параметры.НалоговыйОрган;
		Иначе
			Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Организация);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Данные) И ТипЗнч(Данные) = Тип("СправочникСсылка.ДокументыРеализацииПолномочийНалоговыхОрганов") Тогда
			ЗаполнитьДаннымиТребования(Данные);
		КонецЕсли;
		
		УстановитьДанныеПоРегистрацииВИФНС();
	КонецЕсли;
	
	НачальнаяИнициализация();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.ДатаПодписи = ТекущаяДатаСеанса();
		ЭтотОбъект.Заголовок = ЭтотОбъект.Заголовок + " (создание)";
	КонецЕсли;
	
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ЭтаФорма.ИмяФормы, ".");
	Объект.ИмяФормы = Разложение[3];
	Объект.ИмяОтчета = Разложение[1];
	
	ЗагрузитьДанные();
	РегламентированнаяОтчетность.ДобавитьКнопкуПрисоединенныеФайлы(ЭтаФорма);
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	ЭлектронныйДокументооборотСКонтролирующимиОрганами.ОтметитьКакПрочтенное(Объект.Ссылка);
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ЗаблокироватьДанныеДляРедактирования(Объект.Ссылка, , УникальныйИдентификатор);
	КонецЕсли;
	
	Элементы.Группа4.Видимость = (_ПризОтпрУП = 2);
	Элементы.ГруппаЮЛ.Видимость = (_ОтпрЮЛ = 0);
	Элементы.ГруппаФЛ.Видимость = (_ОтпрЮЛ = 1);
	Элементы.ПриложенныеДокументы.Видимость = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами");
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Элементы._НаимДокПодп.АвтоОтметкаНезаполненного = (_ПрПодп = 2 Или _ПрПодп = 4);
КонецПроцедуры

&НаСервере
Процедура НачальнаяИнициализация()
	ЭтоЮрЛицо = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
	_ПризОтпрУП = 1;
	_КодПрич = 10;
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		Элементы._ПрПодп.СписокВыбора.Добавить(3, "руководитель организации");
		Элементы._ПрПодп.СписокВыбора.Добавить(4, "представитель организации");
		_ПрПодп = 3;
	Иначе 
		Элементы._ПрПодп.СписокВыбора.Добавить(1, "физическое лицо");
		Элементы._ПрПодп.СписокВыбора.Добавить(2, "представитель физического лица");
		_ПрПодп = 1;
	КонецЕсли;
	
	Элементы._Номер.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ДатаТреб.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._НомТреб.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИмяФайлТреб.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ОписПричНепред.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._КодПрич.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._СрокПредст.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._НаимОргОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИННЮЛОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._КППОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИННФЛОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ФамилияОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИмяОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ОтчествоОтпр.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ДолжнПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._Тлф.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._Email.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИННФЛПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ФамилияПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ИмяПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ОтчествоПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._НаимДокПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
	Элементы._ПрПодп.УстановитьДействие("ПриИзменении", "ПриИзмененииРеквизитов");
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаСервере
Функция СформироватьПечатнуюФорму()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПечатьСразу();
КонецФункции

&НаКлиенте
Процедура ПечатьУведомления(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Перед печатью необходимо сохранить изменения. Сохранить изменения?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ПечатьУведомленияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
	Иначе
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьУведомленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПФ = СформироватьПечатнуюФорму();
		Если ПФ <> Неопределено Тогда 
			ПФ.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
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

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура _ПорНомДок1ПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизитов(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура _ПризОтпрУППриИзменении(Элемент)
	Элементы.Группа4.Видимость = (_ПризОтпрУП = 2);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура _ОтпрЮЛПриИзменении(Элемент)
	Элементы.ГруппаЮЛ.Видимость = (_ОтпрЮЛ = 0);
	Элементы.ГруппаФЛ.Видимость = (_ОтпрЮЛ = 1);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокумент(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьДокументЗавершение", ЭтотОбъект);
	ПоказатьВводЗначения(ОписаниеОповещения, "", "Введите наименование, реквизиты и прочие признаки документа");
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьДокументЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатВопроса) = Тип("Строка") 
		И ЗначениеЗаполнено(РезультатВопроса) Тогда 
		
		НовДок = _ПриложенныеФайлы.ПолучитьЭлементы().Добавить();
		НовДок.Документ = РезультатВопроса;
		НовДок.УИДДокумент = Новый УникальныйИдентификатор;
		Модифицированность = Истина;
		Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	Если Элементы._ПриложенныеФайлы.ТекущиеДанные = Неопределено Тогда 
		ПоказатьПредупреждение(, "Необходимо выбрать документ для добавления файла");
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Или Не ЗначениеЗаполнено(Объект.Ссылка) Тогда 
		ТекстВопроса = "Для добавления файла необходимо сохранить уведомление. Сохранить?";
		ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлПослеСохранения", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, 0);
		Возврат;
	КонецЕсли;
	
	АдресФайла  = "";
	ВыбИмяФайла = "";
	
	Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
	
	Попытка
		НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлПослеСохранения(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
		АдресФайла  = "";
		ВыбИмяФайла = "";
		
		Оп = Новый ОписаниеОповещения("ДобавитьФайлЗавершение", ЭтотОбъект);
		
		Попытка
			НачатьПомещениеФайла(Оп, АдресФайла, ВыбИмяФайла, Истина, УникальныйИдентификатор);
		Исключение
			ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
										 |%1'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлЗавершение(Результат, АдресФайла, ВыбИмяФайла, Парам) Экспорт
	Если НЕ Результат Тогда
		Возврат;
	КонецЕсли;
	
	ТекстПредупреждения = "";
	
	Если НЕ (ВРег(Прав(ВыбИмяФайла, 4)) = ".TIF"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".PDF"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".PNG"
		ИЛИ ВРег(Прав(ВыбИмяФайла, 4)) = ".JPG") Тогда
		
		ТекстПредупреждения = НСтр(
			"ru='Файл приложения должен иметь одно из допустимых расширений: JPEG, PDF, JPG, PNG!'");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Каталог = "";
	СтрокаПоиска = ВыбИмяФайла;
	
	РазделительПути = ПолучитьРазделительПути();
	Пока СтрДлина(СтрокаПоиска) > 0 Цикл
		Если Прав(СтрокаПоиска, 1) = РазделительПути Тогда
			Каталог = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска));
			Прервать;
		Иначе
			СтрокаПоиска = Лев(СтрокаПоиска, СтрДлина(СтрокаПоиска) - 1);
		КонецЕсли;
	КонецЦикла;
	
	Элт = Элементы._ПриложенныеФайлы.ТекущиеДанные.ПолучитьРодителя();
	Если Элт = Неопределено Тогда 
		Элт = Элементы._ПриложенныеФайлы.ТекущиеДанные;
	КонецЕсли;
	ПодчЭлт = Элт.ПолучитьЭлементы().Добавить();
	
	Попытка
		ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ВыбИмяФайла, Каталог, ПодчЭлт.ПолучитьИдентификатор());
	Исключение
		ШаблонСообщения = НСтр("ru = 'При загрузке файла возникла ошибка.
									 |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ШаблонСообщения, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстСообщения, , НСтр("ru = 'Ошибка'"));
		Возврат;
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруДанныхФайла(АдресФайла, ПолноеИмяФайла, Каталог, ИДВДереве)
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		ИмяФайла = СтрЗаменить(ПолноеИмяФайла, Каталог, "");
		ИмяБезРасширения = Лев(ИмяФайла, СтрНайти(ИмяФайла, ".", НаправлениеПоиска.СКонца) - 1);
		ПараметрыФайла = Новый Структура;
		ПараметрыФайла.Вставить("ВладелецФайлов", Объект.Ссылка);
		ПараметрыФайла.Вставить("Автор", Неопределено);
		ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
		ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
		ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
		ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
		НоваяСсылкаНаФайл = МодульРаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресФайла, , "Файл создан автоматически из формы уведомления, редактирование запрещено.");
		Файл = _ПриложенныеФайлы.НайтиПоИдентификатору(ИДВДереве);
		Файл.ПрисоединенныйФайл = НоваяСсылкаНаФайл;
		Файл.Документ = ИмяФайла;
		Файл.УИДФайл = Новый УникальныйИдентификатор;
		Файл.УИДДокумент = Файл.ПолучитьРодителя().УИДДокумент;
		Файл.ИндексКартинки = 2;
		Модифицированность = Истина;
		СохранитьДанные();
	КонецЕсли
КонецПроцедуры

&НаКлиенте
Процедура ПриложенныеФайлыПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы._ПриложенныеФайлы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Элементы.ПриложенныеФайлыУдалитьФайл.Доступность = Ложь;
		Элементы.ПриложенныеФайлыУдалитьДокумент.Доступность = Ложь;
		Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = Ложь;
	Иначе 
		Элементы.ПриложенныеФайлыУдалитьФайл.Доступность = ЗначениеЗаполнено(ТекущиеДанные.УИДФайл);
		Элементы.ПриложенныеФайлыУдалитьДокумент.Доступность = (Не ЗначениеЗаполнено(ТекущиеДанные.УИДФайл)) И (ЗначениеЗаполнено(ТекущиеДанные.УИДДокумент));
		Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = (_ПриложенныеФайлы.ПолучитьЭлементы().Количество() > 0);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайл(Команда)
	ТекущиеДанные = Элементы._ПриложенныеФайлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.УИДФайл) Тогда 
		ПрисоединенныйФайл = ТекущиеДанные.ПрисоединенныйФайл;
		ТекущиеДанные.ПолучитьРодителя().ПолучитьЭлементы().Удалить(ТекущиеДанные);
		УдалитьФайлНаСервере(ПрисоединенныйФайл);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьФайлНаСервере(ПрисоединенныйФайл)
	Попытка
		ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
		ПрисоединенныйФайлОбъект.ПометкаУдаления = Истина;
		ПрисоединенныйФайлОбъект.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю("При установке пометки удаления присоединенного файла произошли ошибки");
	КонецПопытки;
	
	Модифицированность = Истина;
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьДокумент(Команда)
	ТекущиеДанные = Элементы._ПриложенныеФайлы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И (Не ЗначениеЗаполнено(ТекущиеДанные.УИДФайл) И ЗначениеЗаполнено(ТекущиеДанные.УИДДокумент)) Тогда 
		МассивПрисоединенныхФайлов = Новый Массив;
		Для Каждого Стр Из ТекущиеДанные.ПолучитьЭлементы() Цикл
			МассивПрисоединенныхФайлов.Добавить(Стр.ПрисоединенныйФайл);
		КонецЦикла;
		УИДДокумент = ТекущиеДанные.УИДДокумент;
		_ПриложенныеФайлы.ПолучитьЭлементы().Удалить(ТекущиеДанные);
		УдалитьДокументНаСервере(УИДДокумент, МассивПрисоединенныхФайлов);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьДокументНаСервере(УИДДокумент, МассивПрисоединенныхФайлов)
	ЕстьИсключение = Ложь;
	Для Каждого Элт Из МассивПрисоединенныхФайлов Цикл
		Попытка
			ПрисоединенныйФайлОбъект = Элт.ПолучитьОбъект();
			ПрисоединенныйФайлОбъект.ПометкаУдаления = Истина;
			ПрисоединенныйФайлОбъект.Записать();
		Исключение
			ЕстьИсключение = Истина;
		КонецПопытки;
	КонецЦикла;
	
	Если ЕстьИсключение Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю("При установке пометки удаления присоединенного файла произошли ошибки");
	КонецЕсли;
	
	Модифицированность = Истина;
	СохранитьДанные();
КонецПроцедуры

&НаКлиенте
Процедура _ПриложенныеФайлыПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииТребования(Команда)
	ВидыТребований = Новый Массив;
	ВидыТребований.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалоговыхДокументов.ТребованиеОПредставленииДокументов"));
	
	ПараметрыВыбораТребования = Новый Структура("РежимВыбора, Организация, ВидыТребований", Истина, Организация, ВидыТребований);
	ОО = Новый ОписаниеОповещения("СоздатьНаОснованииТребованияЗавершение", ЭтотОбъект);
	ОткрытьФорму("Справочник.ДокументыРеализацииПолномочийНалоговыхОрганов.ФормаВыбора", ПараметрыВыбораТребования, ЭтотОбъект,,,, ОО, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНаОснованииТребованияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт 
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда 
		ЗаполнитьДаннымиТребования(РезультатЗакрытия);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДаннымиТребования(Требование)
	Реквизиты = "НалоговыйОрган,Организация,Идентификатор,ИдентификаторОснования,";
	Реквизиты = Реквизиты + "ВидДокумента,НомерДокумента,ДатаДокумента,ДатаСообщения,ДатаОтправки";
	РеквизитыТребования = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Требование, Реквизиты);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
	|	РегистрацииВНалоговомОргане.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.РегистрацииВНалоговомОргане КАК РегистрацииВНалоговомОргане
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.НалоговыеОрганы КАК НалоговыеОрганы
	|		ПО РегистрацииВНалоговомОргане.Код = НалоговыеОрганы.Код
	|ГДЕ
	|	РегистрацииВНалоговомОргане.Владелец = &Организация
	|	И НалоговыеОрганы.Ссылка = &НалоговыйОрган";
		
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("НалоговыйОрган", РеквизитыТребования.НалоговыйОрган);
	
	Объект.РегистрацияВИФНС = Справочники.РегистрацииВНалоговомОргане.ПустаяСсылка();
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Объект.РегистрацияВИФНС = Выборка.Ссылка;
	КонецЦикла;
	
	_ИмяФайлТреб = "";
	Если РеквизитыТребования.ВидДокумента = Перечисления.ВидыНалоговыхДокументов.ТребованиеОПредставленииДокументов Тогда 
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
		ИменаФайлов = КонтекстЭДОСервер.ПолучитьФайлыДокументовРеализацииПолномочийНалоговыхОрганов(Требование);
		_ИмяФайлТреб = КонтекстЭДОСервер.ИмяФайлаБезРасширения(ИменаФайлов[0].ИмяФайла);
	КонецЕсли;
	_НомТреб = РеквизитыТребования.НомерДокумента;
	_ДатаТреб = РеквизитыТребования.ДатаДокумента;
	Элементы._НаимДокПодп.АвтоОтметкаНезаполненного = (_ПрПодп = 2 Или _ПрПодп = 4);
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РегистрацияВИФНСПриИзменении(Элемент)
	УстановитьДанныеПоРегистрацииВИФНС();
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		_ИННФЛПодп = ДанныеПредставителя.ИНН;
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьДанныеРуководителя(Объект);
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,ДокументПредставителя");
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		_ПрПодп = ?(ЭтоЮрЛицо, 4, 2);
		_НаимДокПодп = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		_ПрПодп = ?(ЭтоЮрЛицо, 3, 1);
		_НаимДокПодп = "";
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура _ПриложенныеФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Поле.Имя = "ПриложенныеФайлыДокумент" И ТипЗнч(ВыбраннаяСтрока) = Тип("Число")
		И Элемент.ТекущиеДанные <> Неопределено
		И Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.УИДФайл) Тогда 
		СтандартнаяОбработка = Ложь;
		ОписаниеОповещения = Новый ОписаниеОповещения("_ПриложенныеФайлыВыборЗавершение", ЭтотОбъект, Новый Структура("ИД", Элемент.ТекущиеДанные.ПолучитьИдентификатор()));
		ПоказатьВводЗначения(ОписаниеОповещения, Элемент.ТекущиеДанные.Документ, "Введите наименование, реквизиты и прочие признаки документа");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ПриложенныеФайлыВыборЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатВопроса) = Тип("Строка") 
		И ЗначениеЗаполнено(РезультатВопроса) Тогда
		
		НовДок = _ПриложенныеФайлы.НайтиПоИдентификатору(ДополнительныеПараметры.ИД);
		НовДок.Документ = РезультатВопроса;
		Модифицированность = Истина;
		Элементы.ПриложенныеФайлыДобавитьФайл.Доступность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		Попытка
			Элементы.ГруппаЗакладки.ТекущаяСтраница = Элементы[Параметр.ИмяСтраницы];
			ТекущийЭлемент = Элементы[Параметр.ИмяОбласти];
		Исключение
		КонецПопытки;
		
		Активизировать();
		Источник.Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура _ПрПодпПриИзменении(Элемент)
	Элементы._НаимДокПодп.АвтоОтметкаНезаполненного = (_ПрПодп = 2 Или _ПрПодп = 4);
КонецПроцедуры
