#Область СлужебныеПроцедурыИФункции

#Область Общее

// Позволяет определить, есть ли в коллекции значений одинаковые элементы.
//
Функция ЕстьСовпаденияВКоллекцииЗначений(Знач Таблица, Знач ПроверяемоеПоле, УчитыватьПустыеПоля = Истина) Экспорт
	
	Для Каждого Строка Из Таблица Цикл
		
		Значение = Строка[ПроверяемоеПоле];
		
		Если НЕ УчитыватьПустыеПоля И НЕ ЗначениеЗаполнено(Значение) Тогда
			Продолжить; // Не учитываем пустые поля
		КонецЕсли;
		
		КолВхождений = 0;
		
		Для Каждого Строка2 Из Таблица Цикл
			Если Значение = Строка2[ПроверяемоеПоле] Тогда
				КолВхождений = КолВхождений + 1;
			КонецЕсли;	
		КонецЦикла;
		
		Если КолВхождений > 1 Тогда
			Возврат Истина;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Для внутреннего использования
// 
Функция СобытиеЖурналаРегистрацииЭлектронныхКурсов() Экспорт
	
	Возврат НСтр("ru = 'Электронное обучение'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
	
КонецФункции

Процедура ДобавитьВМассивУникальноеЗначение(МассивЗначений, Знач НовоеЗначение, Знач ПроверятьНаЗаполненность = Истина) Экспорт
	
	Если НЕ ЗначениеЗаполнено(НовоеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивЗначений.Найти(НовоеЗначение) <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	МассивЗначений.Добавить(НовоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ТипыДанных

// Разделяет строку на части по разделителю и заменяет служебные символы.
//
Функция СтрокаВебРазделить(Знач ВходСтрока, Знач Разделитель) Экспорт
	
	КоличествоСтрокВоВходнойСтроке = СтрЧислоСтрок(ВходСтрока);
	
	Если КоличествоСтрокВоВходнойСтроке > 1 Тогда
		ВременнаяСтрока = СтрЗаменить(ВходСтрока, Символы.ПС, "#x0A");
		ВременнаяСтрока = СтрЗаменить(ВременнаяСтрока, Символы.ВК, "#x0D");
	Иначе
		ВременнаяСтрока = ВходСтрока;
	КонецЕсли;
		
	РезультирующийМассив = Новый Массив;
	
    ВременнаяСтрока = СтрЗаменить(ВременнаяСтрока, Разделитель, Символы.ПС);
	ЧислоСтрокВременнойСтроки = СтрЧислоСтрок(ВременнаяСтрока);
	Для Индекс = 1 По ЧислоСтрокВременнойСтроки Цикл
		РазделеннаяСтрока = СтрПолучитьСтроку(ВременнаяСтрока, Индекс);
		Если КоличествоСтрокВоВходнойСтроке > 1 Тогда
			РазделеннаяСтрока = СтрЗаменить(РазделеннаяСтрока, "#x0A", Символы.ПС);
			РазделеннаяСтрока = СтрЗаменить(РазделеннаяСтрока, "#x0D", Символы.ВК);
		КонецЕсли;
		РезультирующийМассив.Добавить(РазделеннаяСтрока);
	КонецЦикла;
	
	Возврат РезультирующийМассив;
	
КонецФункции

Функция ЭтоЧисло(ВходСтрока) Экспорт
	
	Если ТипЗнч(ВходСтрока) = Тип("Число") Тогда
		Возврат Истина;
	КонецЕсли;	
	
	Если ТипЗнч(ВходСтрока) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(ВходСтрока) = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ВходСтрока);	
	
КонецФункции

#КонецОбласти

#Область Формы

// Устанавливает отбор в динамическом списке
//
Процедура УстановитьОтборЭлементовДинамическогоСписка(ДинамическийСписок, ПравоеЗначение, ИмяОтбора = "Владелец", ВидСравнения = Неопределено) Экспорт
	
	Отбор = Неопределено;
	Для каждого ЭлементОтбора Из ДинамическийСписок.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.Представление = ИмяОтбора Тогда
			Отбор = ЭлементОтбора;
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	Если Отбор = Неопределено Тогда
		Отбор = ДинамическийСписок.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		Отбор.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных(ИмяОтбора);
		Отбор.ВидСравнения     = ВидСравнения;
		Отбор.Использование    = Истина;
		Отбор.Представление    = ИмяОтбора;
		Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		Отбор.ПравоеЗначение   = ПравоеЗначение;
	КонецЕсли;
	
	Если Отбор <> Неопределено
		И Отбор.ПравоеЗначение <> ПравоеЗначение Тогда
		
		Отбор.ПравоеЗначение = ПравоеЗначение;
		
	КонецЕсли;
	
	Если Отбор <> Неопределено
		И Отбор.ВидСравнения <> ВидСравнения Тогда
		
		Отбор.ВидСравнения = ВидСравнения;
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ИзменитьИспользованиеГруппировкиДинамическогоСписка(ДинамическийСписок, ИмяГруппировки, Использование) Экспорт
	
	Если ЗначениеЗаполнено(ИмяГруппировки) Тогда
		
		ПолеКомпоновкиДанных = Новый ПолеКомпоновкиДанных(ИмяГруппировки);
		
		Для каждого ЭлементГруппировки Из ДинамическийСписок.Группировка.Элементы Цикл
		
			Если ЭлементГруппировки.Поле = ПолеКомпоновкиДанных Тогда
				ЭлементГруппировки.Использование = Использование;
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	Иначе
		
		Для каждого ЭлементГруппировки Из ДинамическийСписок.Группировка.Элементы Цикл
			ЭлементГруппировки.Использование = Использование;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВидимостьЭлементаФормыБезопасно(Форма, ИмяЭлемента, Видимость) Экспорт
	
	Если Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
		Форма.Элементы[ИмяЭлемента].Видимость = Видимость;
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьЗаголовокЭлементаФормыБезопасно(Форма, ИмяЭлемента, Заголовок) Экспорт
	
	Если Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
		Форма.Элементы[ИмяЭлемента].Заголовок = Заголовок;
	КонецЕсли;	
	
КонецПроцедуры

Процедура УстановитьПодсказкуЭлементаФормыБезопасно(Форма, ИмяЭлемента, Подсказка) Экспорт
	
	Если Форма.Элементы.Найти(ИмяЭлемента) <> Неопределено Тогда
		Форма.Элементы[ИмяЭлемента].Подсказка = Подсказка;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ФорматДанных

// Число

// Конвертирует целое число в строку без учета
// региональных настроек отображения чисел.
//
Функция ЧислоВСтроку(Знач Число) Экспорт
	
	Если ТипЗнч(Число) = Тип("Строка") Тогда
		Возврат Число;
	КонецЕсли;
	
	Если ТипЗнч(Число) = Тип("Число") Тогда
		Возврат Формат(Число, "ЧРД=.; ЧН=0; ЧГ=");
	КонецЕсли;
	
	Возврат Строка(Число);
	
КонецФункции

Функция ЧислоВДату(Число) Экспорт
	
	Если ЗначениеЗаполнено(Число) Тогда
		Возврат Дата("19700101") + (Число(Число) / 1000) + ЭлектронноеОбучениеСлужебныйВызовСервера.СмещениеСтандартногоВремениБазы();
	Иначе
		Возврат Дата("00010101");	
	КонецЕсли;
	
КонецФункции

// Булево

Функция БулевоВСтроку(Знач Булево) Экспорт
	
	Если ТипЗнч(Булево) = Тип("Булево") Тогда
		
		Возврат ?(Булево, НСтр("ru = 'Да'"), НСтр("ru = 'Нет'"));
		
	Иначе
		
		Возврат Булево;
		
	КонецЕсли;
	
КонецФункции

Функция БулевоВJSСтроку(Булево) Экспорт
	
	Если ТипЗнч(Булево) = Тип("Булево") Тогда
		
		Возврат ?(Булево, "true", "false");
		
	Иначе
		
		Возврат "";
		
	КонецЕсли;	

КонецФункции

Функция БулевоВЧисло(Булево) Экспорт
	
	Если ТипЗнч(Булево) = Тип("Булево") Тогда
		
		Возврат ?(Булево, 1, 0);
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;		
	
КонецФункции

// Строка

Функция СтрокаВБулево(Знач Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Булево") Тогда
		Возврат Значение;
	КонецЕсли;
	
	Если Значение = "1"
		ИЛИ НРег(Значение) = "да"
		ИЛИ НРег(Значение) = "истина"
		ИЛИ НРег(Значение) = "true" Тогда
		
		Возврат Истина;
		
	КонецЕсли;	
	
	Если Значение = "0"
		ИЛИ НРег(Значение) = "нет"
		ИЛИ НРег(Значение) = "ложь"
		ИЛИ НРег(Значение) = "false" Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Возврат ЗначениеЗаполнено(Значение);
	
КонецФункции

// Получает строку, пригодную для использования в JavaScript
//
Функция JSСтрока(Знач Строка, ЭкранироватьОдинарныеКавычки = Истина, УдалитьСлужебныеСимволы = Ложь) Экспорт
	
	Если УдалитьСлужебныеСимволы Тогда	
	
		Строка = СтрЗаменить(Строка, "\", "");
		
		Если ЭкранироватьОдинарныеКавычки Тогда
			Строка = СтрЗаменить(Строка, "'", "");
		КонецЕсли;
		
		Строка = СтрЗаменить(Строка, """", "");
		Строка = СтрЗаменить(Строка, Символы.ПС, " ");
		Строка = СтрЗаменить(Строка, Символы.ВК, " ");
		Строка = СтрЗаменить(Строка, Символы.Таб, " ");
		Строка = СтрЗаменить(Строка, Символы.ВТаб, " ");
		Строка = СтрЗаменить(Строка, Символы.НПП, " ");
		Строка = СтрЗаменить(Строка, Символы.ПФ, " ");
		
	Иначе
		
		Строка = СтрЗаменить(Строка, "\", "\\");
		
		Если ЭкранироватьОдинарныеКавычки Тогда
			Строка = СтрЗаменить(Строка, "'", "\'");
		КонецЕсли;
		
		Строка = СтрЗаменить(Строка, """", "\""");
		Строка = СтрЗаменить(Строка, Символы.ПС, "\n");
		Строка = СтрЗаменить(Строка, Символы.ВК, "\r");
		Строка = СтрЗаменить(Строка, Символы.Таб, "\t");
		Строка = СтрЗаменить(Строка, Символы.ВТаб, "\t");
		Строка = СтрЗаменить(Строка, Символы.НПП, " ");
		Строка = СтрЗаменить(Строка, Символы.ПФ, " ");		
		
	КонецЕсли;
	
		
	Возврат Строка;
	
КонецФункции

Функция СтрокаИзJSСтроки(Знач Строка) Экспорт
	
	Строка = СтрЗаменить(Строка, "\\", "\");
	
	Строка = СтрЗаменить(Строка, "\'", "'");
	Строка = СтрЗаменить(Строка, "\""", """");
	Строка = СтрЗаменить(Строка, "\n", Символы.ПС);
	Строка = СтрЗаменить(Строка, "\r", Символы.ВК);
	Строка = СтрЗаменить(Строка, "\t", Символы.Таб);
	
	Возврат Строка;
	
КонецФункции

// Получает строку, пригодную для размещения в HTML файле
//
Функция HTMLСтрока(Знач Строка) Экспорт
	
	Строка = СтрЗаменить(Строка, "&", "&amp;");
	
	Строка = СтрЗаменить(Строка, """", "&quot;");
	Строка = СтрЗаменить(Строка, "<", "&lt;");
	Строка = СтрЗаменить(Строка, ">", "&gt;");
	Строка = СтрЗаменить(Строка, Символы.ПС, "");
	
	Возврат Строка;
	
КонецФункции

Функция ТипПлатформыВСтроку(Тип) Экспорт	
	
	Если Тип = ТипПлатформы.Linux_x86 Тогда
		Возврат "Linux_x86";
		
	ИначеЕсли Тип = ТипПлатформы.Linux_x86_64 Тогда
		Возврат "Linux_x86_64";
		
	ИначеЕсли Тип = ТипПлатформы.Windows_x86 Тогда
		Возврат "Windows_x86";
		
	ИначеЕсли Тип = ТипПлатформы.Windows_x86_64 Тогда
		Возврат "Windows_x86_64";		
		
	ИначеЕсли Тип = ТипПлатформы.MacOS_x86 Тогда
		Возврат "MacOS_x86";
		
	ИначеЕсли Тип = ТипПлатформы.MacOS_x86_64 Тогда
		Возврат "MacOS_x86_64";
		
	ИначеЕсли Тип = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Неизвестный тип платформы ""%1""'"),
		Строка(ТипПлатформы));
	
КонецФункции

Функция СтрокаВТипПлатформы(ТипПлатформыСтрока) Экспорт
	
	Возврат ТипПлатформы[ТипПлатформыСтрока];
	
КонецФункции

// Дата

// Функция выделяет время из даты.
//
Функция ВыделитьВремя(Дата) Экспорт

	Возврат Час(Дата) * 3600 + Минута(Дата) * 60 + Секунда(Дата);

КонецФункции

Функция ДатаВЧислоJS(ЗначениеДаты) Экспорт
	
	Если ЗначениеЗаполнено(ЗначениеДаты) Тогда
	
		Возврат ((УниверсальноеВремя(ЗначениеДаты) - Дата("19700101"))*1000);
		
	Иначе
		
		Возврат 0;
		
	КонецЕсли;
		
КонецФункции

Функция СтрокаISO8601ВДату(ДатаСтрока) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДатаСтрока) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДатаМассив = СтрокаВебРазделить(ДатаСтрока, "-");
	
	Если ДатаМассив.Количество() <> 3 Тогда
		Возврат Неопределено;	
	КонецЕсли;
	
	Попытка
		Возврат Дата(ДатаМассив[0]+ДатаМассив[1]+ДатаМассив[2]);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

Функция ПериодВСтроку(Знач ДатаНачала, Знач ДатаОкончания, СкрытьВремя = Ложь) Экспорт
	
	// Получаем переменные
	
	Если ТипЗнч(ДатаНачала) = Тип("Число") Тогда
		НачалоПериода = ЧислоВДату(ДатаНачала); 
	Иначе
		НачалоПериода = ДатаНачала; 
	КонецЕсли;
	
	Если ТипЗнч(ДатаОкончания) = Тип("Число") Тогда
		КонецПериода = ЧислоВДату(ДатаОкончания); 
	Иначе
		КонецПериода = ДатаОкончания; 
	КонецЕсли;
	
	Если СкрытьВремя Тогда
		Формат = "ДЛФ=DD";
	Иначе
		Формат = "ДЛФ=DDT";
	КонецЕсли;
	
	// Делаем проверки
	
	Если НЕ ЗначениеЗаполнено(НачалоПериода) И НЕ ЗначениеЗаполнено(КонецПериода) Тогда
		Возврат "";
	КонецЕсли;
	
	Если ТипЗнч(НачалоПериода) = ТипЗнч(КонецПериода) И НачалоПериода > КонецПериода Тогда
		Возврат "";
	КонецЕсли;
	
	// Получаем представление
	
	Если ЗначениеЗаполнено(НачалоПериода) И ЗначениеЗаполнено(КонецПериода) Тогда
		
		Если КонецПериода - НачалоПериода <= 86400 Тогда
			
			Если КонецПериода - НачалоПериода >= 86399 Тогда
				Возврат Формат(НачалоПериода, "ДЛФ=DD");
			Иначе
				Если НачалоПериода = КонецПериода Тогда 
					Возврат Формат(НачалоПериода, "ДЛФ=DD") + " в " + Формат(НачалоПериода, "ДЛФ=T");
				Иначе
					Возврат Формат(НачалоПериода, "ДЛФ=DD") + " с " + Формат(НачалоПериода, "ДЛФ=T") + " до " + Формат(КонецПериода, "ДЛФ=T");
				КонецЕсли;				
			КонецЕсли;			
			
		Иначе
			
			Если СкрытьВремя И ((КонецПериода - НачалоПериода) % 86400) = 0 Тогда
				КонецПериода = КонецПериода - 1; // Убираем секунду, чтобы не вылезать в следующие сутки
			КонецЕсли;
			
			Если НачалоПериода = КонецПериода Тогда
				Возврат "в " + Формат(НачалоПериода, Формат);
			Иначе				
				Возврат "с " + Формат(НачалоПериода, Формат) + " по " + Формат(КонецПериода, Формат);
			КонецЕсли;			
			
		КонецЕсли;		
		
	Иначе
		
		Если ЗначениеЗаполнено(НачалоПериода) Тогда
			Возврат "с " + Формат(НачалоПериода, Формат); 
		КонецЕсли;
		
		Если ЗначениеЗаполнено(КонецПериода) Тогда
			Возврат "до " + Формат(КонецПериода, Формат);
		КонецЕсли;
		
	КонецЕсли;	
	
КонецФункции

Функция ДатаВСтроку(ЗначениеДаты, СкрытьВремя) Экспорт
	
	Если ТипЗнч(ЗначениеДаты) = Тип("Дата") И ЗначениеЗаполнено(ЗначениеДаты) Тогда
		Возврат ?(СкрытьВремя, Формат(ЗначениеДаты, "ДЛФ=DD"), Формат(ЗначениеДаты, "ДЛФ=DDT")); 
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

// Цвет

// Преобразует цвет в формате HEX в объект 1С
//
Функция ВебЦветВОбъект(Знач ВебЦвет) Экспорт
	
	ВебЦвет = СокрЛП(ВебЦвет);
	
	Если НЕ ЗначениеЗаполнено(ВебЦвет) Тогда
		Возврат Новый Цвет(0, 0, 0);
	КонецЕсли;
	
	МассивЦветовHEX = Новый Массив;
	МассивЦветовHEX.Добавить("0");
	МассивЦветовHEX.Добавить("0");
	МассивЦветовHEX.Добавить("0");
	
	Если СтрДлина(ВебЦвет) = 3 Тогда
		МассивЦветовHEX[0] = Сред(ВебЦвет, 1, 1);
		МассивЦветовHEX[1] = Сред(ВебЦвет, 2, 1);
		МассивЦветовHEX[2] = Сред(ВебЦвет, 3, 1);
	КонецЕсли;
	
	Если СтрДлина(ВебЦвет) = 6 Тогда
		МассивЦветовHEX[0] = Сред(ВебЦвет, 1, 2);
		МассивЦветовHEX[1] = Сред(ВебЦвет, 3, 2);
		МассивЦветовHEX[2] = Сред(ВебЦвет, 5, 2);
	КонецЕсли;
	
	МассивЦветовDEC = Новый Массив;
	
	Для каждого ЦветHEX Из МассивЦветовHEX Цикл
		
		ЦветDEC = 0;
		
		Если ЦветHEX <> "0" Тогда
		
			Длина = СтрДлина(ЦветHEX);
			
			Для НомерСимвола = 1 По Длина Цикл
				
				Битность = 1;
				
				Для Счетчик = 1 По Длина-НомерСимвола Цикл
					Битность = Битность*16
				КонецЦикла;
				
				ЦветDEC = ЦветDEC + (Найти("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",Сред(ВРег(ЦветHEX),НомерСимвола,1))-1)*Битность;
				
			КонецЦикла;
			
		КонецЕсли;
			
		МассивЦветовDEC.Добавить(Окр(ЦветDEC));	
	
	КонецЦикла;
	
	Возврат Новый Цвет(МассивЦветовDEC[0], МассивЦветовDEC[1], МассивЦветовDEC[2]);
	
КонецФункции

#КонецОбласти

#Область РаботаСФайлами

Процедура СформироватьОписаниеФайлов(Знач НайденныеФайлы, СтруктураФайлов, СписокФайлов, ВключатьСкрытые = Истина, Контекст = Неопределено) Экспорт
	
	Для каждого Файл Из НайденныеФайлы Цикл
		
		Если НЕ Файл.Существует() Тогда
			Продолжить;
		КонецЕсли;
		
		Если НЕ ВключатьСкрытые И Файл.ПолучитьНевидимость() Тогда
			Продолжить;
		КонецЕсли;
				
		СтруктураФайла = НовоеОписаниеФайла(Файл, Контекст);
			
		Если СтруктураФайла.ЭтоКаталог Тогда
			
			НайденныеПодчиненныеФайлы = НайтиФайлы(Файл.ПолноеИмя, "*", Ложь); 
			МассивПодчиненныхФайлов   = Новый Массив;
			
			СформироватьОписаниеФайлов(НайденныеПодчиненныеФайлы, МассивПодчиненныхФайлов, СписокФайлов, ВключатьСкрытые, Контекст); // Рекурсия
			
			СтруктураФайла.Вставить("ПодчиненныеФайлы", МассивПодчиненныхФайлов);
			
		Иначе
			
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Файл.ПолноеИмя);
			
			СписокФайлов.Добавить(ОписаниеФайла);	
			
		КонецЕсли;
		
		СтруктураФайлов.Добавить(СтруктураФайла);
		
	КонецЦикла;
	
	
КонецПроцедуры

Функция НовоеОписаниеФайла(Файл, Контекст, ЭтоКаталог = Ложь) Экспорт
	
	СтруктураФайла = Новый Структура;
	СтруктураФайла.Вставить("Путь", Файл.ПолноеИмя);
	СтруктураФайла.Вставить("Имя", Файл.Имя);
	СтруктураФайла.Вставить("ИмяБезРасширения", Файл.ИмяБезРасширения);
	СтруктураФайла.Вставить("Расширение", Файл.Расширение);
	СтруктураФайла.Вставить("ПолноеИмя", Файл.ПолноеИмя);
	СтруктураФайла.Вставить("ПодчиненныеФайлы", Новый Массив);
	
	Если ТипЗнч(Файл) = Тип("Файл") Тогда
		СтруктураФайла.Вставить("ЭтоКаталог", Файл.ЭтоКаталог());
	Иначе
		СтруктураФайла.Вставить("ЭтоКаталог", ЭтоКаталог);
	КонецЕсли;	
	
	СтруктураФайла.Вставить("Контекст", Контекст);
	
	Возврат СтруктураФайла;
	
КонецФункции

// Делает одинаковые слэши в пути к файлу
//
Функция ПривестиСлэши(Знач Путь) Экспорт
	
	ОсновнойСлэш = РазделительПути(Путь);
	
	Путь = СтрЗаменить(Путь, "\", ОсновнойСлэш);
	Путь = СтрЗаменить(Путь, "/", ОсновнойСлэш);
	
	Возврат Путь;
	
КонецФункции

Функция ПроверитьДоступностьКаталогаДляЗаписи(Знач ПутьККаталогу) Экспорт
	
	РезультатПроверки = Новый Структура("ДоступенДляЗаписи, ОписаниеОшибки, КодОшибки", Ложь, "", -1);
	
	Если НЕ ЗначениеЗаполнено(ПутьККаталогу) Тогда
		РезультатПроверки.ОписаниеОшибки = НСтр("ru = 'Каталог не задан.'");
		Возврат РезультатПроверки;	
	КонецЕсли;
	
	ПутьККаталогу = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьККаталогу);
	
	Каталог = Новый Файл(ПутьККаталогу);
	
	Если НЕ Каталог.Существует() Тогда
		РезультатПроверки.ОписаниеОшибки = НСтр("ru = 'Каталог не существует.'");
		РезультатПроверки.КодОшибки = 1;
		Возврат РезультатПроверки;	
	КонецЕсли;
	
	Если НЕ Каталог.ЭтоКаталог() Тогда
		РезультатПроверки.ОписаниеОшибки = НСтр("ru = 'Путь указывает не на каталог.'");
		РезультатПроверки.КодОшибки = 2;
		Возврат РезультатПроверки;	
	КонецЕсли;	
	
	ПутьКТестовомуКаталогу = ПутьККаталогу + "!@%";
	
	Попытка
		СоздатьКаталог(ПутьКТестовомуКаталогу);
		УдалитьФайлы(ПутьКТестовомуКаталогу);
	Исключение
		РезультатПроверки.ОписаниеОшибки = НСтр("ru = 'Нет прав на редактирование каталога.'");
		РезультатПроверки.КодОшибки = 3;
		Возврат РезультатПроверки;
	КонецПопытки;
	
	РезультатПроверки.ДоступенДляЗаписи = Истина;
	
	Возврат РезультатПроверки;
	
КонецФункции

Функция ДобавитьКонечныйРазделительПути(Знач Путь) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Путь) Тогда
		Возврат Путь;
	КонецЕсли;
	
	ОсновнойСлэш = РазделительПути(Путь);
	
	Если Прав(Путь, 1) = ОсновнойСлэш Тогда
		Возврат Путь;
	Иначе 
		Возврат Путь + ОсновнойСлэш;
	КонецЕсли;
	
КонецФункции

Функция УбратьКонечныйРазделительПути(Знач Путь) Экспорт
	
	ПоследнийСимвол = Сред(Путь, СтрДлина(Путь), 1);
	
	Если ПоследнийСимвол = "/" ИЛИ ПоследнийСимвол = "\" Тогда
		Возврат Сред(Путь, 1, СтрДлина(Путь)-1);
	Иначе
		Возврат Путь;
	КонецЕсли;
	
КонецФункции

Функция РазделительПути(Знач Путь) Экспорт
	
	// Тот слэш, который идет первым является основным.
	
	ПозицияПрямогоСлэша   = Найти(Путь, "/");
	ПозицияОбратногоСлэша = Найти(Путь, "\");
	
	ОсновнойСлэш = "";
	
	Если ПозицияПрямогоСлэша = 0 И ПозицияОбратногоСлэша = 0 Тогда
		
		ОсновнойСлэш = ПолучитьРазделительПути();
		
	Иначе
		
		Если ПозицияПрямогоСлэша = 0 Тогда
			ОсновнойСлэш = "\"; // Нет прямого, значит основной - обратный
		КонецЕсли;
		
		Если ПозицияОбратногоСлэша = 0 Тогда
			ОсновнойСлэш = "/"; // Нет обратного, значит основной - прямой
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ОсновнойСлэш) Тогда // Есть оба слэша, значит выбираем первый
			ОсновнойСлэш = ?(ПозицияПрямогоСлэша < ПозицияОбратногоСлэша, "/", "\"); 
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ОсновнойСлэш;
	
КонецФункции

// Получает расширение файла по типу картинки
//
Функция РасширениеКартинки(Формат) Экспорт
	
	Если Формат = ФорматКартинки.BMP Тогда
		Возврат ".bmp";
	КонецЕсли;
		
	Если Формат = ФорматКартинки.EMF Тогда
		Возврат ".emf";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.GIF Тогда
		Возврат ".gif";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.Icon Тогда
		Возврат ".ico";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.JPEG Тогда
		Возврат ".jpg";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.PNG Тогда
		Возврат ".png";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.TIFF Тогда
		Возврат ".tiff";
	КонецЕсли;
	
	Если Формат = ФорматКартинки.WMF Тогда
		Возврат ".wmf";
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

// Выделяет из имени файла его расширение (набор символов после последней точки).
//
// Параметры
//  ИмяФайла     - Строка, содержащая имя файла, неважно с именем каталога или без.
//
// Возвращаемое значение:
//   Строка - расширение файла.
//
Функция РасширениеИмениФайла(Знач ИмяФайла, ВключаяТочку = Ложь) Экспорт
	
	Расширение = СтрокаОтделеннаяСимволом(ИмяФайла, ".");
	
	Если ВключаяТочку Тогда
		Расширение = "." + Расширение;
	КонецЕсли;
	
	Возврат Расширение;
	
КонецФункции

// Проверяет наличие запрещенных в среде MS Windows символов в имени файла.
//
// Параметры
//  ИмяФайла     - Строка, содержащая имя файла, без каталога.
//
// Возвращаемое значение:
//   Булево - Истина, если есть запрещенные символы, Ложь, если нет.
//
Функция ЗаменитьЗапрещенныеСимволыВИмениФайла(Знач ИмяФайла, СимволДляЗамены = "") Экспорт

	нИмяФайла = ИмяФайла;
	нИмяФайла = СтрЗаменить(нИмяФайла, "\", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, "/", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, ":", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, "*", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, """", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, "<", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, ">", СимволДляЗамены);
	нИмяФайла = СтрЗаменить(нИмяФайла, "|", СимволДляЗамены);
	
	Возврат нИмяФайла;
	
КонецФункции

Функция КоличествоФайловВКаталоге(ПутьККаталогу) Экспорт
	
	ПроверяемыйКаталог = Новый Файл(ПутьККаталогу);
		
	Если НЕ ПроверяемыйКаталог.Существует() ИЛИ НЕ ПроверяемыйКаталог.ЭтоКаталог() Тогда
		Возврат 0;
	КонецЕсли;
	
	ФайлыКаталога = НайтиФайлы(ПутьККаталогу, "*", Истина);
	
	Возврат ФайлыКаталога.Количество();
	
КонецФункции

Функция УникальноеИмяФайла(ИмяФайла, Уровень = 0) Экспорт
	
	Если Уровень > 0 Тогда
		ФайлОбъект = Новый Файл(ИмяФайла + " - " + ЧислоВСтроку(Уровень));		
	Иначе
		ФайлОбъект = Новый Файл(ИмяФайла);
	КонецЕсли;
	
	Если ФайлОбъект.Существует() Тогда
		
		Если Уровень > 100 Тогда
			ВызватьИсключение НСтр("ru = 'Невозможно установить уникальное имя файла'")
		КонецЕсли;
		
		Уровень = Уровень + 1;
		
		ФайлОбъект = Новый Файл(УникальноеИмяФайла(ИмяФайла, Уровень)); //Рекурсия
		
	КонецЕсли;
	
	Возврат ФайлОбъект.ПолноеИмя;
	
КонецФункции

Процедура СкопироватьКаталог(Знач ИмяКаталогаИсточника, Знач ИмяКаталогаПриемника) Экспорт	
	
	КаталогИсточника = Новый Файл(ИмяКаталогаИсточника);
	
	Если НЕ КаталогИсточника.Существует() ИЛИ НЕ КаталогИсточника.ЭтоКаталог() Тогда
		ВызватьИсключение НСтр("ru = 'Каталог источника не найден'")
	КонецЕсли;
	
	КаталогПриемника = Новый Файл(ИмяКаталогаПриемника);

	Если НЕ КаталогПриемника.Существует() Тогда
		СоздатьКаталог(ИмяКаталогаПриемника);
	КонецЕсли;
	
	ВсеФайлыИсточника = НайтиФайлы(ИмяКаталогаИсточника, "*", Ложь);
	
	ИмяКаталогаПриемника = ЭлектронноеОбучениеСлужебныйКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяКаталогаПриемника);
	
	Для каждого ФайлИсточника Из ВсеФайлыИсточника Цикл	
		
		ИмяФайлаВПриемнике = ИмяКаталогаПриемника + ФайлИсточника.Имя;
		
		Если ФайлИсточника.ЭтоКаталог() Тогда
			СкопироватьКаталог(ФайлИсточника.ПолноеИмя, ИмяФайлаВПриемнике); //Рекурсия
		Иначе
			КопироватьФайл(ФайлИсточника.ПолноеИмя, ИмяФайлаВПриемнике);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьВременныйФайл(ПолноеИмяФайла) Экспорт
	
	Если ПустаяСтрока(ПолноеИмяФайла) Тогда
		Возврат;
	КонецЕсли;
		
	Попытка
		УдалитьФайлы(ПолноеИмяФайла);
	Исключение
			
		ЭлектронноеОбучениеСлужебныйВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не удалось удалить временный файл
			|%1 по причине: %2'"), ПолноеИмяФайла, КраткоеПредставлениеОшибки(ИнформацияОбОшибке()))
		);
			
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область Разное

// Процедура удаляет завершающий слэш, если он есть во внутренней гиперссылке
//
Процедура ИсправитьПроблемнуюСсылкуФорматированногоДокумента(АдресГиперссылки) Экспорт
	
	Если Лев(АдресГиперссылки, 8) = "e1c:///?"
		И Прав(АдресГиперссылки, 1) = "/" Тогда
		
		// BUG 8.3.8 - Платформа добавляет к ссылке лишний слэш справа
		
		АдресГиперссылки = Сред(АдресГиперссылки, 1, СтрДлина(АдресГиперссылки)-1);
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Функция возвращает часть строки после последнего встреченного символа в строке
//
Функция СтрокаОтделеннаяСимволом(Знач ИсходнаяСтрока, Знач СимволПоиска)
	
	ПозицияСимвола = СтрДлина(ИсходнаяСтрока);
	
	Пока ПозицияСимвола >= 1 Цикл
		
		Если Сред(ИсходнаяСтрока, ПозицияСимвола, 1) = СимволПоиска Тогда						
			Возврат Сред(ИсходнаяСтрока, ПозицияСимвола + 1); 			
		КонецЕсли;
		
		ПозицияСимвола = ПозицияСимвола - 1;
		
	КонецЦикла;

	Возврат "";
  	
КонецФункции


#КонецОбласти
