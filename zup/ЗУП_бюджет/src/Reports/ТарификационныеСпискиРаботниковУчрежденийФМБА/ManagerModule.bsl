#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Возвращает коллекцию вариантов настроек
//
// Возвращаемое значение:
//  Массив -  коллекция объектов со свойствами Имя и Представление (см. ВариантНастроекКомпоновкиДанных).
//
Функция ВариантыНастроек() Экспорт
	
	ВариантыНастроек = Новый Массив;
	
	ПоляНастройки = "Имя, Представление";
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ТарификационныйСписокРуководства",	"Тарификационный список руководителей"));
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ТарификационныйСписокСлужащих",		"Тарификационный список служащих"));
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ТарификационныйСписокМедПерсонала",	"Тарификационный список медицинского персонала"));
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ТарификационныйСписокРабочих",		"Тарификационный список рабочих"));
	ВариантыНастроек.Добавить(Новый Структура(ПоляНастройки, "ТарификационныйСписокСводный",		"Сводный тарификационный список"));
	
	Возврат ВариантыНастроек;
	
КонецФункции

// См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТарификационныйСписокРуководства");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Тарификационный список руководителя учреждения, его заместителей, директора, главного бухгалтера
		|.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТарификационныйСписокСлужащих");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Тарификационный список работников должностей служащих,
		|в том числе руководителей структурных подразделений (не врачей) и их заместителей и др.'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТарификационныйСписокМедПерсонала");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Тарификационный список работников медицинского и фармацевтического
		|персонала, в том числе врачебный персонал, средний медицинский персонал, младший персонал, фармацевтический персонал'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТарификационныйСписокРабочих");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Тарификационный список работников. Профессии рабочих'");
	
	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "ТарификационныйСписокСводный");
	НастройкиВарианта.Описание =
		НСтр("ru = 'Сводный тарификационный список работников
		|федеральных бюджетных учреждений здравоохранения и социальной защиты ФМБА России'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли