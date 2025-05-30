﻿
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровИУслуг") Тогда
		ДанныеДокументаОснования = ПолучитьДанныеПоРеализацииТоваров(ДанныеЗаполнения);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеДокументаОснования);
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя");
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПоступлениеТоваровИУслуг") Тогда
		ДанныеДокументаОснования = ПолучитьДанныеПоПоступлениеТоваров(ДанныеЗаполнения);
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеДокументаОснования);
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика");
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьДанныеПоРеализацииТоваров(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	РеализацияТоваровИУслуг.Контрагент КАК Плательщик,
	               |	РеализацияТоваровИУслуг.СуммаДокумента КАК СуммаДокумента,
	               |	РеализацияТоваровИУслуг.Ссылка КАК ДокументОснование
	               |ИЗ
	               |	Документ.РеализацияТоваровИУслуг КАК РеализацияТоваровИУслуг
	               |ГДЕ
	               |	РеализацияТоваровИУслуг.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции

Функция ПолучитьДанныеПоПоступлениеТоваров(ДанныеЗаполнения)
	
	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПоступлениеТоваровИУслуг.Контрагент КАК Плательщик,
	               |	ПоступлениеТоваровИУслуг.СуммаДокумента КАК СуммаДокумента,
	               |	ПоступлениеТоваровИУслуг.Ссылка КАК ДокументОснование
	               |ИЗ
	               |	Документ.ПоступлениеТоваровИУслуг КАК ПоступлениеТоваровИУслуг
	               |ГДЕ
	               |	ПоступлениеТоваровИУслуг.Ссылка = &Ссылка";
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	Возврат Выборка;
	
КонецФункции


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	Движения.ДенежныеСредства.Записывать = Истина;
	Движения.ДенежныеСредства.Записать();
	Движения.Хозрасчётный.Записывать = Истина;
	движения.Хозрасчётный.Записать();
	
	Движение = Движения.ДенежныеСредства.Добавить();
	Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
	Движение.Период = Дата;
	Движение.Касса = Касса;
	Движение.Сумма = СуммаДокумента;
	
	АналитикаПроводки = ПолучитьАналитикуПроводки();
	
	Движение = Движения.Хозрасчётный.Добавить();
	Движение.СчетДт = АналитикаПроводки.СчетДебета;
	Движение.СчетКт = АналитикаПроводки.СчетКредита;
	Движение.Период = Дата;
	Движение.Сумма = СуммаДокумента;
	Движение.Содержание = АналитикаПроводки.СодержаниеОперации;
	БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетДт, Движение.СубконтоДт, АналитикаПроводки.СубконтоДебет);
    БухгалтерскийУчет.ЗаполнитьСубконтоПоСчету(Движение.СчетКт, Движение.СубконтоКт, АналитикаПроводки.СубконтоКредит);
КонецПроцедуры


 Функция ПолучитьАналитикуПроводки()
    
    ОплатаОтПокупателя      = Перечисления.ВидыОперацийПоступленияДенег.ОплатаОтПокупателя;
    ВозвратОтПоставщика     = Перечисления.ВидыОперацийПоступленияДенег.ВозвратОтПоставщика;
    ВозвратОтПодотчетника   = Перечисления.ВидыОперацийПоступленияДенег.ВозвратОтПодотчётника;    
    
    СтруктураАналитики = Новый Структура;
	СтруктураАналитики.Вставить("СчетДебета", ПланыСчетов.Хозрасчетный.Касса);
	СтруктураАналитики.Вставить("СубконтоДебет", Касса);
	
    Если ВидОперации = ОплатаОтПокупателя Тогда
		СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчётыСПокупателями);
        СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Оплата от покупателя наличными в кассу");
    ИначеЕсли ВидОперации = ВозвратОтПоставщика Тогда
        СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчётыСПоставщиками);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат от поставщика наличными в кассу");
        СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
    ИначеЕсли ВидОперации = ВозвратОтПодотчетника Тогда 
        СтруктураАналитики.Вставить("СчетКредита", ПланыСчетов.Хозрасчетный.РасчётыСПодотчетнымиЛицами);
        СтруктураАналитики.Вставить("СодержаниеОперации", "Возврат подотчетных средств"); 
        СтруктураАналитики.Вставить("СубконтоКредит", Плательщик);
    КонецЕсли;
    
	Возврат СтруктураАналитики;

КонецФункции 

   

