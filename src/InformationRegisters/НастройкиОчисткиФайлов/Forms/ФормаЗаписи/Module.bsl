///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если ЗначениеЗаполнено(ТекущийОбъект.ВладелецФайла) Тогда
		ИнициализироватьКомпоновщик();
	КонецЕсли;
	Если ТекущийОбъект.ПравилоОтбора.Получить() <> Неопределено Тогда
		Правило.ЗагрузитьНастройки(ТекущийОбъект.ПравилоОтбора.Получить());
	КонецЕсли;

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Запись);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = НСтр("ru = 'Настройка очистки файлов:'")
		+ " " + Запись.ВладелецФайла;
	
	Если МассивРеквизитовСТипомДата.Количество() = 0 Тогда
		Элементы.ДобавитьУсловиеПоДате.Доступность = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.ПравилоНастройкиОтборГруппаКолонокПрименение.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ПравилоОтбора = Новый ХранилищеЗначения(Правило.ПолучитьНастройки());
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Запись, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "РегистрСведений.НастройкиОчисткиФайлов.Форма.ДобавлениеУсловияПоДате" Тогда
		ДобавитьВОтборИнтервалИсключение(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		Источник = Новый Массив;
		Источник.Добавить(Запись.ВладелецФайла);
		МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Запись);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Запись);
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализироватьКомпоновщик()
	
	Если Не ЗначениеЗаполнено(Запись.ВладелецФайла) Тогда
		Возврат;
	КонецЕсли;
	
	Правило.Настройки.Отбор.Элементы.Очистить();
	
	СКД = Новый СхемаКомпоновкиДанных;
	ИсточникДанных = СКД.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СКД.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СКД.ПоляИтога.Очистить();
	СКД.НаборыДанных[0].Запрос = ТекстЗапроса();
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	Правило.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Правило.Восстановить(); 
	Правило.Настройки.Структура.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ТекстЗапроса()
	
	МассивРеквизитовСТипомДата.Очистить();
	Если ТипЗнч(Запись.ВладелецФайла) = Тип("СправочникСсылка.ИдентификаторыОбъектовМетаданных") Тогда
		ТипОбъекта = Запись.ВладелецФайла;
	Иначе
		ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ТипЗнч(Запись.ВладелецФайла));
	КонецЕсли;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();

	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	&ПоляВладельцаФайла
		|ИЗ
		|	#ПолноеИмяВладелецФайла";
	
	СведенияОТипеОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ТипОбъекта, "Имя,ПолноеИмя,ЗначениеПустойСсылки");
	ПоляВладельцаФайла = СведенияОТипеОбъекта.Имя + ".Ссылка";
	Если ВсеСправочники.СодержитТип(ТипЗнч(СведенияОТипеОбъекта.ЗначениеПустойСсылки)) Тогда
		Справочник = Метаданные.Справочники[СведенияОТипеОбъекта.Имя];
		Для Каждого Реквизит Из Справочник.Реквизиты Цикл
			ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС + СведенияОТипеОбъекта.Имя + "." + Реквизит.Имя;
		КонецЦикла;
	ИначеЕсли
		ВсеДокументы.СодержитТип(ТипЗнч(СведенияОТипеОбъекта.ЗначениеПустойСсылки)) Тогда
		Документ = Метаданные.Документы[СведенияОТипеОбъекта.Имя];
		Для Каждого Реквизит Из Документ.Реквизиты Цикл
			ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС + СведенияОТипеОбъекта.Имя + "." + Реквизит.Имя;
			Если Реквизит.Тип.СодержитТип(Тип("Дата")) Тогда
				МассивРеквизитовСТипомДата.Добавить(Реквизит.Имя, Реквизит.Синоним);
				ПоляВладельцаФайла = ПоляВладельцаФайла + "," + Символы.ПС 
					+ СтрЗаменить("РАЗНОСТЬДАТ(&ИмяРеквизита, &ТекущаяДата, ДЕНЬ) Как ДнейДоУдаленияОт&ИмяРеквизита",
						"&ИмяРеквизита", Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляВладельцаФайла", ПоляВладельцаФайла);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "#ПолноеИмяВладелецФайла", 
		СведенияОТипеОбъекта.ПолноеИмя + " КАК " + СведенияОТипеОбъекта.Имя);
	Возврат ТекстЗапроса;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьУсловиеПоДате(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РеквизитыСТипомДата", МассивРеквизитовСТипомДата);
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиФайлов.Форма.ДобавлениеУсловияПоДате", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВОтборИнтервалИсключение(Знач ВыбранноеЗначение)
	
	ОтборПоИнтервалу = Правило.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборПоИнтервалу.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДнейДоУдаленияОт" + ВыбранноеЗначение.РеквизитСТипомДата);
	ОтборПоИнтервалу.ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
	ОтборПоИнтервалу.ПравоеЗначение = ВыбранноеЗначение.ИнтервалИсключение;
	ПредставлениеРеквизитаСТипомДата = МассивРеквизитовСТипомДата.НайтиПоЗначению(ВыбранноеЗначение.РеквизитСТипомДата).Представление;
	ТекстПредставления = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Очищать спустя %1 дней относительно даты (%2)'"), 
		ВыбранноеЗначение.ИнтервалИсключение, ПредставлениеРеквизитаСТипомДата);
	ОтборПоИнтервалу.Представление = ТекстПредставления;

КонецПроцедуры

#КонецОбласти