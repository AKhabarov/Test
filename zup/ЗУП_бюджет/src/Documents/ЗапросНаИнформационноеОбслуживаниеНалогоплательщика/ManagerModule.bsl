#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Печатная форма запросов на сверку с ФНС.
//
Функция ПечатнаяФорма(Сверка) Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	// получаем бланк отчета из макета
	Бланк = Документы.ЗапросНаИнформационноеОбслуживаниеНалогоплательщика.ПолучитьМакет("Сверка");
	
	ПараметрыЗапроса = ПараметрыЗапроса(Сверка);
	
	ЗаполнитьВерхнююЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса);
	ЗаполнитьТабличнуюЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса);
	ЗаполнитьНижнююЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса);
	
	ТабДокумент.МасштабПечати = 100;
	Возврат ТабДокумент;
	
КонецФункции

Функция НаименованиеКБК(ЗначениеКБК, ТаблицаКБК = Неопределено) Экспорт
	
	Если ТаблицаКБК = Неопределено Тогда
		ТаблицаКБК	= ПолучитьТаблицуКБК();
	КонецЕсли;
	
	Если СтрДлина(СокрЛП(ЗначениеКБК)) = 20 Тогда
		НайденнаяСтрока = ТаблицаКБК.Найти(ЗначениеКБК, "КБК");
		Если НайденнаяСтрока <> Неопределено Тогда
			Возврат НайденнаяСтрока.Наименование;
		КонецЕсли;
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

Функция ПолучитьТаблицуКБК() Экспорт
	
	МакетКБК = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО().ПолучитьМакет("КБК");
	
	КБК = Новый ТаблицаЗначений;
	КБК.Колонки.Добавить("КБК", 		 Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(20)));
	КБК.Колонки.Добавить("Наименование", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(500)));
	КБК.Колонки.Добавить("Налог", 		 Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	КБК.Колонки.Добавить("Папка", 		 Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	
	КБК.Колонки.Добавить("ДоступноДляОрганизаций", 		Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("ДоступноДляИПБезСотрудников", Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("ДоступноДляИПССотрудниками", 	Новый ОписаниеТипов("Булево"));
	
	КБК.Колонки.Добавить("ОСНО", 	Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("УСН", 	Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("ЕНВД", 	Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("ПСН", 	Новый ОписаниеТипов("Булево"));
	КБК.Колонки.Добавить("ЕСХН", 	Новый ОписаниеТипов("Булево"));
	
	ИндексКолонкиПризнакаСкрытияУпрощенная = 99;
	ИндексКолонкиУСН = 99;
	ФлагиУчета = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьФлагиИнтеграцииПоУмолчанию();
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьЗначенияКонстантИнтеграции(ФлагиУчета);
	Если ЗначениеЗаполнено(ФлагиУчета) И ФлагиУчета.ИнтеграцияСБанком Тогда //Доступна и активна упрощенная отчетность
		Для НомерКолонки = 1 По МакетКБК.ШиринаТаблицы Цикл
			Если СокрЛП(МакетКБК.Область(1, НомерКолонки).Текст) = "СкрытьЭлемент" Тогда
				ИндексКолонкиПризнакаСкрытияУпрощенная = НомерКолонки;
				Продолжить;
			КонецЕсли;
			Если СокрЛП(МакетКБК.Область(1, НомерКолонки).Текст) = "УСН" Тогда
				ИндексКолонкиУСН = НомерКолонки;
				Продолжить;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
		
	Для НомерСтроки = 2 По МакетКБК.ВысотаТаблицы Цикл
		
		Если ФлагиУчета.ИнтеграцияСБанком Тогда //Доступна и активна упрощенная отчетность
			Если СокрЛП(МакетКБК.Область(НомерСтроки, ИндексКолонкиУСН).Текст) <> "да" Тогда //Только УСН
				Продолжить;
			КонецЕсли;
			Если СокрЛП(МакетКБК.Область(НомерСтроки, ИндексКолонкиПризнакаСкрытияУпрощенная).Текст) = "да" Тогда //Только разрешенные для УСН
				Продолжить;
			КонецЕсли;			
		КонецЕсли;
		
		НовСтр = КБК.Добавить();
		
		Для каждого Колонка Из КБК.Колонки Цикл
			НомерКолонки = КБК.Колонки.Индекс(Колонка) + 1;
			НовСтр[Колонка.Имя] = СокрЛП(МакетКБК.Область(НомерСтроки, НомерКолонки).Текст);
		КонецЦикла; 
		
	КонецЦикла;
	
	КБК.Индексы.Добавить("КБК");
	
	Возврат КБК;
	
КонецФункции

Функция ОбработатьСтрокуПоискаКБК(СтрокаПоиска) Экспорт
	
	// Если больше 26 символов, скорее всего это не Код БК, а текст -
	// см. шаблон отформатированного КБК: 182 1 01 01011 01 1000 110
	Если СтрДлина(СокрЛП(СтрокаПоиска)) > 26 Тогда
		Возврат СтрокаПоиска;
	КонецЕсли;
	
	// Попробуем получить Код БК
	СтрокаПоискаБезПробелов = СтрЗаменить(СтрокаПоиска, " ", "");
	
	// В Коде БК должны быть только цифры
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаПоискаБезПробелов) Тогда
		Возврат СтрокаПоиска;
	КонецЕсли;

	Возврат СтрокаПоискаБезПробелов;
	
КонецФункции

Функция ТаблицаКБКСФильтрамиПоСвойствамОрганизации(Организация, ДатаНачалаПериода, ДатаОкончанияПериода)
	
	ТаблицаКБК = ПолучитьТаблицуКБК();
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Возврат ТаблицаКБК;
	КонецЕсли;
	
	Отбор = Новый Структура();
	
	// Признаки ООО/ИП с сотрудниками/ИП без сотрудников являются взаимоисключающими, поэтому
	// на них можно накладывать набор одновременно.
	ЭтоЮрЛицо = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
	Если ЭтоЮрЛицо Тогда
		Отбор.Вставить("ДоступноДляОрганизаций", Истина);
	Иначе
		ИПИспользуетТрудНаемныхРаботников = РегламентированнаяОтчетность.ИПИспользуетТрудНаемныхРаботников(Организация);
		Если ИПИспользуетТрудНаемныхРаботников Тогда
			Отбор.Вставить("ДоступноДляИПССотрудниками", Истина);
		Иначе
			Отбор.Вставить("ДоступноДляИПБезСотрудников", Истина);
		КонецЕсли;
	КонецЕсли;
	
	СистемыНалогообложения = СистемыНалогообложения(Организация, ДатаНачалаПериода, ДатаОкончанияПериода);
	
	Если СистемыНалогообложения.Количество() > 0 Тогда

		ТаблицаКБК = ТаблицаКБК.Скопировать(Отбор);
		ТаблицаКБК.Колонки.Добавить("ПоддерживаетсяДляДаннойОрганизации");
		
		// Признаки систем налогообложения являются взаимодополняемыми, так как у одной организации
		// может быть различное сочетание этих признаков.

		Для каждого СтрокаТаблицыКБК Из ТаблицаКБК Цикл
			Для каждого СистемаНалогообложения Из СистемыНалогообложения Цикл
				
				ПоддерживаетсяДляДаннойОрганизации = 
					ТаблицаКБК.Колонки.Найти(СистемаНалогообложения) <> Неопределено 
					И СтрокаТаблицыКБК[СистемаНалогообложения] = Истина 
					ИЛИ ТаблицаКБК.Колонки.Найти(СистемаНалогообложения) = Неопределено;
				
				Если ПоддерживаетсяДляДаннойОрганизации Тогда
					СтрокаТаблицыКБК["ПоддерживаетсяДляДаннойОрганизации"]  = Истина;
					Прервать;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
		Отбор = Новый Структура();
		Отбор.Вставить("ПоддерживаетсяДляДаннойОрганизации", Истина);
		ТаблицаКБК = ТаблицаКБК.Скопировать(Отбор);
		ТаблицаКБК.Колонки.Удалить("ПоддерживаетсяДляДаннойОрганизации");
		
	Иначе
		// Отбор только по виду организации без учета системы налогообложения.
		ТаблицаКБК = ТаблицаКБК.Скопировать(Отбор);
	КонецЕсли;
	
	Возврат ТаблицаКБК;
	
КонецФункции

Функция ТаблицаНалоговПоГруппам(
		ЕстьДетализацияПоКБК, 
		Организация, 
		ДатаНачалаПериода,
		ДатаОкончанияПериода,
		ГруппыСПодгруппами = Неопределено) Экспорт
		
	// ДатаНачалаПериода и ДатаОкончанияПериода указываются одновременно для случая, если за указанный период пользователь
	// поменял систему налогообложения и некоторые КБК ему могут быть недоступны.
	// Чтобы такой проблемы не было, КБК показываются для систем и на начало периода и на конец периода.
	
	ТаблицаКБК = ТаблицаКБКСФильтрамиПоСвойствамОрганизации(Организация, ДатаНачалаПериода, ДатаОкончанияПериода);
	
	Если ГруппыСПодгруппами = Неопределено Тогда
		ГруппыСПодгруппами = Новый СписокЗначений;
	КонецЕсли;
	
	ОпределитьГруппыСПодгруппами(ТаблицаКБК, ГруппыСПодгруппами);
	
	Если НЕ ЕстьДетализацияПоКБК Тогда
		ТаблицаКБК = ТаблицаКБК.Скопировать(, "Папка, Налог");
		ТаблицаКБК.Свернуть("Папка, Налог");
	КонецЕсли;

	ТаблицаКБК.Колонки.Добавить("ПапкаУровня1", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	ТаблицаКБК.Колонки.Добавить("ПапкаУровня2", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(100)));
	
	Для каждого СтрокаТаблицыКБК Из ТаблицаКБК Цикл
		
		ПозицияСлеша = Найти(СтрокаТаблицыКБК.Папка, "/");
		
		Если ПозицияСлеша > 0 Тогда
			ИмяРодительскойПапки = СокрЛП(Лев(СтрокаТаблицыКБК.Папка, ПозицияСлеша - 1));
			СтрокаТаблицыКБК.ПапкаУровня1 = ИмяРодительскойПапки;
			СтрокаТаблицыКБК.ПапкаУровня2 = СокрЛП(Сред(СтрокаТаблицыКБК.Папка, ПозицияСлеша + 1));
		Иначе
			ПорядковыйНомер = Лев(СтрокаТаблицыКБК.Папка,3);
			СтрокаТаблицыКБК.ПапкаУровня1 = ПорядковыйНомер + СтрокаТаблицыКБК.Налог;
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаКБК.Колонки.Удалить("Папка");
	
	Если ЕстьДетализацияПоКБК Тогда
		ТаблицаКБК.Сортировать("ПапкаУровня1, ПапкаУровня2, Налог, КБК");
	Иначе
		ТаблицаКБК.Сортировать("ПапкаУровня1, ПапкаУровня2, Налог");
	КонецЕсли;
	
	Возврат ТаблицаКБК;
	
КонецФункции

Функция ВсеНалоги(Организация, ДатаНачалаПериода, ДатаОкончанияПериода) Экспорт
	
	ТаблицаКБК = ТаблицаНалоговПоГруппам(
		Ложь, 
		Организация,
		ДатаНачалаПериода,
		ДатаОкончанияПериода);
		
	ПапкиУровня1 = ТаблицаКБК.ВыгрузитьКолонку("ПапкаУровня1");
	ПапкиУровня2 = ТаблицаКБК.ВыгрузитьКолонку("ПапкаУровня2");
	Налог 		 = ТаблицаКБК.ВыгрузитьКолонку("Налог");
	
	ВсеНалогиИзМакета = ПапкиУровня1;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ПапкиУровня1, ПапкиУровня2);
	
	// Обрезаем номер только у папок
	Для НомерСтроки = 0 По ВсеНалогиИзМакета.Количество() - 1 Цикл
		ВсеНалогиИзМакета[НомерСтроки] = Сред(ВсеНалогиИзМакета[НомерСтроки], 4);
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВсеНалогиИзМакета, Налог);
	
	ВсеНалогиИзМакета = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ВсеНалогиИзМакета);
	
	Возврат ВсеНалогиИзМакета;
	
КонецФункции
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СистемыНалогообложения(Организация, ДатаНачалаПериода, ДатаОкончанияПериода)
	
	СистемыНалогообложенияНаНачалоПериода = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		Организация,
		ДатаНачалаПериода,
		"СистемыНалогообложения,").СистемыНалогообложения;
		
	СистемыНалогообложенияНаНачалоПериода = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СистемыНалогообложенияНаНачалоПериода, 
		",", 
		Истина, 
		Истина);
		
	СистемыНалогообложенияНаКонецПериода = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(
		Организация,
		ДатаОкончанияПериода,
		"СистемыНалогообложения,").СистемыНалогообложения;
		
	СистемыНалогообложенияНаКонецПериода = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СистемыНалогообложенияНаКонецПериода, 
		",", 
		Истина, 
		Истина);
		
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(
		СистемыНалогообложенияНаНачалоПериода, 
		СистемыНалогообложенияНаКонецПериода, 
		Истина);
	
	Возврат СистемыНалогообложенияНаНачалоПериода;
	
КонецФункции

#Область ПечатнаяФормаСверки


#Область ВерхняяЧасть

Процедура ЗаполнитьВерхнююЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса)

	ВерхняяЧастьБланка = Бланк.ПолучитьОбласть("ВерхняяЧасть");
	
	ЗаполнитьКодИФНС(Сверка, Бланк, ВерхняяЧастьБланка);
	ЗаполнитьНаименование(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьИННЦеликомИПосимвольно(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьИндекс(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьАдрес(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьКПП(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьКодИФНСОтвета(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьКодЗапроса(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьФорматОтвета(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьГод(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьПериод(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса);
	
	ТабДокумент.Вывести(ВерхняяЧастьБланка);

КонецПроцедуры

Процедура ЗаполнитьКодИФНС(Сверка, Бланк, ВерхняяЧастьБланка)
	
	// Если организация состоит на учете в двух и более ИФНС и нужна справка о расчетах со всеми ИФНС, 
	// то в сверке в строке "Код ИФНС" указывается значение "0000", КПП не указывается.
	
	// Получаем данные.
	Если НЕ ЗначениеЗаполнено(Сверка.Получатель) Тогда
		КодИФНСПолучателя = "0000";
	Иначе
		КодИФНСПолучателя = СокрЛП(Сверка.Получатель.Код);
	КонецЕсли;
	
	// Выводим в макет.
	ВывестиПосимвольно(ВерхняяЧастьБланка, КодИФНСПолучателя, "ИФНС", 4);
	
КонецПроцедуры

Процедура ЗаполнитьНаименование(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	Наименование = "";
	
	Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
		Наименование = СокрЛП(ПараметрыЗапроса.НаимЮЛПол);
	Иначе
		Наименование =
			СокрЛП(ПараметрыЗапроса.ИПФамилия) + " " + 
			СокрЛП(ПараметрыЗапроса.ИПИмя) + " " +
			СокрЛП(ПараметрыЗапроса.ИПОтчество);
	КонецЕсли;

	// Выводим в макет.
	ВерхняяЧастьБланка.Параметры["Наименование"] = Наименование;
	
КонецПроцедуры

Процедура ЗаполнитьИННЦеликомИПосимвольно(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	ИНН = "";
	
	Если ПараметрыЗапроса.ПрПодп = 1 Тогда // отправитель - налогоплательщик
		Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
			ИНН = СокрЛП(ПараметрыЗапроса.ИННЮЛ);
		Иначе
			ИНН = СокрЛП(ПараметрыЗапроса.ИННФЛ);
		КонецЕсли;
	Иначе
		СвДоверенность = ПараметрыЗапроса.Доверенность;
		СвПредст = СвДоверенность.СвУпПред.СвПред;
		Если СвПредст.Свойство("СвОрг") Тогда // представитель - ЮЛ
			ИНН = СокрЛП(СвПредст.СвОрг.ИННЮЛ);
		Иначе
			Если СвПредст.СведФизЛ.ЯвляетсяСотрудникомОрганизации Тогда
				Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
					ИНН = СокрЛП(ПараметрыЗапроса.ИННЮЛ);
				Иначе
					ИНН = СокрЛП(ПараметрыЗапроса.ИННФЛ);
				КонецЕсли;
			Иначе	
				ИНН = СокрЛП(СвПредст.СведФизЛ.ИННФЛ);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Выводим в макет.
	ВерхняяЧастьБланка.Параметры["ИНН"] = ИНН;
	ВывестиПосимвольно(ВерхняяЧастьБланка, ИНН, "ИНН", 12);
	
КонецПроцедуры

Процедура ЗаполнитьИндекс(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	Индекс = "";
	Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
		АдрНП = РегламентированнаяОтчетностьКлиентСервер.РазложитьАдрес(ПараметрыЗапроса.АдрЮр);
	Иначе
		АдрНП = РегламентированнаяОтчетностьКлиентСервер.РазложитьАдрес(ПараметрыЗапроса.АдрМЖ);
	КонецЕсли;
	Индекс = АдрНП.Индекс;
	
	// Выводим в макет.
	ВывестиПосимвольно(ВерхняяЧастьБланка, Индекс, "Индекс", 6);
	
КонецПроцедуры

Процедура ЗаполнитьАдрес(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	Адрес = "";
	
	Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
		Адрес = ПараметрыЗапроса.АдрЮр;
	Иначе
		Адрес = ПараметрыЗапроса.АдрМЖ;
	КонецЕсли;
	Адрес = РегламентированнаяОтчетностьКлиентСервер.ПредставлениеАдресаВФормате9Запятых(Адрес, Истина);
	
	// Выводим в макет.
	ВерхняяЧастьБланка.Параметры["Адрес"] = Адрес;
	
КонецПроцедуры

Процедура ЗаполнитьКПП(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	КПП = "";
	
	Если ПараметрыЗапроса.ПрПодп = 1 Тогда // отправитель - налогоплательщик
		Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
			КПП = СокрЛП(ПараметрыЗапроса.КППЮЛ);
		КонецЕсли;
	Иначе
		СвДоверенность = ПараметрыЗапроса.Доверенность;
		СвПредст = СвДоверенность.СвУпПред.СвПред;
		Если СвПредст.Свойство("СвОрг") Тогда // представитель - ЮЛ
			КПП = СокрЛП(СвПредст.СвОрг.КПП);
		Иначе
			Если СвПредст.СведФизЛ.ЯвляетсяСотрудникомОрганизации Тогда
				Если НЕ ПараметрыЗапроса.ЭтоПБОЮЛ Тогда
					КПП = СокрЛП(ПараметрыЗапроса.КППЮЛ);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Выводим в макет.
	ВывестиПосимвольно(ВерхняяЧастьБланка, КПП, "КПП", 9, "");
	
КонецПроцедуры

Процедура ЗаполнитьКодИФНСОтвета(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	ИНФСОтвета = "";
	
	Если НЕ ЗначениеЗаполнено(Сверка.Получатель) Тогда
		ИНФСОтвета = СокрЛП(РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Сверка.Организация, , "КодНО").КодНО);
	Иначе
		ИНФСОтвета = СокрЛП(Сверка.Получатель.Код);
	КонецЕсли;
	
	// Выводим в макет.
	ВывестиПосимвольно(ВерхняяЧастьБланка, ИНФСОтвета, "ИНФСОтвета", 4);
	
КонецПроцедуры

Процедура ЗаполнитьКодЗапроса(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	СоответствиеВидаУслугиКоду = Новый Соответствие;
	СоответствиеВидаУслугиКоду.Вставить(Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом, "1");
	СоответствиеВидаУслугиКоду.Вставить(Перечисления.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом, "2");
	СоответствиеВидаУслугиКоду.Вставить(Перечисления.ВидыУслугПриИОН.ПредставлениеПеречняБухгалтерскойИНалоговойОтчетности, "3");
	СоответствиеВидаУслугиКоду.Вставить(Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов, "4");
	СоответствиеВидаУслугиКоду.Вставить(Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате, "5");

	КодЗапроса = СоответствиеВидаУслугиКоду[Сверка.ВидУслуги];
	
	// Выводим в макет.
	ВерхняяЧастьБланка.Параметры["КодЗапроса"] = КодЗапроса;
	
КонецПроцедуры

Процедура ЗаполнитьФорматОтвета(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	СоответствиеФорматовОтветовИдентификатору = Новый Соответствие;
	СоответствиеФорматовОтветовИдентификатору.Вставить(Перечисления.ФорматОтветаНаЗапросИОН.RTF, "1");
	СоответствиеФорматовОтветовИдентификатору.Вставить(Перечисления.ФорматОтветаНаЗапросИОН.XML, "2");
	СоответствиеФорматовОтветовИдентификатору.Вставить(Перечисления.ФорматОтветаНаЗапросИОН.XLS, "3");
	СоответствиеФорматовОтветовИдентификатору.Вставить(Перечисления.ФорматОтветаНаЗапросИОН.PDF, "4");

	ФорматОтвета = СоответствиеФорматовОтветовИдентификатору[Сверка.ФорматОтвета];
	
	// Выводим в макет.
	ВерхняяЧастьБланка.Параметры["ФорматОтвета"] = ФорматОтвета;
	
КонецПроцедуры

Процедура ЗаполнитьГод(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	// Получаем данные.
	Год = "";
	Если Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеВыпискиОперацийИзКарточкиРасчетыСБюджетом Тогда
		Год = Формат(Сверка.ДатаОкончанияПериода, "ДФ=yyyy");
	КонецЕсли;

	// Выводим в макет.
	ВывестиПосимвольно(ВерхняяЧастьБланка, Год, "Год", 4, "");
	
КонецПроцедуры

Процедура ЗаполнитьПериод(Сверка, Бланк, ВерхняяЧастьБланка, ПараметрыЗапроса)
	
	ВерхняяЧастьБланка.Параметры["Период2"] = НСтр("ru = 'c <__.__.____> по <__.__.____>'");
	ВерхняяЧастьБланка.Параметры["Период3"] = НСтр("ru = 'на <__.__.____>'");
	ВерхняяЧастьБланка.Параметры["Период4"] = НСтр("ru = 'год <__.__.__.__> на <__.__.____>'");

	Если Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеПеречняБухгалтерскойИНалоговойОтчетности Тогда
		
		ДатаНач = Формат(Сверка.ДатаНачалаПериода, "ДФ=dd.MM.yyyy");
		ДатаКон = Формат(Сверка.ДатаОкончанияПериода, "ДФ=dd.MM.yyyy");
		Период2 = НСтр("ru = 'c <%1> по <%2>'");
		
		Период2 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Период2,
			ДатаНач,
			ДатаКон);
		
		ВерхняяЧастьБланка.Параметры["Период2"] = Период2;

	ИначеЕсли Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОСостоянииРасчетовСБюджетом
		ИЛИ Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеСправкиОбИсполненииОбязанностейПоУплате Тогда
		
		НаДату  = Формат(Сверка.ДатаОкончанияПериода, "ДФ=dd.MM.yyyy");
		Период3 = НСтр("ru = 'на <%1>'");
		
		Период3 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Период3,
			НаДату);
		
		ВерхняяЧастьБланка.Параметры["Период3"] = Период3;
		
	ИначеЕсли Сверка.ВидУслуги = Перечисления.ВидыУслугПриИОН.ПредставлениеАктовСверкиРасчетов Тогда
		
		Год 	= Формат(Сверка.ДатаНачалаПериода, "ДФ=yyyy");
		НаДату 	= Формат(Сверка.ДатаОкончанияПериода, "ДФ=dd.MM.yyyy");
		Период4 = НСтр("ru = 'год <%1> на <%2>'");
		
		Период4 = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			Период4,
			Год,
			НаДату);
		
		ВерхняяЧастьБланка.Параметры["Период4"] = Период4;

	КонецЕсли;

КонецПроцедуры
	
#КонецОбласти

#Область Таблица

Процедура ЗаполнитьТабличнуюЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса)

	СтрокаТабличнойЧастиБланка = Бланк.ПолучитьОбласть("Таблица");
	ТаблицаКБК	= ПолучитьТаблицуКБК();
	
	Для каждого Налог Из Сверка.ЗапрашиваемыеНалоги Цикл
		
		СтрокаТабличнойЧастиБланка.Параметры["КБК"] 				= Налог.КБК;
		СтрокаТабличнойЧастиБланка.Параметры["ОКАТОИлиОКТМО"] 		= Налог.ОКАТО;
		СтрокаТабличнойЧастиБланка.Параметры["НаименованиеНалога"] 	= НаименованиеКБК(Налог.КБК, ТаблицаКБК);
		
		ТабДокумент.Вывести(СтрокаТабличнойЧастиБланка);
	
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область НижняяЧасть

Процедура ЗаполнитьНижнююЧастьСверки(Сверка, ТабДокумент, Бланк, ПараметрыЗапроса)

	НижняяЧастьБланка = Бланк.ПолучитьОбласть("НижняяЧасть");
	
	ЗаполнитьПризнакУполномоченногоПредставителя(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьПодписанта(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса);
	ЗаполнитьДатуСверки(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса);
	
	ТабДокумент.Вывести(НижняяЧастьБланка);

КонецПроцедуры

Процедура ЗаполнитьПризнакУполномоченногоПредставителя(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса)

	НижняяЧастьБланка.Параметры["ПризнакУполномоченногоПредставителя"] = ПараметрыЗапроса.ПрПодп;

КонецПроцедуры

Процедура ЗаполнитьПодписанта(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса)

	Если ПараметрыЗапроса.ПрПодп = 1 Тогда
		
		ФИОПодписанта = РегламентированнаяОтчетность.РазложитьФИО(ПараметрыЗапроса.ФИОРук);
		
		ФИО = Новый Структура();
		ФИО.Вставить("Фамилия", 	СокрЛП(ФИОПодписанта.Фамилия));
		ФИО.Вставить("Имя", 		СокрЛП(ФИОПодписанта.Имя));
		ФИО.Вставить("Отчество", 	СокрЛП(ФИОПодписанта.Отчество));
	
	Иначе
		
		ФИОПодписанта = ПараметрыЗапроса.Доверенность.СвУпПред.СвПред.СведФизЛ.ФИО;
		
		ФИО = Новый Структура();
		ФИО.Вставить("Фамилия", 	СокрЛП(ФИОПодписанта.Фамилия));
		ФИО.Вставить("Имя", 		СокрЛП(ФИОПодписанта.Имя));
		ФИО.Вставить("Отчество", 	СокрЛП(ФИОПодписанта.Отчество));
		
	КонецЕсли;
			
	Подписант = ФизическиеЛицаКлиентСервер.ФамилияИнициалы(ФИО);
	
	НижняяЧастьБланка.Параметры["ФИО"] = Подписант;

КонецПроцедуры

Процедура ЗаполнитьДатуСверки(Сверка, Бланк, НижняяЧастьБланка, ПараметрыЗапроса)

	УстановитьПривилегированныйРежим(Истина);
	
	ЦиклОбмена = ДокументооборотСКОВызовСервера.ПолучитьПоследнийЦиклОбмена(Сверка);
	
	КонтекстЭДОСервер 	= ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	СообщенияЦикла		= КонтекстЭДОСервер.ПолучитьСообщенияЦиклаОбмена(ЦиклОбмена);
	СтрЗапросыНП 		= СообщенияЦикла.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыТранспортныхСообщений.ЗапросНП));
	
	Если СтрЗапросыНП.Количество() = 0 Тогда
		НижняяЧастьБланка.Параметры["ДатаСверки"] = Формат(ТекущаяДатаСеанса(), "ДЛФ=D");
	Иначе
		НижняяЧастьБланка.Параметры["ДатаСверки"] = Формат(СтрЗапросыНП[0].ДатаТранспорта, "ДЛФ=DD");
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыПечатнойФормы

Функция ПараметрыЗапроса(Сверка)

	УстановитьПривилегированныйРежим(Истина);
	
	КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	Возврат КонтекстЭДОСервер.СформироватьПараметрыЗапроса(Сверка);

КонецФункции

Процедура ВывестиПосимвольно(
		ТабличныйДокумент, 
		Значение, 
		ПрефиксИмениПараметра, 
		КоличествоКлеток, 
		СимволНаполнения = "-")
	
	ДлинаЗначения = СтрДлина(Значение);
	Для НомерСимвола = 0 По КоличествоКлеток - 1 Цикл
		
		ИмяПраметра = ПрефиксИмениПараметра + Строка(НомерСимвола + 1);
		
		Если НомерСимвола > ДлинаЗначения - 1 Тогда
			ЗначениеПараметра = СимволНаполнения;
		Иначе
			ЗначениеПараметра = Сред(Значение, НомерСимвола + 1, 1);
		КонецЕсли;
		
		ТабличныйДокумент.Параметры[ИмяПраметра] = ЗначениеПараметра;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

Процедура ОпределитьГруппыСПодгруппами(ТаблицаКБК, ГруппыСПодгруппами)
	
	ГруппыСПодгруппами.Очистить();
	
	Папки = ТаблицаКБК.Скопировать(,"Папка");
	Папки.Свернуть("Папка");
	
	Для каждого Строка Из Папки Цикл
		
		ПозицияСлеша = Найти(Строка.Папка, "/");
		
		Если ПозицияСлеша > 0 Тогда
			
			ИмяРодительскойПапки = СокрЛП(Лев(Строка.Папка, ПозицияСлеша - 1));
			
			ГруппыСПодгруппами.Добавить(ИмяРодительскойПапки);
			
		КонецЕсли;
	
	КонецЦикла; 
	
КонецПроцедуры 

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	// инициализируем контекст ЭДО - модуль обработки
	ТекстСообщения = "";
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
	Если КонтекстЭДО = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КонтекстЭДО.ОбработкаПолученияФормы("Документ", "ЗапросНаИнформационноеОбслуживаниеНалогоплательщика", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
