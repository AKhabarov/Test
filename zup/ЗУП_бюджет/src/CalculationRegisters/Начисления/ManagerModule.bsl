#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ДополнитьНаборЗаписейНачислениямиСовместителейИПодработок(НаборЗаписей, ДобавленныеЗаписи = НеОпределено) Экспорт
	
	ЗаписиДобавлялись = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("НаборЗаписейНачисления", НаборЗаписей.Выгрузить());
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
	|	Начисления.Регистратор КАК Регистратор,
	|	Начисления.НомерСтроки КАК НомерСтроки,
	|	Начисления.ВидРасчета КАК ВидРасчета,
	|	Начисления.ПериодДействия КАК ПериодДействия,
	|	Начисления.ПериодДействияНачало КАК ПериодДействияНачало,
	|	Начисления.ПериодДействияКонец КАК ПериодДействияКонец,
	|	Начисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	Начисления.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	Начисления.Активность КАК Активность,
	|	Начисления.Сторно КАК Сторно,
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Начисления.Результат КАК Результат,
	|	Начисления.ОтработаноДней КАК ОтработаноДней,
	|	Начисления.ОтработаноЧасов КАК ОтработаноЧасов,
	|	Начисления.РезультатВТомЧислеЗаСчетФБ КАК РезультатВТомЧислеЗаСчетФБ,
	|	Начисления.ГрафикРаботы КАК ГрафикРаботы,
	|	Начисления.ВидУчетаВремени КАК ВидУчетаВремени,
	|	Начисления.ВремяВЧасах КАК ВремяВЧасах,
	|	Начисления.ГрафикРаботыНорма КАК ГрафикРаботыНорма,
	|	Начисления.ОбщийГрафик КАК ОбщийГрафик,
	|	Начисления.Организация КАК Организация,
	|	Начисления.ФиксСтрока КАК ФиксСтрока,
	|	Начисления.ФиксЗаполнение КАК ФиксЗаполнение,
	|	Начисления.ФиксРасчетВремени КАК ФиксРасчетВремени,
	|	Начисления.ФиксРасчет КАК ФиксРасчет,
	|	Начисления.РасчетнаяБазаЗаЕдиницуНормыВремени КАК РасчетнаяБазаЗаЕдиницуНормыВремени,
	|	Начисления.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	Начисления.ПериодРегистрацииВремени КАК ПериодРегистрацииВремени,
	|	Начисления.ПериодРегистрацииНормыВремени КАК ПериодРегистрацииНормыВремени,
	|	Начисления.ДоляРезультата КАК ДоляРезультата
	|ПОМЕСТИТЬ ВТВсеНачисленияНабора
	|ИЗ
	|	&НаборЗаписейНачисления КАК Начисления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.Ссылка КАК ВидРасчета
	|ПОМЕСТИТЬ ВТКонтролируемыеНачисления
	|ИЗ
	|	ПланВидовРасчета.Начисления КАК Начисления
	|ГДЕ
	|	(Начисления.ДублироватьДляВнутреннихСовместителейИПодработок
	|			ИЛИ Начисления.ДублироватьДляПодработок)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Начисления.ПериодРегистрации КАК ПериодРегистрации,
	|	Начисления.Регистратор КАК Регистратор,
	|	Начисления.НомерСтроки КАК НомерСтроки,
	|	Начисления.ВидРасчета КАК ВидРасчета,
	|	Начисления.ПериодДействия КАК ПериодДействия,
	|	Начисления.ПериодДействияНачало КАК ПериодДействияНачало,
	|	Начисления.ПериодДействияКонец КАК ПериодДействияКонец,
	|	Начисления.БазовыйПериодНачало КАК БазовыйПериодНачало,
	|	Начисления.БазовыйПериодКонец КАК БазовыйПериодКонец,
	|	Начисления.Активность КАК Активность,
	|	Начисления.Сторно КАК Сторно,
	|	Начисления.Сотрудник КАК Сотрудник,
	|	Начисления.ФизическоеЛицо КАК ФизическоеЛицо,
	|	Начисления.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	Начисления.Результат КАК Результат,
	|	Начисления.ОтработаноДней КАК ОтработаноДней,
	|	Начисления.ОтработаноЧасов КАК ОтработаноЧасов,
	|	Начисления.РезультатВТомЧислеЗаСчетФБ КАК РезультатВТомЧислеЗаСчетФБ,
	|	Начисления.ГрафикРаботы КАК ГрафикРаботы,
	|	Начисления.ВидУчетаВремени КАК ВидУчетаВремени,
	|	Начисления.ВремяВЧасах КАК ВремяВЧасах,
	|	Начисления.ГрафикРаботыНорма КАК ГрафикРаботыНорма,
	|	Начисления.ОбщийГрафик КАК ОбщийГрафик,
	|	Начисления.Организация КАК Организация,
	|	Начисления.ФиксСтрока КАК ФиксСтрока,
	|	Начисления.ФиксЗаполнение КАК ФиксЗаполнение,
	|	Начисления.ФиксРасчетВремени КАК ФиксРасчетВремени,
	|	Начисления.ФиксРасчет КАК ФиксРасчет,
	|	Начисления.РасчетнаяБазаЗаЕдиницуНормыВремени КАК РасчетнаяБазаЗаЕдиницуНормыВремени,
	|	Начисления.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	Начисления.ПериодРегистрацииВремени КАК ПериодРегистрацииВремени,
	|	Начисления.ПериодРегистрацииНормыВремени КАК ПериодРегистрацииНормыВремени,
	|	Начисления.ДоляРезультата КАК ДоляРезультата
	|ПОМЕСТИТЬ ВТНачисленияНабора
	|ИЗ
	|	ВТВсеНачисленияНабора КАК Начисления
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТКонтролируемыеНачисления КАК КонтролируемыеНачисления
	|		ПО Начисления.ВидРасчета = КонтролируемыеНачисления.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(НачисленияНабора.ПериодДействияНачало) КАК НачалоПериода,
	|	МАКСИМУМ(НачисленияНабора.ПериодДействияКонец) КАК ОкончаниеПериода,
	|	НачисленияНабора.Организация КАК Организация
	|ИЗ
	|	ВТНачисленияНабора КАК НачисленияНабора
	|ГДЕ
	|	НачисленияНабора.Сотрудник = ВЫРАЗИТЬ(НачисленияНабора.Сотрудник КАК Справочник.Сотрудники).ГоловнойСотрудник
	|
	|СГРУППИРОВАТЬ ПО
	|	НачисленияНабора.Организация";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если Не РезультатЗапроса.Пустой() Тогда
		
		УдалитьВременныеТаблицы = Ложь;
		Выборка = РезультатЗапроса.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если УдалитьВременныеТаблицы Тогда
				
				Запрос.Текст =
					"УНИЧТОЖИТЬ ВТФизическиеЛица
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|УНИЧТОЖИТЬ ВТСотрудникиОрганизации
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|УНИЧТОЖИТЬ ВТСотрудникиССовместителями
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|УНИЧТОЖИТЬ ВТНачисленияНабораСНачислениямиСовместителей
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|УНИЧТОЖИТЬ ВТСотрудникиСПодработками";
					
				Запрос.Выполнить();
				
			Иначе
				УдалитьВременныеТаблицы = Истина;
			КонецЕсли;
			
			Запрос.УстановитьПараметр("Организация", Выборка.Организация);
			Запрос.Текст =
				"ВЫБРАТЬ РАЗЛИЧНЫЕ
				|	НачисленияНабора.ФизическоеЛицо
				|ПОМЕСТИТЬ ВТФизическиеЛица
				|ИЗ
				|	ВТНачисленияНабора КАК НачисленияНабора
				|ГДЕ
				|	НачисленияНабора.Сотрудник = НачисленияНабора.Сотрудник.ГоловнойСотрудник";
				
			Запрос.Выполнить();
			
			ПараметрыПолучения = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоВременнойТаблице();
			ЗаполнитьЗначенияСвойств(ПараметрыПолучения, Выборка);
			ПараметрыПолучения.КадровыеДанные = "ВидЗанятости,ГоловнойСотрудник";
			ПараметрыПолучения.ОтбиратьПоГоловнойОрганизации = Истина;
			ПараметрыПолучения.ПодработкиРаботниковПоТрудовымДоговорам = Истина;
			
			КадровыйУчет.СоздатьВТСотрудникиОрганизации(Запрос.МенеджерВременныхТаблиц, Ложь, ПараметрыПолучения);
			
			// Дублирование начислений внутренних совместителей
			Запрос.Текст =
			"ВЫБРАТЬ
			|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
			|	СотрудникиОрганизацииСовместители.Сотрудник КАК Совместитель
			|ПОМЕСТИТЬ ВТСотрудникиССовместителями
			|ИЗ
			|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК СотрудникиОрганизацииСовместители
			|		ПО СотрудникиОрганизации.ФизическоеЛицо = СотрудникиОрганизацииСовместители.ФизическоеЛицо
			|			И (СотрудникиОрганизацииСовместители.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ВнутреннееСовместительство))
			|ГДЕ
			|	СотрудникиОрганизации.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.ОсновноеМестоРаботы)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	НачисленияНабора.ПериодРегистрации КАК ПериодРегистрации,
			|	НачисленияНабора.Регистратор КАК Регистратор,
			|	НачисленияНабора.НомерСтроки КАК НомерСтроки,
			|	НачисленияНабора.ВидРасчета КАК ВидРасчета,
			|	НачисленияНабора.ПериодДействия КАК ПериодДействия,
			|	НачисленияНабора.ПериодДействияНачало КАК ПериодДействияНачало,
			|	НачисленияНабора.ПериодДействияКонец КАК ПериодДействияКонец,
			|	НачисленияНабора.БазовыйПериодНачало КАК БазовыйПериодНачало,
			|	НачисленияНабора.БазовыйПериодКонец КАК БазовыйПериодКонец,
			|	НачисленияНабора.Активность КАК Активность,
			|	НачисленияНабора.Сторно КАК Сторно,
			|	НачисленияНабора.Сотрудник КАК Сотрудник,
			|	НачисленияНабора.ФизическоеЛицо КАК ФизическоеЛицо,
			|	НачисленияНабора.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	НачисленияНабора.Результат КАК Результат,
			|	НачисленияНабора.ОтработаноДней КАК ОтработаноДней,
			|	НачисленияНабора.ОтработаноЧасов КАК ОтработаноЧасов,
			|	НачисленияНабора.РезультатВТомЧислеЗаСчетФБ КАК РезультатВТомЧислеЗаСчетФБ,
			|	НачисленияНабора.ГрафикРаботы КАК ГрафикРаботы,
			|	НачисленияНабора.ВидУчетаВремени КАК ВидУчетаВремени,
			|	НачисленияНабора.ВремяВЧасах КАК ВремяВЧасах,
			|	НачисленияНабора.ГрафикРаботыНорма КАК ГрафикРаботыНорма,
			|	НачисленияНабора.ОбщийГрафик КАК ОбщийГрафик,
			|	НачисленияНабора.Организация КАК Организация,
			|	НачисленияНабора.ФиксСтрока КАК ФиксСтрока,
			|	НачисленияНабора.ФиксЗаполнение КАК ФиксЗаполнение,
			|	НачисленияНабора.ФиксРасчетВремени КАК ФиксРасчетВремени,
			|	НачисленияНабора.ФиксРасчет КАК ФиксРасчет,
			|	НачисленияНабора.РасчетнаяБазаЗаЕдиницуНормыВремени КАК РасчетнаяБазаЗаЕдиницуНормыВремени,
			|	НачисленияНабора.ИдентификаторСтроки КАК ИдентификаторСтроки,
			|	НачисленияНабора.ПериодРегистрацииВремени КАК ПериодРегистрацииВремени,
			|	НачисленияНабора.ПериодРегистрацииНормыВремени КАК ПериодРегистрацииНормыВремени,
			|	НачисленияНабора.ДоляРезультата КАК ДоляРезультата,
			|	ЛОЖЬ КАК ДобавленноеНачислениеНабора
			|ПОМЕСТИТЬ ВТНачисленияНабораСНачислениямиСовместителей
			|ИЗ
			|	ВТНачисленияНабора КАК НачисленияНабора
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	НачисленияНабора.ПериодРегистрации,
			|	НачисленияНабора.Регистратор,
			|	НачисленияНабора.НомерСтроки,
			|	НачисленияНабора.ВидРасчета,
			|	НачисленияНабора.ПериодДействия,
			|	НачисленияНабора.ПериодДействияНачало,
			|	НачисленияНабора.ПериодДействияКонец,
			|	НачисленияНабора.БазовыйПериодНачало,
			|	НачисленияНабора.БазовыйПериодКонец,
			|	НачисленияНабора.Активность,
			|	НачисленияНабора.Сторно,
			|	СотрудникиССовместителями.Совместитель,
			|	НачисленияНабора.ФизическоеЛицо,
			|	НачисленияНабора.ГоловнаяОрганизация,
			|	НачисленияНабора.Результат,
			|	НачисленияНабора.ОтработаноДней,
			|	НачисленияНабора.ОтработаноЧасов,
			|	НачисленияНабора.РезультатВТомЧислеЗаСчетФБ,
			|	НачисленияНабора.ГрафикРаботы,
			|	НачисленияНабора.ВидУчетаВремени,
			|	НачисленияНабора.ВремяВЧасах,
			|	НачисленияНабора.ГрафикРаботыНорма,
			|	НачисленияНабора.ОбщийГрафик,
			|	НачисленияНабора.Организация,
			|	НачисленияНабора.ФиксСтрока,
			|	НачисленияНабора.ФиксЗаполнение,
			|	НачисленияНабора.ФиксРасчетВремени,
			|	НачисленияНабора.ФиксРасчет,
			|	НачисленияНабора.РасчетнаяБазаЗаЕдиницуНормыВремени,
			|	НачисленияНабора.ИдентификаторСтроки,
			|	НачисленияНабора.ПериодРегистрацииВремени,
			|	НачисленияНабора.ПериодРегистрацииНормыВремени,
			|	НачисленияНабора.ДоляРезультата,
			|	ИСТИНА
			|ИЗ
			|	ВТСотрудникиССовместителями КАК СотрудникиССовместителями
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисленияНабора КАК НачисленияНабора
			|		ПО СотрудникиССовместителями.Сотрудник = НачисленияНабора.Сотрудник
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияНабора КАК НачисленияНабораСовместителей
			|		ПО СотрудникиССовместителями.Совместитель = НачисленияНабораСовместителей.Сотрудник
			|			И (НачисленияНабора.ВидРасчета = НачисленияНабораСовместителей.ВидРасчета)
			|			И (НачисленияНабора.ПериодДействияНачало = НачисленияНабораСовместителей.ПериодДействияНачало)
			|			И (НачисленияНабора.ПериодДействияКонец = НачисленияНабораСовместителей.ПериодДействияКонец)
			|ГДЕ
			|	НачисленияНабораСовместителей.Сотрудник ЕСТЬ NULL
			|	И ВЫРАЗИТЬ(НачисленияНабора.ВидРасчета КАК ПланВидовРасчета.Начисления).ДублироватьДляВнутреннихСовместителейИПодработок
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	НачисленияНабораСНачислениямиСовместителей.ПериодРегистрации КАК ПериодРегистрации,
			|	НачисленияНабораСНачислениямиСовместителей.Регистратор КАК Регистратор,
			|	НачисленияНабораСНачислениямиСовместителей.НомерСтроки КАК НомерСтроки,
			|	НачисленияНабораСНачислениямиСовместителей.ВидРасчета КАК ВидРасчета,
			|	НачисленияНабораСНачислениямиСовместителей.ПериодДействия КАК ПериодДействия,
			|	НачисленияНабораСНачислениямиСовместителей.ПериодДействияНачало КАК ПериодДействияНачало,
			|	НачисленияНабораСНачислениямиСовместителей.ПериодДействияКонец КАК ПериодДействияКонец,
			|	НачисленияНабораСНачислениямиСовместителей.БазовыйПериодНачало КАК БазовыйПериодНачало,
			|	НачисленияНабораСНачислениямиСовместителей.БазовыйПериодКонец КАК БазовыйПериодКонец,
			|	НачисленияНабораСНачислениямиСовместителей.Активность КАК Активность,
			|	НачисленияНабораСНачислениямиСовместителей.Сторно КАК Сторно,
			|	НачисленияНабораСНачислениямиСовместителей.Сотрудник КАК Сотрудник,
			|	НачисленияНабораСНачислениямиСовместителей.ФизическоеЛицо КАК ФизическоеЛицо,
			|	НачисленияНабораСНачислениямиСовместителей.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	0 КАК Результат,
			|	0 КАК ОтработаноДней,
			|	0 КАК ОтработаноЧасов,
			|	0 КАК РезультатВТомЧислеЗаСчетФБ,
			|	НачисленияНабораСНачислениямиСовместителей.ГрафикРаботы КАК ГрафикРаботы,
			|	НачисленияНабораСНачислениямиСовместителей.ВидУчетаВремени КАК ВидУчетаВремени,
			|	НачисленияНабораСНачислениямиСовместителей.ВремяВЧасах КАК ВремяВЧасах,
			|	НачисленияНабораСНачислениямиСовместителей.ГрафикРаботыНорма КАК ГрафикРаботыНорма,
			|	НачисленияНабораСНачислениямиСовместителей.Организация КАК Организация,
			|	НачисленияНабораСНачислениямиСовместителей.ФиксСтрока КАК ФиксСтрока,
			|	НачисленияНабораСНачислениямиСовместителей.ФиксЗаполнение КАК ФиксЗаполнение,
			|	НачисленияНабораСНачислениямиСовместителей.ФиксРасчетВремени КАК ФиксРасчетВремени,
			|	НачисленияНабораСНачислениямиСовместителей.ФиксРасчет КАК ФиксРасчет,
			|	НачисленияНабораСНачислениямиСовместителей.РасчетнаяБазаЗаЕдиницуНормыВремени КАК РасчетнаяБазаЗаЕдиницуНормыВремени,
			|	НачисленияНабораСНачислениямиСовместителей.ИдентификаторСтроки КАК ИдентификаторСтроки,
			|	НачисленияНабораСНачислениямиСовместителей.ПериодРегистрацииВремени КАК ПериодРегистрацииВремени,
			|	НачисленияНабораСНачислениямиСовместителей.ДоляРезультата КАК ДоляРезультата
			|ИЗ
			|	ВТНачисленияНабораСНачислениямиСовместителей КАК НачисленияНабораСНачислениямиСовместителей
			|ГДЕ
			|	НачисленияНабораСНачислениямиСовместителей.ДобавленноеНачислениеНабора";
				
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаписиДобавлялись = Истина;
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
				// Записи с нулевыми идентификаторами - "технические" записи подработок и внутренних совместителей.
				НоваяЗапись.ИдентификаторСтроки = 0;
				Если ДобавленныеЗаписи <> НеОпределено Тогда
					ДобавленныеЗаписи.Добавить(НоваяЗапись);
				КонецЕсли;
			КонецЦикла;
			
			// Дублирование начислений внутренних подработок
			Запрос.Текст =
			"ВЫБРАТЬ
			|	СотрудникиОрганизации.Сотрудник КАК Сотрудник,
			|	СотрудникиОрганизацииПодработки.Сотрудник КАК Подработка
			|ПОМЕСТИТЬ ВТСотрудникиСПодработками
			|ИЗ
			|	ВТСотрудникиОрганизации КАК СотрудникиОрганизации
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТСотрудникиОрганизации КАК СотрудникиОрганизацииПодработки
			|		ПО СотрудникиОрганизации.ФизическоеЛицо = СотрудникиОрганизацииПодработки.ФизическоеЛицо
			|			И СотрудникиОрганизации.Сотрудник = СотрудникиОрганизацииПодработки.ГоловнойСотрудник
			|			И (СотрудникиОрганизацииПодработки.ВидЗанятости = ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Подработка))
			|ГДЕ
			|	СотрудникиОрганизации.ВидЗанятости <> ЗНАЧЕНИЕ(Перечисление.ВидыЗанятости.Подработка)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	НачисленияНабора.ПериодРегистрации КАК ПериодРегистрации,
			|	НачисленияНабора.Регистратор КАК Регистратор,
			|	НачисленияНабора.НомерСтроки КАК НомерСтроки,
			|	НачисленияНабора.ВидРасчета КАК ВидРасчета,
			|	НачисленияНабора.ПериодДействия КАК ПериодДействия,
			|	НачисленияНабора.ПериодДействияНачало КАК ПериодДействияНачало,
			|	НачисленияНабора.ПериодДействияКонец КАК ПериодДействияКонец,
			|	НачисленияНабора.БазовыйПериодНачало КАК БазовыйПериодНачало,
			|	НачисленияНабора.БазовыйПериодКонец КАК БазовыйПериодКонец,
			|	НачисленияНабора.Активность КАК Активность,
			|	НачисленияНабора.Сторно КАК Сторно,
			|	СотрудникиСПодработками.Подработка КАК Сотрудник,
			|	НачисленияНабора.ФизическоеЛицо КАК ФизическоеЛицо,
			|	НачисленияНабора.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
			|	0 КАК Результат,
			|	0 КАК ОтработаноДней,
			|	0 КАК ОтработаноЧасов,
			|	0 КАК РезультатВТомЧислеЗаСчетФБ,
			|	НачисленияНабора.ГрафикРаботы КАК ГрафикРаботы,
			|	НачисленияНабора.ВидУчетаВремени КАК ВидУчетаВремени,
			|	НачисленияНабора.ВремяВЧасах КАК ВремяВЧасах,
			|	НачисленияНабора.ГрафикРаботыНорма КАК ГрафикРаботыНорма,
			|	НачисленияНабора.ОбщийГрафик КАК ОбщийГрафик,
			|	НачисленияНабора.Организация КАК Организация,
			|	НачисленияНабора.ФиксСтрока КАК ФиксСтрока,
			|	НачисленияНабора.ФиксЗаполнение КАК ФиксЗаполнение,
			|	НачисленияНабора.ФиксРасчетВремени КАК ФиксРасчетВремени,
			|	НачисленияНабора.ФиксРасчет КАК ФиксРасчет,
			|	НачисленияНабора.РасчетнаяБазаЗаЕдиницуНормыВремени КАК РасчетнаяБазаЗаЕдиницуНормыВремени,
			|	НачисленияНабора.ИдентификаторСтроки КАК ИдентификаторСтроки,
			|	НачисленияНабора.ПериодРегистрацииВремени КАК ПериодРегистрацииВремени,
			|	НачисленияНабора.ПериодРегистрацииНормыВремени КАК ПериодРегистрацииНормыВремени,
			|	НачисленияНабора.ДоляРезультата КАК ДоляРезультата
			|ИЗ
			|	ВТСотрудникиСПодработками КАК СотрудникиСПодработками
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТНачисленияНабораСНачислениямиСовместителей КАК НачисленияНабора
			|		ПО СотрудникиСПодработками.Сотрудник = НачисленияНабора.Сотрудник
			|		ЛЕВОЕ СОЕДИНЕНИЕ ВТНачисленияНабораСНачислениямиСовместителей КАК НачисленияНабораГоловныхСотрудников
			|		ПО СотрудникиСПодработками.Подработка = НачисленияНабораГоловныхСотрудников.Сотрудник
			|			И (НачисленияНабора.ВидРасчета = НачисленияНабораГоловныхСотрудников.ВидРасчета)
			|			И (НачисленияНабора.ПериодДействияНачало = НачисленияНабораГоловныхСотрудников.ПериодДействияНачало)
			|			И (НачисленияНабора.ПериодДействияКонец = НачисленияНабораГоловныхСотрудников.ПериодДействияКонец)
			|ГДЕ
			|	НачисленияНабораГоловныхСотрудников.Сотрудник ЕСТЬ NULL";
			
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ЗаписиДобавлялись = Истина;
				НоваяЗапись = НаборЗаписей.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
				// Записи с нулевыми идентификаторами - "технические" записи подработок и внутренних совместителей.
				НоваяЗапись.ИдентификаторСтроки = 0;
				Если ДобавленныеЗаписи <> НеОпределено Тогда
					ДобавленныеЗаписи.Добавить(НоваяЗапись);
				КонецЕсли;
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
		
	Возврат ЗаписиДобавлялись;
	
КонецФункции

Функция ЕстьДвиженияПоРегистратору(Регистратор) Экспорт 
	Если Не ЗначениеЗаполнено(Регистратор) Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ИСТИНА КАК Поле1
	|ИЗ
	|	РегистрРасчета.Начисления КАК Начисления
	|ГДЕ
	|	Начисления.Регистратор = &Регистратор";
	
	Возврат Не Запрос.Выполнить().Пустой();
КонецФункции	

// Сторнирование движений документа исправленного в текущем периоде.
//
// Параметры:
//  НаборЗаписей		 - РегистрНакопленияНаборЗаписей - Целевой набор записей в который будут добавлены сторнирующие строки.
//  ИсправленныйДокумент - ДокументСсылка				 - Документ, записи которого необходимо сторнировать.
//  Записывать			 - Булево						 - Если Истина, то набор будет записан сразу, если Ложь, то набору будет установлен признак Записывать = Истина.
//
Процедура СторнироватьДвиженияВТекущемПериоде(НаборЗаписей, ИсправленныйДокумент, Записывать = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборИсправленный = СоздатьНаборЗаписей();
	НаборИсправленный.Отбор.Регистратор.Установить(ИсправленныйДокумент);
	НаборИсправленный.Прочитать();
	
	Если НаборИсправленный.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеРесурсыРегистра = Метаданные.РегистрыРасчета.Начисления.Ресурсы;
	
	Для Каждого Строка Из НаборИсправленный Цикл
		
		Если Строка.Сторно
			Или (Строка.СторноТекущегоПериода <> Неопределено И Строка.СторноТекущегоПериода <> ИсправленныйДокумент) Тогда
			Продолжить;
		КонецЕсли;
		
		// "Сторнируем" набор записей исправленного документа.
		МинусСтрока = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(МинусСтрока, Строка);
		Для Каждого Ресурс Из МетаданныеРесурсыРегистра Цикл
			МинусСтрока[Ресурс.Имя] = - МинусСтрока[Ресурс.Имя];
		КонецЦикла;
		МинусСтрока.СторноТекущегоПериода = ИсправленныйДокумент;
		МинусСтрока.ИдентификаторСтроки = - МинусСтрока.ИдентификаторСтроки;
		
		// "Выключим" запись исправленного документа из расчета ФПД.
		Строка.СторноТекущегоПериода = ИсправленныйДокумент;
		НаборИсправленный.Записывать = Истина;
		
	КонецЦикла;
	
	Если НаборИсправленный.Записывать Тогда
		НаборИсправленный.ОбменДанными.Загрузка = Истина;
		НаборИсправленный.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		НаборИсправленный.Записать();
	КонецЕсли;
	
	Если Записывать Тогда
		НаборЗаписей.Записать();
		НаборЗаписей.Записывать = Ложь;
	Иначе
		НаборЗаписей.Записывать = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриОтменеИсправленияВТекущемПериоде(ИсправленныйДокумент) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НаборИсправленный = СоздатьНаборЗаписей();
	НаборИсправленный.Отбор.Регистратор.Установить(ИсправленныйДокумент);
	НаборИсправленный.Прочитать();
	
	Для Каждого Строка Из НаборИсправленный Цикл
		Если Строка.СторноТекущегоПериода = ИсправленныйДокумент Тогда
			Строка.СторноТекущегоПериода = Неопределено;
			НаборИсправленный.Записывать = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если НаборИсправленный.Записывать Тогда
		НаборИсправленный.ОбменДанными.Загрузка = Истина;
		НаборИсправленный.ДополнительныеСвойства.Вставить("ОтключитьПроверкуДатыЗапретаИзменения", Истина);
		НаборИсправленный.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли