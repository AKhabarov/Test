
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ПозицияРезерва") Тогда
		ПозицияРезерва = Параметры.ПозицияРезерва;
	КонецЕсли;
	
	ПриПолученииДанныхНаСервере(Параметры);
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		Элементы.Сотрудники.РежимВыбора = Истина;
		РежимВыбора = Истина;
	Иначе	
		КадровыйРезервФормы.СоздатьКомандыФормыКадровогоРезерва(ЭтаФорма);
		КадровыйРезервФормы.СоздатьЭлементыФормыКомандыКадровогоРезерва(ЭтаФорма, Элементы.ГруппаКомандКадровогоРезерва);
		// Команда исключения из резерва тут не вполне уместна - скрываем.
		Элементы.ФормаИсключениеИзКадровогоРезерва.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьРеквизитовФормы(ЭтаФорма);
	УстановитьКнопкуПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОграничиватьМинимальныйВозрастПриИзменении(Элемент)
	УстановитьДоступностьМинимальногоВозраста(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьМаксимальныйВозрастПриИзменении(Элемент)
	УстановитьДоступностьМаксимальногоВозраста(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьОбразованиеПриИзменении(Элемент)
	УстановитьДоступностьОбразования(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьМинимальныйСтажПриИзменении(Элемент)
	УстановитьДоступностьМинимальногоСтажа(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура ОграничиватьМаксимальныйСтажПриИзменении(Элемент)
	УстановитьДоступностьМаксимальногоСтажа(ЭтаФорма)
КонецПроцедуры

&НаКлиенте
Процедура ВидСтажаПриИзменении(Элемент)
	
	УстановитьФлагиОграничителиСтажа(ЭтаФорма);
	УстановитьДоступностьОграничителейСтажа(ЭтаФорма);
	УстановитьДоступностьМинимальногоСтажа(ЭтаФорма);
	УстановитьДоступностьМаксимальногоСтажа(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыСотрудники

&НаКлиенте
Процедура СотрудникиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		Закрыть(Сотрудники.НайтиПоИдентификатору(ВыбраннаяСтрока).ФизическоеЛицо);
	Иначе
		КадровыйРезервКлиент.ОткрытьФормуСправочникаФизическиеЛица(ЭтаФорма, "Сотрудники");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СотрудникиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Закрыть(Сотрудники[Значение].ФизическоеЛицо);
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКоманд

&НаКлиенте
Процедура КомандаНайти(Команда)
	ЗагрузитьСотрудниковПоОтборам(ОтборыДляЗапроса());
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗаявкаНаВключениеВКадровыйРезерв(Команда)
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("ПозицияРезерва", ПозицияРезерва);
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ЗначенияЗаполнения.Вставить("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", ЗначенияЗаполнения);
	КадровыйРезервКлиент.ОткрытьФормуЗаявкаНаВключениеВКадровыйРезерв(ЭтаФорма, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключениеВКадровыйРезерв(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПозицияРезерва", ПозицияРезерва);
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если НЕ ТекущиеДанные = Неопределено Тогда
		ПараметрыФормы.Вставить("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
	КонецЕсли;
	КадровыйРезервКлиент.ОткрытьФормуВключениеВКадровыйРезерв(ЭтаФорма, ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ИсключениеИзКадровогоРезерва(Команда)
	
	ТекущиеДанные = Элементы.Сотрудники.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("ФизическоеЛицо", ТекущиеДанные.ФизическоеЛицо);
	КадровыйРезервКлиент.ОткрытьФормуИсключениеИзКадровогоРезерва(ЭтаФорма, ПараметрыФормы);
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриПолученииДанныхНаСервере(Параметры)

	// Заполняем реквизиты формы по параметрам.
	Если Параметры.Свойство("ЗаполнитьПоПозиции") И Параметры.ЗаполнитьПоПозиции Тогда
		ЗаполнитьФормуПоПозиции(ЭтаФорма);
	ИначеЕсли Параметры.Свойство("ДанныеТребований") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.ДанныеТребований);
	КонецЕсли;	
		
	ЗагрузитьСотрудниковПоОтборам(ОтборыДляЗапроса());

КонецПроцедуры

&НаСервере
Функция ОтборыДляЗапроса()

	Отборы = Новый Массив;
	
	Если ОграничиватьМинимальныйВозраст Тогда
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "Возраст", ">=", МинимальныйВозраст);
	КонецЕсли;
	Если ОграничиватьМаксимальныйВозраст Тогда
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "Возраст", "<=", МаксимальныйВозраст);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидОбразования) Тогда
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "ВидОбразования", ">=", ВидОбразования);
	КонецЕсли;
	Если ЗначениеЗаполнено(Специальность) Тогда
		ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
		Отборы, "Специальность", "=", Специальность);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВидСтажа) Тогда
		ИмяОтбораСтажа = КадровыйУчетРасширенный.ИмяОтбораПоКатегорииСтажа(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВидСтажа, "КатегорияСтажа"));
		Если ОграничиватьМинимальныйСтаж И ИмяОтбораСтажа <> Неопределено Тогда
			ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			Отборы, ИмяОтбораСтажа, ">=", МинимальныйСтажЛет*12 + МинимальныйСтажМесяцев);
		КонецЕсли;
		Если ОграничиватьМаксимальныйСтаж И ИмяОтбораСтажа <> Неопределено Тогда
			ЗарплатаКадрыОбщиеНаборыДанных.ДобавитьВКоллекциюОтбор(
			Отборы, ИмяОтбораСтажа, "<=", МаксимальныйСтажЛет*12 + МаксимальныйСтажМесяцев);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Отборы;

КонецФункции

&НаСервере
Процедура ЗагрузитьСотрудниковПоОтборам(Отборы)

	Если Отборы.Количество() = 0 Тогда
		ЗагрузитьВсехФизическихЛиц();
	Иначе
		// Загружаем по критериям отборов.
		КритерииПоиска = КадровыйУчет.КритерииПоискаСотрудниковПоКоллекцииОтборов(Отборы);
		Запрос = КадровыйУчет.ЗапросВТСотрудникиПоКритериямПоиска(КритерииПоиска, Истина, "Справочник.ФизическиеЛица", "ВТОтобранныеФизлица");
		
		ТекстЗапросаСУпорядочиванием =
			"ВЫБРАТЬ
			|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо
			|ИЗ
			|	Справочник.ФизическиеЛица КАК ФизическиеЛица
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОтобранныеФизлица КАК ВТОтобранныеФизлица
			|		ПО ФизическиеЛица.Ссылка = ВТОтобранныеФизлица.ФизическоеЛицо
			|
			|УПОРЯДОЧИТЬ ПО
			|	ФизическиеЛица.Наименование";
			
		Запрос.Текст =
			Запрос.Текст
			+ ЗарплатаКадрыОбщиеНаборыДанных.РазделительЗапросов()
			+ ТекстЗапросаСУпорядочиванием;
		
		Сотрудники.Загрузить(Запрос.Выполнить().Выгрузить());
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗагрузитьВсехФизическихЛиц()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ФизическиеЛица.Ссылка КАК ФизическоеЛицо,
	|	ФизическиеЛица.Представление
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	НЕ ФизическиеЛица.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ФизическиеЛица.Наименование";
	Сотрудники.Загрузить(Запрос.Выполнить().Выгрузить());

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьФормуПоПозиции(Форма)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КадровыйРезерв.МинимальныйВозраст,
		|	КадровыйРезерв.МаксимальныйВозраст,
		|	КадровыйРезерв.ВидСтажа,
		|	КадровыйРезерв.МинимальныйСтажМесяцев,
		|	КадровыйРезерв.МаксимальныйСтажМесяцев,
		|	КадровыйРезерв.ВидОбразования,
		|	КадровыйРезерв.Специальность
		|ИЗ
		|	Справочник.КадровыйРезерв КАК КадровыйРезерв
		|ГДЕ
		|	КадровыйРезерв.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Форма.ПозицияРезерва);
	ЭтотОбъект = Запрос.Выполнить().Выгрузить()[0];
	
	ЗаполнитьЗначенияСвойств(Форма, ЭтотОбъект);
	
	УстановитьСтаж(Форма, ЭтотОбъект);
	
	УстановитьФлагиОграничителиВозраста(Форма);
	УстановитьФлагиОграничителиОбразования(Форма);
	УстановитьФлагиОграничителиСтажа(Форма)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьРеквизитовФормы(Форма)

	УстановитьДоступностьМинимальногоВозраста(Форма);
	УстановитьДоступностьМаксимальногоВозраста(Форма);
	УстановитьДоступностьОбразования(Форма);
	УстановитьДоступностьОграничителейСтажа(Форма);
	УстановитьДоступностьМинимальногоСтажа(Форма);
	УстановитьДоступностьМаксимальногоСтажа(Форма);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьКнопкуПоУмолчанию(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ФормаЗакрыть",
		"КнопкаПоУмолчанию",
		НЕ Форма.РежимВыбора);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМинимальногоВозраста(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МинимальныйВозраст",
		"Доступность",
		Форма.ОграничиватьМинимальныйВозраст);
		
	Если Не Форма.ОграничиватьМинимальныйВозраст Тогда
		Форма.МинимальныйВозраст = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМаксимальногоВозраста(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МаксимальныйВозраст",
		"Доступность",
		Форма.ОграничиватьМаксимальныйВозраст);
		
	Если Не Форма.ОграничиватьМаксимальныйВозраст Тогда
		Форма.МаксимальныйВозраст = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьОбразования(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ВидОбразования",
		"Доступность",
		Форма.ОграничиватьОбразование);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"Специальность",
		"Доступность",
		Форма.ОграничиватьОбразование);
		
	Если НЕ Форма.ОграничиватьОбразование Тогда
		Форма.ВидОбразования = ПредопределенноеЗначение("Справочник.ВидыОбразованияФизическихЛиц.ПустаяСсылка");
		Форма.Специальность = ПредопределенноеЗначение("Справочник.КлассификаторСпециальностейПоОбразованию.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьОграничителейСтажа(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ОграничиватьМинимальныйСтаж",
		"Доступность",
		ЗначениеЗаполнено(Форма.ВидСтажа));
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"ОграничиватьМаксимальныйСтаж",
		"Доступность",
		ЗначениеЗаполнено(Форма.ВидСтажа));
		
	Если Не ЗначениеЗаполнено(Форма.ВидСтажа) Тогда
		Форма.ОграничиватьМинимальныйСтаж = Ложь;
		Форма.ОграничиватьМаксимальныйСтаж = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМинимальногоСтажа(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МинимальныйСтажЛет",
		"Доступность",
		Форма.ОграничиватьМинимальныйСтаж);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МинимальныйСтажМесяцев",
		"Доступность",
		Форма.ОграничиватьМинимальныйСтаж);
		
	Если Не Форма.ОграничиватьМинимальныйСтаж Тогда
		Форма.МинимальныйСтажЛет = 0;
		Форма.МинимальныйСтажМесяцев = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьМаксимальногоСтажа(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МаксимальныйСтажЛет",
		"Доступность",
		Форма.ОграничиватьМаксимальныйСтаж);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Форма.Элементы,
		"МаксимальныйСтажМесяцев",
		"Доступность",
		Форма.ОграничиватьМаксимальныйСтаж);
		
	Если Не Форма.ОграничиватьМаксимальныйСтаж Тогда
		Форма.МаксимальныйСтажЛет = 0;
		Форма.МаксимальныйСтажМесяцев = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтаж(Форма, ЭтотОбъект)

	Если ЗначениеЗаполнено(Форма.ВидСтажа) Тогда
		Форма.МинимальныйСтажЛет = Цел(ЭтотОбъект.МинимальныйСтажМесяцев/12);
		Форма.МинимальныйСтажМесяцев = ЭтотОбъект.МинимальныйСтажМесяцев - Форма.МинимальныйСтажЛет*12;
		Форма.МаксимальныйСтажЛет = Цел(ЭтотОбъект.МаксимальныйСтажМесяцев/12);
		Форма.МаксимальныйСтажМесяцев = ЭтотОбъект.МаксимальныйСтажМесяцев - Форма.МаксимальныйСтажЛет*12;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагиОграничителиВозраста(Форма)

	Форма.ОграничиватьМинимальныйВозраст = ЗначениеЗаполнено(Форма.МинимальныйВозраст);
	Форма.ОграничиватьМаксимальныйВозраст = ЗначениеЗаполнено(Форма.МаксимальныйВозраст);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагиОграничителиОбразования(Форма)

	Форма.ОграничиватьОбразование = ЗначениеЗаполнено(Форма.ВидОбразования) ИЛИ ЗначениеЗаполнено(Форма.Специальность);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагиОграничителиСтажа(Форма)

	Форма.ОграничиватьМинимальныйСтаж = ЗначениеЗаполнено(Форма.ВидСтажа) И (ЗначениеЗаполнено(Форма.МинимальныйСтажЛет) ИЛИ ЗначениеЗаполнено(Форма.МинимальныйСтажМесяцев));
	Форма.ОграничиватьМаксимальныйСтаж = ЗначениеЗаполнено(Форма.ВидСтажа) И (ЗначениеЗаполнено(Форма.МаксимальныйСтажЛет) ИЛИ ЗначениеЗаполнено(Форма.МаксимальныйСтажМесяцев));

КонецПроцедуры

#КонецОбласти 
