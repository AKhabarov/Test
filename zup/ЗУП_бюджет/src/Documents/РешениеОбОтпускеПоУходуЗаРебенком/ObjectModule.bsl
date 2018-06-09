#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ДатаНачала = ТекущаяДатаСеанса();
	
	АдаптацияУвольнение.ЗаполнитьПоСотруднику(ЭтотОбъект, ДанныеЗаполнения, Ложь);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	ДанныеДляПроведения = ДанныеДляПроведения();
	
	АдаптацияУвольнение.СформироватьДвиженияМероприятияАдаптацииУвольненияПоДокументу(Движения, ДанныеДляПроведения.ДанныеМероприятийАдаптацииУвольнения);
	АдаптацияУвольнение.ЗарегистрироватьДокументДляОбновленияЗаданийАдаптацииУвольнения(Движения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Начало отпуска'"), , , Ложь);
	
	АдаптацияУвольнение.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты)
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	АдаптацияУвольнение.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	АдаптацияУвольнение.ПриЗаписи(ЭтотОбъект, Отказ)
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене.
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотруднику(ЭтотОбъект, Организация, ОсновнойСотрудник, ДатаНачала);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтпускПоУходуЗаРебенком.ОсновнойСотрудник КАК Сотрудник,
	|	ОтпускПоУходуЗаРебенком.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Мероприятия.Мероприятие,
	|	Мероприятия.ДатаНачала,
	|	Мероприятия.ДатаОкончания,
	|	Мероприятия.Исполнитель
	|ИЗ
	|	Документ.РешениеОбОтпускеПоУходуЗаРебенком.МероприятияАдаптацииУвольнения КАК Мероприятия
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РешениеОбОтпускеПоУходуЗаРебенком КАК ОтпускПоУходуЗаРебенком
	|		ПО Мероприятия.Ссылка = ОтпускПоУходуЗаРебенком.Ссылка
	|ГДЕ
	|	Мероприятия.Ссылка = &Ссылка";
	
	ДанныеМероприятий = Запрос.Выполнить().Выгрузить();
	ДанныеМероприятий.Колонки.Добавить("ДокументОснование", Новый ОписаниеТипов(Метаданные.ОпределяемыеТипы.СобытияАдаптацииУвольнения.Тип));
	ДанныеМероприятий.ЗаполнитьЗначения(Ссылка, "ДокументОснование");
	
	ДанныеДляПроведения = Новый Структура;
	ДанныеДляПроведения.Вставить("ДанныеМероприятийАдаптацииУвольнения", ДанныеМероприятий);
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

#КонецОбласти

#КонецЕсли
