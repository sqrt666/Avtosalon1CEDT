﻿
Функция getRegGET(Запрос)
  Логин = Строка(Запрос.ПараметрыЗапроса.Получить("name"));
  НомерТелефона = Строка(Запрос.ПараметрыЗапроса.Получить("phone"));
  
  НовыйПользовательИБ = ПользователиИнформационнойБазы.СоздатьПользователя();
   НовыйПользовательИБ.Имя = Логин;
   НовыйПользовательИБ.Роли.Добавить(Метаданные.Роли.ПолныеПрава);
НовыйПользовательИБ.Записать();
  
  НовыйКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
  НовыйКонтрагент.Наименование = Логин;
  НовыйКонтрагент.КонтактныйТелефон = НомерТелефона;
  НовыйКонтрагент.ТипКонтрагента = Перечисления.ТипыКонтрагентов.Покупатель;
  НовыйКонтрагент.Комментарий = "Пользователь зарегистрированный из мобильного приложения";
  НовыйКонтрагент.Записать();    
    
    НовыйПользовательСправочник = Справочники.Пользователи.СоздатьЭлемент();
    НовыйПользовательСправочник.Код = НовыйПользовательИБ.УникальныйИдентификатор;
    НовыйПользовательСправочник.Клиент = НовыйКонтрагент.Ссылка;  
    НовыйПользовательСправочник.Наименование = Логин;
	НовыйПользовательСправочник.Записать(); 
      
  
  ЗапросПользователи = Новый Запрос; 
    ЗапросПользователи.Текст = "ВЫБРАТЬ
                               |  УНИКАЛЬНЫЙИДЕНТИФИКАТОР(Пользователи.Ссылка) КАК Ссылка,
                               |  Пользователи.Наименование КАК Наименование,
                               |  Пользователи.Код КАК Код
                               |ИЗ
                               |  Справочник.Пользователи КАК Пользователи
                               |ГДЕ
                               |  Пользователи.Ссылка = &Ссылка";
    ЗапросПользователи.УстановитьПараметр("Ссылка", НовыйПользовательСправочник.Ссылка); 

    МассивПользователей = Новый Массив; 

    Выборка = ЗапросПользователи.Выполнить().Выбрать();
    Пока Выборка.Следующий() Цикл

    ДанныеПользователя = Новый Структура; 
    ДанныеПользователя.Вставить("guid", Строка(Выборка.Ссылка));
    ДанныеПользователя.Вставить("name", Строка(Выборка.Наименование));
    ДанныеПользователя.Вставить("code", Строка(Выборка.Код));

    МассивПользователей.Добавить(ДанныеПользователя); 

    КонецЦикла;

    Ответ = Новый HTTPСервисОтвет(200); 

    ЗаписьJSON = Новый ЗаписьJSON; 
    ЗаписьJSON.УстановитьСтроку();
    ЗаписатьJSON(ЗаписьJSON, МассивПользователей);
    СтрокаОтвета = ЗаписьJSON.Закрыть();

    Ответ.УстановитьТелоИзСтроки(СтрокаОтвета); 

    Возврат Ответ; 
КонецФункции
