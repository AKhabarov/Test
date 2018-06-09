#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеСостоянийСотрудников.Сотрудник КАК Сотрудник,
	|	ДанныеСостоянийСотрудников.ДокументОснование КАК ДокументОснование,
	|	ДанныеСостоянийСотрудников.Сторно КАК Сторно,
	|	ДанныеСостоянийСотрудников.Состояние КАК Состояние,
	|	ДанныеСостоянийСотрудников.Начало КАК Начало,
	|	ДанныеСостоянийСотрудников.Окончание КАК Окончание,
	|	ДанныеСостоянийСотрудников.ВидВремени КАК ВидВремени,
	|	ДанныеСостоянийСотрудников.ОкончаниеПредположительно КАК ОкончаниеПредположительно
	|ПОМЕСТИТЬ ВТПредыдущиеДанныеРегистра
	|ИЗ
	|	РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
	|ГДЕ
	|	ДанныеСостоянийСотрудников.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("МенеджерВременныхТаблиц", Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеСвойства.Свойство("МенеджерВременныхТаблиц") Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДополнительныеСвойства.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СравнениеСПредыдущимНабором.Сотрудник КАК Сотрудник,
	|	СравнениеСПредыдущимНабором.ДокументОснование КАК ДокументОснование,
	|	СравнениеСПредыдущимНабором.Сторно КАК Сторно,
	|	СравнениеСПредыдущимНабором.Состояние КАК Состояние,
	|	СравнениеСПредыдущимНабором.Начало КАК Начало,
	|	СравнениеСПредыдущимНабором.Окончание КАК Окончание,
	|	СравнениеСПредыдущимНабором.ВидВремени КАК ВидВремени,
	|	СравнениеСПредыдущимНабором.ОкончаниеПредположительно КАК ОкончаниеПредположительно,
	|	СУММА(СравнениеСПредыдущимНабором.ФлагИзменений) КАК ФлагИзменений
	|ПОМЕСТИТЬ ВТИзменившиесяДанные
	|ИЗ
	|	(ВЫБРАТЬ
	|		ПредыдущиеДанныеРегистра.Сотрудник КАК Сотрудник,
	|		ПредыдущиеДанныеРегистра.ДокументОснование КАК ДокументОснование,
	|		ПредыдущиеДанныеРегистра.Сторно КАК Сторно,
	|		ПредыдущиеДанныеРегистра.Состояние КАК Состояние,
	|		ПредыдущиеДанныеРегистра.Начало КАК Начало,
	|		ПредыдущиеДанныеРегистра.Окончание КАК Окончание,
	|		ПредыдущиеДанныеРегистра.ВидВремени КАК ВидВремени,
	|		ПредыдущиеДанныеРегистра.ОкончаниеПредположительно КАК ОкончаниеПредположительно,
	|		1 КАК ФлагИзменений
	|	ИЗ
	|		ВТПредыдущиеДанныеРегистра КАК ПредыдущиеДанныеРегистра
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДанныеСостоянийСотрудников.Сотрудник,
	|		ДанныеСостоянийСотрудников.ДокументОснование,
	|		ДанныеСостоянийСотрудников.Сторно,
	|		ДанныеСостоянийСотрудников.Состояние,
	|		ДанныеСостоянийСотрудников.Начало,
	|		ДанныеСостоянийСотрудников.Окончание,
	|		ДанныеСостоянийСотрудников.ВидВремени,
	|		ДанныеСостоянийСотрудников.ОкончаниеПредположительно,
	|		-1
	|	ИЗ
	|		РегистрСведений.ДанныеСостоянийСотрудников КАК ДанныеСостоянийСотрудников
	|	ГДЕ
	|		ДанныеСостоянийСотрудников.Регистратор = &Регистратор) КАК СравнениеСПредыдущимНабором
	|
	|СГРУППИРОВАТЬ ПО
	|	СравнениеСПредыдущимНабором.Сотрудник,
	|	СравнениеСПредыдущимНабором.ДокументОснование,
	|	СравнениеСПредыдущимНабором.Сторно,
	|	СравнениеСПредыдущимНабором.Состояние,
	|	СравнениеСПредыдущимНабором.Начало,
	|	СравнениеСПредыдущимНабором.Окончание,
	|	СравнениеСПредыдущимНабором.ВидВремени,
	|	СравнениеСПредыдущимНабором.ОкончаниеПредположительно
	|
	|ИМЕЮЩИЕ
	|	СУММА(СравнениеСПредыдущимНабором.ФлагИзменений) <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИзменившиесяДанные.Сотрудник КАК Сотрудник,
	|	ИзменившиесяДанные.Начало КАК Начало,
	|	ИзменившиесяДанные.Окончание КАК Окончание
	|ПОМЕСТИТЬ ВТКлючиИзменившихсяДанных
	|ИЗ
	|	ВТИзменившиесяДанные КАК ИзменившиесяДанные";
	
	Запрос.УстановитьПараметр("Регистратор", ЭтотОбъект.Отбор.Регистратор.Значение);
	Запрос.Выполнить();
	
	СостоянияСотрудников.ОбновитьСостоянияСотрудников(Запрос.МенеджерВременныхТаблиц);
	
КонецПроцедуры

#КонецОбласти
	
#КонецЕсли