#Область ПрограммныйИнтерфейс

// Процедура пакетной записи сообщений в журнал регистрации.
// После записи переменная СобытияДляЖурналаРегистрации очищается.
//
// Параметры:
//  СобытияДляЖурналаРегистрации - СписокЗначений - где Значение - Структура со свойствами:
//              * ИмяСобытия  - Строка - Имя записываемого события.
//              * ПредставлениеУровня  - Строка - Представление значений коллекции УровеньЖурналаРегистрации.
//                                       Доступные значения: "Информация", "Ошибка", "Предупреждение", "Примечание".
//              * Комментарий - Строка - Комментарий события.
//              * ДатаСобытия - Дата   - Дата события, подставляется в комментарий при записи.
//
Процедура ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации) Экспорт
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СобытияДляЖурналаРегистрации);
	
КонецПроцедуры

#КонецОбласти
