#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	РезультатЗапроса = ДанныеДляПроведения();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		Движения.ИнструктажиПоОхранеТруда.Записывать = Истина;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяЗапись = Движения.ИнструктажиПоОхранеТруда.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		
		МетаданныеОбъекта = ЭтотОбъект.Метаданные();
		Для Каждого ПараметрЗаполнения Из ДанныеЗаполнения Цикл
			Если МетаданныеОбъекта.Реквизиты.Найти(ПараметрЗаполнения.Ключ)<>Неопределено Тогда
				ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
			Иначе
				Если ОбщегоНазначения.ЭтоСтандартныйРеквизит(МетаданныеОбъекта.СтандартныеРеквизиты, ПараметрЗаполнения.Ключ) Тогда
					ЭтотОбъект[ПараметрЗаполнения.Ключ] = ПараметрЗаполнения.Значение;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ДанныеЗаполнения.Свойство("СписокСотрудников") Тогда
			Для каждого СотрудникМассива Из ДанныеЗаполнения.СписокСотрудников Цикл
				НоваяСтрока = ЭтотОбъект.Сотрудники.Добавить();
				НоваяСтрока.Сотрудник = СотрудникМассива;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаПроведения, "Объект.ДатаПроведения", Отказ, НСтр("ru='Дата проведения'"), , , Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Новый Структура("Сотрудники", "Сотрудник"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотрудникам(ЭтотОбъект, Организация, МассивПараметров, ДатаПроведения);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьСотрудниковПоИнструктажу(Инструктаж) Экспорт
	
	Сотрудники.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Инструктаж", Инструктаж);
	Запрос.УстановитьПараметр("ДатаПроведения", ДатаПроведения);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Параметры = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	Параметры.Организация 		= Организация;
	Параметры.Подразделение 	= Подразделение;
	Параметры.НачалоПериода 	= ДатаПроведения;
	Параметры.ОкончаниеПериода 	= ДатаПроведения;
	Параметры.КадровыеДанные 	= "ДолжностьПоШтатномуРасписанию";
	ЗарплатаКадры.ДополнитьКадровымиДаннымиНастройкиПорядкаСписка(Параметры.КадровыеДанные);
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Истина, Параметры);
	
	ЗначенияИнструктажа = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Инструктаж, "КонтролироватьПроведениеИнструктажа,ИспользоватьДляВсехРабочихМест");
	Запрос.УстановитьПараметр("КонтролироватьПроведениеИнструктажа", ЗначенияИнструктажа.КонтролироватьПроведениеИнструктажа);
	Запрос.УстановитьПараметр("ИспользоватьДляВсехРабочихМест", ЗначенияИнструктажа.ИспользоватьДляВсехРабочихМест);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыИнструктажейПоОхранеТрудаРабочиеМеста.РабочееМесто
	|ПОМЕСТИТЬ ВТРабочиеМестаИнструктажа
	|ИЗ
	|	Справочник.ВидыИнструктажейПоОхранеТруда КАК ВидыИнструктажейПоОхранеТруда
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыИнструктажейПоОхранеТруда.РабочиеМеста КАК ВидыИнструктажейПоОхранеТрудаРабочиеМеста
	|		ПО ВидыИнструктажейПоОхранеТруда.Ссылка = ВидыИнструктажейПоОхранеТрудаРабочиеМеста.Ссылка
	|ГДЕ
	|	ВидыИнструктажейПоОхранеТруда.Ссылка = &Инструктаж
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СотрудникиОрганизации.Сотрудник
	|ИЗ
	|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТРабочиеМестаИнструктажа КАК РабочиеМестаИнструктажа
	|		ПО СотрудникиОрганизации.ДолжностьПоШтатномуРасписанию = РабочиеМестаИнструктажа.РабочееМесто
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИнструктажиПоОхранеТруда.СрезПоследних(&ДатаПроведения, Регистратор <> &Ссылка) КАК ИнструктажиПоОхранеТруда
	|		ПО СотрудникиОрганизации.Сотрудник = ИнструктажиПоОхранеТруда.Сотрудник
	|			И (ИнструктажиПоОхранеТруда.ВидИнструктажа = &Инструктаж)
	|ГДЕ
	|	ВЫБОР
	|			КОГДА &КонтролироватьПроведениеИнструктажа
	|				ТОГДА ИнструктажиПоОхранеТруда.СрокДействия ЕСТЬ NULL 
	|						ИЛИ ИнструктажиПоОхранеТруда.СрокДействия <= &ДатаПроведения
	|			ИНАЧЕ ИСТИНА
	|		КОНЕЦ
	|	И ВЫБОР
	|			КОГДА &ИспользоватьДляВсехРабочихМест
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ РабочиеМестаИнструктажа.РабочееМесто ЕСТЬ НЕ NULL 
	|		КОНЕЦ";
	
	// Добавляем упорядочивание по настройкам.
	ПсевдонимыТаблиц = Новый Соответствие;
	ПсевдонимыТаблиц.Вставить("Справочник.ПодразделенияОрганизаций", "СотрудникиОрганизации");
	ПсевдонимыТаблиц.Вставить("Справочник.Должности", "СотрудникиОрганизации");
	ПсевдонимыТаблиц.Вставить("Справочник.Сотрудники", "СотрудникиОрганизации");
	ЗарплатаКадры.ДополнитьТекстЗапросаУпорядочиваниемСотрудников(Запрос, ПсевдонимыТаблиц);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Сотрудники.Добавить();
		НоваяСтрока.Сотрудник = Выборка.Сотрудник;
	КонецЦикла;
	
	
КонецПроцедуры

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИнструктажПоОхранеТруда.ДатаПроведения КАК Период,
	|	ИнструктажПоОхранеТруда.Организация,
	|	ИнструктажПоОхранеТруда.ВидИнструктажа,
	|	ИнструктажПоОхранеТрудаСотрудники.Сотрудник,
	|	ИнструктажПоОхранеТруда.ДатаПроведения,
	|	ВидыИнструктажейПоОхранеТруда.КоличествоРаз,
	|	ВидыИнструктажейПоОхранеТруда.КоличествоПериодов,
	|	ВидыИнструктажейПоОхранеТруда.Периодичность
	|ПОМЕСТИТЬ ВТИнструктажи
	|ИЗ
	|	Документ.ИнструктажПоОхранеТруда.Сотрудники КАК ИнструктажПоОхранеТрудаСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИнструктажПоОхранеТруда КАК ИнструктажПоОхранеТруда
	|		ПО ИнструктажПоОхранеТрудаСотрудники.Ссылка = ИнструктажПоОхранеТруда.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ВидыИнструктажейПоОхранеТруда КАК ВидыИнструктажейПоОхранеТруда
	|		ПО (ИнструктажПоОхранеТруда.ВидИнструктажа = ВидыИнструктажейПоОхранеТруда.Ссылка)
	|ГДЕ
	|	ИнструктажПоОхранеТрудаСотрудники.Ссылка = &Ссылка";
	
	Запрос.Выполнить();
	
	ОхранаТруда.СоздатьВТСрокиДействияПоПериоду(Запрос.МенеджерВременныхТаблиц, "ВТИнструктажи", "ДатаПроведения");
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СрокиДействияПоПериоду.ДатаПроведения КАК Период,
	|	СрокиДействияПоПериоду.Организация,
	|	СрокиДействияПоПериоду.ВидИнструктажа,
	|	СрокиДействияПоПериоду.Сотрудник,
	|	СрокиДействияПоПериоду.ДатаПроведения,
	|	СрокиДействияПоПериоду.СрокДействия
	|ИЗ
	|	ВТСрокиДействияПоПериоду КАК СрокиДействияПоПериоду";
	
	Возврат Запрос.Выполнить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
