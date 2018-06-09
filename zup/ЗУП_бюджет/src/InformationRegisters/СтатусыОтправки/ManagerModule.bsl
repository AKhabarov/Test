#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьСтатусыОтправкиДляФССиФСРАР() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |	ДокументРегламентированныйОтчет.Ссылка,
				   |	ПоследниеОтправкиФСС.СтатусОтправки КАК СтатусОтправкиФСС,
				   |	ПоследниеОтправкиФСРАР.СтатусОтправки КАК СтатусОтправкиФСРАР
				   |ИЗ
				   |	Документ.РегламентированныйОтчет КАК ДокументРегламентированныйОтчет
				   |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтатусыОтправки КАК СтатусыОтправки
				   |		ПО (СтатусыОтправки.Объект = ДокументРегламентированныйОтчет.Ссылка)
				   |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
				   |			ВложенныеОтправкиФСС.ОтчетСсылка КАК ОтчетСсылка,
				   |			ОтправкиФСС.СтатусОтправки КАК СтатусОтправки
				   |		ИЗ
				   |			(ВЫБРАТЬ
				   |				ОтправкиФСС.ОтчетСсылка КАК ОтчетСсылка,
				   |				МАКСИМУМ(ОтправкиФСС.ДатаОтправки) КАК ДатаОтправки
				   |			ИЗ
				   |				Справочник.ОтправкиФСС КАК ОтправкиФСС
				   |			СГРУППИРОВАТЬ ПО
				   |				ОтправкиФСС.ОтчетСсылка) КАК ВложенныеОтправкиФСС
				   |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОтправкиФСС КАК ОтправкиФСС
				   |					ПО ОтправкиФСС.ОтчетСсылка = ВложенныеОтправкиФСС.ОтчетСсылка
				   |					И ОтправкиФСС.ДатаОтправки = ВложенныеОтправкиФСС.ДатаОтправки) КАК ПоследниеОтправкиФСС
				   |		ПО (ПоследниеОтправкиФСС.ОтчетСсылка = ДокументРегламентированныйОтчет.Ссылка)
				   |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
				   |			ВложенныеОтправкиФСРАР.ОтчетСсылка КАК ОтчетСсылка,
				   |			ОтправкиФСРАР.СтатусОтправки КАК СтатусОтправки
				   |		ИЗ
				   |			(ВЫБРАТЬ
				   |				ОтправкиФСРАР.ОтчетСсылка КАК ОтчетСсылка,
				   |				МАКСИМУМ(ОтправкиФСРАР.ДатаОтправки) КАК ДатаОтправки
				   |			ИЗ
				   |				Справочник.ОтправкиФСРАР КАК ОтправкиФСРАР
				   |			СГРУППИРОВАТЬ ПО
				   |				ОтправкиФСРАР.ОтчетСсылка) КАК ВложенныеОтправкиФСРАР
				   |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОтправкиФСРАР КАК ОтправкиФСРАР
				   |					ПО ОтправкиФСРАР.ОтчетСсылка = ВложенныеОтправкиФСРАР.ОтчетСсылка
				   |					И ОтправкиФСРАР.ДатаОтправки = ВложенныеОтправкиФСРАР.ДатаОтправки) КАК ПоследниеОтправкиФСРАР
				   |		ПО (ПоследниеОтправкиФСРАР.ОтчетСсылка = ДокументРегламентированныйОтчет.Ссылка)
				   |ГДЕ
				   |	(СтатусыОтправки.Статус ЕСТЬ NULL
				   |		ИЛИ СтатусыОтправки.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.ПустаяСсылка))
				   |	И ((НЕ ПоследниеОтправкиФСС.СтатусОтправки ЕСТЬ NULL
				   |		И ПоследниеОтправкиФСС.СтатусОтправки <> ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.ПустаяСсылка))
				   |		ИЛИ (НЕ ПоследниеОтправкиФСРАР.СтатусОтправки ЕСТЬ NULL
				   |		И ПоследниеОтправкиФСРАР.СтатусОтправки <> ЗНАЧЕНИЕ(Перечисление.СтатусыОтправки.ПустаяСсылка)))";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Запись = РегистрыСведений.СтатусыОтправки.СоздатьМенеджерЗаписи();
	
	Пока Выборка.Следующий() Цикл
		
		Запись.Объект = Выборка.Ссылка;
		Запись.Прочитать();
		
		Запись.Объект = Выборка.Ссылка;
		Если ЗначениеЗаполнено(Выборка.СтатусОтправкиФСС) Тогда
			Запись.Статус = Выборка.СтатусОтправкиФСС;
		Иначе
			Запись.Статус = Выборка.СтатусОтправкиФСРАР;
		КонецЕсли;
		Запись.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаПолученияФормы("РегистрСведений", "СтатусыОтправки", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
