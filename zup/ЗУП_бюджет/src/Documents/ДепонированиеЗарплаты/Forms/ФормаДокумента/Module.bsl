
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	УчетДепонированнойЗарплатыФормы.ДепонированиеЗарплатыПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить(ВзаиморасчетыССотрудникамиКлиент.ИмяСобытияИзмененияОплатыВедомости());
	Оповестить("Запись_ДепонированиеЗарплаты", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
    ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	УстановитьДоступностьЭлементов(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПриИзменении(Элемент) 
	ЗарплатаКадрыКлиент.КлючевыеРеквизитыЗаполненияФормыОчиститьТаблицы(ЭтаФорма);
	УстановитьДоступностьЭлементов(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура ГлавныйБухгалтерПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписей();
КонецПроцедуры

&НаКлиенте
Процедура КассирПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписей();
КонецПроцедуры

&НаКлиенте
Процедура БухгалтерПриИзменении(Элемент)
	НастроитьОтображениеГруппыПодписей();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДепоненты

&НаКлиенте
Процедура ДепонентыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ДепонентыПриОкончанииРедактированияНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДепонентыПослеУдаления(Элемент)
	ДепонентыПослеУдаленияНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Заполнить(Команда)
	
	ОчиститьСообщения();
	ЗаполнитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере() Экспорт
	НастроитьОтображениеГруппыПодписей();
	УстановитьДоступностьЭлементов(ЭтаФорма);
	ЗарплатаКадры.КлючевыеРеквизитыЗаполненияФормыЗаполнитьПредупреждения(ЭтотОбъект);
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура НастроитьОтображениеГруппыПодписей()
	ЗарплатаКадры.НастроитьОтображениеГруппыПодписей(Элементы.ПодписиГруппа, "Объект.Кассир", "Объект.ГлавныйБухгалтер", "Объект.Бухгалтер");
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	ОрганизацияВыбрана	= ЗначениеЗаполнено(Форма.Объект.Организация);
	ВедомостьВыбрана	= ЗначениеЗаполнено(Форма.Объект.Ведомость);

	Форма.Элементы.Ведомость.Доступность = ОрганизацияВыбрана;
	Форма.Элементы.ЗаполнениеГруппа.Доступность = ВедомостьВыбрана;
	Форма.Элементы.Депоненты.Доступность = ОрганизацияВыбрана;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	
	ТекущийОбъект  = РеквизитФормыВЗначение("Объект");
	
	Если ТекущийОбъект.МожноЗаполнитьАвтоматически() Тогда
		ТекущийОбъект.ЗаполнитьАвтоматически();
		ЗначениеВРеквизитФормы(ТекущийОбъект , "Объект")
	КонецЕсли;	
	
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДепонентыПриОкончанииРедактированияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ДепонентыПослеУдаленияНаСервере()
	ЗарплатаКадрыКлиентСервер.КлючевыеРеквизитыЗаполненияФормыУстановитьОтображениеПредупреждения(ЭтотОбъект);
КонецПроцедуры

#Область КлючевыеРеквизитыЗаполненияФормы

// Функция возвращает описание таблиц формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыТаблицыОчищаемыеПриИзменении() Экспорт
	Массив = Новый Массив;
	Массив.Добавить("Объект.Депоненты");
	Возврат Массив
КонецФункции 

// Функция возвращает массив реквизитов формы подключенных к механизму ключевых реквизитов формы.
&НаСервере
Функция КлючевыеРеквизитыЗаполненияФормыОписаниеКлючевыхРеквизитов() Экспорт
	Массив = Новый Массив;
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Организация",					Нстр("ru = 'организации'")));
	Массив.Добавить(Новый Структура("ЭлементФормы, Представление", "Ведомость",						Нстр("ru = 'ведомости'")));
	Возврат Массив
КонецФункции

#КонецОбласти

#КонецОбласти
