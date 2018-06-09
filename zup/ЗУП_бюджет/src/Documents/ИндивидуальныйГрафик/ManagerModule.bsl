#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
	РеквизитыДляПроведения = ДополнительныеПараметры.РеквизитыДляПроведения;
	
	УчетРабочегоВремени.ЗарегистрироватьСторноЗаписиПоДокументу(Движения, ДополнительныеПараметры.ПериодРегистрации,
		ИсправленныйДокумент, РеквизитыДляПроведения.СотрудникиДокумента);
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ИндивидуальныйГрафик;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическиеЛицаВТабличныхЧастях(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если  ВидФормы = "ФормаОбъекта" Тогда 
		Если Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Параметры.Ключ) Тогда
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Ключ, "ГрафикСменности") Тогда
				СтандартнаяОбработка = Ложь;
				ВыбраннаяФорма = "ФормаСменногоГрафика";
			КонецЕсли;
		ИначеЕсли Параметры.Свойство("ГрафикСменности") И Параметры.ГрафикСменности = Истина Тогда
			СтандартнаяОбработка = Ложь;
			ВыбраннаяФорма = "ФормаСменногоГрафика";
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

#КонецОбласти

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСменыРаботыСотрудников") Тогда	
		ПредставлениеДокумента = Метаданные.Документы.ИндивидуальныйГрафик.Представление();
	
		ОписаниеКоманды = ЗарплатаКадрыРасширенный.ОписаниеКомандыСозданияДокумента(
			"Документ.ИндивидуальныйГрафик",
			ПредставлениеДокумента);
			
		ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокумента(
		КомандыСозданияДокументов, ОписаниеКоманды);

		
		ОписаниеКоманды = ЗарплатаКадрыРасширенный.ОписаниеКомандыСозданияДокумента(
			"Документ.ИндивидуальныйГрафик",
			НСтр("ru = 'Индивидуальный график сменности'"));
		
		Параметры = Новый Структура;
		Параметры.Вставить("ГрафикСменности", Истина);

		ОписаниеКоманды.Параметры = Параметры; 
		
		ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокумента(
			КомандыСозданияДокументов, ОписаниеКоманды);
			
	КонецЕсли;	
	
КонецФункции

#Область ПроцедурыЗаполнения

Функция ВыборкаДанныхОВремени(ДанныеТабеля, СписокСотрудников = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организация", ДанныеТабеля.Организация);
	Запрос.УстановитьПараметр("ДатаНачала", ДанныеТабеля.ДатаНачалаПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", ДанныеТабеля.ДатаОкончанияПериода);

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	НеучитываемыеДокументы = Новый Массив;
	Если Не ДанныеТабеля.Ссылка.Пустая() Тогда
		НеучитываемыеДокументы.Добавить(ДанныеТабеля.Ссылка);
	КонецЕсли;
	
	Если Не ДанныеТабеля.ИсправленныйДокумент.Пустая() Тогда
		НеучитываемыеДокументы.Добавить(ДанныеТабеля.ИсправленныйДокумент);
	КонецЕсли;	
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Месяц", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("ДатаНачала", Новый ОписаниеТипов("Дата"));
	ТаблицаСотрудников.Колонки.Добавить("ДатаОкончания", Новый ОписаниеТипов("Дата"));	
	ТаблицаСотрудников.Колонки.Добавить("ДатаАктуальности", Новый ОписаниеТипов("Дата"));	
	
	Если СписокСотрудников = Неопределено Тогда
		ПараметрыПолученияСотрудников = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудников.Организация  = ДанныеТабеля.Организация;
		ПараметрыПолученияСотрудников.НачалоПериода = ДанныеТабеля.ДатаНачалаПериода;
		ПараметрыПолученияСотрудников.ОкончаниеПериода = ДанныеТабеля.ДатаОкончанияПериода;
		
		Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
			Модуль.ДобавитьОтборыПоВидуДоговора(ПараметрыПолученияСотрудников.Отборы, Истина);
		КонецЕсли; 
	
		КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудников, "ВТСотрудникиОрганизации");
		
		Запрос.УстановитьПараметр("Месяц", НачалоМесяца(ДанныеТабеля.ДатаНачалаПериода));
		Запрос.УстановитьПараметр("ДатаАктуальности", НачалоМесяца(ДанныеТабеля.Дата));
	
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	СотрудникиОрганизации.Сотрудник,
		|	&Месяц,
		|	&ДатаАктуальности,
		|	&ДатаНачала,
		|	&ДатаОкончания
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации";
		
		Запрос.Выполнить();
		
	Иначе	
		Для Каждого Сотрудник Из СписокСотрудников Цикл
			СтрокаТаблицыСотрудников = ТаблицаСотрудников.Добавить();
			СтрокаТаблицыСотрудников.Сотрудник = Сотрудник;
			СтрокаТаблицыСотрудников.Месяц = НачалоМесяца(ДанныеТабеля.ДатаНачалаПериода); 
			СтрокаТаблицыСотрудников.ДатаНачала = ДанныеТабеля.ДатаНачалаПериода;
			СтрокаТаблицыСотрудников.ДатаОкончания = ДанныеТабеля.ДатаОкончанияПериода;
			СтрокаТаблицыСотрудников.ДатаАктуальности = ДанныеТабеля.Дата;
		КонецЦикла;	
		
		Запрос.УстановитьПараметр("ТаблицаСотрудников", ТаблицаСотрудников);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаСотрудников.Сотрудник,
		|	ТаблицаСотрудников.Месяц,
		|	ТаблицаСотрудников.ДатаНачала,
		|	ТаблицаСотрудников.ДатаОкончания,
		|	ТаблицаСотрудников.ДатаАктуальности КАК ДатаАктуальности
		|ПОМЕСТИТЬ ВТСотрудники
		|ИЗ
		|	&ТаблицаСотрудников КАК ТаблицаСотрудников";
		
		Запрос.Выполнить();
	КонецЕсли;	
	
	ПараметрыДляЗапросВТРабочиеМестаСотрудников = КадровыйУчет.ПараметрыДляЗапросВТРабочиеМестаСотрудниковПоВременнойТаблице(
														"ВТСотрудники",
														"Сотрудник", 
														"ДатаНачала",
														"ДатаОкончания");
	
	ЗапросВТРабочиеМестаСотрудников = КадровыйУчет.ЗапросВТРабочиеМестаСотрудниковПоВременнойТаблице(
											Истина, 
											"ВТРабочиеМестаСотрудников",
											ПараметрыДляЗапросВТРабочиеМестаСотрудников,
											Запрос.МенеджерВременныхТаблиц);
										
	ЗапросВТРабочиеМестаСотрудников.МенеджерВременныхТаблиц = Запрос.МенеджерВременныхТаблиц;
	ЗапросВТРабочиеМестаСотрудников.Выполнить();

	ПараметрыПолученияДанных = УчетРабочегоВремениРасширенный.ПараметрыДляСоздатьВТПлановоеВремяСотрудников();
	ПараметрыПолученияДанных.НеучитываемыеРегистраторы = НеучитываемыеДокументы;
	ПараметрыПолученияДанных.ОтноситьПереходящуюЧастьСменыКДнюНачала = Истина;
	
	УчетРабочегоВремениРасширенный.СоздатьВТПлановоеВремя(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПолученияДанных);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПериодыРаботы.Сотрудник КАК Сотрудник,
	|	ПериодыРаботы.Период КАК ДатаНачала,
	|	МИНИМУМ(ВЫБОР
	|			КОГДА ПериодыРаботыСлед.Период ЕСТЬ NULL
	|				ТОГДА &ДатаОкончания
	|			КОГДА ПериодыРаботыСлед.ВидСобытия = ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
	|				ТОГДА ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ПериодыРаботыСлед.Период, ДЕНЬ), ДЕНЬ, -1)
	|			ИНАЧЕ ДОБАВИТЬКДАТЕ(ПериодыРаботыСлед.Период, СЕКУНДА, -1)
	|		КОНЕЦ) КАК ДатаОкончания,
	|	ПериодыРаботы.Организация КАК Организация,
	|	ПериодыРаботы.Подразделение КАК Подразделение,
	|	ПериодыРаботы.Должность КАК Должность
	|ПОМЕСТИТЬ ВТПериодыРаботыСотрудников
	|ИЗ
	|	ВТРабочиеМестаСотрудников КАК ПериодыРаботы
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМестаСотрудников КАК ПериодыРаботыСлед
	|		ПО ПериодыРаботы.Сотрудник = ПериодыРаботыСлед.Сотрудник
	|			И ПериодыРаботы.Период < ПериодыРаботыСлед.Период
	|ГДЕ
	|	ПериодыРаботы.ВидСобытия <> ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Увольнение)
	|	И ПериодыРаботы.Организация = &Организация
	|	И &УсловиеПодразделение
	|
	|СГРУППИРОВАТЬ ПО
	|	ПериодыРаботы.Сотрудник,
	|	ПериодыРаботы.Период,
	|	ПериодыРаботы.Организация,
	|	ПериодыРаботы.Подразделение,
	|	ПериодыРаботы.Должность
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПлановоеВремя.Сотрудник КАК Сотрудник,
	|	ПлановоеВремя.Дата КАК Дата,
	|	СУММА(ПлановоеВремя.ЧасыПлан) КАК НормаЧасов
	|ПОМЕСТИТЬ ВТНормаВремени
	|ИЗ
	|	ВТПлановоеВремя КАК ПлановоеВремя
	|
	|СГРУППИРОВАТЬ ПО
	|	ПлановоеВремя.Сотрудник,
	|	ПлановоеВремя.Дата
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ПлановоеВремя.Сотрудник КАК Сотрудник,
	|	ПлановоеВремя.Дата  КАК Дата,
	|	ПлановоеВремя.ДниПлан КАК Дней,
	|	ПлановоеВремя.ЧасыПлан КАК Часы,
	|	ПлановоеВремя.ВидУчетаВремени КАК ВидУчетаВремени,
	|	ПлановоеВремя.Смена КАК Смена,
	|	ПлановоеВремя.ПереходящаяЧастьПредыдущейСмены КАК ПереходящаяЧастьПредыдущейСмены,
	|	ПлановоеВремя.ПереходящаяЧастьТекущейСмены КАК ПереходящаяЧастьТекущейСмены,
	|	ЕСТЬNULL(НормаВремени.НормаЧасов, 0) КАК НормаЧасов,
	|	ПлановоеВремя.ПереходящаяЧастьПредыдущейСмены
	|		ИЛИ ПлановоеВремя.ПереходящаяЧастьТекущейСмены КАК ПереходящаяЧастьСмены
	|ИЗ
	|	ВТПлановоеВремя КАК ПлановоеВремя
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТПериодыРаботыСотрудников КАК ПериодыРаботыСотрудников
	|		ПО ПлановоеВремя.Сотрудник = ПериодыРаботыСотрудников.Сотрудник
	|			И ПлановоеВремя.Дата >= ПериодыРаботыСотрудников.ДатаНачала
	|			И ПлановоеВремя.Дата <= ПериодыРаботыСотрудников.ДатаОкончания
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНормаВремени КАК НормаВремени
	|		ПО ПлановоеВремя.Сотрудник = НормаВремени.Сотрудник
	|			И ПлановоеВремя.Дата = НормаВремени.Дата
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО ПлановоеВремя.Сотрудник = Сотрудники.Ссылка
	|ГДЕ
	|	(ПлановоеВремя.ДниПлан <> 0
	|			ИЛИ ПлановоеВремя.ЧасыПлан <> 0)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Сотрудник,
	|	Дата,
	|	ВидУчетаВремени,
	|	Часы УБЫВ";	
	
	Если ЗначениеЗаполнено(ДанныеТабеля.Подразделение) И ПолучитьФункциональнуюОпцию("ВыполнятьРасчетЗарплатыПоПодразделениям") Тогда
		Запрос.УстановитьПараметр("Подразделение", ДанныеТабеля.Подразделение);
		ТекстУсловияПодразделение = "ПериодыРаботы.Подразделение = &Подразделение";
	Иначе
		ТекстУсловияПодразделение = "ИСТИНА";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПодразделение", ТекстУсловияПодразделение);
	
	ПсевдонимыТаблиц = Новый Соответствие;
	ПсевдонимыТаблиц.Вставить("Справочник.ПодразделенияОрганизаций", "ПериодыРаботыСотрудников");
	ПсевдонимыТаблиц.Вставить("Справочник.Должности", "ПериодыРаботыСотрудников");
	ПсевдонимыТаблиц.Вставить("Справочник.Сотрудники", "ВЫРАЗИТЬ(ПериодыРаботыСотрудников.Сотрудник КАК Справочник.Сотрудники)");
	
	ЗарплатаКадры.ДополнитьТекстЗапросаУпорядочиваниемСотрудников(Запрос, ПсевдонимыТаблиц);
	
	Возврат Запрос.Выполнить().Выбрать();

КонецФункции

Функция ДанныеДляЗаполнения(ДанныеТабеля, СписокСотрудников = Неопределено) Экспорт
	ТаблицаСмен = Новый ТаблицаЗначений;
	ТаблицаСмен.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	
	Для НомерДня = 1 По 31 Цикл
		ТаблицаСмен.Колонки.Добавить("Смена" + НомерДня, Новый ОписаниеТипов("СправочникСсылка.СменыРаботыСотрудников"));
		ТаблицаСмен.Колонки.Добавить("ОтражатьЧасыВДеньНачалаСмены" + НомерДня, Новый ОписаниеТипов("Булево"));
	КонецЦикла;
	
	ТаблицаДанныхОВремени = Новый ТаблицаЗначений;
	ТаблицаДанныхОВремени.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники")); 
	
	Для НомерДня = 1 По 31 Цикл
		ТаблицаДанныхОВремени.Колонки.Добавить("ВидВремени" + НомерДня, Новый ОписаниеТипов("СправочникСсылка.ВидыИспользованияРабочегоВремени"));
		ТаблицаДанныхОВремени.Колонки.Добавить("Часов" + НомерДня, Новый ОписаниеТипов("Число"));
		ТаблицаДанныхОВремени.Колонки.Добавить("ПереходящаяЧастьСмены" + НомерДня, Новый ОписаниеТипов("Булево"));
	КонецЦикла;
		
	ВыборкаДанныхОВремени = ВыборкаДанныхОВремени(ДанныеТабеля, СписокСотрудников);
	
	Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Сотрудник") Цикл
		СтрокиДанныхПоСотруднику = Новый Массив;
		СтрокаТаблицыСмен = Неопределено;
		Пока ВыборкаДанныхОВремени.СледующийПоЗначениюПоля("Дата") Цикл
			Постфикс = Строка(День(ВыборкаДанныхОВремени.Дата));
			КоличествоКомбинацийЗначенийИзмерений = 0;
			ТекущаяСмена = Неопределено;
			ОтражатьЧасыВДеньНачалаСмены = Ложь;
			Пока ВыборкаДанныхОВремени.Следующий() Цикл
				КоличествоКомбинацийЗначенийИзмерений = КоличествоКомбинацийЗначенийИзмерений + 1;	
				СтрокаДанных = СтрокаТаблицыДанныхДляЗаполнения(ТаблицаДанныхОВремени, ВыборкаДанныхОВремени.Сотрудник, СтрокиДанныхПоСотруднику, КоличествоКомбинацийЗначенийИзмерений);
					
				Если ЗначениеЗаполнено(ВыборкаДанныхОВремени.Смена) Тогда
					ТекущаяСмена = ВыборкаДанныхОВремени.Смена;
				КонецЕсли;	
				Если ВыборкаДанныхОВремени.ПереходящаяЧастьСмены И ВыборкаДанныхОВремени.ПереходящаяЧастьТекущейСмены Тогда
					ОтражатьЧасыВДеньНачалаСмены = Истина;
				КонецЕсли;
				
				СтрокаДанных["ВидВремени" + Постфикс] = ВыборкаДанныхОВремени.ВидУчетаВремени;
				СтрокаДанных["Часов" + Постфикс] = ВыборкаДанныхОВремени.Часы;
				СтрокаДанных["ПереходящаяЧастьСмены" + Постфикс] = ВыборкаДанныхОВремени.ПереходящаяЧастьСмены;
			КонецЦикла;	
			Если ЗначениеЗаполнено(ТекущаяСмена) Или ОтражатьЧасыВДеньНачалаСмены Тогда
				Если СтрокаТаблицыСмен = Неопределено Тогда
					СтрокаТаблицыСмен = ТаблицаСмен.Добавить();
					СтрокаТаблицыСмен.Сотрудник = ВыборкаДанныхОВремени.Сотрудник;
				КонецЕсли;	
				
				СтрокаТаблицыСмен["Смена" + Постфикс] = ТекущаяСмена;
				СтрокаТаблицыСмен["ОтражатьЧасыВДеньНачалаСмены" + Постфикс] = ОтражатьЧасыВДеньНачалаСмены;
			КонецЕсли;	
		КонецЦикла;
	КонецЦикла;	
	
	ДанныеДляЗаполнения = Новый Структура("ДанныеОВремени, Смены", ТаблицаДанныхОВремени, ТаблицаСмен);
	
	Возврат ДанныеДляЗаполнения;
КонецФункции	

Функция СтрокаТаблицыДанныхДляЗаполнения(ТаблицаДанных, Сотрудник, СтрокиДанныхПоСотруднику, КоличествоКомбинацийЗначенийИзмерений)
	Если КоличествоКомбинацийЗначенийИзмерений > СтрокиДанныхПоСотруднику.Количество() Тогда
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.Сотрудник = Сотрудник;
		СтрокиДанныхПоСотруднику.Добавить(СтрокаДанных);
	Иначе
		СтрокаДанных = СтрокиДанныхПоСотруднику[КоличествоКомбинацийЗначенийИзмерений - 1];
	КонецЕсли;
	
	Возврат СтрокаДанных;
	
КонецФункции	

Функция ДоступныеДляВводаВидыВремени() Экспорт
	ДоступныеДляВводаВидыВремени = Новый Соответствие;
	
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "Вахта");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "ВыходныеДни");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "КормлениеРебенка");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаВРежимеНеполногоВремени");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаВечерниеЧасы");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "РаботаНочныеЧасы");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "СокращенноеВремяОбучающихся");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "СокращенноеРабочееВремя");
	ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеДляВводаВидыВремени, "Явка");
	
	Возврат ДоступныеДляВводаВидыВремени;
КонецФункции

Процедура ДобавитьДоступныйДляВводаВидВремениВКоллекцию(ДоступныеВидыВремени, ИдентификаторВидаВремени)
	ВидВремени = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыИспользованияРабочегоВремени." + ИдентификаторВидаВремени);
	
	Если ЗначениеЗаполнено(ВидВремени) Тогда
		ДоступныеВидыВремени.Вставить(ВидВремени, Истина);
	КонецЕсли;
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#КонецЕсли