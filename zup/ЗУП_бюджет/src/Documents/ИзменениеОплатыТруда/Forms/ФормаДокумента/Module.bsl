
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	РасчетЗарплатыРасширенныйФормы.ИнициализироватьМеханизмПересчетаДокументаПриРедактировании(ЭтаФорма);
	КадровыйУчетФормы.ФормаКадровогоДокументаПриСозданииНаСервере(ЭтаФорма);
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		
		ИспользоватьШтатноеРасписание =  ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
		Объект.ДатаИзменения = ТекущаяДатаСеанса();
		
		ПриПолученииДанныхНаСервере(Объект);
		
		Если Параметры.Свойство("Сотрудник") И ЗначениеЗаполнено(Параметры.Сотрудник) Тогда 
			Объект.Сотрудник = Параметры.Сотрудник;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
			ЗаполнитьСоставДействующихНачисленийСотрудника();
			УстановитьТекущийАванс();
		КонецЕсли;
		
		Объект.ИзменитьНачисления = Истина;
		Объект.ИзменитьАванс = Ложь;
		
	КонецЕсли;
	
	Элементы.РазрядКатегория.Заголовок = РазрядыКатегорииДолжностей.ИнициализироватьЗаголовокФормыИРеквизитов("РеквизитРазрядКатегорияВКадровыхДокументах");	
	
	КадровыйУчетРасширенный.УстановитьПараметрыВыбораНачисленийПоКатегории(
		ЭтаФорма,
		ОписаниеТаблицыНачислений(),
		КадровыйУчетРасширенный.ПараметрыВыбораКатегорииНачислений());
	
	ЗарплатаКадрыРасширенный.УстановитьЗначениеСевернойНадбавкиВФорме(ЭтаФорма, Объект.Сотрудник, Объект.ДатаИзменения, Объект.ФизическоеЛицо);
	
	РазмерАвансаПоУмолчанию = РасчетЗарплатыФормы.РазмерАвансаВПроцентахПоУмолчанию(Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененСтажФизическогоЛица" И Источник.ВладелецФормы = ЭтаФорма Тогда
		ПриИзмененииСтажа();
		ВыполнитьРасчетФОТ();
	КонецЕсли;
	
	Если Источник = Объект.ФизическоеЛицо И ИмяСобытия = "РедактированиеПроцентаСевернойНадбавки" Тогда
		ПриИзмененииПроцентаСевернойНадбавки();
		ВыполнитьРасчетФОТ();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриПолученииДанныхНаСервере(ТекущийОбъект);
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДоступностьЭлементовФормы(ЭтаФорма);
	УстановитьПоказРазмераАванса(ЭтаФорма);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Объект.ИзменитьАванс Тогда
		
		РасчетЗарплатыФормы.ЗапомнитьРазмерАвансаПоУмолчанию(
			ТекущийОбъект.Аванс, ТекущийОбъект.Организация, ТекущийОбъект.СпособРасчетаАванса);
			
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи <> РежимЗаписиДокумента.ОтменаПроведения И Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если РасчетНеобходимоВыполнить Тогда
		
		РассчитатьФОТНаСервере();
		ЗарплатаКадрыРасширенный.ЗаполнитьТекущийОбъектОбъектомФормы(ТекущийОбъект, Объект);
		
	КонецЕсли;
	
	РеквизитыВДанные(ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПрочитатьВремяРегистрации();
	ДанныеНачисленийВРеквизит(ТекущийОбъект);
	УстановитьОтображениеНадписей();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_ИзменениеОплатыТруда", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекущийОбъект = РеквизитФормыВЗначение("Объект");
	РеквизитыВДанные(ТекущийОбъект);
	Отказ = Отказ Или Не ТекущийОбъект.ПроверитьЗаполнение();
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Объект");	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
 
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	СотрудникПриИзмененииНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура ДатаИзмененияПриИзменении(Элемент)
	
	ДатаИзмененияПриИзмененииНаСервере();
	ВыполнитьРасчетФОТ(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПКУПриИзменении(Элемент)
	
	ВыполнитьРасчетФОТ(Истина);
	Объект.ИзменитьНачисления = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрядКатегорияПриИзменении(Элемент)
	ВыполнитьРасчетФОТ(Истина);
	Объект.ИзменитьНачисления = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНачисленияПриИзменении(Элемент)
	
	ИзменитьНачисленияПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьАвансПриИзменении(Элемент)
	
	ОбновитьДоступностьЭлементовФормы(ЭтаФорма);
	
	УстановитьКомментарийКАвансу(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаАвансаПриИзменении(Элемент)
	
	Если Объект.СпособРасчетаАванса = ПредопределенноеЗначение("Перечисление.СпособыРасчетаАванса.ПроцентомОтТарифа") Тогда
		Объект.Аванс = РазмерАвансаПоУмолчанию;
	Иначе
		Объект.Аванс = 0;
	КонецЕсли; 
	
	УстановитьПоказРазмераАванса(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьДокументыВведенныеПозже(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.ДокументыВведенныеПозже);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьРанееВведенныеДокументы(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьВведенныеНаДатуДокументы(ЭтотОбъект.РанееВведенныеДокументы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ГрейдПриИзменении(Элемент)
	
	ГрейдПриИзмененииНаСервере();
	
КонецПроцедуры

#Область ОбработчикиСобытийТаблицыФормыНачисления

&НаКлиенте
Процедура НачисленияПриИзменении(Элемент)
	
	РассчитатьИтогиПоФОТ(ЭтаФорма);
		
КонецПроцедуры
	
&НаКлиенте
Процедура НачисленияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийВыбор(
		ЭтаФорма, Элемент, Поле, СтандартнаяОбработка, 1, Объект.Сотрудник, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриАктивизацииСтроки(Элемент)
	ОписаниеКоманднойПанелиНачислений = СоздатьОписаниеКоманднойПанелиНачислений();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриАктивизацииСтроки(ЭтаФорма, "Начисления", "НачисленияНачисление", 1, ОписаниеКоманднойПанелиНачислений);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийПриНачалеРедактирования(ЭтаФорма, "Начисления", 1, , НоваяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ОписаниеКоманднойПанелиНачислений = СоздатьОписаниеКоманднойПанелиНачислений();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийОтменитьНачисление(ЭтаФорма, "Начисления", 1, ОписаниеКоманднойПанелиНачислений);	
	ВыполнитьРасчетФОТ();
	
КонецПроцедуры

&НаКлиенте
Процедура НачисленияПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗарплатаКадрыРасширенныйКлиент.ВводПлановыхНачисленийРассчитатьФОТПриОкончанииРедактирования(ЭтаФорма, Элемент, 1, ОписаниеТаблицыНачислений()) Тогда
		ВыполнитьРасчетФОТ();
	Иначе
		РассчитатьИтогиПоФОТ(ЭтаФорма);
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура НачисленияНачислениеПриИзменении(Элемент)
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаНачисленийНачислениеПриИзменении(
		ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, Объект.Сотрудник, ТарифнаяСетка, РазрядКатегория, Объект.ДатаИзменения, ТарифнаяСеткаНадбавки, Объект.РазрядКатегория);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗначениеПоказателяПриИзмененииНачисления(Элемент)
	
	ОписаниеТаблицыНачислений = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьКомментарииДействийСНачислением(Элементы.Начисления.ТекущиеДанные,
		ЗарплатаКадрыРасширенныйКлиентСервер.МаксимальноеКоличествоПоказателейПоОписаниюТаблицы(ЭтаФорма, ОписаниеТаблицыНачислений, , 1), 1, ОписаниеТаблицыНачислений, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПересчитатьФОТДокумента(Элемент)
	
	ВыполнитьРасчетФОТ();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПересчитатьИтогиФОТДокумента(Элемент)
	
	РассчитатьИтогиПоФОТ(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыПоказатели

&НаКлиенте
Процедура ПоказателиПриАктивизацииСтроки(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаДополнительныхПоказателейПриАктивизацииСтроки(ЭтаФорма, "Показатели", "ПоказателиПоказатель", ОписаниеКоманднойПанелиПоказателей());
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПередУдалением(Элемент, Отказ)
	
	ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаДополнительныхПоказателейОтменитьПоказатель(ЭтаФорма, "Показатели", ОписаниеКоманднойПанелиПоказателей(), Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаПоТочностиДополнительногоПоказателя(ЭтотОбъект, "Показатели", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если НоваяСтрока Тогда
		ЗарплатаКадрыРасширенныйКлиент.РедактированиеСоставаДополнительныхПоказателейПриВводеНового(ЭтаФорма, Элемент.ТекущиеДанные);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиПоказательПриИзменении(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаПоТочностиДополнительногоПоказателя(ЭтотОбъект, "Показатели", 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказателиЗначениеПриИзменении(Элемент)
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьКомментарииДействийСДополнительнымПоказателем(Элементы.Показатели.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

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
Процедура РедактироватьФОТ(Команда)
	
	РедактироватьФОТ = НЕ Элементы.РедактироватьФОТ.Пометка;
	Элементы.РедактироватьФОТ.Пометка = РедактироватьФОТ;
	
	ЗарплатаКадрыРасширенныйКлиентСервер.УстановитьВидимостьВкладаВФОТРНачисленийРедактируемыхВОтдельныхПолях(ЭтаФорма, РедактироватьФОТ);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИзменитьЗначениеПоказателяСевернаяНадбавка(Команда)
	
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияПроцентаСевернойНадбавки(ЭтаФорма, Объект.Сотрудник, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаКлиенте
Процедура Рассчитать(Команда)
	
	РассчитатьФОТНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровестиИЗакрыть(Команда) Экспорт
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Истина, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПровести(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение);
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ПараметрыЗаписи = Новый Структура("РежимЗаписи", ?(Объект.Проведен, РежимЗаписиДокумента.Проведение, РежимЗаписиДокумента.Запись));
	ЗаписатьНаКлиенте(Ложь, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(ТекущийОбъект)
	
	ПрочитатьВремяРегистрации();
	
	ДополнитьФорму();
	ЗарплатаКадрыРасширенный.УстановитьНастройкиРедактированияНачисленийВОтдельныхПолях(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьТекущиеЗначенияНачисленийСотрудникаРедактируемыхВОтдельныхПолях(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьИзменениеСоставаПлановыхНачислений(ЭтаФорма, Объект.ИзменитьНачисления);
	УстановитьФункциональныеОпцииФормы();
	
	ДанныеНачисленийВРеквизит(ТекущийОбъект);
	УстановитьТекущийАванс();
	ПрочитатьКадровыеДанныеСотрудника();
	ПрочитатьТарифнуюСетку();
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтаФорма, ОписаниеТаблицыНачислений());
	ЗарплатаКадрыРасширенный.УстановитьТекстПоясненияКПорядкуПересчетаТарифныхСтавок(ЭтаФорма, "ПорядокРасчетаСтоимостиЕдиницыВремени");
	ЗарплатаКадрыРасширенный.УстановитьРазмерностьСовокупнойТарифнойСтавки(ЭтаФорма);
	ЗарплатаКадрыРасширенный.УстановитьКомментарийКРазмеруСовокупнойТарифнойСтавки(ЭтаФорма, Объект.ВидТарифнойСтавки,"СовокупнаяТарифнаяСтавкаРазмерность");
	
	РассчитатьИтогиПоФОТ(ЭтаФорма);
	
	УстановитьОтображениеНадписей();
	
	РазрядыКатегорииДолжностей.УстановитьСвязиПараметровВыбораРазрядаКадровогоПриказа(ЭтотОбъект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.УстановитьЗначениеПодсказкиГрейда(ЭтотОбъект, Объект.Грейд);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы() 
	
	ПараметрыФО = Новый Структура;
	ПараметрыФО.Вставить("Организация", Объект.Организация);
	
	УстановитьПараметрыФункциональныхОпцийФормы(ПараметрыФО);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыПлановыхНачислений(Истина, Истина);
	
	ОписаниеТаблицыВидовРасчета.Вставить("ЗапретитьИзменениеПоказателяТарифнойСетки", Истина);
	ОписаниеТаблицыВидовРасчета.Вставить("ПоказыватьВременноОтмененныеНачисления", Истина);
	ОписаниеТаблицыВидовРасчета.ИмяПоляДляВставкиПоказателей = "НачисленияДокументОснование";
	ОписаниеТаблицыВидовРасчета.СодержитПолеХарактерНачисления = Истина;
	
	Возврат ОписаниеТаблицыВидовРасчета;
	
КонецФункции

&НаСервере
Процедура ДополнитьФорму()
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();	
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Начисления", 1);
	ЗарплатаКадрыРасширенный.РедактированиеСоставаДополнительныхПоказателейДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета);
	ЗарплатаКадрыРасширенный.СформироватьСписокВыбораПорядкаПересчета(Элементы);
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Модуль.ГруппаГрейдДополнитьФормуКадровогоПриказа(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры	

&НаСервере
Процедура РеквизитыВДанные(ТекущийОбъект)
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенный.ВводНачисленийРеквизитВДанные(ЭтаФорма, ТекущийОбъект, ОписаниеТаблицыВидовРасчета, 1);	
КонецПроцедуры	

&НаСервере
Процедура ЗаполнитьСоставДействующихНачисленийСотрудника(РассчитатьИтогиПоФОТ = Истина)
	
	Объект.Начисления.Очистить();
	Объект.Показатели.Очистить();
	
	ТаблицаСотрудников = ТаблицаСотрудников();
	Если ТаблицаСотрудников.Количество() > 0 Тогда
		
		ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
		ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДействующиеНачисленияВРеквизит(Объект.Ссылка, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, Объект.ДатаИзменения);
		ЗарплатаКадрыРасширенный.УстановитьЗначениеСевернойНадбавкиВФорме(ЭтаФорма, Объект.Сотрудник, Объект.ДатаИзменения, Объект.ФизическоеЛицо);
		ЗарплатаКадрыРасширенный.УстановитьТекущееЗначениеПорядкаПересчетаТарифнойСтавки(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
		ЗарплатаКадрыРасширенный.УстановитьТекущееЗначениеСовокупнойТарифнойСтавки(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
		
	КонецЕсли;
	
	Если РассчитатьИтогиПоФОТ Тогда
		РассчитатьИтогиПоФОТ(ЭтаФорма);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	Объект.Начисления.Очистить();
	Объект.Показатели.Очистить();
	ЗаполнитьСоставДействующихНачисленийСотрудника(Ложь);
	УстановитьТекущийАванс();
	ПрочитатьКадровыеДанныеСотрудника();
	ЗаполнитьРазрядСотрудника();
	ЗаполнитьПКУСотрудника();
	ПрочитатьТарифнуюСетку();
	ПрочитатьГрейдСотрудника();
	
	ЗарплатаКадрыРасширенный.УстановитьНастройкиРедактированияНачисленийВОтдельныхПолях(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьТекущиеЗначенияНачисленийСотрудникаРедактируемыхВОтдельныхПолях(ЭтаФорма, Объект.Сотрудник, ВремяРегистрации);
	ЗарплатаКадрыРасширенный.УстановитьОтображениеНачисленийРедактируемыхВОтдельныхПолях(ЭтаФорма);
	ЗарплатаКадрыРасширенный.УстановитьИзменениеСоставаПлановыхНачислений(ЭтаФорма, Объект.ИзменитьНачисления);
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтаФорма, ОписаниеТаблицыНачислений());
	
	РассчитатьИтогиПоФОТ(ЭтаФорма);
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущийАванс()
	
	ТаблицаСотрудников = ТаблицаСотрудников();
	ДанныеОбАвансе = РасчетЗарплатыРасширенный.АвансыСотрудников(ТаблицаСотрудников, Объект.Ссылка);
	
	Если ДанныеОбАвансе.Количество() > 0 Тогда
		ТекущийСпособРасчетаАванса	= ДанныеОбАвансе[0].СпособРасчетаАванса;
		ТекущийАванс				= ДанныеОбАвансе[0].Аванс;
	КонецЕсли;
	
	УстановитьКомментарийКАвансу(ЭтаФорма)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПоказРазмераАванса(Форма)
	РасчетЗарплатыКлиентСервер.УстановитьПоказРазмераАванса(Форма);
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКомментарийКАвансу(Форма)
	
	Если Форма.Объект.ИзменитьАванс Тогда
		ТекстПодсказки = 
			РасчетЗарплатыКлиентСервер.КомментарийИзмененияАванса(
			Форма.ТекущийСпособРасчетаАванса, 
			Форма.ТекущийАванс)
	Иначе
		ТекстПодсказки = "";
	КонецЕсли;
	
	ЗарплатаКадрыКлиентСервер.УстановитьРасширеннуюПодсказкуЭлементуФормы(
		Форма,
		"АвансКомментарийГруппа",
		ТекстПодсказки);
			
КонецПроцедуры	

&НаСервере
Процедура ДатаИзмененияПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	
	ТаблицаСотрудников = ТаблицаСотрудников();

	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "ДокументОснование";
	
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийПрочитатьТекущиеДанные(Объект.Ссылка, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, , Объект.ДатаИзменения);
	УстановитьТекущийАванс();
	ПрочитатьТарифнуюСетку();
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры	

&НаСервере
Процедура ДанныеНачисленийВРеквизит(ТекущийОбъект)
	
	ТаблицаСотрудников = ТаблицаСотрудников();
	
	Если ТаблицаСотрудников.Количество() > 0 Тогда
		
		ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
		ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДанныеВРеквизит(ТекущийОбъект.Ссылка, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета, 1, , Объект.ДатаИзменения);
		ЗарплатаКадрыРасширенный.РедактированиеСоставаДополнительныхПоказателейДанныеВРеквизит(ТекущийОбъект.Ссылка, ТаблицаСотрудников, ЭтаФорма, ОписаниеТаблицыВидовРасчета);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОбновитьДоступностьЭлементовФормы(Форма) 
	
	ИзменитьНачисления	= Форма.Объект.ИзменитьНачисления;
	ИзменитьАванс		= Форма.Объект.ИзменитьАванс;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Начисления",
		"Доступность",
		ИзменитьНачисления);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПоказателиГруппа",
		"Доступность",
		ИзменитьНачисления);
		
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ПорядокПересчетаТарифнойСтавкиГруппа",
		"Доступность",
		ИзменитьНачисления);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"АвансКомментарийГруппа",
		"Доступность",
		ИзменитьАванс);
	
КонецФункции
 
&НаКлиенте
Функция СоздатьОписаниеКоманднойПанелиНачислений()
	ОписаниеКоманднойПанелиНачислений = ЗарплатаКадрыРасширенныйКлиент.ОписаниеКоманднойПанелиНачислений();
	Возврат ОписаниеКоманднойПанелиНачислений
КонецФункции

&НаКлиенте
Функция ОписаниеКоманднойПанелиПоказателей()
	
	ОписаниеКоманднойПанелиПоказателей = ЗарплатаКадрыРасширенныйКлиент.ОписаниеКоманднойПанелиПоказателей();
	Возврат ОписаниеКоманднойПанелиПоказателей;
	
КонецФункции

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	
	УстановитьФункциональныеОпцииФормы();
	СотрудникПриИзмененииНаСервере();
	
	РазмерАвансаПоУмолчанию = РасчетЗарплатыФормы.РазмерАвансаВПроцентахПоУмолчанию(Объект.Организация);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРасчетФОТ(ЗаполнитьДанныеТарифнойСетки = Ложь)
	
	Если ЗаполнитьДанныеТарифнойСетки Тогда
		ПерезаполнитьДанныеТарифнойСетки = Истина;
	КонецЕсли; 
	ЗарплатаКадрыРасширенныйКлиент.ПодключитьОбработчикОжиданияАвтоматическогоРасчета(ЭтаФорма, "РассчитатьФОТНаКлиенте");
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьФОТНаКлиенте()
	
	РассчитатьФОТНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьФОТНаСервере()
	
	Если ПерезаполнитьДанныеТарифнойСетки Тогда
		ЗаполнитьДанныеТарифнойСеткиНаСервере();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	
	ОписаниеТаблицыНачислений = ОписаниеТаблицыНачислений();
	ОписаниеДанныхСовокупнойСтавки = ПлановыеНачисленияСотрудниковФормы.ОписаниеДанныхТарифныхСтавок("Объект.ВидТарифнойСтавки", "Объект.СовокупнаяТарифнаяСтавка");
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	
	ПлановыеНачисленияСотрудниковФормы.ЗаполнитьДанныеПлановыхНачисленийПоСотруднику(
		ТаблицаНачислений,
		ТаблицаПоказателей,
		ЭтотОбъект,
		Объект.Сотрудник,
		ГоловнаяОрганизация,
		ВремяРегистрации,
		ОписаниеТаблицыНачислений);

	КадровыеДанные = ПлановыеНачисленияСотрудников.СоздатьТаблицуКадровыхДанныхПоСотруднику(
						Объект.Сотрудник, 
						ВремяРегистрации,
						Объект.Организация);
						
	РассчитанныеВторичныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей, КадровыеДанные); 					
		
	ПлановыеНачисленияСотрудниковФормы.РезультатРасчетаВторичныхДанныхПоСотрудникуВДанныеФормы(
		ЭтотОбъект, 
		РассчитанныеВторичныеДанные, 
		ГоловнаяОрганизация,
		ОписаниеТаблицыНачислений,
		ОписаниеДанныхСовокупнойСтавки);
		
	УстановитьПривилегированныйРежим(Ложь);	
	
	РассчитатьИтогиПоФОТ(ЭтаФорма);
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейПересчетаТарифнойСтавки(ЭтаФорма, ОписаниеТаблицыНачислений());

	ЗарплатаКадрыРасширенныйКлиентСервер.СброситьФлагНеобходимостиВыполненияРасчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьИтогиПоФОТ(Форма)
	
	Форма.ФОТ = ЗарплатаКадрыРасширенныйКлиентСервер.ИтогиПоФОТ(Форма, ОписаниеТаблицыНачислений());
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКадровыеДанныеСотрудника()
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Отбор = Новый Массив;
		Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
		ПоляОтбора = Новый Структура("ГрафикРаботыСотрудников", Отбор);
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ГрафикРаботы,Должность,ДолжностьПоШтатномуРасписанию", ВремяРегистрации, ПоляОтбора, Ложь);
		Если ДанныеСотрудников.Количество() > 0 Тогда
			ГрафикРаботы = ДанныеСотрудников[0].ГрафикРаботы;
			Должность = ДанныеСотрудников[0].Должность;
			ДолжностьПоШтатномуРасписанию = ДанныеСотрудников[0].ДолжностьПоШтатномуРасписанию;
		КонецЕсли;
	КонецЕсли;
	
	КадровыйУчетФормыРасширенный.УстановитьДанныеДолжностиВФорме(
		ЭтаФорма, ВремяРегистрации, Должность, ДолжностьПоШтатномуРасписанию);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПКУСотрудника()
	
	Объект.ПКУ = Неопределено;
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Отбор = Новый Массив;
		Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
		ПоляОтбора = Новый Структура("ПКУСотрудников", Отбор);
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "ПКУ", ВремяРегистрации, ПоляОтбора, Ложь);
		Если ДанныеСотрудников.Количество() > 0 Тогда
			Объект.ПКУ = ДанныеСотрудников[0].ПКУ;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Объект.ПКУ) Тогда 
			РазрядыКатегорииДолжностей.ЗаполнитьПКУСотрудникаПоУмолчанию(ЭтотОбъект, "Объект.ПКУ", ВремяРегистрации, ДолжностьПоШтатномуРасписанию);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРазрядСотрудника()
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		Отбор = Новый Массив;
		Отбор.Добавить(Новый Структура("ЛевоеЗначение,ВидСравнения,ПравоеЗначение","Регистратор", "<>", Объект.Ссылка));
		ПоляОтбора = Новый Структура("РазрядыКатегорииСотрудников", Отбор);
		ДанныеСотрудников = КадровыйУчет.КадровыеДанныеСотрудников(Истина, Объект.Сотрудник, "РазрядКатегория", ВремяРегистрации, ПоляОтбора, Ложь);
		Если ДанныеСотрудников.Количество() > 0 Тогда
			Объект.РазрядКатегория = ДанныеСотрудников[0].РазрядКатегория;
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьНачисленияПриИзмененииНаСервере()
	
	ЗарплатаКадрыРасширенный.УстановитьИзменениеСоставаПлановыхНачислений(ЭтаФорма, Объект.ИзменитьНачисления);
	
	ОбновитьДоступностьЭлементовФормы(ЭтаФорма);
	
	Если НЕ Объект.ИзменитьНачисления Тогда
		ЗаполнитьСоставДействующихНачисленийСотрудника();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ТаблицаСотрудников()
	
	ТаблицаСотрудников = Новый ТаблицаЗначений;
	ТаблицаСотрудников.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	ТаблицаСотрудников.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		СтрокаСотрудник = ТаблицаСотрудников.Добавить();
		СтрокаСотрудник.Сотрудник = Объект.Сотрудник;
		СтрокаСотрудник.Период = ВремяРегистрации;
		
	КонецЕсли;
	
	Возврат ТаблицаСотрудников;
	
КонецФункции

&НаСервере
Процедура УстановитьПредставленияКомандВводаСтажей()
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенный.УстановитьПредставленияКомандВводаСтажей(ЭтаФорма, ТаблицаСотрудников(), ОписаниеТаблицыВидовРасчета, 1);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииСтажа()
	
	УстановитьПредставленияКомандВводаСтажей();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииПроцентаСевернойНадбавки()
	
	ЗарплатаКадрыРасширенный.УстановитьЗначениеСевернойНадбавкиВФорме(ЭтаФорма, Объект.Сотрудник, Объект.ДатаИзменения, Объект.ФизическоеЛицо);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьТарифнуюСетку()
	
	РазрядыКатегорииДолжностей.ПрочитатьДанныеТарифныхСетокДолжностиВФорму(ЭтаФорма, Должность, ДолжностьПоШтатномуРасписанию, ВремяРегистрации);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьГрейдСотрудника()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыКорпоративнаяПодсистемы.Грейды") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
		Объект.Грейд = Модуль.ГрейдСотрудника(Объект.Сотрудник, ВремяРегистрации, Объект.Ссылка);
		Модуль.УстановитьЗначениеПодсказкиГрейда(ЭтотОбъект, Объект.Грейд);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ГрейдПриИзмененииНаСервере()
	
	Модуль = ОбщегоНазначения.ОбщийМодуль("Грейды");
	Модуль.УстановитьЗначениеПодсказкиГрейда(ЭтотОбъект, Объект.Грейд);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДанныеТарифнойСеткиНаСервере()
	
	ДополнительныеПараметры = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыЗаполненияЗначенийПоказателейТарифныхСеток();
	ДополнительныеПараметры.ДатаСведений = Объект.ДатаИзменения;
	ДополнительныеПараметры.ТарифнаяСетка = ТарифнаяСетка;
	ДополнительныеПараметры.ТарифнаяСеткаНадбавки = ТарифнаяСеткаНадбавки;
	ДополнительныеПараметры.РазрядКатегория = РазрядКатегория;
	ДополнительныеПараметры.РазрядКатегорияНадбавки = Объект.РазрядКатегория;
	ДополнительныеПараметры.ПКУ = Объект.ПКУ;
	
	ЗарплатаКадрыРасширенныйКлиентСервер.ЗаполнитьЗначенияПоказателейТарифныхСеток(ЭтаФорма, Объект.Начисления, ОписаниеТаблицыНачислений(), 1, ДополнительныеПараметры);
		
	ПерезаполнитьДанныеТарифнойСетки = Ложь;
		
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, Объект.Сотрудник, Объект.ДатаИзменения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
								МассивСотрудников, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ПараметрыЗаписи)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	ДополнительныеПараметры.Вставить("ПараметрыЗаписи", ПараметрыЗаписи);
	
	РасчетЗарплатыРасширенныйКлиент.ВыполнитьРасчетСотрудникаПередЗаписьюДокумента(ЭтаФорма, "ЗаписатьНаКлиентеЗавершение", ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиентеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		ПараметрыЗаписи = ДополнительныеПараметры.ПараметрыЗаписи;
		ЗакрытьПослеЗаписи = ДополнительныеПараметры.ЗакрытьПослеЗаписи;
		
		ПараметрыЗаписи.Вставить("ПроверкаПередЗаписьюВыполнена", Истина);
		Если Записать(ПараметрыЗаписи) И ЗакрытьПослеЗаписи Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
