#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// Проводит документ по учетам. Если в параметре ВидыУчетов передано Неопределено, то документ проводится по всем учетам.
// Процедура вызывается из обработки проведения и может вызываться из вне.
// 
// Параметры:
//  ДокументСсылка	- ДокументСсылка.Отпуск - Ссылка на документ
//  РежимПроведения - РежимПроведенияДокумента - Режим проведения документа (оперативный, неоперативный)
//  Отказ 			- Булево - Признак отказа от выполнения проведения
//  ВидыУчетов 		- Строка - Список видов учета, по которым необходимо провести документ. Если параметр пустой или Неопределено, то документ проведется по всем учетам
//  Движения 		- Коллекция движений документа - Передается только при вызове из обработки проведения документа
//  Объект			- ДокументОбъект.Отпуск - Передается только при вызове из обработки проведения документа
//  ДополнительныеПараметры - Структура - Дополнительные параметры, необходимые для проведения документа.
//
Процедура ПровестиПоУчетам(ДокументСсылка, РежимПроведения, Отказ, ВидыУчетов = Неопределено, Движения = Неопределено, Объект = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
	ПроведениеРасширенныйСервер.ПодготовитьНаборыЗаписейКРегистрацииДвиженийПоВидамУчета(РежимПроведения, ДокументСсылка, СтруктураВидовУчета, ВидыУчетов, Движения, Объект, Отказ);
	
	РеквизитыДляПроведения = РеквизитыДляПроведения(ДокументСсылка);
	ДанныеДляПроведения = ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета);
	
	ИсправлениеДокументовЗарплатаКадры.ПриПроведенииИсправления(ДокументСсылка, Движения, РежимПроведения, Отказ, РеквизитыДляПроведения, СтруктураВидовУчета, Объект);
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		РасчетЗарплатыРасширенный.СформироватьДвиженияНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), ДанныеДляПроведения.Начисления, ДанныеДляПроведения.ПоказателиНачислений, Истина);
		РасчетЗарплатыРасширенный.СформироватьДвиженияРаспределенияПоТерриториямУсловиямТруда(Движения, Отказ, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда);
		РасчетЗарплатыРасширенный.СформироватьДвиженияУдержаний(
			Движения, Отказ, РеквизитыДляПроведения.Организация, КонецМесяца(РеквизитыДляПроведения.ПериодРегистрации), ДанныеДляПроведения.Удержания, ДанныеДляПроведения.ПоказателиУдержаний);
		ИсполнительныеЛисты.СформироватьУдержанияПоИсполнительнымДокументам(Движения, ДанныеДляПроведения.УдержанияПоИсполнительнымДокументам);
		ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ);
		РасчетЗарплатыРасширенный.СформироватьЗадолженностьПоУдержаниямФизическихЛиц(Движения, ДанныеДляПроведения.ЗадолженностьПоУдержаниям);
		УчетНачисленнойЗарплаты.ЗарегистрироватьНачисленияУдержания(
				Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено, Неопределено, РеквизитыДляПроведения.ПорядокВыплаты);
		УчетНачисленнойЗарплаты.ЗарегистрироватьОтработанноеВремя(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.ОтработанноеВремяПоСотрудникам, Истина);
		
#Область РегистрацияДоходовВУчетеНДФЛ
		
		// - Регистрация бухучета начислений и удержаний, выполняется до вызова регистрации доходов в учете НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
					Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
					ДанныеДляПроведения.НачисленияПоСотрудникам, ДанныеДляПроведения.УдержанияПоСотрудникам, Неопределено,
					РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
					
		// НДФЛ
		УчетНДФЛРасширенный.ЗарегистрироватьДоходыИСуммыНДФЛПоВременнойТаблицеНачислений(
			РеквизитыДляПроведения.Ссылка, Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.Дата, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, РеквизитыДляПроведения.ПланируемаяДатаВыплаты, ДанныеДляПроведения, Истина, Истина);
		// КорректировкиВыплаты
		РасчетЗарплатыРасширенный.СформироватьДвиженияКорректировкиВыплатыПоВременнойТаблицеНачислений(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, РеквизитыДляПроведения.ПорядокВыплаты, ДанныеДляПроведения, Истина, Истина);
		
#КонецОбласти									
		// - Регистрация начислений в доходах для страховых взносов.
		УчетСтраховыхВзносов.СформироватьСведенияОДоходахСтраховыеВзносы(Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, Ложь, Истина, РеквизитыДляПроведения.Ссылка);

		
		// - Регистрация бухучета НДФЛ.
		ОтражениеЗарплатыВБухучетеРасширенный.СформироватьДвиженияБухучетНачисленияУдержанияПоСотрудникам(
					Движения, Отказ, РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации,
					Неопределено, Неопределено, ДанныеДляПроведения.НДФЛПоСотрудникам,
					РасчетЗарплатыРасширенный.ЭтоМежрасчетнаяВыплата(РеквизитыДляПроведения.ПорядокВыплаты));
								
	КонецЕсли;
		
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		
		СостоянияСотрудников.ЗарегистрироватьСостоянияСотрудников(Движения, РеквизитыДляПроведения.Ссылка, ДанныеСостоянийСотрудника(РеквизитыДляПроведения));		
					
		УчетСреднегоЗаработка.УдалитьПричиныПерерасчетов(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
		ПерерасчетЗарплаты.УдалениеПерерасчетовПоДополнительнымПараметрам(РеквизитыДляПроведения.Ссылка, ДополнительныеПараметры);
	КонецЕсли;
	
	ПроведениеРасширенныйСервер.ЗаписьДвиженийПоУчетам(Движения, СтруктураВидовУчета);
	
КонецПроцедуры

// Сторнирует документ по учетам. Используется подсистемой исправления документов.
//
// Параметры:
//  Движения				 - КоллекцияДвижений, Структура	 - Коллекция движений исправляющего документа в которую будут добавлены сторно стоки.
//  Регистратор				 - ДокументСсылка				 - Документ регистратор исправления (документ исправление).
//  ИсправленныйДокумент	 - ДокументСсылка				 - Исправленный документ движения которого будут сторнированы.
//  СтруктураВидовУчета		 - Структура					 - Виды учета, по которым будет выполнено сторнирование исправленного документа.
//  					Состав полей см. в ПроведениеРасширенныйСервер.СтруктураВидовУчета().
//  ДополнительныеПараметры	 - Структура					 - Структура со свойствами:
//  					* ИсправлениеВТекущемПериоде - Булево - Истина когда исправление выполняется в периоде регистрации исправленного документа.
//						* ОтменаДокумента - Булево - Истина когда исправление вызвано документом СторнированиеНачислений.
//  					* ПериодРегистрации	- Дата - Период регистрации документа регистратора исправления.
// 
// Возвращаемое значение:
//  Булево - "Истина" если сторнирование выполнено этой функцией, "Ложь" если специальной процедуры не предусмотрено.
//
Функция СторнироватьПоУчетам(Движения, Регистратор, ИсправленныйДокумент, СтруктураВидовУчета, ДополнительныеПараметры) Экспорт
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаДокумента.
Функция ОписаниеСоставаДокумента() Экспорт
	
	МетаданныеДокумента = Метаданные.Документы.ОтпускВоеннослужащего;
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаДокументаПоМетаданнымФизическоеЛицоВШапке(МетаданныеДокумента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДобавитьКомандыСозданияДокументов(КомандыСозданияДокументов, ДополнительныеПараметры) Экспорт
	
	ЗарплатаКадрыРасширенный.ДобавитьВКоллекциюКомандуСозданияДокументаПоМетаданнымДокумента(
		КомандыСозданияДокументов, Метаданные.Документы.ОтпускВоеннослужащего);
	
КонецФункции

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ОшибкиПечати          - Список значений  - Ошибки печати  (значение - ссылка на объект, представление - текст
//                           ошибки).
//   ОбъектыПечати         - Список значений  - Объекты печати (значение - ссылка на объект, представление - имя
//                           области в которой был выведен объект).
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт

КонецПроцедуры

Функция ДанныеДляПроведения(РеквизитыДляПроведения, СтруктураВидовУчета = Неопределено) Экспорт 
	
	Если СтруктураВидовУчета = Неопределено Тогда
		СтруктураВидовУчета = ПроведениеРасширенныйСервер.СтруктураВидовУчета();
		Для Каждого ВидУчета Из СтруктураВидовУчета Цикл
			СтруктураВидовУчета[ВидУчета.Ключ] = Истина;
		КонецЦикла;
	КонецЕсли;
	
	ДанныеДляПроведения = РасчетЗарплаты.СоздатьДанныеДляПроведенияНачисленияЗарплаты();
	
	Если СтруктураВидовУчета.ОстальныеВидыУчета Тогда
		РасчетЗарплатыРасширенный.ЗаполнитьНачисления(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, "Начисления,НачисленияПерерасчет", "Ссылка.ПериодРегистрации");
		РасчетЗарплатыРасширенный.ЗаполнитьУдержания(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьСписокФизическихЛиц(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплаты.ЗаполнитьДанныеНДФЛ(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		РасчетЗарплатыРасширенный.ЗаполнитьДанныеКорректировкиВыплаты(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка);
		ЗаполнитьСведенияОПособиях(РеквизитыДляПроведения, ДанныеДляПроведения);
		РасчетЗарплатыРасширенный.ЗаполнитьПогашениеЗадолженностиПоУдержаниям(ДанныеДляПроведения, РеквизитыДляПроведения.Ссылка, РеквизитыДляПроведения.ПериодРегистрации);
		
		ОтражениеЗарплатыВБухучете.СоздатьВТНачисленияСДаннымиЕНВД(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации, ДанныеДляПроведения.МенеджерВременныхТаблиц, ДанныеДляПроведения.НачисленияПоСотрудникам);
				
	КонецЕсли;
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведения(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Отпуск.Ссылка,
	|	Отпуск.Организация,
	|	Отпуск.ПериодРегистрации,
	|	Отпуск.ПорядокВыплаты,
	|	Отпуск.Дата,
	|	Отпуск.ПланируемаяДатаВыплаты,
	|	Отпуск.ДатаНачалаОтпуска КАК ДатаНачалаСобытия,
	|	Отпуск.ФизическоеЛицо,
	|	Отпуск.Сотрудник,
	|	Отпуск.ДатаНачалаОтпуска КАК ДатаНачалаПериодаОтсутствия,
	|	Отпуск.ДатаОкончанияОтпуска КАК ДатаОкончанияПериодаОтсутствия,
	|	Отпуск.ИсправленныйДокумент,
	|	Отпуск.Номер,
	|	Отпуск.ДатаНачалаОтпуска,
	|	Отпуск.ДатаОкончанияОтпуска
	|ИЗ
	|	Документ.ОтпускВоеннослужащего КАК Отпуск
	|ГДЕ
	|	Отпуск.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.НомерСтроки,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтроки,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.Территория,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.УсловияТруда,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.ДоляРаспределения,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.Результат,
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.ИдентификаторСтрокиПоказателей
	|ИЗ
	|	Документ.ОтпускВоеннослужащего.РаспределениеПоТерриториямУсловиямТруда КАК ОтпускРаспределениеПоТерриториямУсловиямТруда
	|ГДЕ
	|	ОтпускРаспределениеПоТерриториямУсловиямТруда.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтпускНачисления.НомерСтроки,
	|	ОтпускНачисления.Начисление,
	|	ОтпускНачисления.ДатаНачала,
	|	ОтпускНачисления.ДатаОкончания,
	|	ОтпускНачисления.Результат,
	|	ОтпускНачисления.Подразделение,
	|	ОтпускНачисления.ВидЗанятости,
	|	ОтпускНачисления.НормаДней,
	|	ОтпускНачисления.НормаЧасов,
	|	ОтпускНачисления.ОтработаноДней,
	|	ОтпускНачисления.ОтработаноЧасов,
	|	ОтпускНачисления.Сотрудник,
	|	ОтпускНачисления.РасчетнаяБазаЗаЕдиницуНормыВремени,
	|	ОтпускНачисления.ИдентификаторСтрокиВидаРасчета,
	|	ОтпускНачисления.ГрафикРаботы,
	|	ОтпускНачисления.ВидУчетаВремени,
	|	ОтпускНачисления.ФиксСтрока,
	|	ОтпускНачисления.ФиксЗаполнение,
	|	ОтпускНачисления.ФиксРасчетВремени,
	|	ОтпускНачисления.ФиксРасчет,
	|	ОтпускНачисления.ВремяВЧасах,
	|	ОтпускНачисления.ГрафикРаботыНорма,
	|	ОтпускНачисления.ГрафикРаботыНорма КАК ГрафикРаботыНорма1,
	|	ОтпускНачисления.ОбщийГрафик,
	|	ОтпускНачисления.ПериодРегистрацииВремени,
	|	ОтпускНачисления.ПериодРегистрацииНормыВремени,
	|	ОтпускНачисления.СуммаВычета,
	|	ОтпускНачисления.КодВычета,
	|	ОтпускНачисления.ОплаченоДней,
	|	ОтпускНачисления.ОплаченоЧасов,
	|	ОтпускНачисления.ДокументОснование
	|ИЗ
	|	Документ.ОтпускВоеннослужащего.Начисления КАК ОтпускНачисления
	|ГДЕ
	|	ОтпускНачисления.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Результаты = Запрос.ВыполнитьПакет();
	
	РеквизитыДляПроведения = РеквизитыДляПроведенияПустаяСтруктура();
	
	ВыборкаРеквизиты = Результаты[0].Выбрать();
	
	Пока ВыборкаРеквизиты.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(РеквизитыДляПроведения, ВыборкаРеквизиты);
		
	КонецЦикла;
	
	РаспределениеПоТерриториямУсловиямТруда = Результаты[1].Выгрузить();
	
	РеквизитыДляПроведения.РаспределениеПоТерриториямУсловиямТруда = РаспределениеПоТерриториямУсловиямТруда;

	Начисления = Результаты[2].Выгрузить();
	
	РеквизитыДляПроведения.Начисления = Начисления;
	
	Возврат РеквизитыДляПроведения;
	
КонецФункции

Функция РеквизитыДляПроведенияПустаяСтруктура() Экспорт 
	
	РеквизитыДляПроведенияПустаяСтруктура = Новый Структура("Ссылка, Организация, ПериодРегистрации, ПорядокВыплаты, Дата, ПланируемаяДатаВыплаты, 
		| ДатаНачалаСобытия, ФизическоеЛицо, Сотрудник, ДатаНачалаПериодаОтсутствия, ДатаОкончанияПериодаОтсутствия, 
		| ИсправленныйДокумент, Номер, ДатаНачалаОтпуска, ДатаОкончанияОтпуска, Начисления, РаспределениеПоТерриториямУсловиямТруда");	
	
	Возврат РеквизитыДляПроведенияПустаяСтруктура;
	
КонецФункции

// Проверяет, что сотрудник, указанный в документе работает в период отсутствия.
//
// Параметры:
//		ДокументОбъект	- ДокументОбъект.Отпуск
//		Отказ			- Булево
//
Процедура ПроверитьРаботающих(ДокументОбъект, Отказ) Экспорт
		
	НачалоПроверяемогоПериода 			= '00010101';
	ОкончаниеПроверяемогоПериода 		= '00010101';
				
	Если НЕ ЗначениеЗаполнено(НачалоПроверяемогоПериода) Тогда
		НачалоПроверяемогоПериода = ДокументОбъект.ДатаНачалаОтпуска;
	ИначеЕсли ЗначениеЗаполнено(ДокументОбъект.ДатаНачалаОтпуска) Тогда
		НачалоПроверяемогоПериода = Мин(НачалоПроверяемогоПериода, ДокументОбъект.ДатаНачалаОтпуска);
	КонецЕсли;
		
	ОкончаниеПроверяемогоПериода = Макс(ОкончаниеПроверяемогоПериода, ДокументОбъект.ДатаОкончанияОтпуска);
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияРабочихМестВОрганизацийПоВременнойТаблице();
	ПараметрыПолученияСотрудниковОрганизаций.Организация 				= ДокументОбъект.Организация;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= НачалоПроверяемогоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ОкончаниеПроверяемогоПериода;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ 	= Неопределено;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ДокументОбъект.Сотрудник),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект")
	);
	
КонецПроцедуры

Функция ДанныеСостоянийСотрудника(РеквизитыДляПроведения) Экспорт 
	
	ДанныеСостояний = СостоянияСотрудников.ПустаяТаблицаДанныхСостоянийСотрудника();
	
	НоваяСтрока = ДанныеСостояний.Добавить();
	НоваяСтрока.Сотрудник = РеквизитыДляПроведения.Сотрудник;
	НоваяСтрока.Состояние = Перечисления.СостоянияСотрудника.ОтпускОсновной;
	НоваяСтрока.Начало = РеквизитыДляПроведения.ДатаНачалаОтпуска;
	НоваяСтрока.Окончание = РеквизитыДляПроведения.ДатаОкончанияОтпуска;
			
	Возврат ДанныеСостояний;
	
КонецФункции

Процедура ПроверитьПересечениеФактическогоПериодаДействия(ДокументСсылка, Отказ)
	
	Если Отказ Тогда
		Возврат;	
	КонецЕсли;
	
	ИменаРеквизитов = 
	"ПериодРегистрации,
	|Организация,
	|ИсправленныйДокумент";
	
	РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, ИменаРеквизитов);
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Начисления.*
	               |ИЗ
	               |	Документ.ОтпускВоеннослужащего.Начисления КАК Начисления
	               |ГДЕ
	               |	Начисления.Ссылка = &Ссылка";
				   
	Начисления = Запрос.Выполнить().Выгрузить();
	
	ПараметрыПроверки = РасчетЗарплатыРасширенный.ПараметрыПроверкиПересеченияФактическогоПериодаДействия();
	ПараметрыПроверки.Организация = РеквизитыДокумента.Организация;
	ПараметрыПроверки.ПериодРегистрации = РеквизитыДокумента.ПериодРегистрации;
	ПараметрыПроверки.Документ = ДокументСсылка;
	ПараметрыПроверки.Начисления = Начисления;
	ПараметрыПроверки.ИсправленныйДокумент = РеквизитыДокумента.ИсправленныйДокумент;
	
	РасчетЗарплатыРасширенный.ПроверитьПересечениеФактическогоПериодаДействия(ПараметрыПроверки, Отказ);
	
КонецПроцедуры

Функция ПолныеПраваНаДокумент() Экспорт 
	
	Возврат Пользователи.РолиДоступны("ДобавлениеИзменениеНачисленнойЗарплатыРасширенная, ЧтениеНачисленнойЗарплатыРасширенная", , Ложь);
	
КонецФункции	

Функция ДанныеДляПроверкиОграниченийНаУровнеЗаписей(Объект) Экспорт 
	
	ФизическоеЛицо = ?(ЗначениеЗаполнено(Объект.Сотрудник), ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Сотрудник, "ФизическоеЛицо"), Справочники.ФизическиеЛица.ПустаяСсылка());
	
	ДанныеДляПроверкиОграничений = ЗарплатаКадрыРасширенный.ОписаниеСтруктурыДанныхДляПроверкиОграниченийНаУровнеЗаписей();
	
	ДанныеДляПроверкиОграничений.Организация = Объект.Организация;
	ДанныеДляПроверкиОграничений.МассивФизическихЛиц = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ФизическоеЛицо);
	
	Возврат ДанныеДляПроверкиОграничений;
	
КонецФункции

Функция ПланируемаяДатыВыплатыОтпуска(ДатаНачалаСобытия) Экспорт
	
	ПланируемаяДатыВыплатыОтпуска = Неопределено;
	
	Если ЗначениеЗаполнено(ДатаНачалаСобытия) Тогда
		ДатаТриДняДоОтпуска = ДатаНачалаСобытия - (86400 * 3);

		ПланируемаяДатыВыплатыОтпуска = ДатаТриДняДоОтпуска;
	КонецЕсли;
	
	Возврат ПланируемаяДатыВыплатыОтпуска;
	
КонецФункции

Процедура ЗаполнитьСведенияОПособиях(РеквизитыДляПроведения, ДанныеДляПроведения)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДанныеДляПроведения.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаНачислений.Ссылка,
	|	ТаблицаНачислений.Начисление,
	|	ТаблицаНачислений.Сотрудник,
	|	ТаблицаНачислений.ВидЗанятости КАК ВидЗанятости,
	|	ЛОЖЬ КАК Сторно,
	|	ТаблицаНачислений.ОплаченоДней,
	|	ТаблицаНачислений.Результат,
	|	0 КАК РезультатВТомЧислеЗаСчетФБ
	|ПОМЕСТИТЬ ВТНачисленияДляУчетаПособий
	|ИЗ
	|	Документ.ОтпускВоеннослужащего.Начисления КАК ТаблицаНачислений
	|ГДЕ
	|	ТаблицаНачислений.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ТаблицаНачислений.Сторно
	|			ТОГДА ТаблицаНачислений.СторнируемыйДокумент
	|		ИНАЧЕ ТаблицаНачислений.Ссылка
	|	КОНЕЦ,
	|	ТаблицаНачислений.Начисление,
	|	ТаблицаНачислений.Сотрудник,
	|	ТаблицаНачислений.ВидЗанятости,
	|	ТаблицаНачислений.Сторно,
	|	ТаблицаНачислений.ОплаченоДней,
	|	ТаблицаНачислений.Результат,
	|	0
	|ИЗ
	|	Документ.ОтпускВоеннослужащего.НачисленияПерерасчет КАК ТаблицаНачислений
	|ГДЕ
	|	ТаблицаНачислений.Ссылка = &Ссылка";
	Запрос.УстановитьПараметр("Ссылка", РеквизитыДляПроведения.Ссылка);
	
	Запрос.Выполнить();
	
	ПособиеПлатитУчастникПилотногоПроекта = ПрямыеВыплатыПособийСоциальногоСтрахования.ПособиеПлатитУчастникПилотногоПроекта(РеквизитыДляПроведения.Организация, РеквизитыДляПроведения.ПериодРегистрации);

	УчетПособийСоциальногоСтрахованияРасширенный.ЗаполнитьСведенияОПособиях(ДанныеДляПроведения, ПособиеПлатитУчастникПилотногоПроекта);

КонецПроцедуры

Функция ПериодОтсутствия(ПериодыОтсутствий) Экспорт
	
	ПериодОтсутствия = Новый Структура("НачалоПериода,ОкончаниеПериода", '00010101', '00010101');
	
	Для каждого Период Из ПериодыОтсутствий Цикл
		Если ЗначениеЗаполнено(Период.НачалоПериода) Тогда
			Если НЕ ЗначениеЗаполнено(ПериодОтсутствия.НачалоПериода) Тогда
				ПериодОтсутствия.НачалоПериода = Период.НачалоПериода;
			Иначе
				ПериодОтсутствия.НачалоПериода = Мин(ПериодОтсутствия.НачалоПериода, Период.НачалоПериода);
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Период.ОкончаниеПериода) Тогда
			ПериодОтсутствия.ОкончаниеПериода = Макс(ПериодОтсутствия.ОкончаниеПериода, Период.ОкончаниеПериода);
		КонецЕсли;	   
	КонецЦикла;
	
	Возврат ПериодОтсутствия;
	
КонецФункции

Функция ПериодыОтсутствий(Объект) Экспорт
	
	ПериодыОтсутствий = Новый ТаблицаЗначений;
	ПериодыОтсутствий.Колонки.Добавить("НачалоПериода");
	ПериодыОтсутствий.Колонки.Добавить("ОкончаниеПериода");
	
	КонецИнтервала = Дата(1,1,1);
	
	ПериодОтсутствия = ПериодыОтсутствий.Добавить();
	ПериодОтсутствия.НачалоПериода = Объект.ДатаНачалаОтпуска;
	ПериодОтсутствия.ОкончаниеПериода  = Объект.ДатаОкончанияОтпуска;
	КонецИнтервала = Макс(КонецИнтервала, ПериодОтсутствия.ОкончаниеПериода);
	
	Возврат ПериодыОтсутствий;
	
КонецФункции

// Функция возвращает структуру с описанием данного вида документа.
//
Функция ОписаниеДокумента() Экспорт 

	ОписаниеДокумента = ЗарплатаКадрыРасширенныйКлиентСервер.СтруктураОписанияДокумента();
	
	ОписаниеДокумента.КраткоеНазваниеИменительныйПадеж	 = НСтр("ru = 'отпуск'");
	ОписаниеДокумента.КраткоеНазваниеРодительныйПадеж	 = НСтр("ru = 'отпуска'");
	ОписаниеДокумента.ИмяРеквизитаСотрудник				 = "Сотрудник";
	ОписаниеДокумента.ИмяРеквизитаОтсутствующийСотрудник = "Сотрудник";
	ОписаниеДокумента.ИмяРеквизитаДатаНачалаСобытия		 = "ДатаНачалаОтпуска";
	ОписаниеДокумента.ИмяРеквизитаДатаОкончанияСобытия	 = "ДатаОкончанияОтпуска";
	
	Возврат ОписаниеДокумента;

КонецФункции

#КонецОбласти

#КонецЕсли
