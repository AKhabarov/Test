
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		
		ЗначенияДляЗаполнения = Новый Структура("Организация, Ответственный", 
			"Объект.Организация", "Объект.Ответственный");
		ЗарплатаКадры.ЗаполнитьПервоначальныеЗначенияВФорме(ЭтаФорма, ЗначенияДляЗаполнения);
		
		ПриПолученииДанныхНаСервере();
		
		РасчетЗарплатыРасширенныйФормы.ЗаполнитьНачислениеВФормеДокументаПоКатегории(
			ЭтаФорма, Объект.Начисление, Перечисления.КатегорииНачисленийИНеоплаченногоВремени.ДоплатаДоСреднегоЗаработка);
		
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужбаФормы");
		Модуль.УстановитьПараметрыВыбораСотрудников(ЭтаФорма, "Сотрудник");
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПриПолученииДанныхНаСервере();
	
	ОбменДаннымиЗарплатаКадры.ПриЧтенииНаСервереДокумента(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПриказНаДоплатуДоСреднегоЗаработка", ПараметрыЗаписи, Объект.Ссылка);
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОповеститьОбИсправленииДокумента(Объект.Ссылка, Объект.ИсправленныйДокумент, ПараметрыЗаписи.РежимЗаписи, "ПериодическиеСведения");
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыНачисления" И Источник = ЭтаФорма Тогда
		ЗаполнитьНачисленияИзВРеменногоХранилища(Параметр.АдресВХранилище);
	КонецЕсли;
	ИсправлениеДокументовЗарплатаКадрыКлиент.ОбработкаОповещенияИсправленногоДокумента(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
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
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	СотрудникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	
	ДатаНачалаПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура НачислениеПриИзменении(Элемент)
	
	НачислениеПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияИзменитьФОТНажатие(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Сотрудник) Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("АдресВХранилище", АдресВХранилищеНачисленийИУдержаний(Объект.Сотрудник));
		ПараметрыОткрытия.Вставить("ТолькоПросмотр", ТолькоПросмотр);
		
		ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияСоставаНачисленийИУдержаний(ПараметрыОткрытия, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазмерДоплатыУтвержденПриИзменении(Элемент)
	РазмерДоплатыУтвержденПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура РазмерДоплатыУтвержденПриИзмененииНаСервере()
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "РазмерДоплатыУтвержден");
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

// ИсправлениеДокументов
&НаКлиенте
Процедура Подключаемый_Исправить(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.Исправить(Объект.Ссылка, "ПриказНаДоплатуДоСреднегоЗаработка");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправлению(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправлению(ЭтаФорма.ДокументИсправление, "ПриказНаДоплатуДоСреднегоЗаработка");
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПерейтиКИсправленному(Команда)
	ИсправлениеДокументовЗарплатаКадрыКлиент.ПерейтиКИсправленному(Объект.ИсправленныйДокумент, "ПриказНаДоплатуДоСреднегоЗаработка");
КонецПроцедуры
// Конец ИсправлениеДокументов

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере()
	
	ДополнитьФорму();
	ДанныеВРеквизиты();
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьФорму()
	
	ОписаниеТаблицыВидовРасчета = ОписаниеТаблицыНачислений();
	ЗарплатаКадрыРасширенный.РедактированиеСоставаНачисленийДополнитьФорму(ЭтаФорма, ОписаниеТаблицыВидовРасчета, "Начисления", 1, Ложь);
	
	ЗарплатаКадрыРасширенный.ОформлениеНесколькихДокументовНаОднуДатуДополнитьФорму(ЭтотОбъект);
	
	ИсправлениеДокументовЗарплатаКадры.ГруппаИсправлениеДополнитьФорму(ЭтаФорма, Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ДанныеВРеквизиты()
	
	УстановитьДоступностьРегистрацииНачислений();
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПрочитатьВремяРегистрации();
	
	ИспользуетсяРасчетЗарплаты = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная");
	
	ЗарплатаКадрыРасширенный.МногофункциональныеДокументыДобавитьЭлементыФормы(ЭтаФорма, НСтр("ru='Доплата утверждена'"), , "РазмерДоплатыУтвержден");
	
	УстановитьВидимостьРасчетныхПолей();
	
	ЗарплатаКадрыРасширенный.УстановитьПредупреждающуюНадписьВМногофункциональныхДокументах(ЭтаФорма, "РазмерДоплатыУтвержден");
	
	Если ИспользуетсяРасчетЗарплаты И Не ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений И Объект.РазмерДоплатыУтвержден Тогда 
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		РассчитатьФОТНаФорме(ЭтаФорма);
	КонецЕсли;
	
	ИсправлениеДокументовЗарплатаКадры.ПрочитатьРеквизитыИсправления(ЭтаФорма, "ПериодическиеСведения");
	ИсправлениеДокументовЗарплатаКадрыКлиентСервер.УстановитьПоляИсправления(ЭтаФорма, "ПериодическиеСведения");
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьРасчетныхПолей()
	
	ИменаЭлементов = Новый Массив;
	ИменаЭлементов.Добавить("Начисление");
	ИменаЭлементов.Добавить("ГруппаФОТ");
	
	ЗарплатаКадрыРасширенный.УстановитьОтображениеПолейМногофункциональныхДокументов(ЭтаФорма, ИменаЭлементов);
	
	Если ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений Тогда 
		ЗарплатаКадрыРасширенный.УстановитьОтображениеГруппыФормы(Элементы, "ГруппаФОТ", "ТолькоПросмотр", Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьРегистрацииНачислений()
	
	ПраваНаДокумент = ЗарплатаКадрыРасширенный.ПраваНаМногофункциональныйДокумент(Объект);
	РегистрацияНачисленийДоступна = ПраваНаДокумент.ПолныеПраваПоРолям;
	ОграниченияНаУровнеЗаписей = Новый ФиксированнаяСтруктура(ПраваНаДокумент.ОграниченияНаУровнеЗаписей);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей()
	
	БылиОграничения = ОграниченияНаУровнеЗаписей;
	УстановитьДоступностьРегистрацииНачислений();
	
	Если БылиОграничения.ЧтениеБезОграничений <> ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений
		Или БылиОграничения.ИзменениеБезОграничений <> ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений
		Или БылиОграничения.ИзменениеКадровыхДанных <> ОграниченияНаУровнеЗаписей.ИзменениеКадровыхДанных Тогда 
		
		Объект.РазмерДоплатыУтвержден = ОграниченияНаУровнеЗаписей.ИзменениеБезОграничений;
		
		УстановитьВидимостьРасчетныхПолей();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ОписаниеТаблицыНачислений()
	
	ОписаниеТаблицыВидовРасчета = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыРасчета();
	ОписаниеТаблицыВидовРасчета.ПутьКДанным = "Объект.НачисленияСотрудника";
	ОписаниеТаблицыВидовРасчета.ПутьКДаннымПоказателей = "";
	ОписаниеТаблицыВидовРасчета.ИмяРеквизитаДокументОснование = "ДокументОснование";
	
	Возврат ОписаниеТаблицыВидовРасчета;	
	
КонецФункции	

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьФОТНаФорме(Форма)
	Форма.ФОТ = Форма.Объект.НачисленияСотрудника.Итог("Размер");
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияСотрудника()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Объект.НачисленияСотрудника.Очистить();
	
	СотрудникиДаты = Новый ТаблицаЗначений;
	СотрудникиДаты.Колонки.Добавить("Сотрудник", Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
	СотрудникиДаты.Колонки.Добавить("Период", Новый ОписаниеТипов("Дата"));
	
	НоваяСтрока = СотрудникиДаты.Добавить();
	НоваяСтрока.Сотрудник = Объект.Сотрудник;
	НоваяСтрока.Период = ВремяРегистрации;
	
	ДанныеНачислений = РасчетЗарплатыРасширенный.ДействующиеПлановыеНачисления(СотрудникиДаты, Объект.Ссылка);
	
	СтрокиДоплаты = ДанныеНачислений.Начисления.НайтиСтроки(Новый Структура("Начисление", Объект.Начисление));
	Для Каждого СтрокаДоплаты Из СтрокиДоплаты Цикл
		ДанныеНачислений.Начисления.Удалить(СтрокаДоплаты);
	КонецЦикла;
	
	Объект.НачисленияСотрудника.Загрузить(ДанныеНачислений.Начисления);
	
	НачислениеШапки = Объект.НачисленияСотрудника.Добавить();
	НачислениеШапки.Начисление = Объект.Начисление;
	НачислениеШапки.Размер = 0;
	
КонецПроцедуры

&НаСервере
Процедура РассчитатьФОТПоДокументу()
	
	Если Не ЗначениеЗаполнено(Объект.Начисление) Или Не ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаНачислений = ПлановыеНачисленияСотрудников.ТаблицаНачисленийДляРасчетаВторичныхДанных();
	ТаблицаПоказателей = ПлановыеНачисленияСотрудников.ТаблицаИзвестныеПоказатели();
	
	ГоловнаяОрганизация = ЗарплатаКадрыПовтИсп.ГоловнаяОрганизация(Объект.Организация);
	
	ОписаниеТаблицыНачислений = ОписаниеТаблицыНачислений();
	
	ПлановыеНачисленияСотрудниковФормы.ЗаполнитьДанныеПлановыхНачисленийПоСотруднику(
		ТаблицаНачислений,
		ТаблицаПоказателей,
		ЭтотОбъект,
		Объект.Сотрудник,
		ГоловнаяОрганизация,
		ВремяРегистрации,
		ОписаниеТаблицыНачислений);
		
	РассчитанныеДанные = ПлановыеНачисленияСотрудников.РассчитатьВторичныеДанныеПлановыхНачислений(ТаблицаНачислений, ТаблицаПоказателей);	
	
	ПлановыеНачисленияСотрудниковФормы.РезультатРасчетаВторичныхДанныхПоСотрудникуВДанныеФормы(
		ЭтотОбъект,
		РассчитанныеДанные, 
		ГоловнаяОрганизация,
		ОписаниеТаблицыНачислений);
		
	УстановитьПривилегированныйРежим(Ложь);
	
	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьВремяРегистрации()
	
	ВремяРегистрации = ЗарплатаКадрыРасширенный.ВремяРегистрацииСотрудникаДокумента(Объект.Ссылка, Объект.Сотрудник, Объект.ДатаНачала);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтображениеНадписей()
	
	МассивСотрудников = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Сотрудник);
	ЗарплатаКадрыРасширенный.УстановитьТекстНадписиОДокументахВведенныхНаДату(ЭтотОбъект, ВремяРегистрации, 
		МассивСотрудников, Объект.Ссылка, ОграниченияНаУровнеЗаписей.ЧтениеБезОграничений, Объект.ИсправленныйДокумент);
	
КонецПроцедуры

// Работа с данными формы редактирования начислений.

&НаСервере
Функция АдресВХранилищеНачисленийИУдержаний(Сотрудник)
	
	ПараметрыОткрытия = ЗарплатаКадрыРасширенныйКлиентСервер.ПараметрыРедактированияСоставаНачисленийИУдержаний();
	
	ПараметрыОткрытия.ВладелецНачисленийИУдержаний = Сотрудник;
	ПараметрыОткрытия.ДатаРедактирования = ВремяРегистрации;
	ПараметрыОткрытия.Организация = Объект.Организация;
	ПараметрыОткрытия.РежимРаботы = 3;
	ПараметрыОткрытия.ДополнитьНедостающиеЗначенияПоказателей = Истина;
	
	ДополнитьСтруктуруНачислениямиИПоказателями(Сотрудник, ПараметрыОткрытия.Подразделение, ПараметрыОткрытия);
	
	Возврат ПоместитьВоВременноеХранилище(ПараметрыОткрытия, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ДополнитьСтруктуруНачислениямиИПоказателями(Сотрудник, Подразделение, ПараметрыОткрытия)
	
	МассивНачислений = Новый Массив;
	МассивПоказателей = Новый Массив;
	
	ИдентификаторСтрокиВидаРасчета = 1;
	
	// Добавление всех начислений сотрудника (кроме начисления шапки).
	Для Каждого СтрокаНачислений Из Объект.НачисленияСотрудника Цикл
		
		СтруктураНачисления = Новый Структура("Начисление,ДокументОснование,ИдентификаторСтрокиВидаРасчета,Размер");
		ЗаполнитьЗначенияСвойств(СтруктураНачисления, СтрокаНачислений);
		СтруктураНачисления.ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета;
		МассивНачислений.Добавить(СтруктураНачисления);
		
		ИдентификаторСтрокиВидаРасчета = ИдентификаторСтрокиВидаРасчета + 1;
		
	КонецЦикла;
	
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Используется = Истина;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.Таблица = МассивНачислений;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьСоставВидовРасчета = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ИзменятьЗначенияПоказателей = Ложь;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.НомерТаблицы = 1;
	ПараметрыОткрытия.ОписаниеТаблицыНачислений.ПоказатьФОТ = Истина;
	
	ПараметрыОткрытия.Показатели = МассивПоказателей;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНачисленияИзВРеменногоХранилища(АдресВХранилище);
	
	ДанныеИзХранилища = ПолучитьИзВременногоХранилища(АдресВХранилище);
	Если ДанныеИзХранилища = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудник = ДанныеИзХранилища.ВладелецНачисленийИУдержаний;
	Если Сотрудник <> Объект.Сотрудник Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого НачислениеСотрудника Из ДанныеИзХранилища.Начисления Цикл
		
		СтрокиНачисления = Объект.НачисленияСотрудника.НайтиСтроки(Новый Структура("Начисление", НачислениеСотрудника.Начисление));
		Если СтрокиНачисления.Количество() > 0 Тогда
			СтрокиНачисления[0].Размер = НачислениеСотрудника.Размер;
		КонецЕсли;		
		
	КонецЦикла;
	
	РассчитатьФОТНаФорме(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура СотрудникПриИзмененииНаСервере()
	
	ПрочитатьВремяРегистрации();
	
	ПриИзмененииРеквизитовОпределяющихОграниченияНаУровнеЗаписей();
	
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
	
	УстановитьОтображениеНадписей();
	
КонецПроцедуры

&НаСервере
Процедура ДатаНачалаПриИзмененииНаСервере()
	ПрочитатьВремяРегистрации();
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
	УстановитьОтображениеНадписей();
КонецПроцедуры

&НаСервере
Процедура НачислениеПриИзмененииНаСервере()
	ЗаполнитьНачисленияСотрудника();
	РассчитатьФОТПоДокументу();
КонецПроцедуры

#КонецОбласти
