﻿ Функция ПолучитьЦенуПродажиНаДату(Номенклатура, ВидЦены = Неопределено, ДатаЦены = Неопределено) Экспорт
	Если ВидЦены = Неопределено Тогда
		ВидЦены = Перечисления.ВидыЦенПродажи.Розничная;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЦеныНоменклатурыСрезПоследних.Номенклатура КАК Номенклатура,
	               |	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена
	               |ИЗ
	               |	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(
	               |			&Период,
	               |			Номенклатура = &Номенклатура
	               |				И ВидЦены = &ВидЦены) КАК ЦеныНоменклатурыСрезПоследних";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("Период", ДатаЦены);
	Запрос.УстановитьПараметр("ВидЦены", ВидЦены);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Сообщить("В базе данных не найдены цены для данной номенклатуры!");
		Возврат 0;
	Конецесли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Цена;

КонецФункции