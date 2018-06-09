#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") Тогда
			Если ДанныеЗаполнения.Действие = "Заполнить" Тогда
				ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ИсходнаяДатаНачала, "Объект.ИсходнаяДатаНачала", Отказ, НСтр("ru='Дата начала отпуска'"), , , Ложь);
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаНачала, "Объект.ДатаНачала", Отказ, НСтр("ru='Новая дата начала'"), , , Ложь);
	
	Документы.ПереносОтпуска.ПроверитьРаботающих(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(ИсходнаяДатаНачала) И ЗначениеЗаполнено(Сотрудник) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник,
		|	ПлановыеЕжегодныеОтпуска.ДатаНачала,
		|	ПлановыеЕжегодныеОтпуска.Перенесен
		|ИЗ
		|	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
		|ГДЕ
		|	ПлановыеЕжегодныеОтпуска.Сотрудник = &Сотрудник
		|	И ПлановыеЕжегодныеОтпуска.ДатаНачала = &ДатаНачала";
		Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
		Запрос.УстановитьПараметр("ДатаНачала", ИсходнаяДатаНачала);
		
		УстановитьПривилегированныйРежим(Истина);
		Результат = Запрос.Выполнить();
		УстановитьПривилегированныйРежим(Ложь);
		
		Если Результат.Пустой() Тогда
			ТекстСообщения = НСтр("ru  = 'Отпуск с %1 не был запланирован в графике отпусков.'"); 
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Формат(ИсходнаяДатаНачала,"ДЛФ=D"));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Объект.ИсходнаяДатаНачала",, Отказ);
		Иначе
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ОтменитьПеренос();
	ЗарегистрироватьПеренос();
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	ОтменитьПеренос();
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
	Возврат ОбменДаннымиЗарплатаКадры.ОграниченияРегистрацииПоОрганизацииИСотруднику(ЭтотОбъект, Организация, Сотрудник, ИсходнаяДатаНачала);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПоДаннымЗаполнения(ДанныеЗаполнения)
	
	Если ЭтоНовый() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект,ДанныеЗаполнения);
		Дата = ТекущаяДатаСеанса();
		
		ДанныеЗаполнения.Свойство("Руководитель", Руководитель);
		ДанныеЗаполнения.Свойство("ДолжностьРуководителя", ДолжностьРуководителя);
		
		ЗапрашиваемыеЗначения = Новый Структура;
		ЗапрашиваемыеЗначения.Вставить("Организация", "Организация");
		ЗапрашиваемыеЗначения.Вставить("Ответственный", "Ответственный");
		
		Если ЗначениеЗаполнено(Организация) И Не ЗначениеЗаполнено(Руководитель) Тогда
			ЗапрашиваемыеЗначения.Вставить("Руководитель", "Руководитель");
			ЗапрашиваемыеЗначения.Вставить("ДолжностьРуководителя", "ДолжностьРуководителя");
		КонецЕсли;
			
		ЗарплатаКадры.ЗаполнитьЗначенияВФорме(ЭтотОбъект, ЗапрашиваемыеЗначения, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("Организация"));
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьПеренос()
	
	Запрос = Новый Запрос;

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПлановыеЕжегодныеОтпуска.Организация,
	|	ПлановыеЕжегодныеОтпуска.Сотрудник,
	|	ПлановыеЕжегодныеОтпуска.ДатаНачала,
	|	ПлановыеЕжегодныеОтпуска.ФизическоеЛицо,
	|	ПлановыеЕжегодныеОтпуска.Запланирован,
	|	ЛОЖЬ КАК Перенесен,
	|	ПлановыеЕжегодныеОтпуска.ДокументПланирования,
	|	ПлановыеЕжегодныеОтпуска.КоличествоДней,
	|	ПлановыеЕжегодныеОтпуска.ВидОтпуска,
	|	ПлановыеЕжегодныеОтпуска.ДатаОкончания,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК ПеренесеннаяДатаНачала,
	|	ЗНАЧЕНИЕ(Документ.ПереносОтпуска.ПустаяСсылка) КАК ДокументПереноса
	|ИЗ
	|	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
	|ГДЕ
	|	ПлановыеЕжегодныеОтпуска.ДокументПереноса = &ДокументПереноса";
	Запрос.УстановитьПараметр("ДокументПереноса", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
		
		НаборЗаписей.Отбор.Сотрудник.Установить(Выборка.Сотрудник);
		НаборЗаписей.Отбор.ДатаНачала.Установить(Выборка.ДатаНачала);
		
		НоваяСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗарегистрироватьПеренос()

	НаборЗаписей = РегистрыСведений.ПлановыеЕжегодныеОтпуска.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.Сотрудник.Установить(Сотрудник);
	НаборЗаписей.Отбор.ДатаНачала.Установить(ИсходнаяДатаНачала);
	
	НаборЗаписей.Прочитать();
	Если НаборЗаписей.Количество() > 0 Тогда
		Для каждого СтрокаНабора Из НаборЗаписей Цикл
			СтрокаНабора.Перенесен = Истина;
			СтрокаНабора.ПеренесеннаяДатаНачала = ДатаНачала;
			СтрокаНабора.ДокументПереноса = Ссылка;
		КонецЦикла;
		НаборЗаписей.Записать();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
