
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВедущийОбъект", ОбъектВладелец);
	Если Не ЗначениеЗаполнено(ОбъектВладелец) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Префикс", ПрефиксВедущегоОбъекта);
	
	// Если объект еще не заблокирован для изменений и есть права на изменение набора
	// попытаемся установить блокировку.
	Если НЕ ТолькоПросмотр И НЕ Пользователи.РолиДоступны("ДобавлениеИзменениеДанныхРегистраСведений") Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли; 
	
	Если ТолькоПросмотр Тогда
		
		Элементы.НаборЗаписей.ТолькоПросмотр = Истина;
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы, 
			"ФормаКомандаОК",
			"Доступность",
			Ложь);
		
		Элементы.ФормаКомандаОтмена.КнопкаПоУмолчанию = Истина;
		
	КонецЕсли;
	
	Для Каждого ЗаписьНабора Из Параметры.МассивЗаписей Цикл
		
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, ЗаписьНабора);
		НоваяЗапись.ПериодГод = Год(НоваяЗапись.Период);
		
	КонецЦикла;
	
	НаборЗаписей.Сортировать("Период");
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	ПараметрОповещения = Новый Структура("ИмяРегистра,МассивЗаписей,Префикс", "РазмерВычетовНДФЛ", НаборЗаписей, ПрефиксВедущегоОбъекта);
	Оповестить("ОтредактированаИстория", ПараметрОповещения, ОбъектВладелец);
	ЭтаФорма.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если Не НоваяСтрока Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элемент.ТекущиеДанные.КодВычета = ОбъектВладелец;
	НовыйПериод = НачалоГода(ОбщегоНазначенияКлиент.ДатаСеанса());
	Если НаборЗаписей.Количество() > 1 Тогда
		ПоследнийПериод = НаборЗаписей.Получить(НаборЗаписей.Количество() - 2).Период;
	Иначе
		ПоследнийПериод = '00010101000000';
	КонецЕсли; 
	Если НовыйПериод <= ПоследнийПериод Тогда
		НовыйПериод = КонецГода(ПоследнийПериод) + 1;
	КонецЕсли; 
	Элемент.ТекущиеДанные.Период = НовыйПериод;
	Элемент.ТекущиеДанные.ПериодГод = Год(НовыйПериод);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Элемент.ТекущиеДанные.Период) Тогда
		СообщениеОбОшибке = НСтр("ru = 'Необходимо указать дату сведений'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "НаборЗаписей.Период", , Отказ);
	Иначе
		НайденныеСтроки = НаборЗаписей.НайтиСтроки(Новый Структура("Период", Элемент.ТекущиеДанные.Период));
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока <> Элемент.ТекущиеДанные Тогда
				СообщениеОбОшибке = НСтр("ru = 'Уже есть запись с указанной датой сведений'");
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "НаборЗаписей.Период", , Отказ);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеПериодическихСведенийКлиент.УпорядочитьНаборЗаписейВФорме(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодПриИзменении(Элемент)
	
	ПериодГод = Элементы.НаборЗаписей.ТекущиеДанные.ПериодГод;
	Элементы.НаборЗаписей.ТекущиеДанные.Период = Дата(ПериодГод,1,1);
	
КонецПроцедуры

&НаКлиенте
Процедура НаборЗаписейПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ПериодГод = Элементы.НаборЗаписей.ТекущиеДанные.ПериодГод;
	Элементы.НаборЗаписей.ТекущиеДанные.Период = Дата(ПериодГод,1,1);
	
КонецПроцедуры


