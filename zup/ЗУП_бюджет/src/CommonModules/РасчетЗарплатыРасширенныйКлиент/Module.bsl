
#Область СлужебныйПрограммныйИнтерфейс

// Процедура предназначена для описания действий, 
// выполняемых по команде расшифровки значения показателя.
//
// Параметры:
//	- Форма - управляемая форма документа, выполняющего начисление.
//	- ОписаниеТаблицы - описание таблицы документа с данными показателей.
//	- Элемент - таблица формы
//	- ВыбраннаяСтрока - идентификатор строки таблицы.
//	- Поле - поле формы, в котором размещена команда расшифровки.
//	- СтандартнаяОбработка - признак необходимости выполнения стандартной обработки, 
//							используется для отметки о выполнении команды расшифровки.
//
Процедура ВыполнитьКомандуРасшифровкиЗначенияПоказателя(Форма, ОписаниеТаблицы, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ОповещениеЗавершения = Неопределено) Экспорт
	
	Перем ПересчитыватьСотрудника;
	
	РасчетЗарплатыРасширенныйКлиентПереопределяемый.ВыполнитьКомандуРасшифровкиЗначенияПоказателя(Форма, ОписаниеТаблицы, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ПересчитыватьСотрудника);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("ОписаниеТаблицы", ОписаниеТаблицы);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Если СтандартнаяОбработка Тогда 
		// Если это показатель сдельного заработка - открываем соответствующую форму, если нет - идем далее.
		ОбработкаРасшифровкиСдельногоЗаработка(Форма, ОписаниеТаблицы, Элемент, Поле, СтандартнаяОбработка);
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль("РасчетДенежногоДовольствияКлиент");
			Модуль.РасшифровкаЗначенияПоказателяДенежногоДовольствия(Форма, ОписаниеТаблицы, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
		КонецЕсли; 		
		Если СтандартнаяОбработка Тогда
			Оповещение = Новый ОписаниеОповещения("ВыполнитьКомандуРасшифровкиЗначенияПоказателяЗавершение", ЭтотОбъект, ДополнительныеПараметры);
			УчетСреднегоЗаработкаКлиент.РасшифровкаЗначенияПоказателяСреднегоЗаработка(Форма, ОписаниеТаблицы, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ПересчитыватьСотрудника, Оповещение);
		КонецЕсли;
	Иначе 
		Результат = Новый Структура("ПересчитыватьСотрудника, СтандартнаяОбработка", ПересчитыватьСотрудника, СтандартнаяОбработка);
		ВыполнитьКомандуРасшифровкиЗначенияПоказателяЗавершение(Результат, ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКомандуРасшифровкиЗначенияПоказателяЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ПересчитыватьСотрудника = Результат.ПересчитыватьСотрудника;
	СтандартнаяОбработка = Результат.СтандартнаяОбработка;
	
	Форма = ДополнительныеПараметры.Форма;
	ОписаниеТаблицы = ДополнительныеПараметры.ОписаниеТаблицы;
	ОповещениеЗавершения = ДополнительныеПараметры.ОповещениеЗавершения;
	
	// Если команда выполнена - считаем, что выполнено редактирование таблицы.
	Если Не СтандартнаяОбработка Тогда
		РасчетЗарплатыКлиент.СтрокаРасчетаПриОкончанииРедактирования(Форма, ОписаниеТаблицы, ПересчитыватьСотрудника);
	КонецЕсли;
	
	Если ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ОповещениеЗавершения);
	КонецЕсли;
	
КонецПроцедуры

// Процедура предназначена для заполнения в строке документа, 
// выполняющего начисления, значений показателей, 
// а также сведений сотрудника (подразделение, график работы и др.).
// Используется при изменении одного или нескольких полей, влияющих на такие сведения.
//
// Параметры:
//	Форма						- управляемая форма документа.
//	ОписаниеТаблицыВидовРасчета	- структура, содержащая сведения об изменяемой таблицы начислений
//	ЗаполнятьСведенияСотрудников- булево, определяет необходимость обновления кадровых данных
//	ЗаполнятьЗначенияПоказателей- булево, определяет необходимость обновления значений показателей.
//
Процедура ДополнитьСтрокуРасчета(Форма, ОписаниеТаблицы, ЗаполнятьСведенияСотрудников = Истина, ЗаполнятьЗначенияПоказателей = Истина) Экспорт
	
	СтрокаТаблицы = Форма.Элементы[ОписаниеТаблицы.ИмяТаблицы].ТекущиеДанные;
	
	Если СтрокаТаблицы = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Если ЗаполнятьЗначенияПоказателей Тогда
		// Если для таблицы контролируется заполнение значений показателей,
		// не перезаполняем показатели, если они интерактивно изменялись.
		ИспользуетсяФиксЗаполнение = СтрокаТаблицы.Свойство("ФиксЗаполнение");
		Если ИспользуетсяФиксЗаполнение
			И СтрокаТаблицы["ФиксЗаполнение"] Тогда
			ЗаполнятьЗначенияПоказателей = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Форма.ДополнитьСтроку(СтрокаТаблицы.ПолучитьИдентификатор(), ОписаниеТаблицы, ЗаполнятьСведенияСотрудников, ЗаполнятьЗначенияПоказателей);
	
	Если ЗаполнятьЗначенияПоказателей И ИспользуетсяФиксЗаполнение Тогда
		// Подменим прежние значения, чтобы отличить заполнение по строке 
		// от интерактивного изменения показателей.
		СтарыеЗначенияКонтролируемыхПолей = Форма.ПолучитьСтарыеЗначенияКонтролируемыхПолей();
		Для НомерПоказателя = 1 По ЗарплатаКадрыРасширенныйКлиентСервер.МаксимальноеКоличествоПоказателейПоОписаниюТаблицы(Форма, ОписаниеТаблицы) Цикл
			СтарыеЗначенияКонтролируемыхПолей[ОписаниеТаблицы.ИмяТаблицы + "Значение" + НомерПоказателя] = СтрокаТаблицы["Значение" + НомерПоказателя];
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура открывает общую форму, показывающую, какие удержания были рассчитаны при расчете начислений в документе.
//
// Параметры:
//	Объект			- основной реквизит формы документа.
//	ИмяДокумента	- имя документа.
//	Владелец		- элемент, в который необходимо возвратить результат оповещения.
//
// Возвращаемое значение
//	Форма при закрытии отправляет оповещение владельцу, с которым передается содержимое ТЧ Удержания и Показатели.
//
Процедура ОткрытьФормуПодробнееОРасчетеУдержаний(Объект, ИмяДокумента, Владелец, ОписаниеДокумента) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Объект",		Объект);
	ПараметрыФормы.Вставить("ИмяДокумента",	ИмяДокумента);
	ПараметрыФормы.Вставить("ОписаниеДокумента", ОписаниеДокумента);
	
	ОткрытьФорму("ОбщаяФорма.ПодробнееОРасчетеУдержаний", ПараметрыФормы, Владелец);
	
КонецПроцедуры

// Осуществляет старт процесса по заполнению документа с клиента.
// Проверяет наличие исправленных строк и выполняет диалог с пользователем в случае их наличия.
//
Процедура ЗаполнитьДокументНачисленияЗарплаты(Форма) Экспорт
	
	Если Не Форма.ЕстьИсправленныеСтроки() Тогда
		// Если строки документа не содержат ручных исправлений, то просто заполняем документ, как будто он пустой.
		Форма.ЗаполнитьДанныеФормыНаКлиенте();
		Возврат;
	КонецЕсли;
	
	// Если есть исправленные строки, то необходимо выяснить как именно заполнять: 
	// полным перезаполнением или обновлением с учетом исправлений.
	ДополнительныеПараметры = Новый Структура("Форма", Форма);
	
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьДокументНачисленияЗарплатыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстВопроса = НСтр("ru = 'Документ содержит ручные исправления (выделены шрифтом). 
                         |Сохранить их при перезаполнении?'");
						 
	КнопкиОтвета = Новый СписокЗначений;
	КнопкиОтвета.Добавить("Перезаполнить", НСтр("ru = 'Сохранить'"));
	КнопкиОтвета.Добавить("Заполнить", НСтр("ru = 'Не сохранять'"));
	КнопкиОтвета.Добавить("Отмена", НСтр("ru = 'Отмена'"));
	
	ПоказатьВопрос(Оповещение, ТекстВопроса, КнопкиОтвета, , "Заполнить", НСтр("ru = 'Заполнение документа'"));
	
КонецПроцедуры

// Завершение процесса заполнения документа.
// Старт осуществляется методом ЗаполнитьДокументНачисленияЗарплаты.
//
Процедура ЗаполнитьДокументНачисленияЗарплатыЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = "Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	Форма = Параметры.Форма;
	
	Если Результат = "Заполнить" Тогда
		Форма.ЗаполнитьДанныеФормыНаКлиенте();
	ИначеЕсли Результат = "Перезаполнить" Тогда
		Форма.ПерезаполнитьДанныеФормыНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

Процедура ФормаПодробнееОРасчетеНДФЛКорректировкиВыплатыВыбор(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ОписаниеТаблицыКорректировкиВыплаты, МесяцНачисления, Организация) Экспорт
	
	Если СтрНайти(Поле.Имя, "КомандаРедактированияРаспределения") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияРезультатовРаспределенияПоИсточникамФинансирования(
		Форма, ОписаниеТаблицыКорректировкиВыплаты, ВыбраннаяСтрока, МесяцНачисления, Организация);
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ФормаПодробнееОРасчетеНДФЛПерераспределитьКорректировкиВыплаты(СтрокаКорректировкиВыплаты, РаботаВБюджетномУчреждении) Экспорт
	ОтражениеЗарплатыВБухучетеКлиентСерверРасширенный.ПерераспределитьКорректировкиВыплаты(СтрокаКорректировкиВыплаты, РаботаВБюджетномУчреждении);
КонецПроцедуры

Процедура ФормаПодробнееОРасчетеНДФЛВыполнитьКомандуРедактированияРезультатовРаспределенияНачисленийИУдержаний(Форма, КорректировкиВыплаты, Организация, МесяцНачисления, Элемент, СтандартнаяОбработка = Истина) Экспорт
	
	ОписаниеТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ОписаниеТаблицыКорректировкиВыплаты();
	ОписаниеТаблицы.ПутьКДанным = "КорректировкиВыплаты";
	ОписаниеТаблицы.ПроверяемыеРеквизиты = "ФизическоеЛицо";
	ОписаниеТаблицы.ПутьКДаннымРаспределениеРезультатов = "РаспределениеРезультатовУдержаний";
	ОписаниеТаблицы.ПутьКДаннымАдресРаспределенияРезультатовВХранилище = "АдресТаблицыРаспределенияУдержаний";
	ОписаниеТаблицы.ОтображатьПоляРаспределенияРезультатов = Истина;
	
	Если СтрНайти(Элемент.Имя, "КорректировкаВыплаты") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если КорректировкиВыплаты.Количество() = 0 Тогда
		Если Форма.УчитываемыеСотрудники.Количество() = 1 И Форма.ЕдинственныйСотрудник Тогда
			НоваяСтрокаКорректировкиВыплаты = КорректировкиВыплаты.Добавить();
			НоваяСтрокаКорректировкиВыплаты.ФизическоеЛицо = Форма.УчитываемыеСотрудники[0];
			НоваяСтрокаКорректировкиВыплаты.РезультатРаспределения = Новый ФиксированныйМассив(Новый Массив);
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ВыбраннаяСтрока = КорректировкиВыплаты[0].ПолучитьИдентификатор();
	
	ТаблицаСДанными = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеТаблицы.ПутьКДанным);
	ТекущиеДанные = ТаблицаСДанными.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	ОбработчикПослеЗакрытия = Новый ОписаниеОповещения("ФормаПодробнееОРасчетеНДФЛРаспределениеПоИсточникамФинансированияПослеЗакрытия", ЭтотОбъект);
	ЗарплатаКадрыРасширенныйКлиент.ОткрытьФормуРедактированияРезультатовРаспределенияПоИсточникамФинансирования(Форма, ОписаниеТаблицы, ВыбраннаяСтрока, МесяцНачисления, Организация, ОбработчикПослеЗакрытия);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ФормаПодробнееОРасчетеНДФЛРаспределениеПоИсточникамФинансированияПослеЗакрытия(РезультатОповещения, ДополнительныеПараметры) Экспорт
	
	Если РезультатОповещения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасчетЗарплатыКлиентСервер.ФормаПодробнееОРасчетеНДФЛУстановитьВидимостьЭлементов(РезультатОповещения.Форма);
	
КонецПроцедуры

#Область РаспределениеПоТерриториямУсловиямТруда

Функция ПараметрыДляВыбораПолеРаспределениеПоТерриториямУсловиямТруда() Экспорт
	
	ПараметрыДляВыбора = Новый Структура(
		"Форма, 
		|ОписаниеДокумента,
		|ОписаниеТаблицы");
		
	Возврат ПараметрыДляВыбора;
	
КонецФункции

Процедура ПриНажатииПолеРаспределениеПоТерриториямУсловиямТруда(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ПараметрыДляВыбора) Экспорт
	
	ЧастиИмени = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Поле.Имя, "_");
	Если ЧастиИмени.Найти("РаспределениеПоТерриториямУсловиямТруда") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Форма = ПараметрыДляВыбора.Форма;
	ОписаниеТаблицы = ПараметрыДляВыбора.ОписаниеТаблицы;
	
	// Подготовим строки распределения по соответствующей выбранной строке.
	// Откроем форму распределения.
	// По результатам редактирования в форме распределения:
	// - перенесем результаты редактирования в таблицу распределения,
	// - выполним перерасчет результата.
	
	ИмяТаблицы = ПараметрыДляВыбора.ОписаниеТаблицы.ИмяТаблицы;
	
	ПараметрыФормы = Новый Структура(
		"Распределение, 
		|Начисление, 
		|Сотрудник, 
		|Организация,
		|Договор,
		|ПоказыватьУсловияТруда");
	ПараметрыФормы.ПоказыватьУсловияТруда = Истина;
	
	Форма.ЗаполнитьПараметрыФормыРаспределениеПоТерриториямУсловиямТруда(ПараметрыФормы, ОписаниеТаблицы, ВыбраннаяСтрока);
	
	ДополнительныеПараметры = Новый Структура(
		"Форма, 
		|ИмяТаблицы, 
		|ВыбраннаяСтрока,
		|ОписаниеТаблицы");
	ДополнительныеПараметры.Форма = Форма;
	ДополнительныеПараметры.ИмяТаблицы = ИмяТаблицы;
	ДополнительныеПараметры.ВыбраннаяСтрока = ВыбраннаяСтрока;
	ДополнительныеПараметры.ОписаниеТаблицы = ОписаниеТаблицы;
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ФормаРаспределениеНачисленийПоТерриториямУсловиямТрудаПослеЗакрытия", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("ОбщаяФорма.РаспределениеНачисленийПоТерриториямУсловиямТруда", ПараметрыФормы, Форма, Форма.УникальныйИдентификатор, , , ОбработчикЗавершения);
	
КонецПроцедуры

Процедура ФормаРаспределениеНачисленийПоТерриториямУсловиямТрудаПослеЗакрытия(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма = ДополнительныеПараметры.Форма;
	ВыбраннаяСтрока = ДополнительныеПараметры.ВыбраннаяСтрока;
	ОписаниеТаблицы = ДополнительныеПараметры.ОписаниеТаблицы;
	
	Форма.ПеренестиРезультатыРедактированияРаспределенияПоТерриториямУсловиямТруда(РезультатЗакрытия, ОписаниеТаблицы, ВыбраннаяСтрока);
	
	СтрокаРасчетаПриОкончанииРедактирования(Форма, ОписаниеТаблицы, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область МетодыОбслуживанияИсправленийВДокументе

Процедура ДокументыВыполненияНачисленийПриАктивацииСтроки(Форма, ИмяТаблицы, НачисленияВСтроках) Экспорт 
	
	ДанныеСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеСтроки <> Неопределено Тогда
		РеквизитКонтроляПолей = "КонтролируемыеПоля" + ИмяТаблицы;
		КонтролируемыеПоля = Форма[РеквизитКонтроляПолей];
		УстановитьЗначенияКонтролируемыхПолей(ИмяТаблицы, ДанныеСтроки, КонтролируемыеПоля, Форма.ПолучитьСтарыеЗначенияКонтролируемыхПолей());
	КонецЕсли;
	
КонецПроцедуры	

// Вызывается при окончании редактирования строки одной из коллекций документа, участвующего в расчете.
// Использование процедуры в форме документа-начисления предполагает наличие в форме 
// процедуры РассчитатьСотрудника.
//
Процедура СтрокаРасчетаПриОкончанииРедактирования(Форма, ОписаниеТаблицы, ПересчитыватьСотрудникаБезусловно = Неопределено, ПроводитьПерерасчет = Истина, ОписаниеДокумента = Неопределено) Экспорт
	
	ДанныеСтроки = Форма.Элементы[ОписаниеТаблицы.ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РеквизитКонтроляПолей = "КонтролируемыеПоля" + ОписаниеТаблицы.ИмяТаблицы;
	СтарыеЗначенияКонтролируемыхПолей = Форма.ПолучитьСтарыеЗначенияКонтролируемыхПолей();
	
	КонтролируемыеПоля = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Форма[РеквизитКонтроляПолей]);
	КнопкаОтменыИсправления = Форма.Элементы.Найти(ОписаниеТаблицы.ИмяТаблицы + "ОтменитьИсправление");
	
	// Если используются поля ОтработаноДней(Часов), 
	// для строк с начислениями отработанного времени синхронизируем их с ОплаченоДней(Часов), т.к. отображаются только
	// последние.
	Если ДанныеСтроки.Свойство("ВидВремени") И ЗарплатаКадрыРасширенныйКлиентСервер.ЗачетОтработанногоВремени(ДанныеСтроки.ВидВремени) Тогда
		Если ДанныеСтроки.Свойство("ОтработаноДней") И ДанныеСтроки.Свойство("ОплаченоДней") Тогда
			ДанныеСтроки.ОтработаноДней = ДанныеСтроки.ОплаченоДней;
		КонецЕсли;
		Если ДанныеСтроки.Свойство("ОтработаноЧасов") И ДанныеСтроки.Свойство("ОплаченоЧасов") Тогда
			ДанныеСтроки.ОтработаноЧасов = ДанныеСтроки.ОплаченоЧасов;
		КонецЕсли;
	КонецЕсли;
	
	// Для начислений, которые не рассчитываются - не устанавливаем признак ФиксРасчет.
	УстанавливатьФиксРасчет = Истина;
	ВидРасчета = Неопределено;
	Если ОписаниеДокумента <> Неопределено И ОписаниеДокумента.УстанавливатьФиксРасчет <> Неопределено Тогда 
		УстанавливатьФиксРасчет = ОписаниеДокумента.УстанавливатьФиксРасчет;
	ИначеЕсли ОписаниеТаблицы.СодержитПолеВидРасчета Тогда 
		ВидРасчета = ДанныеСтроки[ОписаниеТаблицы.ИмяРеквизитаВидРасчета];
	ИначеЕсли ОписаниеДокумента <> Неопределено И ОписаниеДокумента.НачисленияИмя = ОписаниеТаблицы.ИмяТаблицы И ОписаниеДокумента.ВидНачисленияВШапке Тогда 
		ВидРасчета = Форма.Объект[ОписаниеДокумента.ВидНачисленияИмя];
	КонецЕсли;
	Если ЗначениеЗаполнено(ВидРасчета) Тогда 
		ОписаниеВидаРасчета = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
		Если ОписаниеВидаРасчета.ЭтоНачисление И Не ОписаниеВидаРасчета.Рассчитывается И ОписаниеВидаРасчета.СпособВыполненияНачисления = ПредопределенноеЗначение("Перечисление.СпособыВыполненияНачислений.ПоОтдельномуДокументуДоОкончательногоРасчета") Тогда
			УстанавливатьФиксРасчет = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ПересчитатьСотрудника = Ложь;
	
	// Проверка контролируемых полей, т.е. наличия исправлений.
	Для Каждого ЭлементСтруктуры Из КонтролируемыеПоля Цикл
		ИмяГруппыПолей = ЭлементСтруктуры.Ключ;
		ГруппаПолей = Новый Массив;
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ГруппаПолей, ЭлементСтруктуры.Значение);
		Для Каждого ИмяПоля Из ГруппаПолей Цикл
			Если ДанныеСтроки.Свойство(ИмяПоля) И СтарыеЗначенияКонтролируемыхПолей[ОписаниеТаблицы.ИмяТаблицы + ИмяПоля] <> ДанныеСтроки[ИмяПоля] Тогда
				ПересчитатьСотрудника = Истина;
				Если ИмяГруппыПолей = "ФиксЗаполнение" И Лев(ИмяПоля, 8) = "Значение" Тогда
					// Если это контроль заполнения значений показателей, то исключаем значения тех показателей, 
					// которые вводятся непосредственно в документе, т.к. их изменение не считается исправлением.
					НомерПоказателя = Сред(ИмяПоля, 9);
					Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(НомерПоказателя) Тогда 
						ПоказательИнфо = ЗарплатаКадрыРасширенныйКлиентПовтИсп.СведенияОПоказателеРасчетаЗарплаты(ДанныеСтроки["Показатель" + НомерПоказателя]);
						Если ПоказательИнфо <> Неопределено И ПоказательИнфо.ВводитсяНепосредственноПриРасчете Тогда
							Продолжить;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;		
				Если ИмяГруппыПолей <> "ФиксРасчет" Или УстанавливатьФиксРасчет Тогда 
					ДанныеСтроки[ИмяГруппыПолей] = Истина;
				КонецЕсли;	
				Если КнопкаОтменыИсправления <> Неопределено Тогда
					КнопкаОтменыИсправления.Доступность = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Рассчитать данные документа по сотруднику.
	Если ПроводитьПерерасчет И (ПересчитатьСотрудника Или ПересчитыватьСотрудникаБезусловно = Истина) Тогда
		Если РасчетЗарплатыРасширенныйКлиентСервер.СтрокаЗаполненаДляРасчета(Форма, ДанныеСтроки, ОписаниеТаблицы) Тогда
			НомерСтроки = ДанныеСтроки.НомерСтроки;
			Форма.РассчитатьСотрудника(ДанныеСтроки[ОписаниеТаблицы.ИмяРеквизитаСотрудник], ОписаниеТаблицы);
			КоллекцияФормы = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, ОписаниеТаблицы.ПутьКДанным);
			Если НомерСтроки > КоллекцияФормы.Количество() Тогда
				НомерСтроки = КоллекцияФормы.Количество();
			КонецЕсли;
			ИдентификаторСтроки = КоллекцияФормы[НомерСтроки - 1].ПолучитьИдентификатор();
			Форма.Элементы[ОписаниеТаблицы.ИмяТаблицы].ТекущаяСтрока = ИдентификаторСтроки;
			ДанныеСтроки = Форма.Элементы[ОписаниеТаблицы.ИмяТаблицы].ТекущиеДанные;
		КонецЕсли;
	КонецЕсли;
	
	// Уже после расчета заполняем значения контролируемых полей.
	УстановитьЗначенияКонтролируемыхПолей(ОписаниеТаблицы.ИмяТаблицы, ДанныеСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей);
	
КонецПроцедуры

Процедура СтрокаРасчетаПриНачалеРедактирования(Форма, ИмяТаблицы, ДанныеСтроки, НоваяСтрока, Копирование) Экспорт
	
	ЗарплатаКадрыРасширенныйКлиент.УстановитьОграничениеТипаПоТочностиПоказателя(ДанныеСтроки, Форма, ИмяТаблицы, 2);
	
	Если Не НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеСтроки.Свойство("ФиксСтрока") Тогда
		ДанныеСтроки.ФиксСтрока = Истина;
	КонецЕсли;
	
КонецПроцедуры	

// Отмена исправления в документе.
// Использование процедуры в форме документа-начисления предполагает наличие в форме 
// процедуры ЗаполнитьНачисленияСотрудника.
Процедура ОтменитьИсправление(Форма, ОписаниеТаблицы) Экспорт 
	
	ИмяТаблицы = ОписаниеТаблицы.ИмяТаблицы;
	
	ДанныеСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтролируемыеПоля = Форма["КонтролируемыеПоля" + ИмяТаблицы];
	Для Каждого ЭлементСтруктуры Из КонтролируемыеПоля Цикл
		ДанныеСтроки[ЭлементСтруктуры.Ключ] = Ложь;
	КонецЦикла;
	Если ДанныеСтроки.Свойство("ФиксСтрока") Тогда
		ДанныеСтроки.ФиксСтрока = Ложь;
	КонецЕсли;
	
	// Перезаполнить данные документа по сотруднику.
	Форма.ПерезаполнитьНачисленияСотрудника(ДанныеСтроки[ОписаниеТаблицы.ИмяРеквизитаСотрудник], Ложь);
		
	// Уже после расчета заполняем значения контролируемых полей.
	СтарыеЗначенияКонтролируемыхПолей = Форма.ПолучитьСтарыеЗначенияКонтролируемыхПолей();
	УстановитьЗначенияКонтролируемыхПолей(ОписаниеТаблицы.ИмяТаблицы, ДанныеСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей);
	
КонецПроцедуры

// Отмена исправления в документе.
// Использование процедуры в форме документа-начисления предполагает наличие в форме 
// процедуры ЗаполнитьНачисленияСотрудника.
Процедура ОтменитьВсеИсправления(Форма, ОписаниеТаблицы) Экспорт
	
	ИмяТаблицы = ОписаниеТаблицы.ИмяТаблицы;
	
	ДанныеНачислений = ОбщегоНазначенияКлиентСервер.ПолучитьРеквизитФормыПоПути(Форма, "Объект." + ИмяТаблицы);
	
	Если ДанныеНачислений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ФиксСтрокаЕсть = ДанныеНачислений[0].Свойство("ФиксСтрока");
	
	// Для накопления уникальных ссылок на пересчитываемых сотрудников.
	СотрудникиДляПересчета = Новый Соответствие;
	
	КонтролируемыеПоля = Форма["КонтролируемыеПоля" + ИмяТаблицы];
	Для Каждого ЭлементСтруктуры Из КонтролируемыеПоля Цикл
		СтруктураОтбора = Новый Структура(ЭлементСтруктуры.Ключ, Истина);
		ИсправленныеСтроки = ДанныеНачислений.НайтиСтроки(СтруктураОтбора);
		Для Каждого ИсправленнаяСтрока Из ИсправленныеСтроки Цикл
			СотрудникиДляПересчета[ИсправленнаяСтрока[ОписаниеТаблицы.ИмяРеквизитаСотрудник]] = 0;
			ИсправленнаяСтрока[ЭлементСтруктуры.Ключ] = Ложь;
			Если ФиксСтрокаЕсть Тогда
				ИсправленнаяСтрока.ФиксСтрока = Ложь;
			КонецЕсли;
		КонецЦикла;	
	КонецЦикла;
	
	СотрудникиМассив = Новый Массив;
	Для Каждого КлючЗначение Из СотрудникиДляПересчета Цикл
		СотрудникиМассив.Добавить(КлючЗначение.Ключ);
	КонецЦикла;
	
	Если СотрудникиМассив.Количество() > 0 Тогда
		// Перезаполнить данные документа по сотруднику.
		Форма.ПерезаполнитьНачисленияСотрудника(СотрудникиМассив, Ложь);
	КонецЕсли;
	
КонецПроцедуры	

// Обновление данных выбранных сотрудников в таблицах документа, выполняющего начисления.
// Использование метода предполагает в форме документа наличие процедуры ПересчитатьСотрудника.
//
// Параметры:
//	Форма
//	ИмяТаблицы - имя таблицы документа, как оно указывается в описании расчетного документа, 
//		см. РасчетЗарплатыРасширенный.ОписаниеРасчетногоДокумента.
//	ВедущееПоле - имя поля, содержащего ведущее поле для обновления (Сотрудник или ФизическоеЛицо).
//	ТипВедущегоПоля - тип значения, являющегося ведущим для обновления (Сотрудник или ФизическоеЛицо).
//
Процедура ПересчитатьСотрудника(Форма, ИмяТаблицы, ВедущееПоле, ТипВедущегоПоля) Экспорт
	
	ИдентификаторыСтрок = Форма.Элементы[ИмяТаблицы].ВыделенныеСтроки;
	Если ИдентификаторыСтрок.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НомерСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные.НомерСтроки;
	Форма.ПересчитатьСотрудника(ИмяТаблицы, ИдентификаторыСтрок, ВедущееПоле, ТипВедущегоПоля);
	КоллекцияФормы = Форма.Объект[ИмяТаблицы];
	Если КоллекцияФормы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Если НомерСтроки > КоллекцияФормы.Количество() Тогда
		НомерСтроки = КоллекцияФормы.Количество();
	КонецЕсли;
	ИдентификаторСтроки = КоллекцияФормы[НомерСтроки - 1].ПолучитьИдентификатор();
	Форма.Элементы[ИмяТаблицы].ТекущаяСтрока = ИдентификаторСтроки;
	ДанныеСтроки = Форма.Элементы[ИмяТаблицы].ТекущиеДанные;
	Если ДанныеСтроки <> Неопределено Тогда
		РеквизитКонтроляПолей = "КонтролируемыеПоля" + ИмяТаблицы;
		КонтролируемыеПоля = Форма[РеквизитКонтроляПолей];
		УстановитьЗначенияКонтролируемыхПолей(ИмяТаблицы, ДанныеСтроки, КонтролируемыеПоля, Форма.ПолучитьСтарыеЗначенияКонтролируемыхПолей());
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьЗначенияКонтролируемыхПолей(ИмяТаблицы, ДанныеСтроки, КонтролируемыеПоля, СтарыеЗначенияКонтролируемыхПолей) Экспорт
	
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементСтруктуры Из КонтролируемыеПоля Цикл
		Для Каждого ИмяПоля Из ЭлементСтруктуры.Значение Цикл
			Если ДанныеСтроки.Свойство(ИмяПоля) Тогда
				СтарыеЗначенияКонтролируемыхПолей[ИмяТаблицы + ИмяПоля] = ДанныеСтроки[ИмяПоля];
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры	

Функция ДобавитьСотрудникаКРасчету(Форма, Сотрудник, ОписаниеТаблицы, ОтображатьКнопкуПересчета = Истина) Экспорт
	
	СотрудникДобавлен = Ложь;
	
	Если НЕ Форма.РассчитыватьДокументыПриРедактировании Тогда
		
		// Если начисление не рассчитывается и не нужно считать НДФЛ и вычеты - расчет сотрудника не требуется.
		Если Не ТребуетсяРасчетСотрудника(Форма, Сотрудник, ОписаниеТаблицы) Тогда 
			СотрудникДобавлен = Истина;
			Возврат СотрудникДобавлен;
		КонецЕсли;	
			
		Если ТипЗнч(Сотрудник) = Тип("СправочникСсылка.Сотрудники") Тогда
			ФизическоеЛицо = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ФизическоеЛицоСотрудника(Сотрудник);
		Иначе
			ФизическоеЛицо = Сотрудник;
		КонецЕсли;
		
		ЗарегистрированноеОписаниеТаблицы = Неопределено;
		Для каждого ТаблицаССотрудниками Из Форма.СотрудникиКРасчету Цикл
			
			Если ТаблицаССотрудниками.Значение.СписокСотрудников.Получить(ФизическоеЛицо) <> Неопределено Тогда
				ЗарегистрированноеОписаниеТаблицы = ТаблицаССотрудниками.Значение.ОписаниеТаблицы;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		ОписаниеВедущейТаблицы = Неопределено;
		Если ЗарегистрированноеОписаниеТаблицы <> Неопределено Тогда
			
			ИмяВедущейТаблицы = РасчетЗарплатыРасширенныйКлиентСервер.ВедущаяТаблицаРасчета(
				ЗарегистрированноеОписаниеТаблицы.ИмяТаблицы, ОписаниеТаблицы.ИмяТаблицы);
				
			Если ИмяВедущейТаблицы = ЗарегистрированноеОписаниеТаблицы.ИмяТаблицы Тогда
				ОписаниеВедущейТаблицы = ЗарегистрированноеОписаниеТаблицы;
			Иначе
				
				ОписаниеВедущейТаблицы = ОписаниеТаблицы;
				
				СписокСотрудников = Форма.СотрудникиКРасчету.Получить(ЗарегистрированноеОписаниеТаблицы.ИмяТаблицы).СписокСотрудников;
				СписокСотрудников.Удалить(ФизическоеЛицо);
				
				Если СписокСотрудников.Количество() = 0 Тогда
					Форма.СотрудникиКРасчету.Удалить(ЗарегистрированноеОписаниеТаблицы.ИмяТаблицы);
				КонецЕсли; 
				
			КонецЕсли; 
			
		Иначе
			ОписаниеВедущейТаблицы = ОписаниеТаблицы;
		КонецЕсли; 
		
		Если ОписаниеВедущейТаблицы <> ЗарегистрированноеОписаниеТаблицы Тогда
			
			ТаблицаССотрудниками = Форма.СотрудникиКРасчету.Получить(ОписаниеВедущейТаблицы.ИмяТаблицы);
			Если ТаблицаССотрудниками = Неопределено Тогда
				ТаблицаССотрудниками = Новый Структура("ОписаниеТаблицы,СписокСотрудников", ОписаниеВедущейТаблицы, Новый Соответствие);
			КонецЕсли; 
			
			ТаблицаССотрудниками.СписокСотрудников.Вставить(ФизическоеЛицо, Истина);
			Форма.СотрудникиКРасчету.Вставить(ОписаниеВедущейТаблицы.ИмяТаблицы, ТаблицаССотрудниками);
			
		КонецЕсли; 
		
		СотрудникДобавлен = Истина;
		РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(Форма, Истина, ОтображатьКнопкуПересчета);
		
	КонецЕсли;
	
	Возврат СотрудникДобавлен;
	
КонецФункции

Функция ТребуетсяРасчетСотрудника(Форма, Сотрудник, ОписаниеТаблицы)
	
	Если Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьСтатьиФинансированияЗарплата")
		Или Форма.ПолучитьФункциональнуюОпциюФормы("ИспользоватьОбособленныеТерритории") Тогда
		
		Возврат Истина;
		
	КонецЕсли;
	
	ТребуетсяРасчет = Истина;
	
	ДанныеСтроки = Форма.Элементы[ОписаниеТаблицы.ИмяТаблицы].ТекущиеДанные;
	
	Если ДанныеСтроки = Неопределено Тогда 
		Возврат ТребуетсяРасчет;
	КонецЕсли;
	
	ВидРасчета = ?(ОписаниеТаблицы.СодержитПолеВидРасчета, ДанныеСтроки[ОписаниеТаблицы.ИмяРеквизитаВидРасчета], 
		?(Форма.Объект.Свойство(ОписаниеТаблицы.ИмяРеквизитаВидРасчета), Форма.Объект[ОписаниеТаблицы.ИмяРеквизитаВидРасчета], Неопределено));
	
	Если Не ЗначениеЗаполнено(ВидРасчета) Или ТипЗнч(ВидРасчета) <> Тип("ПланВидовРасчетаСсылка.Начисления") Тогда 
		Возврат ТребуетсяРасчет;
	КонецЕсли;
	
	ОписаниеВидаРасчета = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ПолучитьИнформациюОВидеРасчета(ВидРасчета);
	
	КодВычетаНДФЛ = ОписаниеВидаРасчета.КодВычетаНДФЛ;
	Если Не ЗначениеЗаполнено(ОписаниеВидаРасчета.КодВычетаНДФЛ) Тогда 
		Если ОписаниеТаблицы.СодержитПолеКодВычета Тогда 
			КодВычетаНДФЛ = ДанныеСтроки[ОписаниеТаблицы.ИмяРеквизитаКодВычета];
		КонецЕсли;
	КонецЕсли;
	
	ТребуетсяРасчетВычета = ЗначениеЗаполнено(КодВычетаНДФЛ);
	
	ТребуетсяРасчетНалоговУдержаний = Истина;
	Если ТипЗнч(Форма.Объект.Ссылка) = Тип("ДокументСсылка.НачислениеЗарплаты") Тогда 
		ТребуетсяРасчетНалоговУдержаний = Истина;
	ИначеЕсли Форма.Объект.Свойство("РассчитыватьУдержания") Тогда 
		ТребуетсяРасчетНалоговУдержаний = Форма.Объект.РассчитыватьУдержания;
	ИначеЕсли Форма.Объект.Свойство("ПорядокВыплаты") Тогда 
		ТребуетсяРасчетНалоговУдержаний = Форма.Объект.ПорядокВыплаты = ПредопределенноеЗначение("Перечисление.ХарактерВыплатыЗарплаты.Межрасчет");
	КонецЕсли;
	
	Если Не ТребуетсяРасчетВычета И Не ТребуетсяРасчетНалоговУдержаний 
		И (Не ОписаниеВидаРасчета.Рассчитывается Или ДанныеСтроки.ФиксРасчет) Тогда 
		ТребуетсяРасчет = Ложь;
	КонецЕсли;
	
	Возврат ТребуетсяРасчет;
		
КонецФункции

Процедура ОчиститьСписокСотрудниковКРасчету(Форма, Сотрудники = Неопределено) Экспорт
	
	Если Сотрудники = Неопределено Тогда
		Форма.СотрудникиКРасчету.Очистить();
	Иначе
		
		Если ТипЗнч(Сотрудники) =  Тип("СправочникСсылка.Сотрудники")
			Или ТипЗнч(Сотрудники) =  Тип("СправочникСсылка.ФизическиеЛица") Тогда
			
			СотрудникиКРасчету = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Сотрудники);
			
		Иначе
			СотрудникиКРасчету = Сотрудники;
		КонецЕсли;
		
		Для каждого СотрудникКРасчету Из СотрудникиКРасчету Цикл
			
			Если ТипЗнч(СотрудникКРасчету) =  Тип("СправочникСсылка.Сотрудники") Тогда
				УдаляемоеФизическоеЛицо = ЗарплатаКадрыРасширенныйКлиентПовтИсп.ФизическоеЛицоСотрудника(СотрудникКРасчету);
			Иначе
				УдаляемоеФизическоеЛицо = СотрудникКРасчету;
			КонецЕсли;
			
			ПричиныРасчетаКУдалению = Новый Массив;
			Для каждого ПричинаРасчета Из Форма.СотрудникиКРасчету Цикл
				
				ПричинаРасчета.Значение.СписокСотрудников.Удалить(УдаляемоеФизическоеЛицо);
				Если ПричинаРасчета.Значение.СписокСотрудников.Количество() = 0 Тогда
					ПричиныРасчетаКУдалению.Добавить(ПричинаРасчета.Ключ);
				КонецЕсли;
				
			КонецЦикла;
			
			Для каждого ПричинаРасчетаКУдалению Из  ПричиныРасчетаКУдалению Цикл
				Форма.СотрудникиКРасчету.Удалить(ПричинаРасчетаКУдалению);
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	РасчетЗарплатыКлиент.УстановитьОтображениеКнопкиПересчитать(Форма, Форма.СотрудникиКРасчету.Количество() > 0);
	
КонецПроцедуры

Процедура ПередЗаписьюДокументаСоСпискомСотрудников(Форма, ИмяОбработчика, Отказ = Ложь, ПараметрыЗаписи = Неопределено) Экспорт
	
	Если Форма.СотрудникиКРасчету.Количество() > 0 Тогда
		
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения(ИмяОбработчика, Форма, ПараметрыЗаписи);
		
		ТекстВопроса = НСтр("ru='Перед записью документа необходимо провести перерасчет измененных строк.
			|Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьРасчетСотрудникаПередЗаписьюДокумента(Форма, ИмяОбработчика, ДополнительныеПараметры, РегистрацияНачисленийДоступна = Истина) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения(ИмяОбработчика, Форма, ДополнительныеПараметры);
	Если РегистрацияНачисленийДоступна И Форма.РасчетНеобходимоВыполнить Тогда
		
		ТекстВопроса = НСтр("ru='Перед записью документа необходимо провести перерасчет изменений.
			|Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
		
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеОповещения, КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередНачаломДобавленияСтрокиПерерасчета(Элемент, Отказ, Копирование) Экспорт 
	
	Если Не Копирование Тогда 
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные.Сторно Или ТекущиеДанные.ФиксСторно Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Копирование сторнирующей записи невозможно'"));
	КонецЕсли;
	
КонецПроцедуры

// Проверка возможности удаления строки перерасчета и отказ при необходимости.
//
Процедура ПередУдалениемСтрокиПерерасчета(Элемент, Отказ) Экспорт
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные.Сторно Или ТекущиеДанные.ФиксСторно Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Удаление сторнирующей записи невозможно'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбработкаРасшифровкиСдельногоЗаработка(Форма, ОписаниеТаблицы, Элемент, Поле, СтандартнаяОбработка)

	ФормаОбъект = Форма.Объект;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если СтрНайти(Поле.Имя, "НачисленияКомандаРасшифровки") = 0 Тогда
		Возврат;
	КонецЕсли;
	
	НомерПоказателя = СтрЗаменить(Поле.Имя, "НачисленияКомандаРасшифровки", "");
	Если НЕ ТекущиеДанные.Свойство("Показатель" + НомерПоказателя) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийПоказатель = ТекущиеДанные["Показатель" + НомерПоказателя];
	Если НЕ ТекущийПоказатель = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ПоказателиРасчетаЗарплаты.СдельныйЗаработок") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ВидРасчета = ?(ОписаниеТаблицы.СодержитПолеВидРасчета, ТекущиеДанные[ОписаниеТаблицы.ИмяРеквизитаВидРасчета], Форма.Объект[ОписаниеТаблицы.ИмяРеквизитаВидРасчета]);
	
	ПараметрыФормы = Новый Структура("Сотрудник", ТекущиеДанные.Сотрудник);
	ПараметрыФормы.Вставить("Организация", ФормаОбъект.Организация);
	ПараметрыФормы.Вставить("Начисление", ВидРасчета);
	ПараметрыФормы.Вставить("ДатаНачала", ТекущиеДанные[ОписаниеТаблицы.ИмяРеквизитаДатаНачала]);
	ПараметрыФормы.Вставить("ДатаОкончания", ТекущиеДанные[ОписаниеТаблицы.ИмяРеквизитаДатаОкончания]);
	
	ОткрытьФорму("ОбщаяФорма.ФормаРасшифровкиСдельногоЗаработка", ПараметрыФормы); 

КонецПроцедуры

Процедура ДоначислитьЗарплатуСейчас(Организация, Период) Экспорт
	
	ДоступныеДоначисления = ПерерасчетЗарплатыВызовСервера.ДокументыПерерасчета(Организация, Период);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Организация", Организация);
	ДополнительныеПараметры.Вставить("МесяцНачисления", ДоступныеДоначисления.МесяцНачисления);
	
	Если ДоступныеДоначисления.Документы.Количество() > 1 Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("РежимДоначисления", Истина);
		ПараметрыОткрытия.Вставить("РежимВыбора", Истина);
		
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("Организация", Организация);
		СтруктураОтбора.Вставить("МесяцНачисления", ДоступныеДоначисления.МесяцНачисления);
		СтруктураОтбора.Вставить("Ссылка", ДоступныеДоначисления.Документы);
		
		ПараметрыОткрытия.Вставить("Отбор", СтруктураОтбора);
		
		Оповещение = Новый ОписаниеОповещения("ДоначислитьСейчасЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		
		ОткрытьФорму("Документ.НачислениеЗарплаты.ФормаСписка",
			ПараметрыОткрытия, ЭтотОбъект, "РежимДоначисления", , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		Если ДоступныеДоначисления.Документы.Количество() = 1 Тогда
			ДокументДоначисления = ДоступныеДоначисления.Документы[0];
		Иначе
			ДокументДоначисления = ПредопределенноеЗначение("Документ.НачислениеЗарплаты.ПустаяСсылка");
		КонецЕсли;
		
		ДоначислитьСейчасЗавершение(ДокументДоначисления, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДоначислитьСейчасЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("Ключ", Результат);
		
		ЗначенияЗаполнения = Новый Структура;
		Если Не ЗначениеЗаполнено(Результат) Тогда
			ЗначенияЗаполнения.Вставить("Организация", ДополнительныеПараметры.Организация);
			ЗначенияЗаполнения.Вставить("МесяцНачисления", ДополнительныеПараметры.МесяцНачисления);
			ЗначенияЗаполнения.Вставить("РежимДоначисления", Истина);
		КонецЕсли; 
		
		ЗначенияЗаполнения.Вставить("ЗаполнитьПриОткрытии", Истина);
		
		ПараметрыОткрытия.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		
		ОткрытьФорму("Документ.НачислениеЗарплаты.ФормаОбъекта", ПараметрыОткрытия, , "РежимДоначисления");
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьИзмененныеДанные(ИзмененныеДанные, ИмяТаблицы, ФизическоеЛицо = Неопределено, Сотрудник = Неопределено, ВидРасчета = Неопределено) Экспорт
	
	РасчетЗарплатыКлиент.ДобавитьИзмененныеДанные(ИзмененныеДанные, ИмяТаблицы, ФизическоеЛицо, Сотрудник, ВидРасчета);
	
КонецПроцедуры

#КонецОбласти