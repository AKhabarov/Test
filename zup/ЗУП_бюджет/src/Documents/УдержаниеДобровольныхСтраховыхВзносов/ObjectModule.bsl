#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьМесяца(Ссылка, ДатаНачала, "ДатаНачалаСтрокой", Отказ, НСтр("ru='Месяц начала периода'"), , , Ложь);
	ОтражениеЗарплатыВБухучетеРасширенный.УточнитьСоставПроверяемыхРеквизитовБухучетПлановыхУдержаний(ЭтотОбъект, ПроверяемыеРеквизиты);
	
	УникальныеЗначения = Новый Соответствие;
	ИндексСтроки = 0;
	Для Каждого ДанныеФизическогоЛица Из Удержания Цикл
		Если УникальныеЗначения[ДанныеФизическогоЛица.ФизическоеЛицо] = Неопределено Тогда
			УникальныеЗначения.Вставить(ДанныеФизическогоЛица.ФизическоеЛицо, Истина);
		Иначе
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Информация о сотруднике %1 была введена в документе ранее.'"), ДанныеФизическогоЛица.ФизическоеЛицо);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Ссылка, "Объект.Удержания[" + Формат(ИндексСтроки, "ЧН=0; ЧГ=0") + "].ФизическоеЛицо", ,Отказ);
		КонецЕсли;
		ИндексСтроки = ИндексСтроки + 1;
	КонецЦикла;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 		= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода		= ДатаНачала;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода	= ДатаОкончания;
	
	КадровыйУчет.ПроверитьРаботающихФизическихЛиц(
		ОбщегоНазначения.ВыгрузитьКолонку(Удержания, "ФизическоеЛицо"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "ФизическоеЛицо", "Объект"));
		
	Если Действие = Перечисления.ДействияСУдержаниями.Начать Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДокументОснование");
	КонецЕсли;
		
	Если Действие <> Перечисления.ДействияСУдержаниями.Прекратить Тогда 
		ЗарплатаКадрыРасширенный.ПроверитьПериодРегистратораНачисленийУдержаний(ДатаНачала, ДатаОкончания, ЭтотОбъект, "ДатаОкончания", Отказ);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Сотрудник") Тогда
			ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения.Сотрудник);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = РасчетЗарплатыРасширенный.СоздатьДанныеДляРегистрацииПлановыхУдержаний();
	РасчетЗарплатыРасширенный.ЗаполнитьДанныеДляРегистрацииПлановыхУдержанийСпискаСотрудников(ДанныеДляПроведения, Ссылка);
	УчетНДФЛРасширенный.ЗаполнитьДанныеДляПримененияСоциальныхВычетов(ДанныеДляПроведения, Ссылка);
	
	ДвиженияУдержаний = Новый Структура;
	ДвиженияУдержаний.Вставить("ДанныеПлановыхУдержаний", ДанныеДляПроведения.ДанныеПлановыхУдержаний);
	ДвиженияУдержаний.Вставить("ЗначенияПоказателей", ДанныеДляПроведения.ЗначенияПоказателей);
	ДвиженияУдержаний.Вставить("РабочиеМестаУдержаний", ДанныеДляПроведения.РабочиеМестаУдержаний);
	
	РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхУдержаний(Движения, ДвиженияУдержаний);
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСтатьиФинансированияЗарплата") И БухучетЗаданВДокументе Тогда
		БухучетПлановыхУдержаний = ОтражениеЗарплатыВБухучетеРасширенный.ДанныеДляРегистрацииБухучетаПлановыхУдержаний(Ссылка);
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетПлановыхУдержаний(Движения, БухучетПлановыхУдержаний);
	КонецЕсли;
	
	УчетНДФЛРасширенный.СформироватьПрименениеСоциальныхВычетовПоУдержаниям(Движения, Отказ, Организация, ДатаНачала, ДанныеДляПроведения.ПримененияСоциальныхВычетов);	
		
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	СоздатьВТДанныеДокументов(ДанныеДляРегистрацииПерерасчетов);
	ЕстьПерерасчеты = ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	
	// Регистрация перерасчетов
	Если ЕстьПерерасчеты Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетовПриОтменеПроведения(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли;
	
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
	МассивПараметров.Добавить(Новый Структура("Удержания", "ФизическоеЛицо"));
	
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическимЛицам(ЭтотОбъект, Организация, МассивПараметров, ДатаНачала);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТДанныеДокументов(МенеджерВременныхТаблиц)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Регистратор", Ссылка);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация КАК Организация,
		|	Сотрудники.Ссылка КАК Сотрудник,
		|	ТаблицаДокумента.Ссылка.ДатаНачала КАК ПериодДействия,
		|	ТаблицаДокумента.Ссылка КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ИЗ
		|	Документ.УдержаниеДобровольныхСтраховыхВзносов.Удержания КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ТаблицаДокумента.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТаблицаДокумента.Ссылка.Организация,
		|	Сотрудники.Ссылка,
		|	ТаблицаДокумента.Ссылка.ДатаОкончания,
		|	ТаблицаДокумента.Ссылка
		|ИЗ
		|	Документ.УдержаниеДобровольныхСтраховыхВзносов.Удержания КАК ТаблицаДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|		ПО ТаблицаДокумента.ФизическоеЛицо = Сотрудники.ФизическоеЛицо
		|ГДЕ
		|	ТаблицаДокумента.Ссылка = &Регистратор
		|	И ТаблицаДокумента.Ссылка.ДатаОкончания <> ДАТАВРЕМЯ(1, 1, 1)";
	
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
