
#Область СлужебныйПрограммныйИнтерфейс

#Область РаботаСОтчетами

// Печать отчета Расчетно-платежная ведомость (0504401), Расчетная ведомость (0504402).
//
Функция Печать0504401(Документ, ИдентификаторВариантаОтчета = "ПФ_MXL_0504401с2015") Экспорт
	
	// "ПФ_MXL_0504401с2015" в "Форма0504401с2015" и т.п.
	КлючВарианта = СтрЗаменить(ИдентификаторВариантаОтчета, "ПФ_MXL_", "Форма");
	
	СпособыВыплатыВедомости = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "СпособВыплаты");
	ХарактерыВыплаты = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СпособыВыплатыВедомости, "ХарактерВыплаты");
	
	Если ХарактерыВыплаты = Перечисления.ХарактерВыплатыЗарплаты.Аванс Тогда
		ОтчетОбъект = Отчеты.АнализНачисленийИУдержанийАвансом.Создать();
		ИдентификаторОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Отчет.АнализНачисленийИУдержанийАвансом");
		ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(КлючВарианта + "ПерваяПоловинаМесяца");
	Иначе
		ОтчетОбъект = Отчеты.АнализНачисленийИУдержаний.Создать();
		ИдентификаторОтчета = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Отчет.АнализНачисленийИУдержаний");
		ВариантОтчета = ОтчетОбъект.СхемаКомпоновкиДанных.ВариантыНастроек.Найти(КлючВарианта);
	КонецЕсли;
	
	Если ВариантОтчета = Неопределено Тогда
		Возврат Новый ТабличныйДокумент;
	КонецЕсли;
	
	ОтчетОбъект.ИнициализироватьОтчет();
	
	НастройкиОтчета = ВариантОтчета.Настройки;
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "ПериодРегистрации, Подразделение");
	
	Период = РеквизитыДокумента.ПериодРегистрации;
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Период",        Новый СтандартныйПериод(НачалоМесяца(Период), КонецМесяца(Период)));
	СтруктураПараметров.Вставить("НачалоПериода", НачалоМесяца(Период));
	СтруктураПараметров.Вставить("КонецПериода",  КонецМесяца(Период));
	
	Для каждого ПараметрЗаполнения Из СтруктураПараметров Цикл
		
		ПараметрКомпоновкиДанных = Новый ПараметрКомпоновкиДанных(ПараметрЗаполнения.Ключ);
		ЗначениеПараметра = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрКомпоновкиДанных);
		Если ЗначениеПараметра <> Неопределено Тогда
			ЗначениеПараметра.Значение = ПараметрЗаполнения.Значение;
			ЗначениеПараметра.Использование = Истина;
		Иначе
			НовыйПараметр = НастройкиОтчета.ПараметрыДанных.Элементы.Добавить();
			НовыйПараметр.Параметр = ПараметрКомпоновкиДанных;
			НовыйПараметр.Значение = ПараметрЗаполнения.Значение;
			НовыйПараметр.Использование = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеВедомости = Документы[Документ.Метаданные().Имя].ДанныеВедомостиДляПечати(Документ);
	СписокСотрудников = ДанныеВедомости.ВыгрузитьКолонку("Сотрудник");
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор, "Сотрудник.ГоловнойСотрудник", СписокСотрудников, ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	
	Если ЗначениеЗаполнено(РеквизитыДокумента.Подразделение) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			НастройкиОтчета.Отбор, "Подразделение", РеквизитыДокумента.Подразделение, ВидСравненияКомпоновкиДанных.ВИерархии, , Истина);
		КонецЕсли;
		
	ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиОтчета);
	
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("КлючВарианта", КлючВарианта);
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("Документ", Документ);
	ОтчетОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ДанныеВедомости", ДанныеВедомости);
	
	ДокументРезультат = Новый ТабличныйДокумент;
	
	ОтчетОбъект.СкомпоноватьРезультат(ДокументРезультат);
	
	Возврат ДокументРезультат;
	
КонецФункции

// Формирование отчета Анализ начислений и удержаний.
//
Процедура ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс = Ложь) Экспорт
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ПриКомпоновкеОтчетаАнализНачисленийИУдержаний(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, НаАванс)
	КонецЕсли;
	
	Если Не СтандартнаяОбработка Тогда
		Возврат
	КонецЕсли;
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Отчет.КомпоновщикНастроек);
	
	Если КлючВарианта = "Форма0504401" ИЛИ КлючВарианта = "Форма0504401с2015" ИЛИ КлючВарианта = "Форма0504402" Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
		ПриКомпоновкеРезультата0504401Или0504402(
			Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, КлючВарианта, НаАванс);
	КонецЕсли	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область РаботаСОтчетами

#Область ФормированиеОтчетовРасчетныеВедомости0504401_0504402

// Процедура формирования отчетов анализа начислений и удержаний.
//
Процедура ПриКомпоновкеРезультата0504401Или0504402(Отчет, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка, КлючВарианта, НаАванс = Ложь) Экспорт
	
	Попытка
		
		// Параметры документа
		ДокументРезультат.ТолькоПросмотр = Истина;
		ДокументРезультат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Форма0504401";
		ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		ДокументРезультат.АвтоМасштаб = Истина;
		
		НастройкиОтчетаАнализНачисленийИУдержаний = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
		
		// Нужно проверить включена ли группировка по подразделениям.
		ЕстьГруппировкаПоПодразделению = Ложь;
		ПараметрГруппировки = Новый ПараметрКомпоновкиДанных("РазбиватьПоПодразделениям");
		ЕстьГруппировкаПоПодразделению = НастройкиОтчетаАнализНачисленийИУдержаний.ПараметрыДанных.НайтиЗначениеПараметра(ПараметрГруппировки).Значение;
		
		ПриКомпоновкеРезультата0504401Или0504402ИзменитьГруппировки(НастройкиОтчетаАнализНачисленийИУдержаний.Структура, ЕстьГруппировкаПоПодразделению);
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
		ЗарплатаКадрыОтчеты.ЗаполнитьПользовательскиеПоляВариантаОтчета(КлючВарианта, НастройкиОтчетаАнализНачисленийИУдержаний, НаАванс);
		
		Если КлючВарианта = "Форма0504401с2015" ИЛИ КлючВарианта = "Форма0504402" Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
			
			ПерваяПоловинаМесяца = (КлючВарианта = "Форма0504402ПерваяПоловинаМесяца");
			
			Если ПерваяПоловинаМесяца Тогда
				КоличествоКолонокУдержаний = 2;
			Иначе
				КоличествоКолонокУдержаний = 4;
			КонецЕсли;
			
			ДополнительныеНачисления = УчетНачисленнойЗарплатыРасширенный.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийФорма0504401с2015();
			УчетНачисленнойЗарплаты.ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисления, НастройкиОтчетаАнализНачисленийИУдержаний, 4);
			ДополнительныеУдержания = УчетНачисленнойЗарплатыРасширенный.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийФорма0504401с2015(ПерваяПоловинаМесяца);
			УчетНачисленнойЗарплаты.ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеУдержания, НастройкиОтчетаАнализНачисленийИУдержаний, КоличествоКолонокУдержаний, "Удержания");
			
		Иначе
			
			ДополнительныеНачисления = УчетНачисленнойЗарплатыРасширенный.ДополнительныеНачисленияОтчетаАнализНачисленийИУдержанийФорма0504401();
			УчетНачисленнойЗарплаты.ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеНачисления, НастройкиОтчетаАнализНачисленийИУдержаний, 4);
			ДополнительныеУдержания = УчетНачисленнойЗарплатыРасширенный.ДополнительныеУдержанияОтчетаАнализНачисленийИУдержанийФорма0504401();
			УчетНачисленнойЗарплаты.ДобавитьПользовательскиеПоляДополнительныхНачисленийИУдержаний(ДополнительныеУдержания, НастройкиОтчетаАнализНачисленийИУдержаний, 4, "Удержания");
			
		КонецЕсли;
		
		МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(Отчет.СхемаКомпоновкиДанных,
			НастройкиОтчетаАнализНачисленийИУдержаний, ДанныеРасшифровки, , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		СоответствиеПользовательскихПолей = ЗарплатаКадрыОтчеты.СоответствиеПользовательскихПолей(НастройкиОтчетаАнализНачисленийИУдержаний);
		
		Если Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДанныеДокумента") Тогда
			НаборыВнешнихДанных = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.ДанныеДокумента;
		Иначе
			НаборыВнешнихДанных = ЗарплатаКадрыОтчеты.НаборыВнешнихДанныхАнализНачисленийИУдержаний();
		КонецЕсли;
		
		ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, НаборыВнешнихДанных, ДанныеРасшифровки, Истина);
		
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ДанныеОтчета = Новый ДеревоЗначений;
		ПроцессорВывода.УстановитьОбъект(ДанныеОтчета);
		ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
		
		Если КлючВарианта = "Форма0504401с2015" Тогда
			
			ПорядокДопНачислений = УчетНачисленнойЗарплаты.ПорядокДополнительныхНачислений(ДополнительныеНачисления, ДанныеОтчета, СоответствиеПользовательскихПолей, 5);
			ПорядокДопУдержаний = УчетНачисленнойЗарплаты.ПорядокДополнительныхУдержаний(ДополнительныеУдержания, ДанныеОтчета, СоответствиеПользовательскихПолей, 16);
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_0504401с2015");
			
		ИначеЕсли КлючВарианта = "Форма0504402"
			Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
			
			ПорядокДопНачислений = УчетНачисленнойЗарплаты.ПорядокДополнительныхНачислений(ДополнительныеНачисления, ДанныеОтчета, СоответствиеПользовательскихПолей, 6);
			ПорядокДопУдержаний = УчетНачисленнойЗарплаты.ПорядокДополнительныхУдержаний(ДополнительныеУдержания, ДанныеОтчета, СоответствиеПользовательскихПолей, 17);
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_0504402");
			
		Иначе
			
			ПорядокДопНачислений = УчетНачисленнойЗарплаты.ПорядокДополнительныхНачислений(ДополнительныеНачисления, ДанныеОтчета, СоответствиеПользовательскихПолей, 4);
			ПорядокДопУдержаний = УчетНачисленнойЗарплаты.ПорядокДополнительныхУдержаний(ДополнительныеУдержания, ДанныеОтчета, СоответствиеПользовательскихПолей, 13);
			Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_0504401");
			
		КонецЕсли;
		
		Макеты = Новый Структура("ШапкаДокумента,Шапка,Строка,ПустаяСтрока,Подвал,ИтогоПоСтранице");
		
		Если НаАванс Тогда
			Макеты.ШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокументаПерваяПоловина");
		Иначе
			Макеты.ШапкаДокумента = Макет.ПолучитьОбласть("ШапкаДокумента");
		КонецЕсли;
		
		Макеты.Шапка = Макет.ПолучитьОбласть("Шапка");
		Макеты.Строка = Макет.ПолучитьОбласть("Строка");
		Макеты.ПустаяСтрока = Макет.ПолучитьОбласть("Строка");
		Макеты.Подвал = Макет.ПолучитьОбласть("Подвал");
		Макеты.ИтогоПоСтранице = Макет.ПолучитьОбласть("ИтогоПоСтранице");
		
		Если Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("Документ") Тогда
			
			Ведомость = Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Документ;
			Если ЗначениеЗаполнено(Ведомость) Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				ДанныеВедомости = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ведомость, "Номер,Дата");
				УстановитьПривилегированныйРежим(Ложь);
				
				Макеты.ШапкаДокумента.Параметры.Заполнить(ДанныеВедомости);
				Если ЗначениеЗаполнено(Макеты.ШапкаДокумента.Параметры.Номер) Тогда
					Макеты.ШапкаДокумента.Параметры.Номер = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Макеты.ШапкаДокумента.Параметры.Номер, Истина, Истина);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Для каждого СтрокаМесяца Из ДанныеОтчета.Строки Цикл
			Для Каждого СтрокаОрганизации Из СтрокаМесяца.Строки Цикл
				ПриКомпоновкеРезультата0504401Или0504402ВывестиОрганизацию(Отчет, СтрокаОрганизации, ДокументРезультат, Макеты, ЕстьГруппировкаПоПодразделению, СоответствиеПользовательскихПолей, ПорядокДопНачислений, ПорядокДопУдержаний);
			КонецЦикла;
		КонецЦикла;
		
		СтандартнаяОбработка = Ложь;
		
	Исключение
		Инфо = ИнформацияОбОшибке();
		ВызватьИсключение НСтр("ru = 'В настройку отчета внесены критичные изменения. Отчет не будет сформирован.'") + " " + КраткоеПредставлениеОшибки(Инфо);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата0504401Или0504402ИзменитьГруппировки(Структура, ЕстьГруппировкаПоПодразделению)
	
	Для каждого ЭлементСтруктуры Из Структура Цикл
		
		Если ЭлементСтруктуры.Имя = "Подразделение" Тогда
			Если ЕстьГруппировкаПоПодразделению Тогда
				ЭлементСтруктуры.Использование = Истина;
			Иначе
				ЭлементСтруктуры.Использование = Ложь;
			КонецЕсли;
		ИначеЕсли ЭлементСтруктуры.Имя = "Сотрудник" Тогда
			Если ЕстьГруппировкаПоПодразделению Тогда
				ЭлементСтруктуры.Использование = Ложь;
			Иначе
				ЭлементСтруктуры.Использование = Истина;
			КонецЕсли;
		КонецЕсли;
		
		ПриКомпоновкеРезультата0504401Или0504402ИзменитьГруппировки(ЭлементСтруктуры.Структура, ЕстьГруппировкаПоПодразделению);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата0504401Или0504402ВывестиОрганизацию(Отчет, СтрокаОрганизации, ДокументРезультат, Макеты, ЕстьГруппировкаПоПодразделению, СоответствиеПользовательскихПолей, ПорядокДопНачислений, ПорядокДопУдержаний)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ОрганизацииИДаты = ЗарплатаКадрыРасширенный.ПараметрОрганизацииИДатыДляПолучитьИННиКППОрганизаций();
	СтрокаОрганизацииИДаты = ОрганизацииИДаты.Добавить();
	СтрокаОрганизацииИДаты.Организация = СтрокаОрганизации.Организация;
	СтрокаОрганизацииИДаты.ДатаСведенийОрганизации = СтрокаОрганизации.МесяцНачисления;
	ОрганизацииИСведенияОНих = ЗарплатаКадрыРасширенный.ПолучитьИННиКППОрганизаций(ОрганизацииИДаты);
	СведенияОбОрганизации = ОрганизацииИСведенияОНих[СтрокаОрганизации.Организация];
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Отчет.КомпоновщикНастроек);
	
	Если ЕстьГруппировкаПоПодразделению Тогда
		Для Каждого СтрокаПодразделения Из СтрокаОрганизации.Строки Цикл
			ПриКомпоновкеРезультата0504401Или0504402ВывестиПодразделение(Отчет, СтрокаПодразделения, ДокументРезультат, Макеты, СоответствиеПользовательскихПолей, ПорядокДопНачислений, ПорядокДопУдержаний);
		КонецЦикла;
	Иначе
		
		Если ДокументРезультат.ВысотаТаблицы > 0 Тогда
			ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		КВыплатеПоВедомости = 0;
		
		Макеты.ШапкаДокумента.Параметры.Заполнить(СтрокаОрганизации);
		Макеты.Шапка.Параметры.Заполнить(СтрокаОрганизации);
		
		ПараметрыЗаполненияШапкиИПодвала = ПриКомпоновкеРезультата0504401Или0504402ПараметрыЗаполненияШапкиИПодвала(Отчет, СтрокаОрганизации.Организация, СтрокаОрганизации.МесяцНачисления);
		
		Для каждого СтрокаТаблицы Из ПорядокДопНачислений Цикл
			Макеты.Шапка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СтрокаТаблицы.Заголовок;
		КонецЦикла;
		
		Для каждого СтрокаТаблицы Из ПорядокДопУдержаний Цикл
			Макеты.Шапка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СтрокаТаблицы.Заголовок;
		КонецЦикла;
		
		Макеты.ШапкаДокумента.Параметры.Заполнить(ПараметрыЗаполненияШапкиИПодвала);
		Макеты.ШапкаДокумента.Параметры.Период = Формат(СтрокаОрганизации.МесяцНачисления, "ДФ='ММММ гггг ""г.""'");
		
		Если КлючВарианта = "Форма0504401с2015" ИЛИ КлючВарианта = "Форма0504402" Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
		
			СведенияОбОрганизации.Свойство("ИНН", Макеты.ШапкаДокумента.Параметры.ИНН);
			СведенияОбОрганизации.Свойство("КПП", Макеты.ШапкаДокумента.Параметры.КПП);
		
		КонецЕсли;
		
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.ШапкаДокумента, СтрокаОрганизации, СоответствиеПользовательскихПолей);
		
		ДанныеВедомости = Неопределено;
		Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДанныеВедомости", ДанныеВедомости);
		
		Если ДанныеВедомости = Неопределено Тогда
			КВыплате = 0;
		Иначе
			КВыплате = ДанныеВедомости.Итог("КВыплате");
			СтрокаОрганизации[СоответствиеПользовательскихПолей.Получить("КВыплате")] = КВыплате;
		КонецЕсли;
			
		Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Макеты.ШапкаДокумента.Параметры, "СуммаВсегоПрописью") Тогда
			Если КВыплате > 0 Тогда
				ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
				Макеты.ШапкаДокумента.Параметры.СуммаВсегоПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(КВыплате, ВалютаУчета);
			КонецЕсли;
		КонецЕсли;	
		
		Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода) Тогда
			Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода = Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода.ПолноеНаименование();
		КонецЕсли; 
		
		ДокументРезультат.Вывести(Макеты.ШапкаДокумента);
		
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.Шапка, СтрокаОрганизации, СоответствиеПользовательскихПолей);
		ДокументРезультат.Вывести(Макеты.Шапка);
		
		НомерСтроки = 0;
		ПромежуточныеИтоги = ПриКомпоновкеРезультата0504401Или0504402ПромежуточныеИтогиПоСтранице();
		
		Для Каждого СтрокаСотрудника Из СтрокаОрганизации.Строки Цикл
			ПриКомпоновкеРезультата0504401Или0504402ВывестиСотрудника(Отчет, НомерСтроки, СтрокаСотрудника, ДокументРезультат, Макеты, СоответствиеПользовательскихПолей, ПромежуточныеИтоги, ДанныеВедомости, КВыплатеПоВедомости, ПорядокДопНачислений, ПорядокДопУдержаний);
		КонецЦикла;

		ПриКомпоновкеРезультата0504401Или0504402ДополнитьСтраницу(НомерСтроки, Макеты, ДокументРезультат, ПромежуточныеИтоги);
		
		Макеты.Подвал.Параметры.Заполнить(СтрокаОрганизации);
		Макеты.Подвал.Параметры.Заполнить(ПараметрыЗаполненияШапкиИПодвала);
		
		Макеты.Подвал.Параметры.КВыплате = КВыплатеПоВедомости;
		
		ДокументРезультат.Вывести(Макеты.Подвал);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата0504401Или0504402ВывестиПодразделение(Отчет, СтрокаПодразделения, ДокументРезультат, Макеты, СоответствиеПользовательскихПолей, ПорядокДопНачислений, ПорядокДопУдержаний)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	ОрганизацииИДаты = ЗарплатаКадрыРасширенный.ПараметрОрганизацииИДатыДляПолучитьИННиКППОрганизаций();
	СтрокаОрганизацииИДаты = ОрганизацииИДаты.Добавить();
	СтрокаОрганизацииИДаты.Организация = СтрокаПодразделения.Организация;
	СтрокаОрганизацииИДаты.ДатаСведенийОрганизации = СтрокаПодразделения.МесяцНачисления;
	ОрганизацииИСведенияОНих = ЗарплатаКадрыРасширенный.ПолучитьИННиКППОрганизаций(ОрганизацииИДаты);
	СведенияОбОрганизации = ОрганизацииИСведенияОНих[СтрокаПодразделения.Организация];
	
	КВыплатеПоВедомости = 0;
	
	Макеты.ШапкаДокумента.Параметры.Заполнить(СтрокаПодразделения);
	Макеты.Шапка.Параметры.Заполнить(СтрокаПодразделения);
	
	ПараметрыЗаполненияШапкиИПодвала = ПриКомпоновкеРезультата0504401Или0504402ПараметрыЗаполненияШапкиИПодвала(Отчет, СтрокаПодразделения.Организация, СтрокаПодразделения.МесяцНачисления);
		
	Для каждого СтрокаТаблицы Из ПорядокДопНачислений Цикл
		Макеты.Шапка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СтрокаТаблицы.Заголовок;
	КонецЦикла;
	Для каждого СтрокаТаблицы Из ПорядокДопУдержаний Цикл
		Макеты.Шапка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СтрокаТаблицы.Заголовок;
	КонецЦикла;
	
	Макеты.ШапкаДокумента.Параметры.Заполнить(ПараметрыЗаполненияШапкиИПодвала);
	Макеты.ШапкаДокумента.Параметры.Период = Формат(СтрокаПодразделения.МесяцНачисления, "ДФ='ММММ гггг ""г.""'");
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Отчет.КомпоновщикНастроек);
	Если КлючВарианта = "Форма0504401с2015" Или КлючВарианта = "Форма0504402" Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
		
		СведенияОбОрганизации.Свойство("ИНН", Макеты.ШапкаДокумента.Параметры.ИНН);
		СведенияОбОрганизации.Свойство("КПП", Макеты.ШапкаДокумента.Параметры.КПП);
		
	КонецЕсли;
	
	ДанныеВедомости = Неопределено;
	Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("ДанныеВедомости", ДанныеВедомости);
	Если ДанныеВедомости = Неопределено Тогда
		КВыплате = 0;
	Иначе
		КВыплате = ДанныеВедомости.Итог("КВыплате");
		СтрокаПодразделения[СоответствиеПользовательскихПолей.Получить("КВыплате")] = КВыплате;
	КонецЕсли;
	Если КВыплате > 0 Тогда
		ВалютаУчета = ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
		Макеты.ШапкаДокумента.Параметры.СуммаВсегоПрописью = РаботаСКурсамиВалют.СформироватьСуммуПрописью(КВыплате, ВалютаУчета);
	КонецЕсли;
	
	ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.ШапкаДокумента, СтрокаПодразделения, СоответствиеПользовательскихПолей);
		
	Если НастройкиПечатныхФорм.ВыводитьПолнуюИерархиюПодразделений И ЗначениеЗаполнено(Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода) Тогда
		Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода = Макеты.ШапкаДокумента.Параметры.ПодразделениеНаКонецПериода.ПолноеНаименование();
	КонецЕсли; 
		
	ДокументРезультат.Вывести(Макеты.ШапкаДокумента);
	ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.Шапка, СтрокаПодразделения, СоответствиеПользовательскихПолей);
	ДокументРезультат.Вывести(Макеты.Шапка);
	НомерСтроки = 0;
	ПромежуточныеИтоги = ПриКомпоновкеРезультата0504401Или0504402ПромежуточныеИтогиПоСтранице();
	
	Для Каждого СтрокаСотрудника Из СтрокаПодразделения.Строки Цикл
		ПриКомпоновкеРезультата0504401Или0504402ВывестиСотрудника(Отчет, НомерСтроки, СтрокаСотрудника, ДокументРезультат, Макеты, СоответствиеПользовательскихПолей, ПромежуточныеИтоги, ДанныеВедомости, КВыплатеПоВедомости, ПорядокДопНачислений, ПорядокДопУдержаний);
	КонецЦикла;
	ПриКомпоновкеРезультата0504401Или0504402ДополнитьСтраницу(НомерСтроки, Макеты, ДокументРезультат, ПромежуточныеИтоги);
	
	Макеты.Подвал.Параметры.Заполнить(СтрокаПодразделения);
	Макеты.Подвал.Параметры.Заполнить(ПараметрыЗаполненияШапкиИПодвала);
	
	ДокументРезультат.Вывести(Макеты.Подвал);
	
КонецПроцедуры

Функция ПриКомпоновкеРезультата0504401Или0504402ПараметрыЗаполненияШапкиИПодвала(Отчет, Организация, ДатаОтчета)
	
	КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Отчет.КомпоновщикНастроек);
	
	ПоляПараметровЗаполнения = Новый Массив;
	ПоляПараметровЗаполнения.Добавить("Руководитель");
	ПоляПараметровЗаполнения.Добавить("ГлавныйБухгалтер");
	ПоляПараметровЗаполнения.Добавить("Кассир");
	ПоляПараметровЗаполнения.Добавить("Составил");
	ПоляПараметровЗаполнения.Добавить("ДолжностьСоставившего");
	ПоляПараметровЗаполнения.Добавить("Проверил");
	ПоляПараметровЗаполнения.Добавить("ДолжностьПроверившего");
	ПоляПараметровЗаполнения.Добавить("Раздатчик");
	ПоляПараметровЗаполнения.Добавить("ДолжностьРаздатчика");
	ПоляПараметровЗаполнения.Добавить("Ответственный");
	ПоляПараметровЗаполнения.Добавить("ДолжностьОтветственногоИсполнителя");
	
	ПараметрыЗаполнения = Новый Структура(СтрСоединить(ПоляПараметровЗаполнения, ", "));
	
	Документ = Неопределено;
	Отчет.КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Свойство("Документ", Документ);
	
	Если Документ <> Неопределено Тогда
		
		ДоступныеПоляДокумента = Новый Массив;
		Для Каждого ПолеПараметровЗаполнения Из ПоляПараметровЗаполнения Цикл
			Если Документ.Метаданные().Реквизиты.Найти(ПолеПараметровЗаполнения) <> Неопределено Тогда
				ДоступныеПоляДокумента.Добавить(ПолеПараметровЗаполнения);
			КонецЕсли	
		КонецЦикла;
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, СтрСоединить(ДоступныеПоляДокумента, ", "));
		ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, РеквизитыДокумента);
		
	Иначе
		
		ПараметрыЗаполнения = Новый Структура;
		КлючиОтветственныхЛиц = "";
		НастройкиОтчета = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
		
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Руководитель", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "ГлавныйБухгалтер", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Кассир", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Составил", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "ДолжностьСоставившего", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Проверил", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "ДолжностьПроверившего", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Раздатчик", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "ДолжностьРаздатчика", КлючиОтветственныхЛиц);
		ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, "Ответственный", КлючиОтветственныхЛиц);
		ПараметрДанных = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДолжностьОтветственного"));	
		Если ПараметрДанных <> Неопределено И ПараметрДанных.Использование Тогда
			ПараметрыЗаполнения.Вставить("ДолжностьОтветственногоИсполнителя", ПараметрДанных.Значение);
		КонецЕсли;
		
		Если Не ПустаяСтрока(КлючиОтветственныхЛиц) Тогда
			
			ПараметрыЗаполненияПоУмолчанию = Новый Структура("Организация," + КлючиОтветственныхЛиц, Организация);
			ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ПараметрыЗаполненияПоУмолчанию, КонецМесяца(ДатаОтчета));
			
			ПараметрыЗаполненияПоУмолчанию.Удалить("Организация");
			Для каждого КлючИЗначение Из ПараметрыЗаполненияПоУмолчанию Цикл
				ПараметрыЗаполнения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
			КонецЦикла;
			
		КонецЕсли; 
		
		ПараметрыЗаполнения.Вставить("Номер", "");
		ПараметрыЗаполнения.Вставить("Дата", "");
		
	КонецЕсли;
	
	МассивФизЛиц = Новый Массив;
	Если ПараметрыЗаполнения.Свойство("Руководитель") И ЗначениеЗаполнено(ПараметрыЗаполнения.Руководитель) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Руководитель);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("ГлавныйБухгалтер") И ЗначениеЗаполнено(ПараметрыЗаполнения.ГлавныйБухгалтер) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.ГлавныйБухгалтер);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("Кассир") И ЗначениеЗаполнено(ПараметрыЗаполнения.Кассир) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Кассир);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("Составил") И ЗначениеЗаполнено(ПараметрыЗаполнения.Составил) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Составил);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("Проверил") И ЗначениеЗаполнено(ПараметрыЗаполнения.Проверил) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Проверил);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("Раздатчик") И ЗначениеЗаполнено(ПараметрыЗаполнения.Раздатчик) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Раздатчик);
	КонецЕсли; 
	Если ПараметрыЗаполнения.Свойство("Ответственный") И ЗначениеЗаполнено(ПараметрыЗаполнения.Ответственный) Тогда
		МассивФизЛиц.Добавить(ПараметрыЗаполнения.Ответственный);
	КонецЕсли; 
	
	Если МассивФизЛиц.Количество() > 0 Тогда
		
		ФИОФизическихЛиц = ЗарплатаКадры.СоответствиеФИОФизЛицСсылкам(ДатаОтчета, МассивФизЛиц);
		
		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Руководитель];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("РуководительРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.ГлавныйБухгалтер];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("ГлавныйБухгалтерРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Кассир];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("КассирРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Составил];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("СоставилРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Проверил];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("ПроверилРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Раздатчик];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("РаздатчикРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 

		ФИО = ФИОФизическихЛиц[ПараметрыЗаполнения.Ответственный];
		Если ЗначениеЗаполнено(ФИО) Тогда
			ПараметрыЗаполнения.Вставить("ОтветственныйИсполнительРасшифровкаПодписи", ФизическиеЛицаЗарплатаКадры.РасшифровкаПодписи(ФИО));
		КонецЕсли; 
		
	КонецЕсли; 
	
	Возврат ПараметрыЗаполнения;
		
КонецФункции

Процедура ДобавитьПараметр(ПараметрыЗаполнения, НастройкиОтчета, ИмяПараметра, КлючиОтветственныхЛиц)
	
	ПараметрДанных = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(ИмяПараметра));	
	Если ПараметрДанных <> Неопределено И ПараметрДанных.Использование Тогда
		ПараметрыЗаполнения.Вставить(ИмяПараметра, ПараметрДанных.Значение);
	Иначе
		КлючиОтветственныхЛиц = ?(ПустаяСтрока(КлючиОтветственныхЛиц), "", КлючиОтветственныхЛиц + ",") + ИмяПараметра;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата0504401Или0504402ВывестиСотрудника(Отчет, НомерСтроки, СтрокаГоловногоСотрудника, ДокументРезультат, Макеты, СоответствиеПользовательскихПолей, ПромежуточныеИтоги, ДанныеВедомости, КВыплатеПоВедомости, ПорядокДопНачислений, ПорядокДопУдержаний)
	
	НастройкиПечатныхФорм = ЗарплатаКадрыПовтИсп.НастройкиПечатныхФорм();
	
	НомерСтроки = НомерСтроки + 1;
	
	МакетСотрудника = Новый ТабличныйДокумент;
	ПромежуточныеИтогиПоГоловномуСотруднику = ПриКомпоновкеРезультата0504401Или0504402ПромежуточныеИтогиПоСтранице();
	НесколькоРабочихМест = СтрокаГоловногоСотрудника.Строки.Количество() > 1;
	
	Для каждого СтрокаСотрудника Из СтрокаГоловногоСотрудника.Строки Цикл
		
		Если ДанныеВедомости <> Неопределено Тогда
			СтрокаДанныхВедомости = ДанныеВедомости.Найти(СтрокаСотрудника.Сотрудник, "Сотрудник");
			Если СтрокаДанныхВедомости <> Неопределено Тогда
				СтрокаСотрудника[СоответствиеПользовательскихПолей.Получить("КВыплате")] = СтрокаДанныхВедомости.КВыплате;
			КонецЕсли;
		КонецЕсли;
	
		Макеты.Строка.Параметры.Заполнить(СтрокаСотрудника);
		
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.Строка, СтрокаСотрудника, СоответствиеПользовательскихПолей);
		
		Для каждого СтрокаТаблицы Из ПорядокДопНачислений Цикл
			СуммаЯчейки = СтрокаСотрудника[СоответствиеПользовательскихПолей.Получить(СтрокаТаблицы.Имя)];
			Если СтрокаТаблицы.Имя = "ПрочиеНачисления" Тогда
				Для каждого КатегорияКолонки Из СтрокаТаблицы.КатегорииКолонки Цикл
					СуммаЯчейки = СуммаЯчейки + СтрокаСотрудника[СоответствиеПользовательскихПолей.Получить(КатегорияКолонки)];
				КонецЦикла;
			КонецЕсли;
			Макеты.Строка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СуммаЯчейки;
		КонецЦикла;
		
		Для каждого СтрокаТаблицы Из ПорядокДопУдержаний Цикл
			СуммаЯчейки = СтрокаСотрудника[СоответствиеПользовательскихПолей.Получить(СтрокаТаблицы.Имя)];
			Если СтрокаТаблицы.Имя = "ПрочиеУдержания" Тогда
				Для каждого КатегорияКолонки Из СтрокаТаблицы.КатегорииКолонки Цикл
					СуммаЯчейки = СуммаЯчейки + СтрокаСотрудника[СоответствиеПользовательскихПолей.Получить(КатегорияКолонки)];
				КонецЦикла;
			КонецЕсли;
			Макеты.Строка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СуммаЯчейки;
		КонецЦикла;
		
		Макеты.Строка.Параметры.НомерПП = НомерСтроки;
		
		Если Макеты.Строка.Параметры.КВыплате < 0 Тогда
			Макеты.Строка.Параметры.КВыплате = 0;
		КонецЕсли;
		
		ЗарплатаКадрыОтчеты.ДобавитьВПромежуточныйИтог(ПромежуточныеИтогиПоГоловномуСотруднику, Макеты.Строка.Параметры);
		КВыплатеПоВедомости = КВыплатеПоВедомости + Макеты.Строка.Параметры.КВыплате;
		
		Если НесколькоРабочихМест Тогда
			
			ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(
				Макеты.Строка, СтрокаГоловногоСотрудника, СоответствиеПользовательскихПолей,
				"ВсегоНачислено,НДФЛ,ПрочиеУдержания,ВсегоУдержано,ДолгЗаОрганизацией,ДолгЗаСотрудником,КВыплате");
				
			Для каждого СтрокаТаблицы Из ПорядокДопУдержаний Цикл
				СуммаЯчейки = СтрокаГоловногоСотрудника[СоответствиеПользовательскихПолей.Получить(СтрокаТаблицы.Имя)];
				Если СтрокаТаблицы.Имя = "ПрочиеУдержания" Тогда
					Для каждого КатегорияКолонки Из СтрокаТаблицы.КатегорииКолонки Цикл
						СуммаЯчейки = СуммаЯчейки + СтрокаГоловногоСотрудника[СоответствиеПользовательскихПолей.Получить(КатегорияКолонки)];
					КонецЦикла;
				КонецЕсли;
				Макеты.Строка.Параметры["Колонка" + СтрокаТаблицы.НомерКолонки] = СуммаЯчейки;
			КонецЦикла;
		
		КонецЕсли; 
			
		Если  СтрокаСотрудника.Сотрудник <> СтрокаСотрудника.ГоловнойСотрудник Тогда
			Макеты.Строка.Параметры.ДолжностьНаКонецПериодаНаименованиеКраткое = СтрокаСотрудника.СотрудникУточнениеНаименования;
		КонецЕсли; 
		
		МакетСотрудника.Вывести(Макеты.Строка);
		
	КонецЦикла;
	
	Если МакетСотрудника.ВысотаТаблицы > 1 Тогда
		
		КлючВарианта = ЗарплатаКадрыОтчеты.КлючВарианта(Отчет.КомпоновщикНастроек);
		Если КлючВарианта = "Форма0504401с2015" Или КлючВарианта = "Форма0504401" Тогда
			// Номер по порядку
			МакетСотрудника.Область(1, 1, МакетСотрудника.ВысотаТаблицы, 1).Объединить();
			// Табельный номер
			МакетСотрудника.Область(1, 2, МакетСотрудника.ВысотаТаблицы, 2).Объединить();
			// Всего начислено
			МакетСотрудника.Область(1, 14, МакетСотрудника.ВысотаТаблицы, 14).Объединить();
			// Удержания
			МакетСотрудника.Область(1, 15, МакетСотрудника.ВысотаТаблицы, 15).Объединить();
			МакетСотрудника.Область(1, 16, МакетСотрудника.ВысотаТаблицы, 16).Объединить();
			МакетСотрудника.Область(1, 17, МакетСотрудника.ВысотаТаблицы, 17).Объединить();
			МакетСотрудника.Область(1, 18, МакетСотрудника.ВысотаТаблицы, 18).Объединить();
			МакетСотрудника.Область(1, 19, МакетСотрудника.ВысотаТаблицы, 19).Объединить();
			МакетСотрудника.Область(1, 20, МакетСотрудника.ВысотаТаблицы, 20).Объединить();
		ИначеЕсли КлючВарианта = "Форма0504402"
			Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
			// Номер по порядку
			МакетСотрудника.Область(1, 1, МакетСотрудника.ВысотаТаблицы, 1).Объединить();
			// ФИО
			МакетСотрудника.Область(1, 2, МакетСотрудника.ВысотаТаблицы, 2).Объединить();
			// Табельный номер
			МакетСотрудника.Область(1, 3, МакетСотрудника.ВысотаТаблицы, 3).Объединить();
			МакетСотрудника.Область(1, 4, МакетСотрудника.ВысотаТаблицы, 4).Объединить();
			// Всего начислено
			МакетСотрудника.Область(1, 15, МакетСотрудника.ВысотаТаблицы, 15).Объединить();
			// Удержания
			МакетСотрудника.Область(1, 16, МакетСотрудника.ВысотаТаблицы, 16).Объединить();
			МакетСотрудника.Область(1, 17, МакетСотрудника.ВысотаТаблицы, 17).Объединить();
			МакетСотрудника.Область(1, 18, МакетСотрудника.ВысотаТаблицы, 18).Объединить();
			МакетСотрудника.Область(1, 19, МакетСотрудника.ВысотаТаблицы, 19).Объединить();
			МакетСотрудника.Область(1, 20, МакетСотрудника.ВысотаТаблицы, 20).Объединить();
			МакетСотрудника.Область(1, 21, МакетСотрудника.ВысотаТаблицы, 21).Объединить();
		КонецЕсли;
		Если КлючВарианта = "Форма0504401с2015" Тогда
			// Задолженность за организацией
			МакетСотрудника.Область(1, 21, МакетСотрудника.ВысотаТаблицы, 21).Объединить();
			// Задолженность за сотрудником
			МакетСотрудника.Область(1, 22, МакетСотрудника.ВысотаТаблицы, 22).Объединить();
			// К выплате
			МакетСотрудника.Область(1, 23, МакетСотрудника.ВысотаТаблицы, 23).Объединить();
			// Роспись
			МакетСотрудника.Область(1, 24, МакетСотрудника.ВысотаТаблицы, 24).Объединить();
			// ФИО
			МакетСотрудника.Область(1, 25, МакетСотрудника.ВысотаТаблицы, 28).Объединить();
		ИначеЕсли КлючВарианта = "Форма0504401" Тогда
			// К выплате
			МакетСотрудника.Область(1, 21, МакетСотрудника.ВысотаТаблицы, 21).Объединить();
			// Роспись
			МакетСотрудника.Область(1, 22, МакетСотрудника.ВысотаТаблицы, 22).Объединить();
			// ФИО
			МакетСотрудника.Область(1, 23, МакетСотрудника.ВысотаТаблицы, 25).Объединить();
		ИначеЕсли КлючВарианта = "Форма0504402"
			Или КлючВарианта = "Форма0504402ПерваяПоловинаМесяца" Тогда
			// Задолженность за организацией
			МакетСотрудника.Область(1, 22, МакетСотрудника.ВысотаТаблицы, 22).Объединить();
			// Задолженность за сотрудником
			МакетСотрудника.Область(1, 23, МакетСотрудника.ВысотаТаблицы, 24).Объединить();
			// К выплате
			МакетСотрудника.Область(1, 25, МакетСотрудника.ВысотаТаблицы, 26).Объединить();
		КонецЕсли;
		
	КонецЕсли;
	
	МассивВыводимыхОбластей = Новый Массив;
	МассивВыводимыхОбластей.Добавить(МакетСотрудника);
	МассивВыводимыхОбластей.Добавить(Макеты.ИтогоПоСтранице);
	МассивВыводимыхОбластей.Добавить(Макеты.Подвал);
	
	Если НЕ ОбщегоНазначения.ПроверитьВыводТабличногоДокумента(ДокументРезультат, МассивВыводимыхОбластей) Тогда
		
		ЗаполнитьЗначенияСвойств(Макеты.ИтогоПоСтранице.Параметры, ПромежуточныеИтоги);
		ДокументРезультат.Вывести(Макеты.ИтогоПоСтранице);
		ДокументРезультат.ВывестиГоризонтальныйРазделительСтраниц();
		ЗарплатаКадрыОтчеты.ЗаполнитьПараметрыПользовательскихПолей(Макеты.Шапка, СтрокаСотрудника, СоответствиеПользовательскихПолей);
		ДокументРезультат.Вывести(Макеты.Шапка);
		ПромежуточныеИтоги = ПриКомпоновкеРезультата0504401Или0504402ПромежуточныеИтогиПоСтранице();

	КонецЕсли;
	
	ЗарплатаКадрыОтчеты.ДобавитьВПромежуточныйИтог(ПромежуточныеИтоги, ПромежуточныеИтогиПоГоловномуСотруднику);

	ДокументРезультат.Вывести(МакетСотрудника);
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата0504401Или0504402ДополнитьСтраницу(НомерСтроки, Макеты, ДокументРезультат, ПромежуточныеИтоги)
	
	ОбластиКонцаСтраницы = Новый Массив();
	ОбластиКонцаСтраницы.Добавить(Макеты.ИтогоПоСтранице);
	ОбластиКонцаСтраницы.Добавить(Макеты.Подвал);
	ОбщегоНазначенияБЗК.ДополнитьСтраницуТабличногоДокумента(ДокументРезультат, Макеты.ПустаяСтрока, ОбластиКонцаСтраницы);  
	
	ЗаполнитьЗначенияСвойств(Макеты.ИтогоПоСтранице.Параметры, ПромежуточныеИтоги);
	ДокументРезультат.Вывести(Макеты.ИтогоПоСтранице);
	
КонецПроцедуры

Функция ПриКомпоновкеРезультата0504401Или0504402ПромежуточныеИтогиПоСтранице()
	
	ПромежуточныеИтоги = Новый Структура;
	
	ПромежуточныеИтоги.Вставить("КВыплате", 0);
	
	Возврат ПромежуточныеИтоги;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти