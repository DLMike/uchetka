///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Клиентские события формы отчета.

// См. ОтчетыКлиентПереопределяемый.ОбработкаРасшифровки
Процедура ПриОбработкеРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	Если Расшифровка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.АнализЖурналаРегистрации" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрВариантОтчета = ОтчетыКлиентСервер.НайтиПараметр(
		ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки,
		ФормаОтчета.Отчет.КомпоновщикНастроек.ПользовательскиеНастройки,
		"ВариантОтчета");
	Если ПараметрВариантОтчета = Неопределено
	 Или ПараметрВариантОтчета.Значение <> "ПродолжительностьРаботыРегламентныхЗаданий" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	ТипРасшифровки = Расшифровка.Получить(0);
	Если ТипРасшифровки = "РасшифровкаРегламентногоЗадания" Тогда
		
		ВариантРасшифровки = Новый СписокЗначений;
		ВариантРасшифровки.Добавить("СведенияОРегламентномЗадании", НСтр("ru = 'Сведения о регламентном задании'"));
		ВариантРасшифровки.Добавить("ОткрытьЖурналРегистрации", НСтр("ru = 'Перейти к журналу регистрации'"));
		
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Расшифровка", Расшифровка);
		ПараметрыОбработчика.Вставить("ФормаОтчета", ФормаОтчета);
		Обработчик = Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		ФормаОтчета.ПоказатьВыборИзМеню(Обработчик, ВариантРасшифровки);
		
	ИначеЕсли ТипРасшифровки <> Неопределено Тогда
		ПоказатьСведенияОРегламентномЗадании(Расшифровка);
	КонецЕсли;
	
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ОбработкаДополнительнойРасшифровки
Процедура ПриОбработкеДополнительнойРасшифровки(ФормаОтчета, Элемент, Расшифровка, СтандартнаяОбработка) Экспорт
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя <> "Отчет.АнализЖурналаРегистрации" Тогда
		Возврат;
	КонецЕсли;
	Если ТипЗнч(Элемент.ТекущаяОбласть) = Тип("РисунокТабличногоДокумента") Тогда
		Если ТипЗнч(Элемент.ТекущаяОбласть.Объект) = Тип("Диаграмма") Тогда
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// См. ОтчетыКлиентПереопределяемый.ПриНачалеВыбораЗначений
Процедура ПриНачалеВыбораЗначений(ФормаОтчета, УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка) Экспорт
	
	Если ФормаОтчета.НастройкиОтчета.ПолноеИмя = "Отчет.ИзменениеРолейПрофилей" Тогда
		ПриНачалеВыбораЗначенийОтчетаИзменениеРолейПрофилей(ФормаОтчета,
			УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ВыбранныйВариант - СписокЗначений:
//    * Значение - Строка
//  ПараметрыОбработчика - Структура:
//    * Расшифровка - ИдентификаторРасшифровкиКомпоновкиДанных
//    * ФормаОтчета - ФормаКлиентскогоПриложения
//                  - РасширениеУправляемойФормыДляОтчета:
//        ** ОтчетТабличныйДокумент - ТабличныйДокумент
//
Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйВариант, ПараметрыОбработчика) Экспорт
	Если ВыбранныйВариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Действие = ВыбранныйВариант.Значение;
	Если Действие = "СведенияОРегламентномЗадании" Тогда
		
		Диаграмма = ПараметрыОбработчика.ФормаОтчета.ОтчетТабличныйДокумент.Области.ДиаграммаГанта; // РисунокТабличногоДокумента
		ОбъектДиаграммы = Диаграмма.Объект; // ДиаграммаГанта
		СписокТочек = ОбъектДиаграммы.Точки;
		
		СписокТочек = ОбъектДиаграммы.Точки;
		Для Каждого ТочкаДиаграммыГанта Из СписокТочек Цикл
			
			РасшифровкаТочки = ТочкаДиаграммыГанта.Расшифровка;
			Если ТочкаДиаграммыГанта.Значение = НСтр("ru = 'Фоновые задания'") Тогда // АПК:1391 Значение точки диаграммы локализуемое.
				Продолжить;
			КонецЕсли;
			
			Если РасшифровкаТочки.Найти(ПараметрыОбработчика.Расшифровка.Получить(2)) <> Неопределено Тогда
				ПоказатьСведенияОРегламентномЗадании(РасшифровкаТочки);
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли Действие = "ОткрытьЖурналРегистрации" Тогда
		
		СеансРегламентногоЗадания = Новый СписокЗначений;
		СеансРегламентногоЗадания.Добавить(ПараметрыОбработчика.Расшифровка.Получить(1));
		ДатаНачала = ПараметрыОбработчика.Расшифровка.Получить(3);
		ДатаОкончания = ПараметрыОбработчика.Расшифровка.Получить(4);
		ОтборЖурналаРегистрации = Новый Структура("Сеанс, ДатаНачала, ДатаОкончания", 
			СеансРегламентногоЗадания, ДатаНачала, ДатаОкончания);
		ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ОтборЖурналаРегистрации);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПоказатьСведенияОРегламентномЗадании(Расшифровка)
	ПараметрыФормы = Новый Структура("РасшифровкаИзОтчета", Расшифровка);
	ОткрытьФорму("Отчет.АнализЖурналаРегистрации.Форма.СведенияОРегламентномЗадании", ПараметрыФормы);
КонецПроцедуры

// Для процедуры ПриНачалеВыбораЗначений
Процедура ПриНачалеВыбораЗначенийОтчетаИзменениеРолейПрофилей(ФормаОтчета, УсловияВыбора, ОповещениеОЗакрытии, СтандартнаяОбработка)
	
	Если УсловияВыбора.ИмяПоля <> "Роль" Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Выбранные = ОбщегоНазначенияКлиент.СкопироватьРекурсивно(УсловияВыбора.Отмеченные);
	УдалитьПустыеЗначения(Выбранные);
	
	Коллекции = Новый СписокЗначений;
	Коллекции.Добавить("Роли");
	
	ПараметрыПодбора = СтандартныеПодсистемыКлиентСервер.ПараметрыВыбораОбъектовМетаданных();
	ПараметрыПодбора.ВыбиратьСсылки = Истина;
	ПараметрыПодбора.ВыбранныеОбъектыМетаданных = Выбранные;
	ПараметрыПодбора.КоллекцииВыбираемыхОбъектовМетаданных = Коллекции;
	ПараметрыПодбора.СпособГруппировкиОбъектов = "ПоВидам";
	ПараметрыПодбора.Заголовок = НСтр("ru = 'Подбор ролей'");
	
	СтандартныеПодсистемыКлиент.ВыбратьОбъектыМетаданных(ПараметрыПодбора, ОповещениеОЗакрытии);
	
КонецПроцедуры

// Для процедуры ПриНачалеВыбораЗначенийОтчетаИзменениеРолейПрофилей.
Процедура УдалитьПустыеЗначения(ОтмеченныеЗначения)
	
	Индекс = ОтмеченныеЗначения.Количество() - 1;
	
	Пока Индекс >= 0 Цикл 
		Элемент = ОтмеченныеЗначения[Индекс];
		Индекс = Индекс - 1;
		
		Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
			ОтмеченныеЗначения.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти