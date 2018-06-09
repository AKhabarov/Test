#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	// В идентификаторе (Код) допустимы только английские символы, подчеркивания, минус и числа.
	РазрешенныеСимволы = ОбработкаНовостейКлиентСервер.РазрешенныеДляИдентификацииСимволы();
	СписокЗапрещенныхСимволов = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьСтрокуНаЗапрещенныеСимволы(
		СокрЛП(ЭтотОбъект.Код),
		РазрешенныеСимволы);

	Если СписокЗапрещенныхСимволов.Количество() > 0 Тогда
		Отказ = Истина;
		Сообщение = Новый СообщениеПользователю;
		Сообщение.УстановитьДанные(ЭтотОбъект);
		Сообщение.Поле = "Код";
		Сообщение.ПутьКДанным = "Объект";
		Сообщение.Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='В идентификаторе присутствуют запрещенные символы: %1.
				|Разрешено использовать цифры, английские буквы, подчеркивание и минус.'"),
			СписокЗапрещенныхСимволов);
		Сообщение.Сообщить();
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	ЭтотОбъект.Код          = СокрЛП(ЭтотОбъект.Код);
	ЭтотОбъект.Наименование = СокрЛП(ЭтотОбъект.Наименование);

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли