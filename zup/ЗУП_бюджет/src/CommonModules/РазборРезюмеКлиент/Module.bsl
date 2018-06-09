
#Область ПрограммныйИнтерфейс

// Обработчик подключаемой команды. Получает вложение, выполняет проверки разбирает его и открывает форму нового кандидата.
//
// Параметры: 
//	МассивОбъектов - Массив - массив объектов взаимодействия. 
//	ДополнительныеПараметры - Структура - структура параметров команды.
//
Процедура СоздатьКандидатаПоВложениюПодключаемый(МассивОбъектов, ДополнительныеПараметры) Экспорт
	
	#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте функция разбора резюме недоступна.'"));
	Возврат;
	#Иначе
	
	Если МассивОбъектов.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Входящее письмо не выбрано. Выберите требуемое письмо.'"));
		Возврат;
	КонецЕсли;
		                                                    
	ТекущееВзаимодействие = МассивОбъектов[0];
	
	Если ТипЗнч(ТекущееВзаимодействие) <> Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда ""Создать кандидата"" может быть выполнена только для входящего письма.'"));
		Возврат;
	КонецЕсли;
	
	ОбрабатываемыеТипыВложений = РазборРезюмеКлиент.МассивДоступныхРасширений();
	ОбрабатываемыеТипыВложений = СтрСоединить(ОбрабатываемыеТипыВложений,",");
	ОбрабатываемыеТипыВложений = СтрЗаменить(ОбрабатываемыеТипыВложений,".","");
	
	СписокВложений = РазборРезюмеВызовСервера.СписокВложений(ТекущееВзаимодействие, ОбрабатываемыеТипыВложений);
	
	Если СписокВложений.Количество() = 1 Тогда
		Вложение = СписокВложений[0].Значение;        
		СоздатьКандидатаПоВложению(Вложение);
	ИначеЕсли СписокВложений.Количество() > 1 Тогда
		КлиентскийМодуль = ОбщегоНазначенияКлиент.ОбщийМодуль("РазборРезюмеКлиент");
		СписокВложений.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработатьЗавершениеВыбораВложения", КлиентскийМодуль),НСТр("ru = 'Выберите вложение'"));
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'В выбранном письме нет вложений обрабатываемых типов.'"));
		Возврат;
	КонецЕсли; 
	#КонецЕсли
	
КонецПроцедуры

// Начинает процесс работы с файлом-вложением. Разбирает текст резюме и открывает форму нового кандидата.
//
// Параметры: 
//	Вложение - СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы - файл для разбора. 
//
Процедура СоздатьКандидатаПоВложению(Вложение) Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("Вложение", Вложение);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьКандидатаПоВложениюПродолжение", РазборРезюмеКлиент, Параметры);
	
	РаботаСКартинкамиКлиент.ПровестиИнициализациюВнешнихКомпонент(ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура СоздатьКандидатаПоВложениюПродолжение(Результат, Параметры) Экспорт
	
	#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'В веб-клиенте функция разбора резюме недоступна.'"));
	Возврат;
	#Иначе
	
	Вложение = Параметры.Вложение;
	
	ДанныеРезюме = РазборРезюмеВызовСервера.ДанныеРезюме(Вложение);
	
	Если ПустаяСтрока(ДанныеРезюме.Расширение) Тогда
		СтруктураРезюме = РазборРезюмеКлиент.СтруктураРезюмеПоФайлу(Неопределено);
	Иначе
		ИмяФайлаРезюме = ПолучитьИмяВременногоФайла(ДанныеРезюме.Расширение);
	
		ДанныеРезюме.ДвоичныеДанные.Записать(ИмяФайлаРезюме);
		ФайлРезюме = Новый Файл(ИмяФайлаРезюме);
		СтруктураРезюме = РазборРезюмеКлиент.СтруктураРезюмеПоФайлу(ФайлРезюме);
		Попытка
			УдалитьФайлы(ИмяФайлаРезюме);
		Исключение
			ИнформацияОшибки = ИнформацияОбОшибке();
		КонецПопытки;
	КонецЕсли; 
			
	ПараметрыВызоваФормы = Новый Структура("СтруктураРезюме", СтруктураРезюме.СтруктураДанныхКандидата);
	ПараметрыВызоваФормы.Вставить("Сайт", ПредопределенноеЗначение("Справочник.ИсточникиИнформацииОКандидатах.ПустаяСсылка"));
	
	ФормаКандидата = ОткрытьФорму("Справочник.Кандидаты.Форма.ФормаЭлемента",ПараметрыВызоваФормы);
	
	#КонецЕсли
	
КонецПроцедуры

// Процедура команды. Запускает диалог выбора файла и передает дальше полученный файл резюме для создания нового кандидата.
//
// Параметры: 
//	Источник - УправляемаяФорма - форма с которой была вызвана команда создания кандидата. 
//
Процедура СоздатьКандидатаПоФайлу(Источник) Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("Источник", Источник);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоздатьКандидатаПоФайлуПродолжение", РазборРезюмеКлиент, Параметры);
	
	РаботаСКартинкамиКлиент.ПровестиИнициализациюВнешнихКомпонент(ОписаниеОповещения);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура СоздатьКандидатаПоФайлуПродолжение(Результат, Параметры) Экспорт
	
	Источник = Параметры.Источник;
	
	УникальныйИдентификатор = Новый УникальныйИдентификатор();
	
	Если ТипЗнч(Источник) = Тип("УправляемаяФорма") Тогда
		УникальныйИдентификатор = Источник.УникальныйИдентификатор;
	КонецЕсли;
	
	Если Не РасширениеРаботыСФайламиПодключено() Тогда
		// Веб-клиент без расширения для работы с файлами.
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьСозданиеКандидатаПослеПомещенияФайла", РазборРезюмеКлиент);
		Попытка
			НачатьПомещениеФайла(ОписаниеОповещения,,,,УникальныйИдентификатор);
			Возврат;
		Исключение
			ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось загрузить файл на сервер по причине:
					|%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			ПоказатьПредупреждение(, ТекстПредупреждения);
		КонецПопытки;
	КонецЕсли;
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.МножественныйВыбор	= Ложь;
	ДиалогВыбораФайла.Заголовок				= НСтр("ru = 'Выбор файла'");
	ДиалогВыбораФайла.Фильтр				= НСтр("ru = '(*.txt;*.rtf;*.doc;*.docx;*)|*.txt;*.rtf;*.doc;*.docx;'");
		
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗакончитьСозданиеКандидатаПослеПомещенияФайлов", РазборРезюмеКлиент);
	
	Попытка
		НачатьПомещениеФайлов(ОписаниеОповещения, , ДиалогВыбораФайла, Истина,УникальныйИдентификатор);
	Исключение
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось загрузить файл на сервер по причине:
				|%1'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецПопытки;
	
КонецПроцедуры

// Возвращает результат подключения расширения работы с файлами.
//
// Возвращаемое значение:
//  Булево - в тонком клиенте всегда Истина, в браузере Google Chrome всегда Ложь.
//
Функция РасширениеРаботыСФайламиПодключено() Экспорт
	
	Если КлиентПоддерживаетСинхронныеВызовы() Тогда
		Возврат ПодключитьРасширениеРаботыСФайлами();
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Выполняется в ходе создания файла с диска после помещения файла (веб без расширения).
//
// Параметры:
//  Результат - Булево - Истина, если файл помещен, и Ложь, если пользователь отказался.
//  Адрес - Строка - адрес данных файла в хранилище.
//  ПолныйПуть - Строка - полное имя выбранного файла.
//  Параметры - Неопределено - не используется.
//
Процедура ЗакончитьСозданиеКандидатаПослеПомещенияФайла(Результат, Адрес, ПолныйПуть, Параметры) Экспорт
	
	ПомещенныеФайлы = Новый Массив();	
	Если Результат Тогда
		ПомещенныеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПолныйПуть, Адрес));
	КонецЕсли;
	
	ЗакончитьСозданиеКандидатаПослеПомещенияФайлов(ПомещенныеФайлы, Параметры);
	
КонецПроцедуры	

// Выполняется в ходе создания файла с диска после помещения файла (тонкий и веб с расширением).
//
// Параметры:
//  ПомещенныеФайлы - Неопределено, Массив - результат выполнения операции помещения файлов
//                   - Неопределено, если файлы поместить не удалось.
//					 - Массив помещенных файлов.
//  ПараметрыЗагрузки - Неопределено - не используется.
//
Процедура ЗакончитьСозданиеКандидатаПослеПомещенияФайлов(ПомещенныеФайлы, ПараметрыЗагрузки) Экспорт
	
	Если ПомещенныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ПомещенныеФайлы.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Загрузка файлов не выполнена.'"));
		Возврат;
	КонецЕсли;
	
	ФайлРезюмеПараметры = ПомещенныеФайлы[0];
	
	ФайлРезюме = Новый Файл(ФайлРезюмеПараметры.Имя);  
	
	СтруктураРезюме = СтруктураРезюмеПоФайлу(ФайлРезюме);
	
	Если СтруктураРезюме.ОписаниеОшибки = "" Тогда
		
		ПараметрыВызоваФормы = Новый Структура();
		ПараметрыВызоваФормы.Вставить("СтруктураРезюме", СтруктураРезюме.СтруктураДанныхКандидата);
		ПараметрыВызоваФормы.Вставить("Сайт", ПредопределенноеЗначение("Справочник.ИсточникиИнформацииОКандидатах.ПустаяСсылка"));
		ПараметрыВызоваФормы.Вставить("ФайлРезюмеДляЗагрузки", ФайлРезюмеПараметры.Имя);
		ПараметрыВызоваФормы.Вставить("АдресРезюмеДляЗагрузки", ФайлРезюмеПараметры.Хранение );
		
		ФормаКандидата = ОткрытьФорму("Справочник.Кандидаты.Форма.ФормаЭлемента", ПараметрыВызоваФормы,, Истина);
	Иначе
		ТекстПредупреждения = НСтр(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Не удается создать кандидата по выбранному файлу. 
                                    |%1'", СтруктураРезюме.ОписаниеОшибки));
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
КонецПроцедуры	

// Формирует структуру резюме из полученного файла.
//
// Параметры:
//  ФайлРезюме - ДвоичныеДанные - сам файл резюме
//  ШаблонРезюме - СправочникСсылка.ИсточникиИнформацииОКандидатах - вариант шаблона для разбора резюме.
//
// Возвращаемое значение:
//  Структура - структура с заполненными данными резюме. 
//
Функция СтруктураРезюмеПоФайлу(Знач ФайлРезюме, Знач ШаблонРезюме = Неопределено) Экспорт
	
	СтруктураОтвета = СтруктураДанныхРезюме();
	
	#Если ВебКлиент Тогда
		
	ТекстСообщения = НСтр("ru = 'В веб-клиенте функция разбора резюме не поддерживается.'");
	ПоказатьПредупреждение(, ТекстСообщения);
	СтруктураОтвета.Вставить("ОписаниеОшибки", ТекстСообщения);
	Возврат СтруктураОтвета;
	#Иначе
	
	Если ТипЗнч(ФайлРезюме) <> Тип("Файл") Тогда
		СтруктураОтвета.Вставить("ОписаниеОшибки", НСтр("ru = 'Ожидается файл резюме.'"));
		Возврат СтруктураОтвета;
	ИначеЕсли НЕ ФайлРезюме.Существует() Тогда 
		СтруктураОтвета.Вставить("ОписаниеОшибки", НСтр(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Не найден файл ""%1""'",ФайлРезюме.ПолноеИмя)));
		Возврат СтруктураОтвета;
	КонецЕсли; 
	
	РасширениеФайла = НРег(ФайлРезюме.Расширение);
	Если МассивДоступныхРасширений().Найти(РасширениеФайла) = Неопределено Тогда
		СтруктураОтвета.Вставить("ОписаниеОшибки",НСтр(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ru = 'Расширение ""%1"" не в ходит в перечень обслуживаемых'",РасширениеФайла)));
		Возврат СтруктураОтвета;
	КонецЕсли; 
	
	ТекстРезюме = ТекстИзФайла(ФайлРезюме);
	
	Если ПустаяСтрока(ТекстРезюме) Тогда
		СтруктураОтвета.Вставить("ОписаниеОшибки", НСтр("ru = 'Не удалось извлечь текст из файла.'"));
		Возврат СтруктураОтвета;
	КонецЕсли; 
	
	СтруктураОтвета = СтруктураРезюмеПоТексту(ТекстРезюме, ШаблонРезюме);
		
	Фотография = ИзвлечениеФотографии(ФайлРезюме);	
	
	Если ТипЗнч(Фотография)  = Тип("Картинка") Тогда
		СтруктураОтвета.СтруктураДанныхКандидата.Вставить("Фото",Фотография);
	КонецЕсли; 
	
	Возврат СтруктураОтвета;
	
	#КонецЕсли 
	
КонецФункции

// Формирует структуру резюме из полученного текста.
//  
// Параметры:
//  ТекстРезюме - Строка - текст для извлечения данных резюме
//  ШаблонРезюме - СправочникСсылка.ИсточникиИнформацииОКандидатах - вариант шаблона для разбора резюме.
//
// Возвращаемое значение:
//  Структура - структура с заполненными данными резюме.
//
Функция СтруктураРезюмеПоТексту(Знач ТекстРезюме, Знач ШаблонРезюме = Неопределено) Экспорт
	
	СтруктураОтвета = СтруктураДанныхРезюме();
	
	Если НЕ ПустаяСтрока(ТекстРезюме) Тогда
		
		РазборРезюмеВызовСервера.ПарсингТекста(СтруктураОтвета,ТекстРезюме, ШаблонРезюме);
		
	КонецЕсли; 
	
	Возврат СтруктураОтвета;
КонецФункции

// Возвращает перечень расширений
// 
// Возвращаемое значение:
//  Массив - массив строк с расширениями (например, ".doc").
//
Функция МассивДоступныхРасширений() Экспорт
	Возврат СтрРазделить(".txt;.rtf;.doc;.docx",";",Ложь);
КонецФункции

#Область РаботаСВложением                       

// Обработчик завершения выбора файла резюме из вложения. Запускает процесс обработки файла из вложения.
//
// Параметры:
//  ВыбранныйЭлемент - ЭлементСпискаЗначений - выбранное вложение из предложенного списка. 
//	Параметры - Структура - структура параметров команды.
//
Процедура ОбработатьЗавершениеВыбораВложения(ВыбранныйЭлемент, Параметры) Экспорт 

	#Если Не ВебКлиент Тогда
		
	Если ТипЗнч(ВыбранныйЭлемент) = Тип("ЭлементСпискаЗначений") Тогда
		СоздатьКандидатаПоВложению(ВыбранныйЭлемент.Значение);
	КонецЕсли; 
	
	#КонецЕсли

КонецПроцедуры
 
#КонецОбласти 

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Проверяет, поддерживает ли клиент синхронные вызовы.
//
//  Возвращаемое значение:
//   Булево - Истина, если веб-клиент поддерживает синхронные вызовы; Ложь, не поддерживает. 
//
Функция КлиентПоддерживаетСинхронныеВызовы()
	                         
#Если ВебКлиент Тогда
	// В Chrome расширение не подключается.
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИнформацияПрограммыМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(
		СистемнаяИнформация.ИнформацияПрограммыПросмотра, " ");
	
	Для Каждого ИнформацияПрограммы Из ИнформацияПрограммыМассив Цикл
		Если Найти(ИнформацияПрограммы, "Chrome") > 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
#КонецЕсли
	
	Возврат Истина;
	
КонецФункции

#Если НЕ ВебКлиент Тогда

#Область ИзвлечениеТекста

Функция ТекстИзФайла(Знач ФайлРезюме)
	
	ПолученныйТекст = Неопределено;
	
	РасширениеФайла = НРег(ФайлРезюме.Расширение);
	
	Если РасширениеФайла = ".doc" 
		ИЛИ РасширениеФайла = ".docx"
		ИЛИ РасширениеФайла = ".rtf" Тогда
		ПолученныйТекст = ТекстИзФайлаMicrosoftWord(ФайлРезюме);
	ИначеЕсли РасширениеФайла = ".txt" Тогда 
		ПолученныйТекст = ТекстИзФайлаTXT(ФайлРезюме);
	КонецЕсли; 

	Если Не ПустаяСтрока(ПолученныйТекст) Тогда
		ПолученныйТекст = ОбщегоНазначенияКлиентСервер.УдалитьНедопустимыеСимволыXML(ПолученныйТекст);
		ПолученныйТекст = ТекстПослеНормализации(ПолученныйТекст);
	КонецЕсли; 
	
	Возврат ПолученныйТекст;
	
КонецФункции

Функция ТекстПослеНормализации(Знач Текст)
	
	// Удаляем символы цитирования и пустые символы по краям строки.
	КодСимволаЦитирования = КодСимвола(">");
	ТекстРезультата = Новый ТекстовыйДокумент;
	Для Индекс = 1 По СтрЧислоСтрок(Текст) Цикл
		
		Строка = СтрПолучитьСтроку(Текст, Индекс);
		Строка = СокрЛП(Строка);
		Пока КодСимвола(Строка) = КодСимвола(">") Цикл
			Строка = Сред(Строка, 2);
			Строка = СокрЛП(Строка);
			Если Не СтрЗаканчиваетсяНа(Строка, ".") Тогда
				Строка = Строка + ".";
			КонецЕсли;
		КонецЦикла;
		ТекстРезультата.ДобавитьСтроку(Строка);
		
	КонецЦикла;
	Текст = ТекстРезультата.ПолучитьТекст();
	Текст = СокрЛП(Текст);
	
	// Исправляем лишние переводы строки.
	ДлинаТекста = СтрДлина(Текст);
	ОбработатьТекст = Истина;
	Пока ОбработатьТекст Цикл
		// При нормализации используется "!", а не ".", во избежании появления лишних дат.
		Текст = СтрЗаменить(Текст, Символы.ПС + Символы.ПС + Символы.ПС, Символы.ПС + Символы.ПС);
		Текст = СтрЗаменить(Текст, "   ", " ");
		Текст = СтрЗаменить(Текст, "  ", " ");
		Текст = СтрЗаменить(Текст, " " + Символы.ПС, Символы.ПС);
		Текст = СтрЗаменить(Текст, "?.", "?");
		Текст = СтрЗаменить(Текст, "?!", "?");
		Текст = СтрЗаменить(Текст, "!.", "!");
		Текст = СтрЗаменить(Текст, "!!", "!");
		Текст = СтрЗаменить(Текст, ".!", ".");
		Текст = СтрЗаменить(Текст, "--", "-");
		Текст = СокрЛП(Текст);
		
		ОбработатьТекст = ДлинаТекста <> СтрДлина(Текст);
		ДлинаТекста = СтрДлина(Текст);
		
	КонецЦикла;
	
	// Корректировка ё
	Текст = СтрЗаменить(Текст, "Ё", "Е");
	Текст = СтрЗаменить(Текст, "ё", "е");
	
	Возврат Текст;
	
КонецФункции
 
Функция ТекстИзФайлаMicrosoftWord(Знач ФайлРезюме)
	
	ИзвлеченныйТекст = "";
	
	Попытка
		ОбъектWord = Новый COMОбъект("Word.Application");
		ОбъектWord.Visible = 0;
		Док = ОбъектWord.Documents.Open(ФайлРезюме.ПолноеИмя,0,1,0,,,1);
	Исключение
		ОписаниеОшибки = НСтр("ru = 'Ошибка работы с приложением MS Word. Рекомендации:
		|1) Проверьте файл, возможно он заблокирован и доступен только для чтения или поврежден.
		|2) Переустановите приложение MS Word или используйте более новую версию приложения..'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
		
		ОбъектWord.Quit(0);
		ОбъектWord = Неопределено;
		Возврат "";
	КонецПопытки;
	
	Док.Activate();
	
	Selection = ОбъектWord.Selection;
	Selection.WholeStory();
	ИзвлеченныйТекст = Selection.Text;
	
	Док.Close(False); 
	ОбъектWord.Quit();
	ОбъектWord = Неопределено;
	
	Возврат	ИзвлеченныйТекст;
	
КонецФункции

Функция ТекстИзФайлаTXT(Знач ФайлРезюме)
	
	ИзвлеченныйТекст = "";
	
	Извлечение = Новый ИзвлечениеТекста(ФайлРезюме.ПолноеИмя);
	Попытка
		ИзвлеченныйТекст = Извлечение.ПолучитьТекст();
	Исключение
		ОписаниеОшибки = ИнформацияОбОшибке();
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации("РазборРезюме.ИзвлечениеТекста", "Ошибка", ОписаниеОшибки.Описание, ОбщегоНазначенияКлиент.ДатаСеанса());
	КонецПопытки; 
	
	Возврат	ИзвлеченныйТекст;
	
КонецФункции
 
#КонецОбласти 

#Область ИзвлечениеФото

Функция ИзвлечениеФотографии(Знач ФайлРезюме)
	
	РасширениеФайла = НРег(ФайлРезюме.Расширение);
	
	Если РасширениеФайла = ".doc" 
		ИЛИ РасширениеФайла = ".docx"
		ИЛИ РасширениеФайла = ".rtf" Тогда
		Возврат ФотоИзФайлаWord(ФайлРезюме);
	КонецЕсли; 
	
КонецФункции

Функция ФотоИзФайлаWord(Знач ФайлРезюме)
	
	КэшированныеКомпоненты = ПараметрыПриложения["СтандартныеПодсистемы.ВнешниеКомпоненты.Объекты"];
	
	ОбъектДляРаботыСКартинкой = Неопределено;
	
	Если ТипЗнч(КэшированныеКомпоненты) = Тип("ФиксированноеСоответствие") Тогда
		ОбъектДляРаботыСКартинкой = КэшированныеКомпоненты.Получить("ОбщийМакет.КомпонентаПолученияКартинкиИзБуфера");
	КонецЕсли;
	
	Если ОбъектДляРаботыСКартинкой = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		ОбъектWord = Новый COMОбъект("Word.Application");
		ОбъектWord.Visible = 0;
		Док = ОбъектWord.Documents.Open(ФайлРезюме.ПолноеИмя,0,1,0,,,1);
	Исключение
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Ошибка работы с приложением MS Word.
					|Извлечь фото из ""%1""  не удалось.'"), ФайлРезюме.ПолноеИмя);
				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);				
		
		ОбъектWord.Quit(0);
		ОбъектWord = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	Док.Activate();
	
	Selection = ОбъектWord.Selection;
	Selection.WholeStory();
	InlineShapes = Selection.InlineShapes;
	Shapes = ОбъектWord.ActiveDocument.Shapes;
	
	ВставлятьКартинкуИзБуфера = Ложь;
	Если InlineShapes.Count > 0 Тогда
		InlineShapes.Item(1).Select();
		ОбъектWord.Selection.CopyAsPicture();
		ВставлятьКартинкуИзБуфера = Истина;
	ИначеЕсли Shapes.Count Тогда
		Shapes.Item(1).Select();
		ОбъектWord.Selection.CopyAsPicture();
		ВставлятьКартинкуИзБуфера = Истина;
	КонецЕсли;

	Если ВставлятьКартинкуИзБуфера Тогда
		ПутьКФайлу = ОбъектДляРаботыСКартинкой.ПолучитьКартинкуИзБуфера();

		Если Не ПустаяСтрока(ПутьКФайлу) Тогда
			
			Док.Close(False); 
			ОбъектWord.Quit();
			ОбъектWord = Неопределено;
			
			Возврат Новый Картинка(ПутьКФайлу);
		КонецЕсли;
	КонецЕсли;
	
	Док.Close(False); 
	ОбъектWord.Quit();
	ОбъектWord = Неопределено;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти 

#КонецЕсли 

// Возвращает пустую структуру резюме кандидата
//
// Возвращаемое значение:
//  Структура - пустая структура резюме кандидата.
//
Функция СтруктураДанныхРезюме()
	
	СтруктураОтвета = Новый Структура("ОписаниеОшибки, СтруктураДанныхКандидата");
	СтруктураОтвета.ОписаниеОшибки = "";
	СтруктураОтвета.СтруктураДанныхКандидата = ПодборПерсоналаКлиентСервер.ОписаниеРезюмеКандидата();
	
	Возврат СтруктураОтвета;
	
КонецФункции

#КонецОбласти 


