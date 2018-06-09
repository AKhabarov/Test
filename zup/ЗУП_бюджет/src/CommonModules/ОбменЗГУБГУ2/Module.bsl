////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обмен ЗГУ 3.0 и БГУ 2.0"
// Серверные процедуры и функции.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет, используется ли обмен ЗГУ ред. 3 - БГУ ред. 2 для конкретной организации.
//
// Параметры
//	Организация - СправочникСсылка.Организации - Организация, не обязательный.
//	НастройкиОбмена - Структура:
//		* ИспользуетсяОбменПоВсемОрганизациям - Булево.
//		* ИспользуетсяОбменПоОрганизациям     - Булево.
//		* ИспользованиеОбменаПоОрганизациям   - Соответствие:
//			*	Ключ     - СправочникСсылка.Организации.
//			*	Значение - Булево.
//
// Возвращаемое значение:
// 	Булево - Истина, если обмен используется, Ложь в противном случае.
//
Функция ОбменИспользуется(Организация = Неопределено, НастройкиОбмена = Неопределено) Экспорт
	
	Если НастройкиОбмена = Неопределено Тогда
		НастройкиОбмена = НастройкиОбмена();
	КонецЕсли;
	
	Если Организация = Неопределено Тогда
		// Если организация не указана, получаем значение без отбора по организации
		Возврат НастройкиОбмена.ИспользуетсяОбменПоВсемОрганизациям Или НастройкиОбмена.ИспользуетсяОбменПоОрганизациям;
	КонецЕсли;
	
	Возврат НастройкиОбмена.ИспользуетсяОбменПоВсемОрганизациям
		Или НастройкиОбмена.ИспользованиеОбменаПоОрганизациям[Организация];
	
КонецФункции

// Обработчик регистрации изменений для начальной выгрузки данных.
// Используется для переопределения стандартной обработки регистрации изменений.
// При стандартной обработке будут зарегистрированы изменения всех данных из состава плана обмена.
// Если для плана обмена предусмотрены фильтры ограничения миграции данных,
// то использование этого обработчика позволит повысить производительность начальной выгрузки данных.
// В обработчике следует реализовать регистрацию изменений с учетом фильтров ограничения миграции данных.
// Если для плана обмена используются ограничения миграции по дате или по дате и организациям,
// то можно воспользоваться универсальной процедурой
// ОбменДаннымиСервер.ЗарегистрироватьДанныеПоДатеНачалаВыгрузкиИОрганизациям.
// Обработчик используется только для универсального обмена данными с использованием правил обмена
// и для универсального обмена данными без правил обмена и не используется для обменов в РИБ.
// Использование обработчика позволяет повысить производительность
// начальной выгрузки данных в среднем в 2-4 раза.
//
// Параметры:
// 	Получатель - ПланОбменаСсылка - Узел плана обмена, в который требуется выгрузить данные.
// 	СтандартнаяОбработка - Булево - Признак выполнения стандартной (системной) обработки события.
// 	Отбор - Массив - фильтр отбора по метаданным.
//
Процедура ОбработкаРегистрацииНачальнойВыгрузкиДанных(Знач Получатель, СтандартнаяОбработка, Отбор) Экспорт
	
	Если Получатель.Метаданные().Имя = "ОбменЗГУБГУ2" Тогда
		РегистрацияИзмененияДляНачальнойВыгрузки(Получатель, СтандартнаяОбработка, Отбор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НастройкиОбмена()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИспользованиеОбмена = Новый Структура;
	ИспользованиеОбмена.Вставить("ИспользуетсяОбменПоВсемОрганизациям", Ложь);
	ИспользованиеОбмена.Вставить("ИспользуетсяОбменПоОрганизациям", Ложь);
	ИспользованиеОбмена.Вставить("ИспользованиеОбменаПоОрганизациям", Новый Соответствие);
	
	ИспользованиеОбмена.ИспользуетсяОбменПоВсемОрганизациям = Константы.ИспользоватьОбменЗГУБГУ2ПоВсемОрганизациям.Получить();
	
	ИспользованиеОбменаПоОрганизациям = Новый Соответствие;
	ИспользованиеОбменаПоОрганизациям.Вставить(Справочники.Организации.ПустаяСсылка(), Ложь);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ИспользованиеОбмена.Используется) КАК ОбменИспользуется
	|ИЗ
	|	РегистрСведений.ИспользованиеОбменаЗГУБГУ2ПоОрганизациям КАК ИспользованиеОбмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Организации.Ссылка КАК Организация,
	|	ЕСТЬNULL(ИспользованиеОбмена.Используется, ЛОЖЬ) КАК ОбменИспользуется
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИспользованиеОбменаЗГУБГУ2ПоОрганизациям КАК ИспользованиеОбмена
	|		ПО Организации.Ссылка = ИспользованиеОбмена.Организация";
	
	Результат = Запрос.Выполнить(); 
	Если Не Результат.Пустой() Тогда
		
		ИспользуетсяОбменПоОрганизациям = Результат.Выгрузить().ВыгрузитьКолонку("ОбменИспользуется").Найти(Истина) <> Неопределено;
		ИспользованиеОбмена.ИспользуетсяОбменПоОрганизациям = ИспользуетсяОбменПоОрганизациям;
		
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ИспользованиеОбменаПоОрганизациям.Вставить(Выборка.Организация, Выборка.ОбменИспользуется);
		КонецЦикла;
		
	КонецЕсли;
	
	ИспользованиеОбмена.ИспользованиеОбменаПоОрганизациям = ИспользованиеОбменаПоОрганизациям;
	
	Возврат ИспользованиеОбмена;
	
КонецФункции

Процедура РегистрацияИзмененияДляНачальнойВыгрузки(Получатель, СтандартнаяОбработка, Данные)
	
	РеквизитыУзла = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Получатель, "ИспользоватьОтборПоОрганизациям, Организации");
	
	Если Не РеквизитыУзла.ИспользоватьОтборПоОрганизациям Тогда 
		Возврат
	КонецЕсли;	
	
	СтандартнаяОбработка = Ложь;
	
	Организации = РеквизитыУзла.Организации.Выгрузить().ВыгрузитьКолонку("Организация");
	
	МетаданныеПланаОбмена = Получатель.Метаданные();
	ИмяПланаОбмена    = МетаданныеПланаОбмена.Имя;
	СоставПланаОбмена = МетаданныеПланаОбмена.Состав;

	ИспользоватьФильтрПоМетаданным = (ТипЗнч(Данные) = Тип("Массив"));
	
	Для Каждого ЭлементСоставаПланаОбмена Из СоставПланаОбмена Цикл
		
		Если ИспользоватьФильтрПоМетаданным И Данные.Найти(ЭлементСоставаПланаОбмена.Метаданные) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПолноеИмяОбъекта = ЭлементСоставаПланаОбмена.Метаданные.ПолноеИмя();
		
		Если ЭлементСоставаПланаОбмена.АвтоРегистрация = АвтоРегистрацияИзменений.Запретить
			И ОбменДаннымиПовтИсп.ПравилаРегистрацииОбъектаСуществуют(ИмяПланаОбмена, ПолноеИмяОбъекта) Тогда
			
			Если ОбщегоНазначения.ЭтоСправочник(ЭлементСоставаПланаОбмена.Метаданные) Тогда
				
				Если ЭлементСоставаПланаОбмена.Метаданные = Метаданные.Справочники.Организации Тогда
					
					Запрос = Новый Запрос;
					Запрос.УстановитьПараметр("Организации", Организации);
					Запрос.Текст = 
					"ВЫБРАТЬ
					|	Организации.Ссылка
					|ИЗ
					|	Справочник.Организации КАК Организации
					|ГДЕ
					|	Организации.Ссылка В(&Организации)";
					
					Выборка = Запрос.Выполнить().Выбрать();
					
					Пока Выборка.Следующий() Цикл
						
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
						
					КонецЦикла;
					
					Продолжить;	
					
				КонецЕсли;
				
				МетаданныеВладельцы = ЭлементСоставаПланаОбмена.Метаданные.Владельцы;
				
				Если МетаданныеВладельцы.Содержит(Метаданные.Справочники.Организации) Тогда
					
					Выборка = ВыборкаСправочниковПоВладельцуОрганизации(ПолноеИмяОбъекта, Организации);
					
					Пока Выборка.Следующий() Цикл
						
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
						
					КонецЦикла;
					
					Продолжить;
					
				КонецЕсли;
				
			ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ЭлементСоставаПланаОбмена.Метаданные) Тогда // Документы
				
				Если ЭлементСоставаПланаОбмена.Метаданные.Реквизиты.Найти("Организация") <> Неопределено Тогда
					
					Выборка = ВыборкаДокументовПоОрганизациям(ПолноеИмяОбъекта, Организации);
					
					Пока Выборка.Следующий() Цикл
						
						ПланыОбмена.ЗарегистрироватьИзменения(Получатель, Выборка.Ссылка);
						
					КонецЦикла;
					
					Продолжить;
					
				КонецЕсли;
				
			ИначеЕсли ОбщегоНазначения.ЭтоРегистр(ЭлементСоставаПланаОбмена.Метаданные) Тогда // Регистры
				
				// Регистры сведений (независимые)
				Если ОбщегоНазначения.ЭтоРегистрСведений(ЭлементСоставаПланаОбмена.Метаданные)
					И ЭлементСоставаПланаОбмена.Метаданные.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
					
					ОсновнойОтбор = ОсновнойОтборРегистраСведений(ЭлементСоставаПланаОбмена.Метаданные);
					
					ОтборПоОрганизации = (ОсновнойОтбор.Найти("Организация") <> Неопределено);
					
					Если ОтборПоОрганизации Тогда // Регистрация по организациям
						
						Выборка = ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, Организации);
						
					Иначе
						
						Выборка = Неопределено;
						
					КонецЕсли;
					
					Если Выборка <> Неопределено Тогда
						
						НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьНаборЗаписей();
						
						Пока Выборка.Следующий() Цикл
							
							Для Каждого ИмяИзмерения Из ОсновнойОтбор Цикл
								
								НаборЗаписей.Отбор[ИмяИзмерения].Значение = Выборка[ИмяИзмерения];
								НаборЗаписей.Отбор[ИмяИзмерения].Использование = Истина;
								
							КонецЦикла;
							
							ПланыОбмена.ЗарегистрироватьИзменения(Получатель, НаборЗаписей);
							
						КонецЦикла;
						
						Продолжить;
						
					КонецЕсли;
					
				Иначе // Регистры (прочие)
					
					Если ЭлементСоставаПланаОбмена.Метаданные.Измерения.Найти("Организация") <> Неопределено Тогда 
						
						Выборка = ВыборкаРегистраторовНаборовЗаписейПоОрганизациям(ПолноеИмяОбъекта, Организации);
						
						НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяОбъекта).СоздатьНаборЗаписей();
						
						Пока Выборка.Следующий() Цикл
							
							НаборЗаписей.Отбор.Регистратор.Значение = Выборка.Регистратор;
							НаборЗаписей.Отбор.Регистратор.Использование = Истина;
							
							ПланыОбмена.ЗарегистрироватьИзменения(Получатель, НаборЗаписей);
							
						КонецЦикла;
						
						Продолжить;
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		ПланыОбмена.ЗарегистрироватьИзменения(Получатель, ЭлементСоставаПланаОбмена.Метаданные);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВыборкаСправочниковПоВладельцуОрганизации(ПолноеИмяОбъекта, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК Таблица
	|ГДЕ
	|	Таблица.Владелец В(&Организации)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ВыборкаДокументовПоОрганизациям(ПолноеИмяОбъекта, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК Таблица
	|ГДЕ
	|	Таблица.Организация В(&Организации)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ВыборкаЗначенийОсновногоОтбораРегистраСведенийПоОрганизациям(ОсновнойОтбор, ПолноеИмяОбъекта, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	[Измерения]
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Организация В(&Организации)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[Измерения]", СтрСоединить(ОсновнойОтбор, ", "));
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ВыборкаРегистраторовНаборовЗаписейПоОрганизациям(ПолноеИмяОбъекта, Организации)
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаРегистра.Регистратор КАК Регистратор
	|ИЗ
	|	[ПолноеИмяОбъекта] КАК ТаблицаРегистра
	|ГДЕ
	|	ТаблицаРегистра.Организация В(&Организации)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "[ПолноеИмяОбъекта]", ПолноеИмяОбъекта);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Организации", Организации);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

Функция ОсновнойОтборРегистраСведений(ОбъектМетаданных)
	
	Результат = Новый Массив;
	
	Если ОбъектМетаданных.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический
		И ОбъектМетаданных.ОсновнойОтборПоПериоду Тогда
		
		Результат.Добавить("Период");
		
	КонецЕсли;
	
	Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
		
		Если Измерение.ОсновнойОтбор Тогда
			
			Результат.Добавить(Измерение.Имя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

