#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТПериодыДействияРегистраций(МенеджерВременныхТаблиц) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ИсторияРегистрацийВНалоговомОргане.Период,
		|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница,
		|	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане,
		|	МИНИМУМ(ИсторияРегистрацийВНалоговомОрганеПоследующие.Период) КАК ПериодПоследующий
		|ПОМЕСТИТЬ ВТРегистрацииСПоследующимиПериодами
		|ИЗ
		|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОрганеПоследующие
		|		ПО ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница = ИсторияРегистрацийВНалоговомОрганеПоследующие.СтруктурнаяЕдиница
		|			И ИсторияРегистрацийВНалоговомОргане.Период < ИсторияРегистрацийВНалоговомОрганеПоследующие.Период
		|
		|СГРУППИРОВАТЬ ПО
		|	ИсторияРегистрацийВНалоговомОргане.Период,
		|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница,
		|	ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	РегистрацииСПоследующимиПериодами.Период,
		|	РегистрацииСПоследующимиПериодами.СтруктурнаяЕдиница,
		|	РегистрацииСПоследующимиПериодами.РегистрацияВНалоговомОргане,
		|	ЕСТЬNULL(ИсторияРегистрацийВНалоговомОргане.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ПериодПоследующий,
		|	ЕСТЬNULL(ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане, РегистрацииСПоследующимиПериодами.РегистрацияВНалоговомОргане) КАК РегистрацияВНалоговомОрганеПоследующая
		|ПОМЕСТИТЬ ВТПериодыДействияРегистраций
		|ИЗ
		|	ВТРегистрацииСПоследующимиПериодами КАК РегистрацииСПоследующимиПериодами
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
		|		ПО РегистрацииСПоследующимиПериодами.СтруктурнаяЕдиница = ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница
		|			И РегистрацииСПоследующимиПериодами.ПериодПоследующий = ИсторияРегистрацийВНалоговомОргане.Период";
		
	Запрос.Выполнить();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
