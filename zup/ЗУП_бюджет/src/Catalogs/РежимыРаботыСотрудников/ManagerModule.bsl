#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура СоздатьВТСреднемесячныеНормыВремени(МенеджерВременныхТаблиц, РежимРаботы, Год = Неопределено) Экспорт 
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("РежимРаботы", РежимРаботы);
	Запрос.УстановитьПараметр("Год", Год);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СреднемесячныеНормыВремениГрафиковРаботыСотрудников.Год КАК Год,
	|	&РежимРаботы КАК РежимРаботы,
	|	СРЕДНЕЕ(СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоЧасов) КАК СреднемесячноеЧислоЧасов,
	|	СРЕДНЕЕ(СреднемесячныеНормыВремениГрафиковРаботыСотрудников.СреднемесячноеЧислоДней) КАК СреднемесячноеЧислоДней
	|ПОМЕСТИТЬ ВТСреднемесячныеНормыВремени
	|ИЗ
	|	Справочник.ГрафикиРаботыСотрудников КАК ГрафикиРаботыСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СреднемесячныеНормыВремениГрафиковРаботыСотрудников КАК СреднемесячныеНормыВремениГрафиковРаботыСотрудников
	|		ПО ГрафикиРаботыСотрудников.Ссылка = СреднемесячныеНормыВремениГрафиковРаботыСотрудников.ГрафикРаботыСотрудников
	|			И (ГрафикиРаботыСотрудников.РежимРаботы = &РежимРаботы)
	|			И (&УсловиеГод)
	|
	|СГРУППИРОВАТЬ ПО
	|	СреднемесячныеНормыВремениГрафиковРаботыСотрудников.Год";	
	Если Год = Неопределено Тогда
		ТекстУсловияГод = "ИСТИНА";
	Иначе
		ТекстУсловияГод = "СреднемесячныеНормыВремениГрафиковРаботыСотрудников.Год = &Год";
	КонецЕсли;	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеГод", ТекстУсловияГод);
	Запрос.Выполнить();	
КонецПроцедуры	

#КонецОбласти

#КонецЕсли