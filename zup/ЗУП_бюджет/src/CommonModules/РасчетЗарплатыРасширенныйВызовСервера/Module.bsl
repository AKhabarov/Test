
#Область СлужебныеПроцедурыИФункции

// Обработчик события ОбработкаПолученияДанныхВыбора модуля менеджера ПВР Начисления.
//
Процедура НачисленияОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Запрос = Новый Запрос;
	
	ТекстЗапросаУсловий = "";

	// Исключение пособий по уходу за ребенком.
	Если Параметры.Свойство("ИсключатьПособияПоУходуЗаРебенком") Тогда
		
		ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + "
			|	И ") + "(Не ПланВидовРасчетаНачисления.КатегорияНачисленияИлиНеоплаченногоВремени В (&ПособияПоУходуЗаРебенком))";
			
		ИсключенныеВиды = Новый Массив;
		ИсключенныеВиды.Добавить(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоПолутораЛет"));
		ИсключенныеВиды.Добавить(ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ПособиеПоУходуЗаРебенкомДоТрехЛет"));			
		
		Запрос.УстановитьПараметр("ПособияПоУходуЗаРебенком", ИсключенныеВиды);
		
	КонецЕсли;
	
	// Условия подбора по строке и коду.
	Если Параметры.Свойство("СтрокаПоиска") И Не ПустаяСтрока(Параметры.СтрокаПоиска) Тогда
		
		УсловияПодбора = "";
		МетаданныеОбъекта = Метаданные.ПланыВидовРасчета.Начисления;
		
		Для каждого Поле Из МетаданныеОбъекта.ВводПоСтроке Цикл
			УсловияПодбора = УсловияПодбора + ?(ПустаяСтрока(УсловияПодбора), "", Символы.ПС + "ИЛИ ") + "(ПланВидовРасчетаНачисления." + Поле.Имя + " ПОДОБНО &СтрокаПоиска)";
		КонецЦикла;
		
		Если Не ПустаяСтрока(УсловияПодбора) Тогда
			ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + "
				|	И ") + "(" + УсловияПодбора + ")";
		КонецЕсли; 
			
		Запрос.УстановитьПараметр("СтрокаПоиска", Параметры.СтрокаПоиска + "%");
		
	КонецЕсли; 
	
	// Добавление отборов, переданных в параметре.
	Если Параметры.Отбор.Количество() > 0 Тогда
		
		Для каждого ЭлементОтбора Из Параметры.Отбор Цикл
			
			Если ТипЗнч(ЭлементОтбора.Значение) = Тип("ФиксированныйМассив") Тогда				
				УсловиеСПравымЗначением = " В (&Отбор" + ЭлементОтбора.Ключ + ")";				
			Иначе				
				УсловиеСПравымЗначением = " = (&Отбор" + ЭлементОтбора.Ключ + ")";				
			КонецЕсли; 
			
			ТекстЗапросаУсловий = ?(ПустаяСтрока(ТекстЗапросаУсловий), "", ТекстЗапросаУсловий + Символы.ПС + " И ")
				+ "ПланВидовРасчетаНачисления." + ЭлементОтбора.Ключ + УсловиеСПравымЗначением;
				
			Запрос.УстановитьПараметр("Отбор" + ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
			
		КонецЦикла;
		
	КонецЕсли;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 51
		|	ПланВидовРасчетаНачисления.Ссылка КАК Ссылка,
		|	ПланВидовРасчетаНачисления.ПометкаУдаления,
		|	"""" КАК Предупреждение,
		|	ПланВидовРасчетаНачисления.Наименование,
		|	ПланВидовРасчетаНачисления.Код,
		|	ЛОЖЬ КАК ЯвляетсяДенежнымСодержанием
		|ИЗ
		|	ПланВидовРасчета.Начисления КАК ПланВидовРасчетаНачисления";
		
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		НовыйТекстЗапроса = Модуль.УточнитьТекстЗапросаСпискаНачислений(ТекстЗапроса, ТекстЗапросаУсловий);
		Если Не ПустаяСтрока(НовыйТекстЗапроса) Тогда
			ТекстЗапроса = НовыйТекстЗапроса;
		КонецЕсли;
	КонецЕсли;	

	Если Не ПустаяСтрока(ТекстЗапросаУсловий) Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	" + ТекстЗапросаУсловий;
	КонецЕсли; 
		
	ТекстЗапроса = ТекстЗапроса + "
		|УПОРЯДОЧИТЬ ПО
		|	ПланВидовРасчетаНачисления.Наименование";
		
	Запрос.Текст = ТекстЗапроса;
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ШаблонПредставления = "%1";
		Если ЗначениеЗаполнено(Выборка.Код) Тогда
			ШаблонПредставления = "%1 (%2)";
		КонецЕсли;
		Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонПредставления, Выборка.Наименование, СокрЛП(Выборка.Код));
		ДанныеВыбора.Добавить(Выборка.Ссылка, Представление);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Функция СведенияОНастройкахЗарплатаКадрыРасширенная(Организация) Экспорт
	
	Возврат РегистрыСведений.НастройкиЗарплатаКадрыРасширенная.СведенияОНастройкахОрганизации(
		Организация, "ВыплачиватьЗарплатуВПоследнийДеньМесяца,ДатаВыплатыЗарплатыНеПозжеЧем");
	
КонецФункции

Процедура СохранитьНастройкуРежимаОтображенияПодробно(ОбъектСсылка, ВидимостьПолейПодробно, ОписаниеТаблицы) Экспорт

	Если ТипЗнч(ОбъектСсылка) = Тип("Строка") Тогда
		КлючОбъекта = ОбъектСсылка;
	Иначе
		КлючОбъекта = ОбъектСсылка.Метаданные().Имя;
	КонецЕсли;
	КлючНастроек = ОписаниеТаблицы.ИмяТаблицы + "Подробно";
	
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		ВидимостьПолейПодробно);

КонецПроцедуры

// Обработчик события ОбработкаПолученияДанныхВыбора перечисления КатегорииНачисленийИНеоплаченногоВремени.
//
Процедура КатегорииНачисленийИНеоплаченногоВремениОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка,
	|	ТаблицаКатегорий.Синоним
	|ПОМЕСТИТЬ ВТТаблицаКатегорий
	|ИЗ
	|	&ТаблицаКатегорий КАК ТаблицаКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка
	|ИЗ
	|	ВТТаблицаКатегорий КАК ТаблицаКатегорий
	|ГДЕ
	|	ТаблицаКатегорий.Ссылка В(&ДействующиеКатегории)
	|	И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу категорий.
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииНачисленийИНеоплаченногоВремени"));
	ТаблицаКатегорий.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Ссылка = Перечисления.КатегорииНачисленийИНеоплаченногоВремени[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаКатегорий", ТаблицаКатегорий);
	Запрос.УстановитьПараметр("ДействующиеКатегории", Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДействующиеКатегории());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

// Обработчик события ОбработкаПолученияДанныхВыбора перечисления КатегорииУдержаний.
//
Процедура КатегорииУдержанийОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка,
	|	ТаблицаКатегорий.Синоним
	|ПОМЕСТИТЬ ВТТаблицаКатегорий
	|ИЗ
	|	&ТаблицаКатегорий КАК ТаблицаКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка
	|ИЗ
	|	ВТТаблицаКатегорий КАК ТаблицаКатегорий
	|ГДЕ
	|	ТаблицаКатегорий.Ссылка В(&ДействующиеКатегории)
	|	И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу категорий.
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииУдержаний"));
	ТаблицаКатегорий.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.КатегорииУдержаний.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Ссылка = Перечисления.КатегорииУдержаний[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаКатегорий", ТаблицаКатегорий);
	Запрос.УстановитьПараметр("ДействующиеКатегории", Перечисления.КатегорииУдержаний.ДействующиеКатегории());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура ДанныеДляРасчетаЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт 
	
	Если Данные.Ссылка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВидДокумента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Данные.Ссылка, "ВидДокумента");
	
	Если Не ЗначениеЗаполнено(ВидДокумента) Тогда
		Возврат;
	КонецЕсли;
	
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = '%1 %2 от %3'"), 
			ВидДокумента, 
			Данные.Номер, 
			Формат(Данные.Дата, "ДЛФ=Д"));
		
	СтандартнаяОбработка = Ложь;
		
КонецПроцедуры

Процедура НачислениеЗарплатыОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка) Экспорт 
	
	Если Данные.РежимДоначисления Тогда
		
		СтандартнаяОбработка = Ложь;
		Представление = Документы.НачислениеЗарплаты.ПредставлениеТипаДоначислениеПерерасчет() + " " + Данные.Номер + " " +НСтр("ru='от'") + " "  + Формат(Данные.Дата, "ДЛФ=D");;
		
	Иначе 
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ОперацииРасчетаЗарплаты") Тогда 
			Модуль = ОбщегоНазначения.ОбщийМодуль("ОперацииРасчетаЗарплаты");
		    ВидОперации = Модуль.ВидОперацииДокумента(Данные.Ссылка);
			Если ЗначениеЗаполнено(ВидОперации) Тогда
				СтандартнаяОбработка = Ложь;
				Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = '%1 %2 от %3'"), Строка(ВидОперации), Данные.Номер, Формат(Данные.Дата, "ДЛФ=Д"));
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
