
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.ГруппаРазмерОклада.Заголовок = ?(
		ПолучитьФункциональнуюОпцию("ИспользоватьГосударственнуюСлужбу") 
			Или ПолучитьФункциональнуюОпцию("НачислятьОкладЗаКлассныйЧинМуниципальнымСлужащим"),
		НСтр("ru = 'Оклад за классный чин, ранг'"), 
		НСтр("ru = 'Надбавка к должностному окладу за классный чин, ранг'"));
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ИзмеренияДаты = КлассныеЧиныРанги.ИсходныеДанныеДляОпределенияОкладовНадбавокПоКласснымЧинамРангам();
	
	НоваяСтрока = ИзмеренияДаты.Добавить();
	НоваяСтрока.КлассныйЧинРанг = Объект.Ссылка;
	НоваяСтрока.Период = ТекущаяДатаСеанса();
	
	ЗначенияОкладовНадбавок = КлассныеЧиныРанги.ЗначенияДействующихОкладовНадбавокПоКласснымЧинамРангам(ИзмеренияДаты, Объект.Ссылка);
	
	Если ЗначенияОкладовНадбавок.Количество() > 0 Тогда 
		ДатаУтверждения = ЗначенияОкладовНадбавок[0].ПериодЗаписи;
		Размер = ЗначенияОкладовНадбавок[0].Размер;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Наименование) И Не ЗначениеЗаполнено(Объект.ОчередностьВГруппе) Тогда
		
		Позиция1 = СтрНайти(Объект.Наименование, "1");
		Позиция2 = СтрНайти(Объект.Наименование, "2");
		Позиция3 = СтрНайти(Объект.Наименование, "3");
		
		Если Позиция1 > 0 И Позиция2 = 0 И Позиция3 = 0 Тогда
			Объект.ОчередностьВГруппе = 3;
		ИначеЕсли Позиция2 > 0 И Позиция1 = 0 И Позиция3 = 0 Тогда
			Объект.ОчередностьВГруппе = 2;
		ИначеЕсли Позиция3 > 0 И Позиция1 = 0 И Позиция2 = 0 Тогда
			Объект.ОчередностьВГруппе = 1;	
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ИсторияИзменения(Команда)
	
	Отбор = Новый Структура("КлассныйЧинРанг", Объект.Ссылка);
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	ОткрытьФорму("РегистрСведений.ОкладыНадбавкиПоКласснымЧинамРангам.Форма.ИсторияИзменения", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Изменить(Команда)
	
	ОткрытьФорму("Документ.УтверждениеОкладовНадбавокЗаКлассныеЧины.ФормаСписка", , ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства 
&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

#КонецОбласти
