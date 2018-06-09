#Область СлужебныеПроцедурыИФункции

// Порядок элементов

Процедура ПереместитьЭлемент(Направление, СсылкаНаЭлемент) Экспорт
	РазработкаЭлектронныхКурсовСлужебный.ПереместитьЭлемент(Направление, СсылкаНаЭлемент);
КонецПроцедуры

// Работа с видео

Функция ШиринаВидеоПоУмолчанию() Экспорт	
	Возврат РазработкаЭлектронныхКурсовСлужебный.ШиринаВидеоПоУмолчанию();	
КонецФункции

// Работа с YouTube

Функция ПерсональныеНастройкиYouTube() Экспорт
	Возврат РазработкаЭлектронныхКурсовСлужебный.ПерсональныеНастройкиYouTube();
КонецФункции

Функция НастройкиYouTube() Экспорт	
	Возврат РазработкаЭлектронныхКурсовСлужебныйПовтИсп.НастройкиYouTube();	
КонецФункции

// Загрузка файлов

Процедура ПоместитьФайлВБазу(Знач СвойстваФайла, Знач СвойстваВладельца) Экспорт
	РазработкаЭлектронныхКурсовСлужебный.ПоместитьФайлВБазу(СвойстваФайла, СвойстваВладельца);
КонецПроцедуры

// Внешние программы

Функция ДвоичныеДанныеПрограммы(ИмяПрограммы) Экспорт
	Возврат РазработкаЭлектронныхКурсовСлужебный.ДвоичныеДанныеПрограммы(ИмяПрограммы)
КонецФункции

#КонецОбласти