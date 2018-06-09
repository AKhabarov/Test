
#Область СлужебныйПрограммныйИнтерфейс

#Область ДатыИзмененийЗаконодательства

// Возвращает дату вступления в силу Федерального закона от 3 июля 2016 года № 243-ФЗ.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаПередачиАдминистрированияВзносовФНС() Экспорт 

	Возврат '20170101'

КонецФункции

// Возвращает дату вступления в силу нормативного акта.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаВводаВзносовНаДоплатуШахтерам() Экспорт 

	Возврат '20110101'

КонецФункции 

// Возвращает дату вступления в силу нормативного акта.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаВводаВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией() Экспорт 

	Возврат '20130101'

КонецФункции 

// Возвращает дату вступления в силу нормативного акта.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаОтменыТФОМС() Экспорт 

	Возврат '20120101'

КонецФункции 

// Возвращает дату вступления в силу Федерального закона "О внесении изменений в отдельные законодательные акты
// Российской Федерации по вопросам обязательного пенсионного страхования в части права выбора застрахованными лицами
// варианта пенсионного обеспечения".
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР() Экспорт 

	Возврат '20140101'

КонецФункции 

// Возвращает дату вступления в силу приказа Минфина РФ.
//
// Параметры:
//  нет
//
// Возвращаемое значение:
//   дата
//
Функция ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины() Экспорт 

	Возврат '20160101'

КонецФункции 

/////////////////////////////////////////////////////////////////////////////////////////

// Возвращает строку-перечень полей ресурсов страховых взносов.
//
// Параметры:
//	БезЕНВД - булево - необязательный, если Истина, в строку будут включены парные ЕНВДные поля.
//  ИмяТаблицы - строка - необязательный, если задан, строка результат может использоваться как часть текста запроса к
//                        таблице, содержащей соответствующие поля.
//	ВключатьДопТарифы - булево - необязательный, если Истина, в строку будут включены поля взносов по дополнительным
//	                             тарифам для вредников.
//
// Возвращаемое значение:
//	Строка.
// 
Функция РассчитываемыеВзносыВПФР(БезЕНВД = Ложь, ИмяТаблицы = "", ВключатьДопТарифы = Истина, ВключатьСпецоценку = Истина) Экспорт
	
	ИмяТаблицыСТочкой = "";
	Если ЗначениеЗаполнено(ИмяТаблицы) Тогда
		ИмяТаблицыСТочкой = ИмяТаблицы + "."
	КонецЕсли;
	
	ПереченьРесурсов = "ПФРДоПредельнойВеличины,ПФРСПревышения,ПФРПоСуммарномуТарифу,ПФРСтраховая,ПФРНакопительная" + ?(ВключатьДопТарифы, "," + ВзносыПоДополнительнымТарифам(),"") + ?(БезЕНВД,"",",ПФРДоПредельнойВеличиныЕНВД,ПФРСПревышенияЕНВД,ПФРПоСуммарномуТарифуЕНВД,ПФРСтраховаяЕНВД,ПФРНакопительнаяЕНВД");
	Если ВключатьДопТарифы И ВключатьСпецоценку Тогда
		ПереченьРесурсов = ПереченьРесурсов + "," + ВзносыПоКодамСпециальнойОценки();
	КонецЕсли;
	
	Возврат ИмяТаблицыСТочкой + СтрЗаменить(ПереченьРесурсов, ",", "," + ИмяТаблицыСТочкой)
	
КонецФункции 

Функция РассчитываемыеВзносыВФСС(БезЕНВД = Ложь, ИмяТаблицы = "") Экспорт
	
	ИмяТаблицыСТочкой = "";
	Если ЗначениеЗаполнено(ИмяТаблицы) Тогда
		ИмяТаблицыСТочкой = ИмяТаблицы + "."
	КонецЕсли;
	
	ПереченьРесурсов = "ФСС,ФССНесчастныеСлучаи" + ?(БезЕНВД,"",",ФССЕНВД");
	
	Возврат ИмяТаблицыСТочкой + СтрЗаменить(ПереченьРесурсов, ",", "," + ИмяТаблицыСТочкой)
	
КонецФункции 

Функция РассчитываемыеВзносыВФОМС(БезЕНВД = Ложь, ИмяТаблицы = "") Экспорт
	
	ИмяТаблицыСТочкой = "";
	Если ЗначениеЗаполнено(ИмяТаблицы) Тогда
		ИмяТаблицыСТочкой = ИмяТаблицы + "."
	КонецЕсли;
	
	ПереченьРесурсов = "ФФОМС,ТФОМС" + ?(БезЕНВД,"",",ФФОМСЕНВД,ТФОМСЕНВД");
	
	Возврат ИмяТаблицыСТочкой + СтрЗаменить(ПереченьРесурсов, ",", "," + ИмяТаблицыСТочкой)
	
КонецФункции 

// Возвращает строку-перечень полей ресурсов страховых взносов.
//
// Параметры:
//	БезЕНВД - булево - необязательный, если Истина, в строку будут включены парные ЕНВДные поля.
//  ИмяТаблицы - строка - необязательный, если задан, строка результат может использоваться как часть текста запроса к
//                        таблице, содержащей соответствующие поля.
//	ВключатьДопТарифы - булево - необязательный, если Истина, в строку будут включены поля взносов по дополнительным
//	                             тарифам для вредников.
//
// Возвращаемое значение:
//	Строка.
// 
Функция РассчитываемыеВзносы(БезЕНВД = Ложь, ИмяТаблицы = "", ВключатьДопТарифы = Истина, ВключатьСпецоценку = Истина) Экспорт
	
	Возврат РассчитываемыеВзносыВПФР(БезЕНВД, ИмяТаблицы, ВключатьДопТарифы, ВключатьСпецоценку) + "," + РассчитываемыеВзносыВФСС(БезЕНВД, ИмяТаблицы) + "," + РассчитываемыеВзносыВФОМС(БезЕНВД, ИмяТаблицы)
	
КонецФункции 

// Возвращает строку-перечень полей ресурсов страховых взносов, по которым ведутся расчеты с фондами.
//
// Параметры:
//	БезЕНВД - булево - необязательный, если Истина, в строку будут включены парные ЕНВДные поля.
//  ИмяТаблицы - строка - необязательный, если задан, строка результат может использоваться как часть текста запроса к
//                        таблице, содержащей соответствующие поля.
//	ВключатьДопТарифы - булево - необязательный, если Истина, в строку будут включены поля взносов по дополнительным
//	                             тарифам для вредников.
//
// Возвращаемое значение:
//	Строка.
// 
Функция ОтражаемыеВУчетеВзносы(БезЕНВД = Ложь, ИмяТаблицы = "", ВключатьДопТарифы = Истина) Экспорт
	
	ИмяТаблицыСТочкой = "";
	Если ЗначениеЗаполнено(ИмяТаблицы) Тогда
		ИмяТаблицыСТочкой = ИмяТаблицы + "."
	КонецЕсли;
	
	ПереченьРесурсов = СтрЗаменить(ВзносыЗаВредников(), ",", "БезСпецОценки,") + СтрЗаменить(ВзносыЗаВредников(), ",", "СпецОценка,");
	
	Возврат РассчитываемыеВзносы(БезЕНВД, ИмяТаблицы, ВключатьДопТарифы, Ложь) + ?(ВключатьДопТарифы, "," + ИмяТаблицыСТочкой + СтрЗаменить(Лев(ПереченьРесурсов, СтрДлина(ПереченьРесурсов) - 1), ",", "," + ИмяТаблицыСТочкой), "");
	
КонецФункции 

// Возвращает строку-перечень полей ресурсов страховых взносов по дополнительным тарифам для вредников.
//
// Параметры:
//	нет
//
// Возвращаемое значение:
//	Строка.
// 
Функция ВзносыЗаВредников() 
	
	Возврат "ПФРЗаЗанятыхНаПодземныхИВредныхРаботах,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах,"
	
КонецФункции 

// Возвращает строку-перечень полей ресурсов страховых взносов по дополнительным тарифам для вредников.
//
// Параметры:
//	нет
//
// Возвращаемое значение:
//	Строка.
// 
Функция ВзносыПоДополнительнымТарифам() Экспорт
	
	Возврат ВзносыЗаВредников() + "ПФРНаДоплатуЛетчикам,ПФРНаДоплатуШахтерам" 
	
КонецФункции 

// Возвращает строку-перечень полей ресурсов страховых взносов по дополнительному тарифу по классам условий труда.
//
// Параметры:
//	нет
//
// Возвращаемое значение:
//	Строка.
// 
Функция ВзносыПоКодамСпециальнойОценки() Экспорт
	
	Возврат "ПФРЗаЗанятыхНаПодземныхИВредныхРаботахОпасный,ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный1,ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный2,ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный3,ПФРЗаЗанятыхНаПодземныхИВредныхРаботахВредный4,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахОпасный,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный1,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный2,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный3,ПФРЗаЗанятыхНаТяжелыхИПрочихРаботахВредный4"
	
КонецФункции 

/////////////////////////////////////////////////////////////////////////////////////////

// Возвращает текстовое описание для тарифа страховых взносов.
//
// Параметры:
//	ТарифСтраховыхВзносов - СправочникСсылка.ВидыТарифовСтраховыхВзносов -
//
// Возвращаемое значение:
//	Строка.
// 
Функция ОписаниеВидаТарифа(ТарифСтраховыхВзносов) Экспорт
	
	ОписаниеТарифа = "";	
	Если ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ОбщийНалоговыйРежим") Тогда
		ОписаниеТарифа = "Основной тариф страховых взносов установлен статьями 425 и 426 НК РФ (до 2017 года - статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.УпрощенныйНалоговыйРежим") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (с 2011 по 2016 годы -  статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ЕНВД") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (с 2011 по 2016 годы -  статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.СельХозПроизводители") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2010 год тариф был установлен пунктом 1 части 2 статьи 57, на 2011-2014 годы пунктом 1 части 1 статьи 58, в 2015 и 2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ЕСХН") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2010 год тариф был установлен пунктом 3 части 2 статьи 57, на 2011-2014 годы пунктом 2 части 1 статьи 58, в 2015 и 2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ОрганизацияИнвалидов") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2010 год тариф был установлен пунктом 2 части 2 статьи 57, на 2011-2014 годы пунктом 3 части 1 статьи 58, в 2015 и 2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.НародныеХудожественныеПромыслы") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2010 год тариф был установлен пунктом 1 части 2 статьи 57, на 2011-2014 годы пунктом 1 части 1 статьи 58, в 2015 и 2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.СМИ") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2011-2014 годы тариф был установлен пунктом 7 части 1 статьи 58, в 2015 и 2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ОрганизацииОказывающиеИнжиниринговыеУслуги") Тогда
		ОписаниеТарифа = "С 2017 года применяются ставки основного тарифа страховых взносов, установленные статьями 425 и 426 НК РФ (на 2012-2013 годы тариф был установлен пунктом 13 части 1 статьи 58, в 2014-2016 годах применялись ставки основного тарифа страховых взносов, установленные статьями 12 и 58.2 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
		
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ХозОбществаБюджетныхВУЗов") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2019 годы для страхователей, удовлетворяющих условиям подпункта 1 пункта 1 статьи 427 НК РФ (с 2011 по 2016 годы - пункта 4 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.РезидентТехникоВнедренческойЗоны") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2019 годы для страхователей, удовлетворяющих условиям подпункта 2 пункта 1 статьи 427 НК РФ (на 2010 год тариф был установлен пунктом 2 части 2 статьи 57, на 2011-2016 годы пунктом 5 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ITОрганизации") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2023 годы для страхователей, удовлетворяющих условиям подпункта 3 пункта 1 статьи 427 НК РФ (на 2010 год тариф был установлен пунктом 4 части 2 статьи 57, на 2011-2016 годы пунктом 6 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляЧленовЭкипажейМорскихСудовПодФлагомРФ") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2027 годы для страхователей, удовлетворяющих условиям подпункта 4 пункта 1 статьи 427 НК РФ (на 2012-2016 годы пунктом 9 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.УпрощенныйНалоговыйРежимПроизводство") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2018 годы для страхователей, удовлетворяющих условиям подпункта 5 пункта 1 статьи 427 НК РФ (с 2011 по 2016 годы - пункта 8 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ДляФармацевтовАптек") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2018 годы для аптечных организаций и индивидуальных предпринимателей подпунктом 6 пункта 1 статьи 427 НК РФ (с 2012 по 2016 годы - пунктом 10 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.НекоммерческиеОрганизации") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2018 годы для страхователей, удовлетворяющих условиям подпункта 7 пункта 1 статьи 427 НК РФ (с 2012 по 2016 годы - пункта 11 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.БлаготворительныеОрганизации") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2018 годы для страхователей, удовлетворяющих условиям подпункта 8 пункта 1 статьи 427 НК РФ (с 2012 по 2016 годы - пункта 12 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.ИндивидуальныйПредпринимательПрименяющийПатент") Тогда
		ОписаниеТарифа = "Тариф установлен на 2017-2018 годы для индивидуальных предпринимателей, применяющих патент подпунктом 9 пункта 1 статьи 427 НК РФ (с 2013 по 2016 годы - пункта 14 части 1 статьи 58 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.УчастникПроектаИнновационныйЦентрСколково") Тогда
		ОписаниеТарифа = "Тариф установлен для страхователей, удовлетворяющих условиям подпункта 10 пункта 1 статьи 427 НК РФ (до 2017 года - статьей 58.1 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.УчастникОсобойЗоныВКрыму") Тогда
		ОписаниеТарифа = "Тариф установлен для страхователей, удовлетворяющих условиям подпункта 11 пункта 1 статьи 427 НК РФ (в 2015 и 2016 годах - статьей 58.4 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.РезидентТерриторииОпережающегоСоциальноЭкономическогоРазвития") Тогда
		ОписаниеТарифа = "Тариф установлен для страхователей, удовлетворяющих условиям подпункта 12 пункта 1 статьи 427 НК РФ (в 2015 и 2016 годах - статьей 58.5 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
	ИначеЕсли ТарифСтраховыхВзносов = ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент("Справочник.ВидыТарифовСтраховыхВзносов.РезидентПортаВладивосток") Тогда
		ОписаниеТарифа = "Тариф установлен для страхователей, удовлетворяющих условиям подпункта 13 пункта 1 статьи 427 НК РФ (в 2016 году - статьей 58.6 Федерального закона от 24 июля 2009 г. № 212-ФЗ)"
		
	КонецЕсли;
	
	Возврат ОписаниеТарифа;
	
КонецФункции	

// Возвращает текстовое описание для вида застрахованного лица.
//
// Параметры:
//	ВидЗастрахованногоЛица - ПеречислениеСсылка.ВидыЗастрахованныхЛицОбязательногоСтрахования -
//
// Возвращаемое значение:
//	Строка.
// 
Функция ОписаниеВидаЗастрахованногоЛица(ВидЗастрахованногоЛица) Экспорт

	Если ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ГражданеРФ") Тогда
		Возврат НСтр("ru='На граждан России распространяется обязательное пенсионное, медицинское и социальное страхование в полном объеме.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ПостоянноПроживающиеИностранцы") Тогда
		Возврат НСтр("ru='На приравненных к гражданам РФ иностранных граждан и лиц без гражданства распространяется обязательное пенсионное, медицинское и социальное страхование в полном объеме. Страховые взносы уплачиваются в общеустановленном порядке.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВысококвалифицированныеСпециалистыПостоянноПроживающие") Тогда
		Возврат НСтр("ru='На постоянно проживающих на территории РФ иностранных граждан и лиц без гражданства, являющихся высококвалифицированными специалистами и членами их семей, распространяется обязательное пенсионное и социальное страхование в полном объеме. Страховые взносы в ПФР и ФСС уплачиваются в том же порядке, что и за граждан РФ'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВременноПроживающиеИностранцы") Тогда
		Возврат НСтр("ru='На временно проживающих на территории РФ иностранных граждан и лиц без гражданства распространяется обязательное медицинское и социальное страхование в полном объеме. В части пенсионного страхования все уплачиваемые взносы с 2012 года относятся к страховой части пенсии.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВысококвалифицированныеСпециалистыВременноПроживающие") Тогда
		Возврат НСтр("ru='На временно проживающих на территории РФ иностранных граждан и лиц без гражданства, являющихся высококвалифицированными специалистами и членами их семей, распространяется обязательное пенсионное и социальное страхование в полном объеме. В части пенсионного страхования все уплачиваемые взносы с 2012 года относятся к страховой части пенсии.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВысококвалифицированныеСпециалистыИзЕАЭС") Тогда
		Возврат НСтр("ru='На временно пребывающих на территории РФ граждан стран ЕАЭС, являющихся высококвалифицированными специалистами и членами их семей, с 1 января 2015 года распространяется обязательное медицинское и социальное страхование в полном объеме.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВременноПребывающиеИностранцыСтрахуемыеФСС") Тогда
		Возврат НСтр("ru='На временно пребывающих на территории РФ иностранных граждан стран, с которыми заключены соответствующие международные договоры, не распространяется медицинское страхование и пенсионное страхование в РФ. Обязательное социальное распространяется на таких лиц с 1 января 2015 года.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВременноПребывающиеИностранцы") Тогда
		Возврат НСтр("ru='На временно пребывающих на территории РФ иностранных граждан и лиц без гражданства не распространяется медицинское страхование в РФ. Обязательное социальное и пенсионное страхование распространяется на таких лиц с 1 января 2015 года, с 1 января 2012 года по 31 декабря 2014 года право на пенсионное страхование распространяется при условии заключения трудового договора на срок не менее 6 месяцев.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВременноПребывающиеИностранцыПризнанныеБеженцами") Тогда
		Возврат НСтр("ru='На временно пребывающих на территории РФ иностранных граждан и лиц без гражданства, получивших временное убежище на территории РФ или свидетельство о рассмотрении ходатайства о признании беженцем, распространяется обязательное медицинское страхование в РФ. Обязательное социальное и пенсионное страхование распространяется на таких лиц с 1 января 2015 года, с 1 января 2012 года по 31 декабря 2014 года право на пенсионное страхование распространяется при условии заключения трудового договора на срок не менее 6 месяцев.'");
	ИначеЕсли ВидЗастрахованногоЛица = ПредопределенноеЗначение("Перечисление.ВидыЗастрахованныхЛицОбязательногоСтрахования.ВременноПребывающиеИностранцыНестрахуемые") Тогда
		Возврат НСтр("ru='На нестрахуемых временно пребывающих на территории РФ иностранных граждан и лиц без гражданства (в том числе высококвалифицированных иностранных специалистов) не распространяется пенсионное, медицинское и социальное страхование в РФ.'");
	КонецЕсли;
	
	Возврат "";

КонецФункции 

/////////////////////////////////////////////////////////////////////////////////////////

// Формирует соответствие описания реквизитов, содержащих суммы взносов.
//      	 
// Параметры:
//		Месяц - дата - необязательный, указывает на месяц начисления, для которого могут использоваться те или иные колонки
//		               взносов.
//		ВключатьДопТарифы - булево - необязательный, если выставлен в Ложь, взносы по доп.тарифам в описание не включаются.
//
// Возвращаемое значение:
//		Соответствие
//
Функция ОписаниеПолейВзносовВСоответствии(Месяц = '00010101', ВключатьДопТарифы = Истина, ВключатьКолонкиЕНВД = Истина) Экспорт

	ДатаПоявленияВзносовНаДоплатуШахтерам = ДатаВводаВзносовНаДоплатуШахтерам();
	ДатаОтменыТФОМС = ДатаОтменыТФОМС();
	ДатаПоявленияВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией = ДатаВводаВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией();
	ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР = ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР();
	ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины = ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины();
	
	Описание = Новый Соответствие;
	
	Описание.Вставить("ФФОМС", "ФФОМС");
	Если ВключатьКолонкиЕНВД Тогда
		Описание.Вставить("ФФОМСЕНВД", "ФФОМС (ЕНВД)");
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Месяц) Или Месяц < ДатаОтменыТФОМС Тогда
		Описание.Вставить("ТФОМС", "ТФОМС");
		Если ВключатьКолонкиЕНВД Тогда
			Описание.Вставить("ТФОМСЕНВД", "ТФОМС (ЕНВД)");
		КонецЕсли;
	КонецЕсли;
	
	Описание.Вставить("ФСС", "ФСС");
	Если ВключатьКолонкиЕНВД Тогда
		Описание.Вставить("ФССЕНВД", "ФСС (ЕНВД)");
	КонецЕсли;
	Описание.Вставить("ФССНесчастныеСлучаи", "ФСС (несч. случ.)");
	
	Если Месяц < ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР Тогда
		Описание.Вставить("ПФРНакопительная", "ПФР (накоп.)");
		Описание.Вставить("ПФРСтраховая", "ПФР (страх.)");
		Если ВключатьКолонкиЕНВД Тогда
			Описание.Вставить("ПФРНакопительнаяЕНВД", "ПФР (накоп. ЕНВД)");
			Описание.Вставить("ПФРСтраховаяЕНВД", "ПФР (страх. ЕНВД)");
		КонецЕсли;
	ИначеЕсли Месяц < ДатаВыделенияВзносовНаОПСсСуммПревышенияПредельнойВеличины Тогда
		Описание.Вставить("ПФРПоСуммарномуТарифу", "ПФР (на ОПС)");
		Если ВключатьКолонкиЕНВД Тогда
			Описание.Вставить("ПФРПоСуммарномуТарифуЕНВД", "ПФР (на ОПС ЕНВД)");
		КонецЕсли;
	Иначе
		Описание.Вставить("ПФРДоПредельнойВеличины", "ПФР (на ОПС, до предела)");
		Если ВключатьКолонкиЕНВД Тогда
			Описание.Вставить("ПФРДоПредельнойВеличиныЕНВД", "ПФР (на ОПС, до предела ЕНВД)");
		КонецЕсли;
		Описание.Вставить("ПФРСПревышения", "ПФР (на ОПС, с превышения)");
		Если ВключатьКолонкиЕНВД Тогда
			Описание.Вставить("ПФРСПревышенияЕНВД", "ПФР (на ОПС, с превышения ЕНВД)");
		КонецЕсли;
	КонецЕсли;
	
	Если ВключатьДопТарифы Тогда
		Описание.Вставить("ПФРНаДоплатуЛетчикам", "ПФР (летн. экипаж)");
		Если Не ЗначениеЗаполнено(Месяц) Или Месяц >= ДатаПоявленияВзносовНаДоплатуШахтерам Тогда
			Описание.Вставить("ПФРНаДоплатуШахтерам", "ПФР (шахтеры)");
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Месяц) Или Месяц >= ДатаПоявленияВзносовЗаЗанятыхНаРаботахСДосрочнойПенсией Тогда
			Если Не ЗначениеЗаполнено(Месяц) Или Месяц >= ДатаОбъединенияСтраховойИНакопительнойЧастейВзносовПФР Тогда
				Описание.Вставить("ПФРЗаЗанятыхНаПодземныхИВредныхРаботах", "ПФР (подз. раб., без оценки)");
				Описание.Вставить("ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах", "ПФР (тяж. раб., без оценки)");
				Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ВзносыПоКодамСпециальнойОценки()) Цикл
					Описание.Вставить(ИмяПоля, "ПФР " + ?(Найти(ИмяПоля,"Подземн") > 0,"(подз. раб., ","(тяж. раб., ") + ?(Прав(ИмяПоля,1) = "й","кл.О4","кл.В3." + Прав(ИмяПоля,1)) + ")");
				КонецЦикла;
			Иначе
				Описание.Вставить("ПФРЗаЗанятыхНаПодземныхИВредныхРаботах", "ПФР (подземные работы)");
				Описание.Вставить("ПФРЗаЗанятыхНаТяжелыхИПрочихРаботах", "ПФР (тяжелые работы)");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Описание
	
КонецФункции

/////////////////////////////////////////////////////////////////////////////////////////

// Возвращает текст подсказки для поля "ДатаРегистрацииИзменений" периодических регистров сведений:
// "ВременноПребывающиеПринятыеПоДолгосрочнымДоговорам", "КлассыУсловийТрудаПоДолжностям", 
// "ПрименяемыеТарифыСтраховыхВзносов", "СведенияОбИнвалидностиФизическихЛиц", "СтатусыЗастрахованныхФизическихЛиц"
//
Функция ТекстПодсказкиПоляДатаРегистрацииПериодическихРегистров() Экспорт 
	Возврат НСтр("ru = 'При регистрации изменений задним числом может потребоваться перерасчет страховых взносов.'");	 	
КонецФункции	

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формирует из любой даты каноническую дату получения дохода с точки зрения страховых взносов.
//      	 
// Параметры:
//		Дата - дата -
//
// Возвращаемое значение:
//		Дата
//
Функция ДатаПолученияДохода(Дата) Экспорт
	Возврат НачалоДня(КонецМесяца(Дата));	
КонецФункции	

#КонецОбласти
