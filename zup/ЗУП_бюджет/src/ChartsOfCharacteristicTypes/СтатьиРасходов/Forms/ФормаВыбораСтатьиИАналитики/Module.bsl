
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Параметр = Новый Структура("СтатьяРасходов, АналитикаРасходов", СтатьяРасходов, АналитикаРасходов);
		Закрыть(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
