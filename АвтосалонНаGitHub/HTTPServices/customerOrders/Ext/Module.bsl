﻿
Функция createOrderPOST(Запрос)
    ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку()); 
	ДанныеЗапроса = ПрочитатьJSON(ЧтениеJSON, Ложь);
	ЧтениеJSON.Закрыть();
	
	НоваяЗапись = Документы.ЗаказНаряд.СоздатьДокумент(); 
	НоваяЗапись.Сотрудник = Справочники.Сотрудники.НайтиПоНаименованию(ДанныеЗапроса.Сотрудник); 
	НоваяЗапись.Клиент = Справочники.Пользователи.НайтиПоКоду(ДанныеЗапроса.GUIDПользователя).Клиент;
	НоваяЗапись.Дата = ТекущаяДата();
	НоваяЗапись.ДатаЗаписи = ПрочитатьДатуJSON(ДанныеЗапроса.ДатаЗаписи, ФорматДатыJSON.ISO);
	
	Для Каждого СтруктураУслуги Из ДанныеЗапроса.МассивУслуг Цикл 
		НоваяУслуга = НоваяЗапись.Услуги.Добавить();
		НоваяУслуга.Услуга  = Справочники.Номенклатура.НайтиПоНаименованию(СтруктураУслуги.Номенклатура);
		НоваяУслуга.Цена = Число(СтруктураУслуги.Цена);
		НоваяУслуга.Количество = Число(СтруктураУслуги.Количество);
		НоваяУслуга.Сумма = Число(СтруктураУслуги.Сумма);
	КонецЦикла;
	
	Попытка
		НоваяЗапись.Записать(РежимЗаписиДокумента.Проведение); 
		ТекстОтвета = "Создан и проведен документ " + НоваяЗапись.Номер;
		Ответ = Новый HTTPСервисОтвет(200);
	Исключение
		Ответ = Новый HTTPСервисОтвет(500);
		ТекстОтвета = "Произошла ошибка при проведении документа " + НоваяЗапись.Номер + "! ";
	КонецПопытки;
	
	Ответ.УстановитьТелоИзСтроки(ТекстОтвета);
	
	Возврат Ответ;
КонецФункции 