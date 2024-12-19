#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	//СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	//TODO: Вставить содержимое обработчика
	Объект.ДатыУборки.Очистить();
	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) Тогда
		Объект.ДатаНачала = ТекущаяДатаСеанса();
	КонецЕсли;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Люди.Наименование КАК Наименование,
	|	Люди.Родитель КАК Родитель,
	|	Люди.Имя КАК Имя,
	|	Люди.Отчество,
	|	Люди.КонтактнаяИнформация.(
	|		НомерТелефона КАК Телефон),
	|	Люди.Очередь,
	|	Люди.Родитель,
	|	Люди.Ссылка,
	|	Люди.Пол
	|ИЗ
	|	Справочник.Люди КАК Люди
	|ГДЕ
	|	Люди.ПометкаУдаления = ЛОЖЬ
	|	И Люди.ЭтоГруппа = ЛОЖЬ
	|	И Люди.Членство = ИСТИНА
	|	И Люди.Трудосопособность = ИСТИНА
	|
	|УПОРЯДОЧИТЬ ПО
	|	Родитель,
	|	Люди.Пол,
	|	Наименование,
	|	Имя
	|АВТОУПОРЯДОЧИВАНИЕ";
	Выборка = Запрос.Выполнить().Выбрать();
   	
   	КоличествоЛюдей = Выборка.Количество();
   	Если КоличествоЛюдей > 10 Тогда 
   		КоличествоМесяцев = КоличествоЛюдей / 10 + 2;
   	Иначе 
   		КоличествоМесяцев = 2;
   	КонецЕсли;
   	НачалоГрафика		= Объект.ДатаНачала;
   	КонецГрафика		= ДобавитьМесяц(НачалоГрафика, КоличествоМесяцев);
   	ГрафикЗаполнения	= Объект.ГрафикРаботы;

   	РасписаниеСлужений = КалендарныеГрафики.РасписанияРаботыНаПериод(ГрафикЗаполнения , НачалоГрафика, КонецГрафика);
   	
   	Индекс	= 0;
   	
    Пока Выборка.Следующий() Цикл
    	
    	Если Выборка.Пол = Перечисления.Пол.Мужской Тогда
    		Обращение	= "б.";
    	Иначе
    		Обращение	= "с.";
    	КонецЕсли;
    	
   		НоваяСтрока					= Объект.ДатыУборки.Добавить();
    	НоваяСтрока.ФИО				= Обращение + " " + Выборка.Наименование+ " " + Выборка.Имя;
    	НоваяСтрока.НомерТелефона	= УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъекта(Выборка.Ссылка,
    	 		ТекущаяДатаСеанса(),Ложь);
    	СтрТЗ						= РасписаниеСлужений.Получить(Индекс);
    	НоваяСтрока.Дата 			= СтрТЗ.ДатаГрафика;
    	Индекс						= Индекс + 1; 
    КонецЦикла;
   // Объект.Записать();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте 
Процедура Подключаемый_ВыполнитьКоманду(Команда)
          ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры 

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
          ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
          ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры 
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти