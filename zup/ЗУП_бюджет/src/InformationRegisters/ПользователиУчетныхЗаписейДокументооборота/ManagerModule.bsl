#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	КонтекстЭДО = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО();
	КонтекстЭДО.ОбработкаПолученияФормы("РегистрСведений", "ПользователиУчетныхЗаписейДокументооборота", ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти
