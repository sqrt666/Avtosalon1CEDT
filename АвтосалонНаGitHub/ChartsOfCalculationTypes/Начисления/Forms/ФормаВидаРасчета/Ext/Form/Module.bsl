﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимость();         
	
	Если Объект.Предопределенный Тогда
		
		Элементы.ГруппаФормулаРасчета.Видимость = Ложь;
	
	КонецЕсли;	
		
КонецПроцедуры