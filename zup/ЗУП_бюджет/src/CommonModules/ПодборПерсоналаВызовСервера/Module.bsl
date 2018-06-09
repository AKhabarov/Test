#Область СлужебныеПроцедурыИФункции

#Область ОтправкаСообщений

Функция ФорматШаблонаПисьмаHTML(Шаблон)
	
	ТипТекстаПисьма = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Шаблон, "ТипТекстаПисьма");
	Возврат ТипТекстаПисьма = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML;
	
КонецФункции

Функция ФорматТекстаПисьмаHTML()
	
	Если Взаимодействия.ИспользуетсяПочтовыйКлиент() Тогда
		ФорматСообщения = Взаимодействия.ФорматСообщенияПоУмолчанию(Пользователи.ТекущийПользователь());
		ВФорматеHTML = (ФорматСообщения = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML);
	Иначе
		ВФорматеHTML = Истина;
	КонецЕсли;
	
	Возврат ВФорматеHTML;
	
КонецФункции

Функция КонструкторСообщения(Параметры)
	
	Сообщение = Новый Структура;
	Сообщение.Вставить("Тема", "");
	Сообщение.Вставить("Текст", "");
	Сообщение.Вставить("Получатель", Новый СписокЗначений);
	Сообщение.Вставить("Вложения", Новый СписокЗначений);
	Сообщение.Вставить("ДополнительныеПараметры", Параметры);
	
	Предмет = Параметры.Предметы[0];
	ВФорматеHTML = ФорматТекстаПисьмаHTML();
	
	// В текущей версии форма "Отправка сообщения" работает только со строковым типом значения свойства Текст.
	Если Взаимодействия.ИспользуетсяПочтовыйКлиент() И ВФорматеHTML Тогда
		Сообщение.Текст = Новый Структура("ТекстHTML, СтруктураВложений", "", Новый Структура);
	КонецЕсли;
	
	Если Параметры.Свойство("ВывестиСписокСсылок") 
		Или Параметры.Свойство("ВывестиСписокПредметов") Тогда
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Предмет);
		ПередаваемыеПараметры = Новый Структура("ИдентификаторПечатнойФормы, ВФорматеHTML", Параметры.ИдентификаторПечатнойФормы, ВФорматеHTML);
		
		ТекстПисьма = "ТекстДляЗамены";
		Если Параметры.Свойство("ВывестиСписокСсылок") Тогда
			ПодстрокаЗамены = МенеджерОбъекта.СписокСсылокНаПредметы(Параметры.Предметы, ПередаваемыеПараметры);
		Иначе
			ПодстрокаЗамены = МенеджерОбъекта.ПредставлениеСпискаПредметов(Параметры.Предметы, ПередаваемыеПараметры);
		КонецЕсли;
		
		Если ВФорматеHTML Тогда
			ТекстПисьма = ПодборПерсонала.ТекстВHTML(ТекстПисьма);
		КонецЕсли;
		
		// Подстрока замены может содержать тэги, которые при преобразовании в HTML будут считаться простым текстом.
		// Поэтому просто заменяем ее.
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "ТекстДляЗамены", ПодстрокаЗамены);
		
		Если Взаимодействия.ИспользуетсяПочтовыйКлиент() И ВФорматеHTML Тогда
			Сообщение.Текст = Новый Структура("ТекстHTML, СтруктураВложений", ТекстПисьма, Новый Структура);
		Иначе
			Сообщение.Текст = ТекстПисьма;
		КонецЕсли;
		
	КонецЕсли;
	
	УточнитьСоставВложенийСообщенияБезШаблона(Сообщение, Параметры);
	ПодборПерсонала.УточнитьПочтуПолучателейСообщения(Сообщение.Получатель, Параметры);
	
	Возврат Сообщение;
	
КонецФункции

Процедура УточнитьСоставВложенийСообщенияБезШаблона(Сообщение, Параметры)
	
	Вложения = Сообщение.Вложения;
	
	ПараметрыВложений = Новый Структура;
	ПараметрыВложений.Вставить("УпаковатьВАрхив", Ложь);
	ПараметрыВложений.Вставить("ТранслитерироватьИменаФайлов", Ложь);
	ПараметрыВложений.Вставить("ФорматыВложений", ПодборПерсонала.ФорматыВложенийПоУмолчанию());
	
	ДополнительныеВложения = ДополнительныеВложенияДляСообщения(Сообщение.ДополнительныеПараметры, ПараметрыВложений);
	
	Для Каждого ФайлДанных Из ДополнительныеВложения Цикл
		Вложения.Добавить(ФайлДанных.АдресВоВременномХранилище, ФайлДанных.ИмяФайла);
	КонецЦикла;
	
	ПодборПерсонала.ДобавитьПрисоединенныеФайлыВоВложения(Сообщение);
	
КонецПроцедуры

Функция ПодготовитьСообщениеНаСервере(Шаблон, ДополнительныеПараметры) Экспорт
	
	УникальныйИдентификатор = ДополнительныеПараметры.УникальныйИдентификатор;
	Предметы = ДополнительныеПараметры.Предметы;
	
	ПараметрыСообщения = СформироватьПараметрыСообщения(Шаблон, ДополнительныеПараметры);
	Сообщение = ШаблоныСообщений.СформироватьСообщение(Шаблон, Предметы[0], УникальныйИдентификатор, ПараметрыСообщения);
	
	Сообщение = ПреобразоватьПараметрыПисьма(Сообщение);
	
	ПредметВзаимодействия = Неопределено;
	Если ДополнительныеПараметры.Свойство("ПредметВзаимодействия", ПредметВзаимодействия) Тогда
		Сообщение.Вставить("Основание", ПредметВзаимодействия);
	КонецЕсли;
	
	Возврат Сообщение;
	
КонецФункции

Функция ПодготовитьСообщениеБезШаблонаНаСервере(ДополнительныеПараметры) Экспорт
	
	Возврат КонструкторСообщения(ДополнительныеПараметры);
	
КонецФункции

Функция ПодготовитьСообщениеЗаявителюНаСервере(Шаблон, ДополнительныеПараметры) Экспорт
	
	Предметы = ДополнительныеПараметры.Предметы;
	Получатель = ЗаявительКандидата(Предметы[0]);
	ДополнительныеПараметры.Вставить("Получатель", Получатель);

	Если Предметы.Количество() = 1 Тогда
		ДополнительныеПараметры.Вставить("ПредметВзаимодействия", Предметы[0]);
	КонецЕсли;
	
	Возврат ПодготовитьСообщениеНаСервере(Шаблон, ДополнительныеПараметры);
	
КонецФункции

Функция ПодготовитьСообщениеЗаявителюБезШаблонаНаСервере(ДополнительныеПараметры) Экспорт
	
	Получатель = ЗаявительКандидата(ДополнительныеПараметры.Предметы[0]);
	
	ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	ДополнительныеПараметры.ПроизвольныеПараметры.Вставить("Получатель", Получатель);
	
	Возврат КонструкторСообщения(ДополнительныеПараметры);
	
КонецФункции

Функция ЗаявительКандидата(Кандидат)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Кандидат", Кандидат);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	Кандидаты.Вакансия.Заявитель КАК Получатель
	|ИЗ
	|	Справочник.Кандидаты КАК Кандидаты
	|ГДЕ
	|	Кандидаты.Ссылка = &Кандидат";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Получатель;
	
КонецФункции

Функция ОтправитьСообщенияКандидатам(Шаблон, ДополнительныеПараметры) Экспорт
	
	Результат = Новый Структура("КоличествоУспешных, КоличествоНеУспешных", 0, 0);
	
	КоличествоУспешных = 0;
	КоличествоНеУспешных = 0;
	
	ДатаВремяОтправки = ТекущаяДатаСеанса();
	
	Кандидаты = ДополнительныеПараметры.Кандидаты;
	УникальныйИдентификатор = ДополнительныеПараметры.УникальныйИдентификатор;
	
	ДозаполнитьДополнительныеПараметры(Шаблон, ДополнительныеПараметры);
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Кандидаты", Кандидаты);
	
	Запрос.Текст = "ВЫБРАТЬ
	|	ЕСТЬNULL(ПротоколыОтправкиСообщенийКандидатам.ДатаОтправки, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаОтправки,
	|	Кандидаты.Ссылка КАК Кандидат,
	|	Кандидаты.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Кандидаты.Подразделение КАК Подразделение
	|ИЗ
	|	Справочник.Кандидаты КАК Кандидаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПротоколыОтправкиСообщенийКандидатам КАК ПротоколыОтправкиСообщенийКандидатам
	|		ПО Кандидаты.Ссылка = ПротоколыОтправкиСообщенийКандидатам.Кандидат
	|ГДЕ
	|	Кандидаты.Ссылка В(&Кандидаты)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если ЗначениеЗаполнено(Выборка.ДатаОтправки) Тогда
			
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Кандидат %1 уже был оповещен о вакансии.'"), Выборка.Кандидат);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, Выборка.Кандидат);
			Продолжить;
			
		КонецЕсли;
		
		Попытка
			
			ПараметрыСообщения = ПараметрыСообщения(Шаблон, Выборка.ФизическоеЛицо, ДополнительныеПараметры);
			РезультатОтправки = ШаблоныСообщений.СформироватьСообщениеИОтправить(Шаблон, ДополнительныеПараметры.Предметы[0], ДополнительныеПараметры.УникальныйИдентификатор, ПараметрыСообщения);
			
			Если РезультатОтправки.Отправлено Тогда
				
				УстановитьПривилегированныйРежим(Истина);
				
				МенеджерЗаписи = РегистрыСведений.ПротоколыОтправкиСообщенийКандидатам.СоздатьМенеджерЗаписи();
				МенеджерЗаписи.Кандидат = Выборка.Кандидат;
				МенеджерЗаписи.Подразделение = Выборка.Подразделение;
				МенеджерЗаписи.ДатаОтправки = ДатаВремяОтправки;
				МенеджерЗаписи.Записать();
				
				КоличествоУспешных = КоличествоУспешных + 1;
				
				УстановитьПривилегированныйРежим(Ложь);
				
			Иначе
				
				ТекстОшибки = СтрШаблон(НСтр("ru = 'Ошибка отправки сообщения: 
					|%1'"), РезультатОтправки.ОписаниеОшибки);
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Кандидат);
				
				КоличествоНеУспешных = КоличествоНеУспешных + 1;
				
			КонецЕсли;
			
		Исключение
			
			ТекстОшибки = СтрШаблон(НСтр("ru = 'Во время подготовки к отправке письма произошла ошибка: 
				|%1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, Выборка.Кандидат);
			
			КоличествоНеУспешных = КоличествоНеУспешных + 1;
			
		КонецПопытки
		
	КонецЦикла;
	
	Результат.КоличествоУспешных = КоличествоУспешных;
	Результат.КоличествоНеУспешных = КоличествоНеУспешных;
	
	Возврат Результат;
	
КонецФункции

Процедура ДозаполнитьДополнительныеПараметры(Шаблон, ДополнительныеПараметры)
	
	ДополнительныеПараметры.Вставить("ПисьмоВФорматеHTML", ФорматШаблонаПисьмаHTML(Шаблон) И ФорматТекстаПисьмаHTML());
	
КонецПроцедуры

Функция СформироватьПараметрыСообщения(Шаблон, ДополнительныеПараметры)
	
	ДозаполнитьДополнительныеПараметры(Шаблон, ДополнительныеПараметры);
	
	Возврат ПараметрыСообщения(Шаблон, , ДополнительныеПараметры);
	
КонецФункции

Функция ПараметрыСообщения(Шаблон, Получатель = Неопределено, ДополнительныеПараметры = Неопределено)
	
	Параметры = Новый Структура("ПроизвольныеПараметры, ПреобразовыватьHTMLДляФорматированногоДокумента", Новый Соответствие, Истина);
	
	Если Не ЗначениеЗаполнено(Получатель) Тогда
		ДополнительныеПараметры.Свойство("Получатель", Получатель);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Получатель) Тогда
		
		ФИОПолучателя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Получатель, ?(ТипЗнч(Получатель) = Тип("СправочникСсылка.ФизическиеЛица"), "ФИО", "Наименование"));
		
		Параметры.ПроизвольныеПараметры.Вставить("Получатель", Получатель);
		Параметры.ПроизвольныеПараметры.Вставить("ФИОПолучателя", ФИОПолучателя);
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополнительныеПараметры) Тогда
		
		Предметы = ДополнительныеПараметры.Предметы;
		
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Предметы[0]);
		ПередаваемыеПараметры = Новый Структура("ИдентификаторПечатнойФормы, ВФорматеHTML", ДополнительныеПараметры.ИдентификаторПечатнойФормы, ДополнительныеПараметры.ПисьмоВФорматеHTML);
		
		Параметры.ПроизвольныеПараметры.Вставить("ПредставлениеСпискаПредметов", МенеджерОбъекта.ПредставлениеСпискаПредметов(Предметы, ПередаваемыеПараметры));
		Параметры.ПроизвольныеПараметры.Вставить("СписокСсылокНаПредметы", МенеджерОбъекта.СписокСсылокНаПредметы(Предметы, ПередаваемыеПараметры));
		
		Если Не ЗначениеЗаполнено(Шаблон.ВладелецШаблона) Тогда
			
			ПараметрыШаблона = ШаблоныСообщений.ПараметрыШаблона(Шаблон);
			Если ПараметрыШаблона.ФорматыВложений = Неопределено Тогда
				ПараметрыШаблона.ФорматыВложений = ПодборПерсонала.ФорматыВложенийПоУмолчанию();
			КонецЕсли;
			
			Параметры.Вставить("ДополнительныеВложения", ДополнительныеВложенияДляСообщения(ДополнительныеПараметры, ПараметрыШаблона));
			
		КонецЕсли;
		
		// Эти параметры понадобятся для переноса присоединенных файлов.
		Параметры.Вставить("Предметы", ДополнительныеПараметры.Предметы);
		Параметры.Вставить("УникальныйИдентификатор", ДополнительныеПараметры.УникальныйИдентификатор);
		Параметры.Вставить("ИдентификаторОписания", ДополнительныеПараметры.ИдентификаторПечатнойФормы);
		
	КонецЕсли;
	
	Возврат Параметры;
	
КонецФункции

Функция ПреобразоватьПараметрыПисьма(Сообщение)
	
	ПараметрыПисьма = Новый Структура();
	ПараметрыПисьма.Вставить("Отправитель");
	ПараметрыПисьма.Вставить("Тема", Сообщение.Тема);
	ПараметрыПисьма.Вставить("Текст", Сообщение.Текст);
	ПараметрыПисьма.Вставить("СообщенияПользователю", Сообщение.СообщенияПользователю);
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", Ложь);
	
	Если Сообщение.Получатель = Неопределено ИЛИ Сообщение.Получатель.Количество() = 0 Тогда
		ПараметрыПисьма.Вставить("Получатель", "");
	Иначе
		ПараметрыПисьма.Вставить("Получатель", Сообщение.Получатель);
	КонецЕсли;
	
	МассивВложений = Новый Массив;
	Для Каждого ОписаниеВложения Из Сообщение.Вложения Цикл
		ИнформацияОВложении = Новый Структура("Представление, АдресВоВременномХранилище, Кодировка, Идентификатор");
		ЗаполнитьЗначенияСвойств(ИнформацияОВложении, ОписаниеВложения);
		МассивВложений.Добавить(ИнформацияОВложении);
	КонецЦикла;
	ПараметрыПисьма.Вставить("Вложения", МассивВложений);
	
	Возврат ПараметрыПисьма;
	
КонецФункции

Функция ДополнительныеВложенияДляСообщения(ДополнительныеПараметры, ПараметрыВложений)
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("АдресВоВременномХранилище");
	Результат.Колонки.Добавить("ИмяФайла");
	Результат.Колонки.Добавить("Размер");
	
	ИдентификаторПечатнойФормы = "";
	ДополнительныеПараметры.Свойство("ИдентификаторПечатнойФормы", ИдентификаторПечатнойФормы);
	
	Если Не ЗначениеЗаполнено(ИдентификаторПечатнойФормы) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Предметы = ДополнительныеПараметры.Предметы;
	УникальныйИдентификатор = ДополнительныеПараметры.УникальныйИдентификатор;
	ИмяМенеджераПечати = ОбщегоНазначения.ИмяТаблицыПоСсылке(Предметы[0]);
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьПечатныеФормы(ИмяМенеджераПечати, ИдентификаторПечатнойФормы, Предметы, Новый Структура);
	
	Для Каждого ПечатнаяФорма Из КоллекцияПечатныхФорм.КоллекцияПечатныхФорм Цикл
		
		Если ПечатнаяФорма = Неопределено 
			Или ПечатнаяФорма.ТабличныйДокумент.ВысотаТаблицы = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		ФайлыВХранилище = ПодборПерсонала.ПоместитьТабличныйДокументВоВременноеХранилище(ПечатнаяФорма, ПараметрыВложений, УникальныйИдентификатор);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ФайлыВХранилище, Результат);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти