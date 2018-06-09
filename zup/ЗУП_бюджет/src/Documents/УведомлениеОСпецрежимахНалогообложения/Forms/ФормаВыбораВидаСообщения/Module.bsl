
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуКНД();
	
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	АдресДанные = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);
	
	СозданиеСообщения = Параметры.Свойство("Создание_УведомлениеОСпецрежимахНалогообложения");
	УчитыватьУведомленияНеВходящиеВБРО = Параметры.Свойство("УчитыватьУведомленияНеВходящиеВБРО");
	Параметры.Свойство("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
	
	Если Параметры.Свойство("Организация") Тогда
		Организация = Параметры.Организация;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидУведомления") Тогда
		ВидУведомления = Параметры.ВидУведомления;
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		ОргПоУмолчанию = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
		Организация = ОргПоУмолчанию;
	ИначеЕсли Не ЗначениеЗаполнено(Организация) Тогда 
		Попытка
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
			|	Организации.Ссылка КАК Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	НЕ Организации.ПометкаУдаления";
			Выборка = Запрос.Выполнить().Выбрать();
			Если Выборка.Следующий() И Выборка.Количество() = 1 Тогда
				Организация = Выборка.Ссылка;
			КонецЕсли;
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось определить организацию по умолчанию'"));
		КонецПопытки;
	КонецЕсли;
	
	Если СозданиеСообщения И ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ВидУведомления) Тогда
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			Если Не ДанноеСообщениеДоступноДляОрганизации(ВидУведомления) Тогда 
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Уведомление %1 не доступно для организации'"), ВидУведомления);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		Иначе
			Если Не ДанноеСообщениеДоступноДляИП(ВидУведомления) Тогда
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Уведомление %1 не доступно для индивидуального предпринимателя'"), ВидУведомления);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
				Отказ = Истина;
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	// Формируем список уведомлений
	Если Параметры.Свойство("ВидыПрочихУведомлений")
		И ТипЗнч(Параметры.ВидыПрочихУведомлений) = Тип("Массив") Тогда 
		
		ВидыУведомленийОрг = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВидыУведомленийДляОрганизации();
		ВидыУведомленийИП = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ВидыУведомленийДляИП();
		
		Для Каждого Элемент Из Параметры.ВидыПрочихУведомлений Цикл
			Если ВидыУведомленийИП.Найти(Элемент) <> Неопределено Тогда 
				ВидыСообщенийИП.Добавить(Элемент);
			КонецЕсли;
			Если ВидыУведомленийОрг.Найти(Элемент) <> Неопределено Тогда 
				ВидыСообщенийОрганизации.Добавить(Элемент);
			КонецЕсли;
			ВидыСообщенийОбщий.Добавить(Элемент);
		КонецЦикла;
		СформироватьСписок();
	Иначе 
		СформироватьДерево();
	КонецЕсли;
	
	ОрганизацияПредидущийВыбор = Организация;
	Если ЗначениеЗаполнено(Организация) Тогда 
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
			ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийООО"), "ВидыСообщений");
		Иначе
			ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийИП"), "ВидыСообщений");
		КонецЕсли;
	КонецЕсли;
	
	// Если вид уведомления известен, то позиционируемся на нем
	Если ЗначениеЗаполнено(ВидУведомления) Тогда
		ВидУведомления = Параметры.ВидУведомления;
		Идентификатор = Неопределено;
		ПолучитьИдентификаторНужногоЭлемента(ВидыСообщений.ПолучитьЭлементы(), ВидУведомления, Идентификатор);
		Элементы.ВидыСообщений.ТекущаяСтрока = Идентификатор;
	КонецЕсли;
	
	Если СозданиеСообщения Тогда
		Элементы.Выбрать.Доступность = ЗначениеЗаполнено(Организация);
		Элементы.СоздатьПоКНД.Доступность = ЗначениеЗаполнено(Организация);
	Иначе
		// В форме выбора не показываем организацию
		Элементы.Организация.Видимость = Ложь;
		Элементы.КНДГруппа.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуКНД()
	Попытка
		СН = Новый Соответствие;
		Для Каждого КЗ Из УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьСоответствиеВидовУведомленийИменамОтчетов() Цикл 
			СН[КЗ.Значение] = КЗ.Ключ;
		КонецЦикла;
		
		Для Каждого КЗ Из УведомлениеОСпецрежимахНалогообложенияПовтИсп.ПолучитьСоответствиеОтчетаПоКНД() Цикл 
			Если Метаданные.Отчеты.Найти(КЗ.Значение) <> Неопределено Тогда 
				НовСтр = КНДОтчетов.Добавить();
				НовСтр.КНД = КЗ.Ключ;
				НовСтр.ИмяОтчета = КЗ.Значение;
				НовСтр.Тип = СН[КЗ.Значение];
			КонецЕсли;
		КонецЦикла;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не удалось сформировать таблицу кодов КНД'"));
	КонецПопытки;
	
	Элементы.КНДГруппа.Видимость = (КНДОтчетов.Количество() > 0);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоКНД(Команда)
	СтрокиОтчетов = КНДОтчетов.НайтиСтроки(Новый Структура("КНД", СокрЛП(КНД)));
	Если СтрокиОтчетов.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Отчет с КНД '") + СокрЛП(КНД) + НСтр("ru=' не поддерживается'"));
	Иначе 
		ЭтоЮридическоеЛицо = ЭтоЮридическоеЛицо(Организация);
		Если ЭтоЮридическоеЛицо Тогда
			Если НЕ ДанноеСообщениеДоступноДляОрганизации(СтрокиОтчетов[0].Тип) Тогда
				ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для ИП'");
				ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(СтрокиОтчетов[0].Тип));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
				Возврат;
			КонецЕсли;
		Иначе
			Если НЕ ДанноеСообщениеДоступноДляИП(СтрокиОтчетов[0].Тип) Тогда
				ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для организаций'");
				ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(СтрокиОтчетов[0].Тип));
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстПредупреждения);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
		ОбработкаВыбораВидаУведомления(СтрокиОтчетов[0].Тип, СтрокиОтчетов[0].ИмяОтчета);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// Если организация и ВидУведомления заполнены, то пропускаем эту форму, сразу создаем объект (только в режиме создания)
	Если СозданиеСообщения Тогда
		Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ВидУведомления) Тогда
			Данные = Элементы.ВидыСообщений.ТекущиеДанные;
			Если Данные <> Неопределено Тогда
				ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
			КонецЕсли;
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидыСообщенийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Организация) И СозданиеСообщения Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Укажите организацию'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),, "Организация");
		Возврат;
	КонецЕсли;
	
	Данные = Элементы.ВидыСообщений.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Элементы.Выбрать.Доступность = ЗначениеЗаполнено(Организация);
	Элементы.СоздатьПоКНД.Доступность = ЗначениеЗаполнено(Организация);
	Если ВидыСообщенийИП.Количество() > 0 Тогда
		СформироватьСписок();
	ИначеЕсли Организация <> ОрганизацияПредидущийВыбор Тогда
		ПерестроитьДерево(Элементы.ВидыСообщений.ТекущиеДанные.Тип);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Данные = Элементы.ВидыСообщений.ТекущиеДанные;
	Если Данные <> Неопределено Тогда
		ОбработкаВыбораВидаУведомления(Данные.Тип, Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерестроитьДерево(ВидУведомленияВыбранный = Неопределено)
	Если Организация <> ОрганизацияПредидущийВыбор Тогда
		Если Не ЗначениеЗаполнено(Организация) Тогда 
			ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийОбщее"), "ВидыСообщений");
		Иначе
			НовОргЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
			СтарОргЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(ОрганизацияПредидущийВыбор);
			Если НовОргЮЛ <> СтарОргЮЛ Или (Не ЗначениеЗаполнено(ОрганизацияПредидущийВыбор)) Тогда 
				Если НовОргЮЛ Тогда 
					ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийООО"), "ВидыСообщений");
				Иначе
					ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("ДеревоУведомленийИП"), "ВидыСообщений");
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ВидУведомленияВыбранный) Тогда
			Идентификатор = Неопределено;
			ПолучитьИдентификаторНужногоЭлемента(ВидыСообщений.ПолучитьЭлементы(), ВидУведомленияВыбранный, Идентификатор);
			Элементы.ВидыСообщений.ТекущаяСтрока = Идентификатор;
		КонецЕсли;
	КонецЕсли;
	ОрганизацияПредидущийВыбор = Организация;
КонецПроцедуры

&НаСервере
Процедура СформироватьСписок()
	
	КорневойУровень = ВидыСообщений.ПолучитьЭлементы();
	КорневойУровень.Очистить();
	ДеревоУведомлений = РеквизитФормыВЗначение("ВидыСообщений");
	
	ДеревоУведомленийООО.ПолучитьЭлементы().Очистить();
	ДеревоУведомленийИП.ПолучитьЭлементы().Очистить();
	
	Если Не ЗначениеЗаполнено(Организация) Тогда 
		Список = ВидыСообщенийОбщий;
	ИначеЕсли РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация) Тогда 
		Список = ВидыСообщенийОрганизации;
	Иначе 
		Список = ВидыСообщенийИП;
	КонецЕсли;
	
	Для Каждого ОтправляемыйЭлемент Из Список Цикл
		ДобавитьВеткуВДеревоУведомлений(ДеревоУведомлений.Строки, ОтправляемыйЭлемент.Значение);
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ВидыСообщений");
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ДеревоУведомленийОбщее");
	СформироватьДеревоОООИП(ДеревоУведомленийООО, ВидыСообщений, Ложь);
	СформироватьДеревоОООИП(ДеревоУведомленийИП, ВидыСообщений, Истина);
	
	ПерестроитьДерево();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ДанноеСообщениеДоступноДляИП(Вид)
	
	Если Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР21001")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР24001")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС") 
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента") Тогда
		
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ДанноеСообщениеДоступноДляОрганизации(Вид)
	
	Если Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР11001")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР13001")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаР14001")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов") 
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково")
		Или Вид = ПредопределенноеЗначение("Перечисление.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента") Тогда
		
		Возврат Истина;
	Иначе 
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура СформироватьДерево()
	
	ФлагиУчета = ЭлектронныйДокументооборотСКонтролирующимиОрганами.ПолучитьФлагиИнтеграцииПоУмолчанию();
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиПереопределяемый.ПолучитьЗначенияКонстантИнтеграции(ФлагиУчета);
	ДеревоУведомлений = РеквизитФормыВЗначение("ВидыСообщений");
	
	КорневойУровень = ДеревоУведомлений.Строки;
	
	// Ветка УСН
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "УСН";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииОбъектаНалогообложенияПоУСН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбОтказеОтУСН);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбУтратеПраваНаУСН);
		
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда //Доступна и активна упрощенная отчетность
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН);
	КонецЕсли;

	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПрекращенииДеятельностиПоУСН);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	// Ветка ЕНВД
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "ЕНВД";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД1);
	КонецЕсли;	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД2);	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД3);
	КонецЕсли;	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаЕНВД4);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	// Ветка торговый сбор
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Торговый сбор";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС2);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	// Ветка Патентная система
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Патентная система";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеПатентаРекомендованнаяФорма);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОбУтратеПраваНаПатент);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПрекращенииДеятельностиПоПатентнойСистеме);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		// Ветка иностранные организации
		Папка = КорневойУровень.Добавить();
		Папка.Наименование = "Участие в иностранных организациях";
		Папка.ИндексКартинки = 0;
		ЭлементыПапки = Папка.Строки;
		
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаУ_ИО);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаКИК);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаСИО);
		Если ЭлементыПапки.Количество() = 0 Тогда 
			КорневойУровень.Удалить(Папка);
		КонецЕсли;	
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		// Ветка иностранные организации
		Папка = КорневойУровень.Добавить();
		Папка.Наименование = "Обособленные подразделения";
		Папка.ИндексКартинки = 0;
		ЭлементыПапки = Папка.Строки;
		
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.Форма_1_6_Учет);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_1);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_3_2);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СообщениеОНаделенииОППолномочиямиПоВыплатам);
		Если ЭлементыПапки.Количество() = 0 Тогда 
			КорневойУровень.Удалить(Папка);
		КонецЕсли;
	КонецЕсли;
	
	// Ветка взаиморасчеты с налоговой
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Взаиморасчеты с налоговой инспекцией";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОВозвратеНалога);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОЗачетеНалога);
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	// Прочее
	Папка = КорневойУровень.Добавить();
	Папка.Наименование = "Прочее";
	Папка.ИндексКартинки = 0;
	ЭлементыПапки = Папка.Строки;
	
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ДекларацияОХарактеристикахОбъектаНедвижимости);
	КонецЕсли;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеИсключенииПроверки);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеПостановкаОбъектаНВОС);
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.НевозможностьПредоставленияДокументов);
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПредоставленииРассрочкиФСС);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПостановкаСнятиеВКачествеНалоговогоАгента);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеОПримененииНалоговойЛьготыУчастникамиРегиональныхИнвестиционныхПроектов);
	КонецЕсли;
	ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_6);
	Если ЗначениеЗаполнено(ФлагиУчета) И Не ФлагиУчета.ИнтеграцияСБанком Тогда
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаС09_4);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.СогласиеНаРаскрытиеНалоговойТайны);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеУчастникаСколково);
		ДобавитьВеткуВДеревоУведомлений(ЭлементыПапки, Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ЗаявлениеНаПолучениеДокументаНалоговогоРезидента);
	КонецЕсли;	
	Если ЭлементыПапки.Количество() = 0 Тогда 
		КорневойУровень.Удалить(Папка);
	КонецЕсли;
	
	// Уведомления, не входящие в БРО
	Если УчитыватьУведомленияНеВходящиеВБРО Тогда
		ДобавитьКДеревуПрочиеУведомление(ДеревоУведомлений);
	КонецЕсли;
	
	СоответствиеАдрес = ПоместитьВоВременноеХранилище(ЭтотОбъект.УникальныйИдентификатор);
	
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ВидыСообщений");
	ЗначениеВРеквизитФормы(ДеревоУведомлений, "ДеревоУведомленийОбщее");
	СформироватьДеревоОООИП(ДеревоУведомленийООО, ВидыСообщений, Ложь);
	СформироватьДеревоОООИП(ДеревоУведомленийИП, ВидыСообщений, Истина);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоОООИП(НовЭлтРек, ИсхЭлт, ДляИП)
	Для Каждого Элт Из ИсхЭлт.ПолучитьЭлементы() Цикл 
		ЭтоПапка = (Элт.ПолучитьЭлементы().Количество() > 0);
		Если ЭтоПапка Тогда
			НовЭлтПапка = НовЭлтРек.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НовЭлтПапка, Элт);
			СформироватьДеревоОООИП(НовЭлтПапка, Элт, ДляИП);
		Иначе
			Если ТипЗнч(Элт.Тип) <> Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения")
				Или (ДляИП И ДанноеСообщениеДоступноДляИП(Элт.Тип))
				Или ((Не ДляИП) И ДанноеСообщениеДоступноДляОрганизации(Элт.Тип)) Тогда 
				
				НовЭлт = НовЭлтРек.ПолучитьЭлементы().Добавить();
				ЗаполнитьЗначенияСвойств(НовЭлт, Элт);
			КонецЕсли;
		КонецЕсли;
		
		Если ЭтоПапка И (НовЭлтПапка.ПолучитьЭлементы().Количество() = 0) Тогда
			НовЭлтРек.ПолучитьЭлементы().Удалить(НовЭлтПапка);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ДобавитьКДеревуПрочиеУведомление(ДеревоУведомлений)
	
	ТаблицаОписанияОбъектов = РегламентированнаяОтчетность.ТаблицаОписанияОбъектовРегламентированнойОтчетности();
	ТаблицаОписанияУведомлений = ТаблицаОписанияОбъектов.Скопировать(Новый Структура("ВидДокумента, ЯвляетсяАктуальным", Перечисления.СтраницыЖурналаОтчетность.Уведомления, Истина));
	
	// Получаем имена всех групп
	Группы = Новый Массив;
	Для каждого СтрокаТаблицыОписанияУведомлений Из ТаблицаОписанияУведомлений Цикл
		Если Группы.Найти(СтрокаТаблицыОписанияУведомлений.ГруппаВДереве) = Неопределено Тогда
			Группы.Добавить(СтрокаТаблицыОписанияУведомлений.ГруппаВДереве);
		КонецЕсли;
	КонецЦикла;
	
	КорневойУровень = ДеревоУведомлений.Строки;
	
	// Строим дерево
	Для каждого Группа Из Группы Цикл
		
		СтрокиОбъектовДаннойГруппы = ТаблицаОписанияУведомлений.НайтиСтроки(Новый Структура("ГруппаВДереве", Группа));
		Если Группа = "" Тогда
			
			// Если нет группы, добавляем в корень
			Для каждого СтрокаОбъектовДаннойГруппы Из СтрокиОбъектовДаннойГруппы Цикл
			
				Сообщение = КорневойУровень.Добавить();
				Сообщение.Наименование = СтрокаОбъектовДаннойГруппы.Наименование;

				МассивТипов = Новый Массив;
				МассивТипов.Добавить(СтрокаОбъектовДаннойГруппы.ТипОбъекта);
				Сообщение.Тип = Новый ОписаниеТипов(МассивТипов);
				Сообщение.ИндексКартинки = 1;
				
				Сообщение.КонтролирующийОрган = СтрокаОбъектовДаннойГруппы.ВидКонтролирующегоОргана;
			
			КонецЦикла; 
		
		Иначе
			
			// Создаем папку
			Папка = ДеревоУведомлений.Строки.Добавить();
			Папка.Наименование = Группа;
			Папка.ИндексКартинки = 0;
			ЭлементыПапки = Папка.Строки;
			
			// Добавляем в папку элементы
			Для каждого СтрокаОбъектовДаннойГруппы Из СтрокиОбъектовДаннойГруппы Цикл
				Сообщение = ЭлементыПапки.Добавить();
				
				Сообщение.Наименование 	= СтрокаОбъектовДаннойГруппы.Наименование;
				
				МассивТипов = Новый Массив;
				МассивТипов.Добавить(СтрокаОбъектовДаннойГруппы.ТипОбъекта);
				Сообщение.Тип = Новый ОписаниеТипов(МассивТипов);
				Сообщение.ИндексКартинки = 1;
				
				Сообщение.КонтролирующийОрган = СтрокаОбъектовДаннойГруппы.ВидКонтролирующегоОргана;
			КонецЦикла;
			
		КонецЕсли;
	
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Функция ЭтоЮридическоеЛицо(Организация)
	
	Возврат РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Организация);
	
КонецФункции

&НаСервере
Функция ЭтотТипНеВходитВБРО(Тип) Экспорт
	
	ТаблицаОбъектовНеВходящихВБРО = РегламентированнаяОтчетность.ТаблицаОписанияОбъектовРегламентированнойОтчетности();
	СведенияПоОбъекту = ТаблицаОбъектовНеВходящихВБРО.Найти(Тип, "ТипОбъекта");
	
	Возврат СведенияПоОбъекту <> Неопределено;
	
КонецФункции

&НаСервере
Функция ПолноеИмяОбъектаМетаданных(Тип)
	
	Возврат Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
	
КонецФункции

&НаСервере
Процедура ДобавитьВеткуВДеревоУведомлений(Родитель, ТипУведомления)
	
	ИмяОтчета = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ПолучитьИмяОтчетаПоВидуУведомления(ТипУведомления);
	Если ЗначениеЗаполнено(ИмяОтчета) И Метаданные.Отчеты.Найти(ИмяОтчета) = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Сообщение = Родитель.Добавить();
	Сообщение.Наименование = Строка(ТипУведомления);
	Сообщение.ИндексКартинки = 1;
	Сообщение.Тип = ТипУведомления;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораВидаУведомления(Тип, Наименование)
	
	Данные = ПолучитьИзВременногоХранилища(АдресДанные);
	
	Если ТипЗнч(Тип) = Тип("ПеречислениеСсылка.ВидыУведомленийОСпецрежимахНалогообложения") Тогда
		
		ВидУведомления = Тип;
		
		Если СозданиеСообщения Тогда
			
			ЭтоЮридическоеЛицо = ЭтоЮридическоеЛицо(Организация);
			
			Если ЭтоЮридическоеЛицо Тогда
				
				// Проверка на организаций
				Если НЕ ДанноеСообщениеДоступноДляОрганизации(ВидУведомления) Тогда
					
					ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для ИП'");
					ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(ВидУведомления));
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ТекстПредупреждения;
					Сообщение.Сообщить();
					
					Возврат;
				КонецЕсли;
				
			Иначе
				
				// Проверка на ИП
				Если НЕ ДанноеСообщениеДоступноДляИП(ВидУведомления) Тогда
					
					ТекстПредупреждения = НСтр("ru = 'Уведомление ""%1"" можно создавать только для организаций'");
					ТекстПредупреждения = СтрЗаменить(ТекстПредупреждения, "%1", Строка(ВидУведомления));
					Сообщение = Новый СообщениеПользователю;
					Сообщение.Текст = ТекстПредупреждения;
					Сообщение.Сообщить();
					
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
			СтандартнаяОбработка = Истина;
			Попытка
				РегламентированнаяОтчетностьКлиентПереопределяемый.ПередОткрытиемФормыУведомления(Организация, ВидУведомления, СтандартнаяОбработка);
			Исключение
				СтандартнаяОбработка = Истина;
			КонецПопытки;
			
			ПараметрыУведомления = Новый Структура;
			ПараметрыУведомления.Вставить("Организация", Организация);
			ПараметрыУведомления.Вставить("ВидУведомления", ВидУведомления);
			ПараметрыУведомления.Вставить("UIDФорма1СОтчетность", UIDФорма1СОтчетность);
			ПараметрыУведомления.Вставить("Данные", Данные);
			
			Если СтандартнаяОбработка Или Данные <> Неопределено Тогда
				ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.ФормаОбъекта",  ПараметрыУведомления, ЭтотОбъект.ВладелецФормы);
			Иначе
				Оповестить("РеализованаНестандартнаяОбработкаОткрытияУведомления", ПараметрыУведомления);
			КонецЕсли;
			
		КонецЕсли;
		
		Закрыть(ВидУведомления);
			
	Иначе
		
		// Если это тип, не входящий в БРО, то объект создаем с помощью переопределемого метода
		ТипСоздаваемогоОбъекта = ?(ТипЗнч(Тип) = Тип("ОписаниеТипов") И Тип.Типы().Количество() > 0, Тип.Типы()[0], Тип);
		Если ЭтотТипНеВходитВБРО(ТипСоздаваемогоОбъекта) Тогда
			Если СозданиеСообщения Тогда
				СтандартнаяОбработка = Истина;
				РегламентированнаяОтчетностьКлиентПереопределяемый.СоздатьНовыйОбъект(Организация, ТипСоздаваемогоОбъекта, СтандартнаяОбработка);
				Если СтандартнаяОбработка Тогда
					// Создаем объект
					
					ИмяОбъектаМетаданных = ПолноеИмяОбъектаМетаданных(ТипСоздаваемогоОбъекта);
					ОткрытьФорму(ИмяОбъектаМетаданных + ".ФормаОбъекта", 
						Новый Структура("Организация, Данные", Организация, Данные), ЭтотОбъект.ВладелецФормы);
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ПараметрыЗакрытия = Новый Структура();
		ПараметрыЗакрытия.Вставить("Тип", 			Тип);
		ПараметрыЗакрытия.Вставить("Наименование", 	Наименование);
		
		Закрыть(ПараметрыЗакрытия);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПолучитьИдентификаторНужногоЭлемента(Элементы, ВидУведомления, Идентификатор)

	Для каждого Элемент из Элементы Цикл
		
		Если Элемент.Тип = ВидУведомления Тогда
			Идентификатор = Элемент.ПолучитьИдентификатор();
			Возврат;
		Конецесли;
		
		ПолучитьИдентификаторНужногоЭлемента(Элемент.ПолучитьЭлементы(), ВидУведомления, Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
