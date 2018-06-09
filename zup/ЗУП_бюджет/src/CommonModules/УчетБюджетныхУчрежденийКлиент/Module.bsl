
#Область СлужебныеПроцедурыИФункции

#Область НастройкаРасчетаЗарплаты

Процедура УстановитьЗначенияЗависимыхНастроекРасчетаЗарплаты(Форма, ИспользоватьНачислениеЗарплаты) Экспорт

	Если Не Форма.РаботаВБюджетномУчреждении Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользоватьНачислениеЗарплаты Тогда
		
		ЗаполнитьЗначенияСвойств(Форма.НастройкиБюджетныхУчрежденийПрежняя, Форма.НастройкиБюджетныхУчреждений);
		Форма.НастройкиБюджетныхУчреждений.ИспользоватьУчетВРазрезеИФО = Ложь;
		
	Иначе
		
		// Восстановим прежние значения зависимых настроек.
		ЗаполнитьЗначенияСвойств(Форма.НастройкиБюджетныхУчреждений, Форма.НастройкиБюджетныхУчрежденийПрежняя);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

Процедура УстановитьИнформационнуюСсылкуПереносаДанных(ИмяИсточника, ИнформационнаяСсылка, РаботаВБюджетномУчреждении) Экспорт
	
	Если ИмяИсточника = "ЗарплатаИКадрыГосударственногоУчреждения" Тогда
		ИнформационнаяСсылка = "";
	ИначеЕсли ИмяИсточника = "ЗарплатаИКадрыБюджетногоУчреждения" Тогда
		ИнформационнаяСсылка = "http://its.1c.ru/db/metbud81#content:6209:hdoc";
	ИначеЕсли ИмяИсточника = "МедицинаЗарплатаИКадрыБюджетногоУчреждения" Тогда
		ИнформационнаяСсылка = "";
	ИначеЕсли РаботаВБюджетномУчреждении И ИмяИсточника = "Зарплата+Кадры. Редакция 2.3" Тогда
		ИнформационнаяСсылка = "http://its.1c.ru/db/metbud81#content:6220:hdoc";
	КонецЕсли;
	
КонецПроцедуры

Процедура ОткрытьФормуСпискаДокументаОтражениеЗарплатыВБухучетеБюджетныхУчреждений(ПараметрыФормы = Неопределено, ВладелецФормы = Неопределено) Экспорт
	
	ОткрытьФорму("Документ.ОтражениеЗарплатыВБухучетеБюджетныхУчреждений.ФормаСписка", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

#КонецОбласти