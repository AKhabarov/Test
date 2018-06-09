#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает структуру параметров для ограничения регистрации объекта при обмене
// Вызывается ПередЗаписью объекта.
//
// Возвращаемое значение:
//	ОграниченияРегистрации - Структура - Описание см. ОбменДаннымиЗарплатаКадры.ОграниченияРегистрации.
//
Функция ОграниченияРегистрации() Экспорт
	
	МассивПозиций = ЭтотОбъект.Выгрузить().ВыгрузитьКолонку("ПозицияШтатногоРасписания");
	
	Возврат ОбменДаннымиЗарплатаКадрыРасширенный.ОграниченияРегистрацииПоПозициямШтатногоРасписания(ЭтотОбъект, МассивПозиций);
	
КонецФункции

#КонецОбласти 

#КонецЕсли
