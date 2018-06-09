#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	УчетНДФЛВызовСервера.ВидыВычетовНДФЛОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура НачальноеЗаполнение() Экспорт
	
	ЗаполнитьКодыВычетовНДФЛ();
	ОбновлениеДоходовВычетовНДФЛПредопределенныхЯнварь2012();
	ОписатьВычетПоДСВ();
	УстановитьВременныйКодВычету320();
	
КонецПроцедуры

Процедура ЗаполнитьКодыВычетовНДФЛ()
	
	ВычетыНДФЛ = Справочники.ВидыВычетовНДФЛ;
	ГруппыВычетов = Перечисления.ГруппыВычетовПоНДФЛ;
	
	ОписатьКодВычетаНДФЛ("Код103", "103", "400 руб. на налогоплательщика, не относящегося к категориям, перечисленным в пп. 1-2 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные);
	ОписатьКодВычетаНДФЛ("Код104", "104", "500 рублей на налогоплательщика, относящегося к категориям, перечисленным в пп. 2 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные);
	ОписатьКодВычетаНДФЛ("Код105", "105", "3000 рублей на налогоплательщика, относящегося к категориям, перечисленным в пп. 1 п. 1 ст. 218 Налогового кодекса Российской Федерации", Ложь, ГруппыВычетов.Стандартные);
	ОписатьКодВычетаНДФЛ("Код108", "114 (108)", "На первого ребенка в возрасте до 18 лет, на учащегося очной формы обучения, аспиранта, ординатора, студента, курсанта в возрасте до 24 лет", Ложь, ГруппыВычетов.СтандартныеНаДетей, "108", "114");
	ОписатьКодВычетаНДФЛ("Код109", "117 (109)", "На ребенка-инвалида до 18 лет, на учащегося очной формы обучения, аспиранта, ординатора, студента до 24 лет, явл. инвалидом I или II группы", Ложь, ГруппыВычетов.СтандартныеНаДетей, "109", "117");
	ОписатьКодВычетаНДФЛ("Код110", "118 (110)", "В двойном размере на первого ребенка до 18 лет, на учащегося очной формы обучения до 24 лет единственному родителю, опекуну, попечителю", Ложь, ГруппыВычетов.СтандартныеНаДетей, "110", "118");
	ОписатьКодВычетаНДФЛ("Код111", "122 (111)", "В двойном размере на первого ребенка до 18 лет, на учащегося очной формы обучения до 24 лет при отказе второго родителя от вычета", Ложь, ГруппыВычетов.СтандартныеНаДетей, "111", "122");
	ОписатьКодВычетаНДФЛ("Код112", "121 (112)", "В двойном размере на ребенка-инвалида до 18 лет, на учащегося очной формы обучения до 24 лет, явл. инвалидом, единственному родителю, опекуну и др.", Ложь, ГруппыВычетов.СтандартныеНаДетей, "112", "121");
	ОписатьКодВычетаНДФЛ("Код113", "125 (113)", "В двойном размере на ребенка-инвалида до 18 лет, на учащегося очной формы обучения до 24 лет, явл. инвалидом, при отказе второго родителя от вычета", Ложь, ГруппыВычетов.СтандартныеНаДетей, "113", "125");
	ОписатьКодВычетаНДФЛ("Код115", "115", "На второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсанта в возрасте до 24", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "115");
	ОписатьКодВычетаНДФЛ("Код116", "116", "На третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, к", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "116");
	ОписатьКодВычетаНДФЛ("Код119", "119", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсант", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "119");
	ОписатьКодВычетаНДФЛ("Код120", "120", "В двойном размере на третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ордин", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "120");
	ОписатьКодВычетаНДФЛ("Код123", "123", "В двойном размере на второго ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ординатора, студента, курсант", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "123");
	ОписатьКодВычетаНДФЛ("Код124", "124", "В двойном размере на третьего и каждого последующего ребенка в возрасте до 18 лет, а также на каждого учащегося очной формы обучения, аспиранта, ордин", Ложь, ГруппыВычетов.СтандартныеНаДетей, "-"  , "124");

 	ОписатьКодВычетаНДФЛ("Код311", "311", "Сумма, израсходованная налогоплательщиком на новое строительство либо приобретение на территории РФ жилого дома, квартиры или доли (долей) в них", Ложь, ГруппыВычетов.Имущественные);
	ОписатьКодВычетаНДФЛ("Код312", "312", "Сумма, направленная на погашение процентов по целевым займам (кредитам) на новое строительство или приобретение на территории РФ жилого дома, квартиры", Ложь, ГруппыВычетов.Имущественные);
	ОписатьКодВычетаНДФЛ("Код318", "318", "Сумма процентов по кредитам в целях перекредитования кредитов на новое строительство или приобретение на территории РФ жилого дома, квартиры", Ложь, ГруппыВычетов.Имущественные);
	ОписатьКодВычетаНДФЛ("Код319", "319", "Сумма упл-х пенс-х взносов по договору негосударственного пенсионного обеспечения и/или страх-х взносов по договору добровольного пенсионного страх-ия", Ложь, ГруппыВычетов.Социальные);
	
	ОписатьКодВычетаНДФЛ("Код201", "201", "Расходы по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг");
	ОписатьКодВычетаНДФЛ("Код202", "202", "Расходы по операциям с ценными бумагами, не обращающимися на организованном рынке ценных бумаг");
	ОписатьКодВычетаНДФЛ("Код203", "203", "Расходы по операциям с ценными бумагами, не обр-мися на орг.рынке ценных бумаг, которые на момент их приобретения обр-лись на орг.рынке ценных бумаг");
	ОписатьКодВычетаНДФЛ("Код204", "204", "Убыток по опер-ям с цен.бумагами, не обр-ся на орг. рынке, которые на момент приобретения обр-сь на орг. рынке, уменьш. нал. базу доходов с кодом 1530");
	ОписатьКодВычетаНДФЛ("Код205", "205", "Убыток по операциям с ценными бумагами, обращающимися на организованном рынке ценных бумаг, уменьшающий налоговую базу доходов с кодом 1532");
	ОписатьКодВычетаНДФЛ("Код206", "206", "Расходы по доходам с кодом 1532");
	ОписатьКодВычетаНДФЛ("Код207", "207", "Расходы по доходам с кодом 1535");
	ОписатьКодВычетаНДФЛ("Код208", "208", "Убыток по опер. с фин.инстр. срочных сделок, обр-ся на орг. рынке, базисным активом которых явл. цен.бумаги, уменьш. нал. базу доходов с кодом 1530");
	ОписатьКодВычетаНДФЛ("Код209", "209", "Убыток по опер. с фин.инстр. ср.сделок, обр-ся на орг.рынке, базисным активом кот. не явл. цен.бумаги,  уменьш. нал. базу по опер. с фин.инстр. ср.сд.");
	ОписатьКодВычетаНДФЛ("Код210", "210", "Сумма убытка по опер-ям с фин. инстр-ми срочных сделок, обр-ся на орг. рынке цен.бумаг и базисным активом кот. явл. цен.бумаги, фондовые индексы ...", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код211", "211", "Расходы, в виде процентов по займу, произведенные по совокупности операций РЕПО", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код212", "212", "Сумма превыш. расходов по опер-ям РЕПО над доходами по опер-ям РЕПО, уменьш. налог. базу по опер-ям с цен.бумагами, обр-ся на орг. рынке ценных бумаг", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код213", "213", "Расходы по операциям, связанным с закрытием короткой позиции, и затраты, связанные с приобр-ем и реализацией ценных бумаг, явл. объектом операций РЕПО", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код214", "214", "Убытки по операциям, связанным с закрытием короткой позиции, и затраты, связанные с приобр-ем и реализацией ценных бумаг, явл. объектом операций РЕПО", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код215", "215", "Расходы в виде процентов, уплаченных в налоговом периоде по совокупности договоров займа", Ложь, , "-");
	ОписатьКодВычетаНДФЛ("Код216", "216", "Сумма превыш. расходов в виде %% по дог-ам займа над доходами по дог-ам займа, уменьш. налог. базу по опер-ям с цен.бумагами, обр-ся на орг. рынке", Ложь, , "-");	
 	ОписатьКодВычетаНДФЛ("Код403", "403", "Сумма фактически произведенных и документально подтвержденных расходов, связанных с выполнением работ (оказанием услуг) по договорам ГПХ");
	ОписатьКодВычетаНДФЛ("Код404", "404", "Сумма фактически произведенных и документально подтвержденных расходов, связанных с получением авторских вознаграждений");
	ОписатьКодВычетаНДФЛ("Код405", "405", "Сумма в пределах нормативов затрат, связанных с получением авторских вознаграждений");
	ОписатьКодВычетаНДФЛ("Код501", "501", "Вычет из стоимости подарков, полученных от организаций и индивидуальных предпринимателей");
	ОписатьКодВычетаНДФЛ("Код502", "502", "Вычет из стоимости призов в денежной и натуральной форме на конкурсах и соревнованиях, проводимых в соотв. с решениями Прав-ва РФ и др. органов власти");
	ОписатьКодВычетаНДФЛ("Код503", "503", "Вычет из суммы материальной помощи, оказываемой работодателями своим работникам, а также бывшим своим работникам-пенсионерам");
	ОписатьКодВычетаНДФЛ("Код504", "504", "Вычет из суммы возмещения (оплаты) работодателями своим работникам, бывшим своим работникам (пенсионерам), а также инвалидам стоимости медикаментов");
	ОписатьКодВычетаНДФЛ("Код505", "505", "Вычет из стоимости выигрышей и призов, полученных на конкурсах, играх и других мероприятиях в целях рекламы товаров (работ, услуг)");
	ОписатьКодВычетаНДФЛ("Код506", "506", "Вычет из суммы материальной помощи, оказываемой инвалидам общественными организациями инвалидов");
	ОписатьКодВычетаНДФЛ("Код507", "507", "Вычет из суммы помощи (в денежной и натуральной формах), а также стоимости подарков, полученных ветеранами, инвалидами ВОВ и приравненных к ним");
	ОписатьКодВычетаНДФЛ("Код508", "508", "Вычет из суммы материальной помощи, оказываемой работодателями своим работникам при рождении (усыновлении) ребенка");
	ОписатьКодВычетаНДФЛ("Код509", "509", "Вычет из доходов, полученных работниками в натуральной форме в качестве оплаты труда от организаций - с/х товаропроизводителей и крестьянских х-в");
	ОписатьКодВычетаНДФЛ("Код601", "601", "Сумма, уменьшающая налоговую базу по доходам, полученным в виде дивидендов");
	ОписатьКодВычетаНДФЛ("Код607", "607", "Вычет в сумме уплаченных работодателем страховых взносов за работника на накопительную часть трудовой пенсии, но не более 12000 рублей в год");
	ОписатьКодВычетаНДФЛ("Код620", "620", "Иные суммы, уменьшающие налоговую базу в соответствии с положениями главы 23 Налогового кодекса Российской Федерации");

КонецПроцедуры	

Процедура ОбновлениеДоходовВычетовНДФЛПредопределенныхЯнварь2012() Экспорт

	ВычетыНДФЛ = Справочники.ВидыВычетовНДФЛ;
	
	ОписатьКодВычетаНДФЛ("Код210", "210", "Сумма убытка по опер-ям с фин. инстр-ми срочных сделок, обр-ся на орг. рынке цен.бумаг и базисным активом кот. явл. цен.бумаги, фондовые индексы ...", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код211", "211", "Расходы, в виде процентов по займу, произведенные по совокупности операций РЕПО", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код212", "212", "Сумма превыш. расходов по опер-ям РЕПО над доходами по опер-ям РЕПО, уменьш. налог. базу по опер-ям с цен.бумагами, обр-ся на орг. рынке ценных бумаг", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код213", "213", "Расходы по операциям, связанным с закрытием короткой позиции, и затраты, связанные с приобр-ем и реализацией ценных бумаг, явл. объектом операций РЕПО", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код214", "214", "Убытки по операциям, связанным с закрытием короткой позиции, и затраты, связанные с приобр-ем и реализацией ценных бумаг, явл. объектом операций РЕПО", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код215", "215", "Расходы в виде процентов, уплаченных в налоговом периоде по совокупности договоров займа", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код216", "216", "Сумма превыш. расходов в виде %% по дог-ам займа над доходами по дог-ам займа, уменьш. налог. базу по опер-ям с цен.бумагами, обр-ся на орг. рынке", , , "-"); // с 2011 г.
	ОписатьКодВычетаНДФЛ("Код217", "217", "Сумма превыш. расходов в виде %% по дог-ам займа над доходами по дог-ам займа, уменьш. налог. базу по опер-ям с цен.бумагами, не обр-ся на орг. рынке", , , "-"); // с 2011 г.
	
КонецПроцедуры

Процедура ОписатьВычетПоДСВ() Экспорт

	ОписатьКодВычетаНДФЛ("Код320", "320", "Сумма уплаченных дополнительных страховых взносов на накопительную часть трудовой пенсии в соответствии с Федеральным законом от 30.04.2008 № 56-ФЗ", Ложь, Перечисления.ГруппыВычетовПоНДФЛ.Социальные, "-");
	
КонецПроцедуры

Процедура УстановитьВременныйКодВычету320() Экспорт

	Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Справочники.ВидыВычетовНДФЛ.Код320,"КодПрименяемыйВНалоговойОтчетностиС2011Года") <> "620" Тогда
		ОписатьКодВычетаНДФЛ("Код320", "320", "Сумма уплаченных дополнительных страховых взносов на накопительную часть трудовой пенсии в соответствии с Федеральным законом от 30.04.2008 № 56-ФЗ", Ложь, Перечисления.ГруппыВычетовПоНДФЛ.Социальные, "-", "620"); 
	КонецЕсли;	

КонецПроцедуры

Процедура ОписатьКодВычетаНДФЛ(ИмяПредопределенныхДанных, Код, Наименование, ВычетКДоходу = Истина, ГруппаВычета = Неопределено, Код2010 = "", Код2011 = "") 

	СсылкаПредопределенного = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыВычетовНДФЛ." + ИмяПредопределенныхДанных);
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		Элемент = СсылкаПредопределенного.ПолучитьОбъект();
	Иначе
		Элемент = Справочники.ВидыВычетовНДФЛ.СоздатьЭлемент();
		Элемент.ИмяПредопределенныхДанных = ИмяПредопределенныхДанных;
	КонецЕсли;

	Элемент.Код = Код;
	Элемент.Наименование = Наименование;
	
	Если ЗначениеЗаполнено(Код2010) Тогда
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2010Года = Код2010;
	Иначе 	
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2010Года = Элемент.Код;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Код2011) Тогда
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2011Года = Код2011;
	Иначе  	
		Элемент.КодПрименяемыйВНалоговойОтчетностиС2011Года = Элемент.Код;
	КонецЕсли;

	Элемент.ВычетКДоходу = ВычетКДоходу;
	Элемент.ГруппаВычета = ГруппаВычета;

	Элемент.ОбменДанными.Загрузка = Истина;
	Элемент.Записать();

КонецПроцедуры

#КонецОбласти

#КонецЕсли

