////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в бухгалтерском учете.
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура УстановитьСтраницуНастройкиБухучетаНачислений(Форма) Экспорт

	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	КатегорияНачисления = Объект.КатегорияНачисленияИлиНеоплаченногоВремени;
	
	Если КатегорияНачисленийБезОплаты(КатегорияНачисления) Тогда 
		Элементы.НалоговыйИБухгалтерскийУчет.Видимость = Ложь;
		Возврат;
	Иначе
		Элементы.НалоговыйИБухгалтерскийУчет.Видимость = Истина;
	КонецЕсли;
	
	Если КатегорияНачисленийПособияФСС(КатегорияНачисления) Тогда
		
		СписокВыбора = Элементы.СтратегияОтраженияВУчетеПособия.СписокВыбора;
		
		Если Форма.ИспользоватьСтатьиФинансирования Тогда
			
			Элементы.СтраницыОтражениеВБухучете.ТекущаяСтраница = Элементы.СтраницаОтражениеВБухучетеПособияФСС;
			
			Если КатегорияНачисления <> ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаДнейУходаЗаДетьмиИнвалидами") 
				И КатегорияНачисления <> ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ДенежноеСодержаниеОплатаДнейУходаЗаДетьмиИнвалидами") Тогда
				СтрокаВыбора = "ПоФактическимНачислениям,ПоДаннымОСотруднике,ПоБазеСреднегоЗаработка,КакЗаданоВидуРасчета";
			Иначе
				СтрокаВыбора = "ПоДаннымОСотруднике,ПоБазеСреднегоЗаработка,КакЗаданоВидуРасчета";
			КонецЕсли;
			ЗаполнитьСписокВыборкаСтратегии(СписокВыбора, СтрокаВыбора);
			
		Иначе
			Элементы.СтраницыОтражениеВБухучете.ТекущаяСтраница = Элементы.СтраницаБухучетПособияФСС;
		КонецЕсли;
		
	Иначе
		
		СписокВыбора = Элементы.СтратегияОтраженияВУчете.СписокВыбора;
		Элементы.СтраницыОтражениеВБухучете.ТекущаяСтраница = Элементы.СтраницаОтражениеВБухучете;
		
		Если КатегорияНачисления = ПредопределенноеЗначение("Перечисление.КатегорииНачисленийИНеоплаченногоВремени.ОплатаБольничногоЛистаЗаСчетРаботодателя") Тогда
			
			Если Форма.ИспользоватьСтатьиФинансирования Тогда
				СтрокаВыбора = "ПоФактическимНачислениям,ПоДаннымОСотруднике,ПоБазеСреднегоЗаработка,КакЗаданоВидуРасчета";
			Иначе
				СтрокаВыбора = "ПоДаннымОСотруднике,КакЗаданоВидуРасчета";
			КонецЕсли;
			
		ИначеЕсли Объект.Рассчитывается И КатегорияНачисленийОплатаПоСреднемуОбщий(КатегорияНачисления) Тогда
			
			Если Форма.ИспользоватьСтатьиФинансирования Тогда
				СтрокаВыбора = "ПоДаннымОСотруднике,ПоБазеСреднегоЗаработка,КакЗаданоВидуРасчета";
			Иначе
				СтрокаВыбора = "ПоДаннымОСотруднике,КакЗаданоВидуРасчета";
			КонецЕсли;
			
		Иначе
			
			БазаДоступна = Форма.ЕстьПоказательРасчетнаяБаза
			И Форма.Объект.СпособРасчета <> ПредопределенноеЗначение("Перечисление.СпособыРасчетаНачислений.ДоплатаДоСреднегоЗаработка")
			И Форма.Объект.СпособРасчета <> ПредопределенноеЗначение("Перечисление.СпособыРасчетаНачислений.ДоплатаДоСреднегоЗаработкаФСС")
			И Форма.Объект.СпособРасчета <> ПредопределенноеЗначение("Перечисление.СпособыРасчетаНачислений.ДоплатаДоСохраняемогоДенежногоСодержанияЗаДниБолезни")
			И Форма.Объект.ПериодРасчетаБазовыхНачислений = ПредопределенноеЗначение("Перечисление.ПериодыРасчетаБазовыхНачислений.ТекущийМесяц");
			
			Если БазаДоступна Тогда
				СтрокаВыбора = "ПоДаннымОСотруднике,ПоБазовымРасчетам,КакЗаданоВидуРасчета";
			Иначе
				СтрокаВыбора = "ПоДаннымОСотруднике,КакЗаданоВидуРасчета";
			КонецЕсли;
			
		КонецЕсли;
		
		ЗаполнитьСписокВыборкаСтратегии(СписокВыбора, СтрокаВыбора);
		
	КонецЕсли;
	
	Если СписокВыбора.НайтиПоЗначению(Объект.СтратегияОтраженияВУчете) = Неопределено Тогда
		Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоДаннымОСотрудникеИЕгоПлановыхНачислениях")	
	КонецЕсли;
	ОбработатьИзменениеСтратегииОтраженияВБухучетеНачисления(Форма, Ложь);
	
КонецПроцедуры

Процедура ОбработатьИзменениеСтратегииОтраженияВБухучетеНачисления(Форма, ОбновитьНастройки = Истина) Экспорт
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	БухучетНастраиваетсяВНачислении = Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.КакЗаданоВидуРасчета");
	СтратегияПоФактическимНачислениям = Объект.СтратегияОтраженияВУчете = ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоФактическимНачислениям");
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СпособОтраженияЗарплатыВБухучете", "Доступность", БухучетНастраиваетсяВНачислении);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтношениеКЕНВД", "Доступность", БухучетНастраиваетсяВНачислении);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансирования", "Доступность", БухучетНастраиваетсяВНачислении);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяРасходов", "Доступность", БухучетНастраиваетсяВНачислении);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "СтатьяФинансированияПособия", "Доступность", БухучетНастраиваетсяВНачислении);
	
	Если Не ОбновитьНастройки Тогда
		Возврат;
	КонецЕсли;
	
	Если БухучетНастраиваетсяВНачислении Тогда
		
		Объект.СтатьяФинансирования = Форма.БылаСтатьяФинансирования;
		Объект.СтатьяРасходов = Форма.БылаСтатьяРасходов;
		Объект.СпособОтраженияЗарплатыВБухучете = Форма.БылСпособОтраженияЗарплатыВБухучете;
		Объект.ОтношениеКЕНВД = Форма.БылоОтношениеКЕНВД;
		
	Иначе
		
		Если ЗначениеЗаполнено(Объект.СпособОтраженияЗарплатыВБухучете) Тогда
			Форма.БылСпособОтраженияЗарплатыВБухучете = Объект.СпособОтраженияЗарплатыВБухучете;
			Объект.СпособОтраженияЗарплатыВБухучете = ПредопределенноеЗначение("Справочник.СпособыОтраженияЗарплатыВБухУчете.ПустаяСсылка");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.ОтношениеКЕНВД) Тогда
			Форма.БылоОтношениеКЕНВД = Объект.ОтношениеКЕНВД;
			Объект.ОтношениеКЕНВД = ПредопределенноеЗначение("Перечисление.ОтношениеКЕНВДЗатратНаЗарплату.ПустаяСсылка");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.СтатьяФинансирования) Тогда
			Форма.БылаСтатьяФинансирования = Объект.СтатьяФинансирования;
			Объект.СтатьяФинансирования = ПредопределенноеЗначение("Справочник.СтатьиФинансированияЗарплата.ПустаяСсылка");
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Объект.СтатьяРасходов) Тогда
			Форма.БылаСтатьяРасходов = Объект.СтатьяРасходов;
			Объект.СтатьяРасходов = ПредопределенноеЗначение("Справочник.СтатьиРасходовЗарплата.ПустаяСсылка");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьПредставлениеВидаНачисленияПоНКРФ(Форма) Экспорт
	
	Форма.ПредставлениеВидаНачисленияПоНКРФ = ЗарплатаКадрыКлиентСервер.ПредставлениеВидаНачисленияПоНКРФ(Форма.Объект.ВидНачисленияДляНУ);
	
КонецПроцедуры

Процедура ЗаполнитьПредставлениеРаспределенияВСтроке(СтрокаНачисленияУдержания, РаспределениеСодержитОшибки, ИмяТаблицы, РаботаВБюджетномУчреждении) Экспорт 
	
	Если ИмяТаблицы = "ПогашениеЗаймов" Или ИмяТаблицы = "НДФЛ" Тогда
		РезультатРаспределения = СвернутьРаспределениеРезультатовУдержаний(СтрокаНачисленияУдержания.РезультатРаспределения);
	Иначе
		РезультатРаспределения = СтрокаНачисленияУдержания.РезультатРаспределения;
	КонецЕсли;
	
	Если РезультатРаспределения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаНачисленияУдержания.КомандаРедактированияРаспределения = ПредставлениеРаспределения(РезультатРаспределения, РаспределениеСодержитОшибки, РаботаВБюджетномУчреждении);
	
КонецПроцедуры

Функция ПредставлениеРаспределения(РезультатРаспределения, РаспределениеСодержитОшибки, ОбрабатыватьСтатьюРасходов) Экспорт

	ПредставлениеРаспределения = "";
	
	КоличествоСтрокРаспределения = РезультатРаспределения.Количество();
	НомерСтрокиРаспределения = 1;
	
	Если РаспределениеСодержитОшибки Тогда
		ПредставлениеРаспределения = НСтр("ru = 'Не задано'");
	Иначе
		
		Для Каждого СтрокаРаспределения Из РезультатРаспределения Цикл
			
			Если СтрокаРаспределения.СтатьяФинансирования = Неопределено Тогда
				КодСтатьиФинансирования = "  ";
			Иначе
				КодСтатьиФинансирования = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрокаРаспределения.КодСтатьиФинансирования, 3, " ", "Справа");
			КонецЕсли;
			
			Если ОбрабатыватьСтатьюРасходов Тогда
				СтрокаПодстановки = НСтр("ru = '(%1)'");
				СтатьяРасхода = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтрокаРаспределения.СтатьяРасходов, 3, " ");
				КодСтатьиРасходов = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаПодстановки, СтатьяРасхода);
			ИначеЕсли КоличествоСтрокРаспределения > 1 Тогда
				КодСтатьиРасходов = ":";
			Иначе
				КодСтатьиРасходов = "";
			КонецЕсли;
			
			Если КоличествоСтрокРаспределения = 1 Тогда
				СуммаРаспределения = "";
				ПереводСтроки = "";
			Иначе
				СуммаРаспределения = Строка(Формат(СтрокаРаспределения.Результат, "ЧДЦ=2; ЧРГ="));			
				СуммаРаспределения = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СуммаРаспределения, 9, " ");
				Если КоличествоСтрокРаспределения = 1 Или НомерСтрокиРаспределения = 2 Тогда
					ПереводСтроки = "";
				Иначе
					ПереводСтроки = Символы.ПС;
				КонецЕсли;			
			КонецЕсли;		
			
			Если НомерСтрокиРаспределения = 2 И КоличествоСтрокРаспределения > 2 Тогда
				БолееДвухСтрок = "…";
			Иначе
				БолееДвухСтрок = " ";
			КонецЕсли;
			
			СтрокаПодстановки = НСтр("ru = '%1%2%3 %4%5%6'");
			ПредставлениеРаспределения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			СтрокаПодстановки, ПредставлениеРаспределения, КодСтатьиФинансирования,
			КодСтатьиРасходов, СуммаРаспределения, БолееДвухСтрок, ПереводСтроки);
			
			Если НомерСтрокиРаспределения = 2 Тогда
				Прервать;
			КонецЕсли;
			
			НомерСтрокиРаспределения = НомерСтрокиРаспределения + 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат ПредставлениеРаспределения;

КонецФункции

Функция СвернутьРаспределениеРезультатовУдержаний(РаспределениеРезультатов)
	
	ИменаКолонок = "СтатьяФинансирования,СтатьяРасходов,КодСтатьиФинансирования,Результат,ВидУдержания,Сотрудник,Подразделение";
	
	СтруктураВозврата = Новый Массив;
	
	Для каждого СтрокаРаспределениеРезультатов Из РаспределениеРезультатов Цикл
		
		// Зачет излишне удержанного НДФЛ включен в сумму НДФЛ.
		Если СтрокаРаспределениеРезультатов.Свойство("ВидУдержания")
			И СтрокаРаспределениеРезультатов.ВидУдержания = ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛЗачтено") Тогда
			Продолжить;
		КонецЕсли;
		
		ОписаниеСтроки = Новый Структура(ИменаКолонок);
		ЗаполнитьЗначенияСвойств(ОписаниеСтроки, СтрокаРаспределениеРезультатов);
		
		СтрокаНеНайдена = Истина;
		
		Для Каждого СтрокаСтруктурыВозврата Из СтруктураВозврата Цикл
			Если СтрокаСтруктурыВозврата.СтатьяФинансирования = ОписаниеСтроки.СтатьяФинансирования
				И СтрокаСтруктурыВозврата.КодСтатьиФинансирования = ОписаниеСтроки.КодСтатьиФинансирования
				И СтрокаСтруктурыВозврата.СтатьяРасходов = ОписаниеСтроки.СтатьяРасходов
				И СтрокаСтруктурыВозврата.Сотрудник = ОписаниеСтроки.Сотрудник
				И СтрокаСтруктурыВозврата.Подразделение = ОписаниеСтроки.Подразделение Тогда
				СтрокаСтруктурыВозврата.Результат = СтрокаСтруктурыВозврата.Результат + ОписаниеСтроки.Результат;
				СтрокаНеНайдена = Ложь;
			КонецЕсли;				
		КонецЦикла;
		
		Если СтрокаНеНайдена Тогда
			СтруктураВозврата.Добавить(ОписаниеСтроки);
		КонецЕсли;			
		
	КонецЦикла; 
	
	Возврат Новый ФиксированныйМассив(СтруктураВозврата);
	
КонецФункции

Процедура ПерераспределитьНДФЛ(СтрокаНДФЛ, РаботаВБюджетномУчреждении) Экспорт
	
	Если СтрокаНДФЛ.РезультатРаспределения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НДФЛ = СтрокаНДФЛ.Налог - СтрокаНДФЛ.ЗачтеноАвансовыхПлатежей;
	
	НДФЛРаспределено = 0;
	РаспределениеНДФЛ = Новый Массив;
	Для каждого РезультатРаспределения Из СтрокаНДФЛ.РезультатРаспределения Цикл
		Если РезультатРаспределения.ВидУдержания = ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ") Тогда   
			НДФЛРаспределено = НДФЛРаспределено + РезультатРаспределения.Результат;
			РаспределениеНДФЛ.Добавить(РезультатРаспределения);
		КонецЕсли;
	КонецЦикла;
	
	Если НДФЛ <> НДФЛРаспределено Тогда
		
		СтрокаНДФЛ.РезультатРаспределения = ОтражениеЗарплатыВБухучетеРасширенныйВызовСервера.РезультатРаспределенияСуммыПоБазе(НДФЛ, РаспределениеНДФЛ, "Результат", 0);
		
		ЕстьОшибкиРаспределения = Ложь;
		ЕстьОшибкиЗаполнения = Ложь;
		ПроверяемыеПоля = Новый Структура;
		ПроверяемыеПоля.Вставить("СтатьяФинансирования", Истина);
		ПроверяемыеПоля.Вставить("СтатьяРасходов", РаботаВБюджетномУчреждении);
		
		НДФЛРаспределено = 0;
		Для каждого СтрокаРаспределения Из СтрокаНДФЛ.РезультатРаспределения Цикл
			НДФЛРаспределено = НДФЛРаспределено + СтрокаРаспределения.Результат;
			Для Каждого КлючИЗначение Из ПроверяемыеПоля Цикл
				Если КлючИЗначение.Значение И Не ЗначениеЗаполнено(СтрокаРаспределения[КлючИЗначение.Ключ]) Тогда
					ЕстьОшибкиЗаполнения = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если НДФЛ = 0 И НДФЛРаспределено = 0 Тогда
			ЕстьОшибкиРаспределения = Ложь;
			ЕстьОшибкиЗаполнения = Ложь;
		Иначе
			ЕстьОшибкиРаспределения = НДФЛ <> НДФЛРаспределено;
		КонецЕсли;
		ЗаполнитьПредставлениеРаспределенияВСтроке(СтрокаНДФЛ, ЕстьОшибкиРаспределения Или ЕстьОшибкиЗаполнения, "НДФЛ", РаботаВБюджетномУчреждении);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПерераспределитьПогашениеЗаймов(СтрокаТаблицы, РаботаВБюджетномУчреждении) Экспорт
	
	Если СтрокаТаблицы.РезультатРаспределения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаспределениеСтроки = Новый Соответствие;
	РаспределениеСтроки.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.ПогашениеЗаймаИзЗарплаты"),
									Новый Структура("ИмяКолонки,Результат,РаспределениеРезультата", "ПогашениеЗайма", 0, Новый Массив));
	РаспределениеСтроки.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.НДФЛ"),
									Новый Структура("ИмяКолонки,Результат,РаспределениеРезультата", "НалогНаМатериальнуюВыгоду", 0, Новый Массив));
	РаспределениеСтроки.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.ПроцентыПоЗайму"),
									Новый Структура("ИмяКолонки,Результат,РаспределениеРезультата", "ПогашениеПроцентов", 0, Новый Массив));
	РаспределениеСтроки.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.НачисленоПроцентовПоЗайму"),
									Новый Структура("ИмяКолонки,Результат,РаспределениеРезультата", "НачисленоПроцентов", 0, Новый Массив));
	РаспределениеСтроки.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОсобыхНачисленийИУдержаний.МатериальнаяВыгодаПоЗаймам"),
									Новый Структура("ИмяКолонки,Результат,РаспределениеРезультата", "МатериальнаяВыгода", 0, Новый Массив));
	
	Для каждого РезультатРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
		ДанныеКолонки = РаспределениеСтроки[РезультатРаспределения.ВидУдержания];
		ДанныеКолонки.Результат = ДанныеКолонки.Результат + РезультатРаспределения.Результат;
		ДанныеКолонки.РаспределениеРезультата.Добавить(РезультатРаспределения);
	КонецЦикла;
	
	ИтогПоСтроке = 0;
	РаспределениеВыполнялось = Ложь;
	НовоеРаспределениеСтроки = Новый Массив;
	Для каждого ЭлементСоответствия Из РаспределениеСтроки Цикл
	
		ДанныеКолонки = ЭлементСоответствия.Значение;
		РезультатКолонки = СтрокаТаблицы[ДанныеКолонки.ИмяКолонки];
		ИтогПоСтроке = ИтогПоСтроке + РезультатКолонки;
		Если СтрокаТаблицы[ДанныеКолонки.ИмяКолонки] <> ДанныеКолонки.Результат Тогда
			ДанныеКолонки.РаспределениеРезультата = ОтражениеЗарплатыВБухучетеРасширенныйВызовСервера.РезультатРаспределенияСуммыПоБазе(РезультатКолонки, ДанныеКолонки.РаспределениеРезультата, "Результат");
			РаспределениеВыполнялось = Истина;
		КонецЕсли;
		
		Для каждого ЭлементКоллекции Из ДанныеКолонки.РаспределениеРезультата Цикл
			НовоеРаспределениеСтроки.Добавить(Новый ФиксированнаяСтруктура(ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ЭлементКоллекции)));
		КонецЦикла;
	
	КонецЦикла;
	
	Если РаспределениеВыполнялось Тогда
		
		СтрокаТаблицы.РезультатРаспределения = Новый ФиксированныйМассив(НовоеРаспределениеСтроки);
		
		ЕстьОшибкиРаспределения = Ложь;
		ЕстьОшибкиЗаполнения = Ложь;
		ПроверяемыеПоля = Новый Структура;
		ПроверяемыеПоля.Вставить("СтатьяФинансирования", Истина);
		ПроверяемыеПоля.Вставить("СтатьяРасходов", РаботаВБюджетномУчреждении);
		
		ВсегоРаспределено = 0;
		Для каждого СтрокаРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
			ВсегоРаспределено = ВсегоРаспределено + СтрокаРаспределения.Результат;
			Для Каждого КлючИЗначение Из ПроверяемыеПоля Цикл
				Если КлючИЗначение.Значение И Не ЗначениеЗаполнено(СтрокаРаспределения[КлючИЗначение.Ключ]) Тогда
					ЕстьОшибкиЗаполнения = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если ИтогПоСтроке = 0 И ВсегоРаспределено = 0 Тогда
			ЕстьОшибкиРаспределения = Ложь;
			ЕстьОшибкиЗаполнения = Ложь;
		Иначе
			ЕстьОшибкиРаспределения = ИтогПоСтроке <> ВсегоРаспределено;
		КонецЕсли;
		ЗаполнитьПредставлениеРаспределенияВСтроке(СтрокаТаблицы, ЕстьОшибкиРаспределения Или ЕстьОшибкиЗаполнения, "ПогашениеЗаймов", РаботаВБюджетномУчреждении);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПерераспределитьУдержания(СтрокаТаблицы, РаботаВБюджетномУчреждении) Экспорт

	Если СтрокаТаблицы.РезультатРаспределения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсегоРаспределено = 0;
	РаспределениеСтроки = Новый Массив;
	Для каждого РезультатРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
		ВсегоРаспределено = ВсегоРаспределено + РезультатРаспределения.Результат;
		РаспределениеСтроки.Добавить(РезультатРаспределения);
	КонецЦикла;
	
	Если СтрокаТаблицы.Результат <> ВсегоРаспределено Тогда
		
		ОкруглятьРезультатРаспределения = ОтражениеЗарплатыВБухучетеРасширенныйВызовСервера.ОкруглятьРезультатРаспределенияУдержания(СтрокаТаблицы.Удержание);
		Точность = ?(ОкруглятьРезультатРаспределения,0,2);
		
		СтрокаТаблицы.РезультатРаспределения = ОтражениеЗарплатыВБухучетеРасширенныйВызовСервера.РезультатРаспределенияСуммыПоБазе(СтрокаТаблицы.Результат, РаспределениеСтроки, "Результат", Точность);
		
		ЕстьОшибкиРаспределения = Ложь;
		ЕстьОшибкиЗаполнения = Ложь;
		ПроверяемыеПоля = Новый Структура;
		ПроверяемыеПоля.Вставить("СтатьяФинансирования", Истина);
		ПроверяемыеПоля.Вставить("СтатьяРасходов", РаботаВБюджетномУчреждении);
		
		ВсегоРаспределено = 0;
		Для каждого СтрокаРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
			ВсегоРаспределено = ВсегоРаспределено + СтрокаРаспределения.Результат;
			Для Каждого КлючИЗначение Из ПроверяемыеПоля Цикл
				Если КлючИЗначение.Значение И Не ЗначениеЗаполнено(СтрокаРаспределения[КлючИЗначение.Ключ]) Тогда
					ЕстьОшибкиЗаполнения = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если СтрокаТаблицы.Результат = 0 И ВсегоРаспределено = 0 Тогда
			ЕстьОшибкиРаспределения = Ложь;
			ЕстьОшибкиЗаполнения = Ложь;
		Иначе
			ЕстьОшибкиРаспределения = СтрокаТаблицы.Результат <> ВсегоРаспределено;
		КонецЕсли;
		ЗаполнитьПредставлениеРаспределенияВСтроке(СтрокаТаблицы, ЕстьОшибкиРаспределения Или ЕстьОшибкиЗаполнения, "Удержания", РаботаВБюджетномУчреждении);
		
	КонецЕсли;

КонецПроцедуры

Процедура ПерераспределитьКорректировкиВыплаты(СтрокаТаблицы, РаботаВБюджетномУчреждении) Экспорт

	Если СтрокаТаблицы.РезультатРаспределения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВсегоРаспределено = 0;
	РаспределениеСтроки = Новый Массив;
	Для каждого РезультатРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
		ВсегоРаспределено = ВсегоРаспределено + РезультатРаспределения.Результат;
		РаспределениеСтроки.Добавить(РезультатРаспределения);
	КонецЦикла;
	
	Если СтрокаТаблицы.КорректировкаВыплаты <> ВсегоРаспределено Тогда
		
		СтрокаТаблицы.РезультатРаспределения = ОтражениеЗарплатыВБухучетеРасширенныйВызовСервера.РезультатРаспределенияСуммыПоБазе(СтрокаТаблицы.КорректировкаВыплаты, РаспределениеСтроки, "Результат");
		
		ЕстьОшибкиРаспределения = Ложь;
		ЕстьОшибкиЗаполнения = Ложь;
		ПроверяемыеПоля = Новый Структура;
		ПроверяемыеПоля.Вставить("СтатьяФинансирования", Истина);
		ПроверяемыеПоля.Вставить("СтатьяРасходов", РаботаВБюджетномУчреждении);
		
		ВсегоРаспределено = 0;
		Для каждого СтрокаРаспределения Из СтрокаТаблицы.РезультатРаспределения Цикл
			ВсегоРаспределено = ВсегоРаспределено + СтрокаРаспределения.Результат;
			Для Каждого КлючИЗначение Из ПроверяемыеПоля Цикл
				Если КлючИЗначение.Значение И Не ЗначениеЗаполнено(СтрокаРаспределения[КлючИЗначение.Ключ]) Тогда
					ЕстьОшибкиЗаполнения = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если СтрокаТаблицы.КорректировкаВыплаты = 0 И ВсегоРаспределено = 0 Тогда
			ЕстьОшибкиРаспределения = Ложь;
			ЕстьОшибкиЗаполнения = Ложь;
		Иначе
			ЕстьОшибкиРаспределения = СтрокаТаблицы.КорректировкаВыплаты <> ВсегоРаспределено;
		КонецЕсли;
		ЗаполнитьПредставлениеРаспределенияВСтроке(СтрокаТаблицы, ЕстьОшибкиРаспределения Или ЕстьОшибкиЗаполнения, "КорректировкиВыплаты", РаботаВБюджетномУчреждении);
		
	КонецЕсли;

КонецПроцедуры

Функция ОписаниеИсходныхДанныхДляОбновленияЗависимыхТаблиц() Экспорт

	ИсходныеДанные = Новый Структура;
	ИсходныеДанные.Вставить("РаспределятьЗависимыеТаблицы", Ложь);
	ИсходныеДанные.Вставить("ИзмениласьДоляЕНВД", 			Ложь);
	ИсходныеДанные.Вставить("ТребуетсяПересчетНДФЛ", 			Ложь);
	ИсходныеДанные.Вставить("Сотрудник");
	ИсходныеДанные.Вставить("ВидРасчета");
	ИсходныеДанные.Вставить("ИменаТаблицДляОбновления","");
	ИсходныеДанные.Вставить("ИмяИсходнойТаблицы","");
	ИсходныеДанные.Вставить("НомерСтрокиИсходнойТаблицы", 0);
	
	Возврат ИсходныеДанные;

КонецФункции


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КатегорияНачисленийБезОплаты(КатегорияНачисления) Экспорт

	КатегорииНачислений = ОтражениеЗарплатыВБухучетеКлиентСерверРасширенныйПовтИсп.КатегорииНачисленийБезОплаты();
	Возврат КатегорииНачислений.Найти(КатегорияНачисления)<>Неопределено;

КонецФункции
		
Функция КатегорияНачисленийПособияФСС(КатегорияНачисления)

	КатегорииНачислений = ОтражениеЗарплатыВБухучетеКлиентСерверРасширенныйПовтИсп.КатегорииНачисленийПособияФСС();
	Возврат КатегорииНачислений.Найти(КатегорияНачисления)<>Неопределено;

КонецФункции

Функция КатегорияНачисленийОплатаПоСреднемуОбщий(КатегорияНачисления) Экспорт

	КатегорииНачислений = ОтражениеЗарплатыВБухучетеКлиентСерверРасширенныйПовтИсп.КатегорииНачисленийОплатаПоСреднемуОбщий();
	Возврат КатегорииНачислений.Найти(КатегорияНачисления)<>Неопределено;

КонецФункции

Процедура ЗаполнитьСписокВыборкаСтратегии(СписокВыбора, СтрокаВыбора)
	
	СписокВыбора.Очистить();
	
	Для каждого ЗначениеВыбора Из СтрРазделить(СтрокаВыбора,",") Цикл
	
		Если ЗначениеВыбора = "ПоФактическимНачислениям" Тогда
			СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоФактическимНачислениям"),НСтр("ru = 'По фактическим начислениям текущего года'"));	
		ИначеЕсли ЗначениеВыбора = "ПоДаннымОСотруднике" Тогда
			СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоДаннымОСотрудникеИЕгоПлановыхНачислениях"), НСтр("ru = 'По настройкам сотрудника'"));
		ИначеЕсли ЗначениеВыбора = "ПоБазеСреднегоЗаработка" Тогда
			СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазеСреднегоЗаработка"), НСтр("ru = 'По базе среднего заработка'"));
		ИначеЕсли ЗначениеВыбора = "ПоБазовымРасчетам" Тогда
			СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.ПоБазовымРасчетам"), НСтр("ru = 'Как задано для базовых начислений'"));	
		ИначеЕсли ЗначениеВыбора = "КакЗаданоВидуРасчета" Тогда
			СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.СтратегииОтраженияВУчетеНачисленийУдержаний.КакЗаданоВидуРасчета"), НСтр("ru = 'Как задано для начисления'"));
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
