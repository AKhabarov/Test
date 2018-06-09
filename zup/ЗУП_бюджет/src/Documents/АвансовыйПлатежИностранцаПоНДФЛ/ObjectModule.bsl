#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения, , Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	УчетНДФЛ.СформироватьАвансовыйПлатежИностранца(Движения, Отказ, Организация, ДатаОперации, ПолучитьДанныеДляПроведения())
	
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
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИФизическомуЛицу(ЭтотОбъект, Организация, Сотрудник, Дата(НалоговыйПериод, 12, 31));
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АвансовыйПлатежИностранцаПоНДФЛ.НалоговыйПериод КАК Год,
	|	АвансовыйПлатежИностранцаПоНДФЛ.Сотрудник КАК ФизическоеЛицо,
	|	АвансовыйПлатежИностранцаПоНДФЛ.Сумма
	|ИЗ
	|	Документ.АвансовыйПлатежИностранцаПоНДФЛ КАК АвансовыйПлатежИностранцаПоНДФЛ
	|ГДЕ
	|	АвансовыйПлатежИностранцаПоНДФЛ.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
