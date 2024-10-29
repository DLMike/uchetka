
&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	//TODO: Вставить содержимое обработчика
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст ="
	|	ВЫБРАТЬ
	|	Люди.Наименование,
	|	Люди.Родитель,
	|	Люди.Имя,
	|	Люди.Отчество,
	|	Люди.КонтактнаяИнформация.(
	|		НомерТелефона),
	|	Люди.Очередь,
	|	Люди.Родитель
	|ИЗ
	|	Справочник.Люди КАК Люди
	|ГДЕ
	|	Люди.ПометкаУдаления = ЛОЖЬ
	|	И Люди.ЭтоГруппа = ЛОЖЬ
	|	И Люди.Членство = ИСТИНА
	|	И Люди.Трудосопособность = ИСТИНА";
	Выборка = Запрос.Выполнить().Выгрузить();
    Всего = Выборка.Количество();
    
    
    
	Сообщить(Всего);
КонецПроцедуры
