#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКопировании(ОбъектКопирования)
	
	КодДоходаНДФЛ = Справочники.ВидыДоходовНДФЛ.ПустаяСсылка();
	КодДоходаСтраховыеВзносы = Справочники.ВидыДоходовПоСтраховымВзносам.ПустаяСсылка();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли