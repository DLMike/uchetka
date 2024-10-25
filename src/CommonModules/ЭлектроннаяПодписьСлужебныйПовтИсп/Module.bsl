///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура:
//   * ИспользоватьЭлектронныеПодписи - Булево
//   * ИспользоватьШифрование - Булево
//   * ПроверятьЭлектронныеПодписиНаСервере - Булево
//   * СоздаватьЭлектронныеПодписиНаСервере - Булево
//   * ЗаявлениеНаВыпускСертификатаДоступно - Булево
//   * ОписанияПрограмм - ФиксированныйМассив из см. ОписаниеПрограммы
//   * ОписанияПрограммПоСсылке - ФиксированноеСоответствие из КлючИЗначение:
//       ** Ключ - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования
//       ** Значение - см. ОписаниеПрограммы
//
Функция ОбщиеНастройки() Экспорт
	
	ОбщиеНастройки = Новый Структура;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбщиеНастройки.Вставить("ИспользоватьЭлектронныеПодписи",
		Константы.ИспользоватьЭлектронныеПодписи.Получить());
	
	ОбщиеНастройки.Вставить("ИспользоватьШифрование",
		Константы.ИспользоватьШифрование.Получить());
	
	Если ОбщегоНазначения.РазделениеВключено()
	 Или ОбщегоНазначения.ИнформационнаяБазаФайловая()
	   И Не ОбщегоНазначения.КлиентПодключенЧерезВебСервер() Тогда
		
		ОбщиеНастройки.Вставить("ПроверятьЭлектронныеПодписиНаСервере", Ложь);
		ОбщиеНастройки.Вставить("СоздаватьЭлектронныеПодписиНаСервере", Ложь);
	Иначе
		ОбщиеНастройки.Вставить("ПроверятьЭлектронныеПодписиНаСервере",
			Константы.ПроверятьЭлектронныеПодписиНаСервере.Получить());
		
		ОбщиеНастройки.Вставить("СоздаватьЭлектронныеПодписиНаСервере",
			Константы.СоздаватьЭлектронныеПодписиНаСервере.Получить());
	КонецЕсли;
	
	ОбщиеНастройки.Вставить("ЗаявлениеНаВыпускСертификатаДоступно", 
		Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено);
		
	Если ОбщиеНастройки.ЗаявлениеНаВыпускСертификатаДоступно Тогда
		МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата = ОбщегоНазначения.ОбщийМодуль("Обработки.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбщиеНастройки.ЗаявлениеНаВыпускСертификатаДоступно = МодульЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ЗаявлениеНаВыпускСертификатаДоступно();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Программы.Ссылка КАК Ссылка,
	|	Программы.Наименование КАК Представление,
	|	Программы.ИмяПрограммы КАК ИмяПрограммы,
	|	Программы.ТипПрограммы КАК ТипПрограммы,
	|	Программы.АлгоритмПодписи КАК АлгоритмПодписи,
	|	Программы.АлгоритмХеширования КАК АлгоритмХеширования,
	|	Программы.АлгоритмШифрования КАК АлгоритмШифрования,
	|	Программы.РежимИспользования КАК РежимИспользования
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК Программы
	|ГДЕ
	|	НЕ Программы.ПометкаУдаления
	|	И НЕ Программы.ЭтоВстроенныйКриптопровайдер
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Выборка = Запрос.Выполнить().Выбрать();
	ОписанияПрограмм = Новый Массив;
	ОписанияПрограммПоСсылке = Новый Соответствие;
	
	ПрограммыПоИменамСТипом = Новый Соответствие;
	ПрограммыПоИдентификаторамАлгоритмовОткрытогоКлюча = Новый Соответствие;
	
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	НаборыАлгоритмовДляСозданияПодписи = ЭлектроннаяПодписьСлужебныйКлиентСервер.НаборыАлгоритмовДляСозданияПодписи();
	
	Для Каждого ПоставляемаяНастройка Из ПоставляемыеНастройки Цикл
		
		КлючПоискаПрограммыПоИмениСТипом = ЭлектроннаяПодписьСлужебныйКлиентСервер.КлючПоискаПрограммыПоИмениСТипом(
			ПоставляемаяНастройка.ИмяПрограммы, ПоставляемаяНастройка.ТипПрограммы);
			
		Описание = ОписаниеПрограммы();
		ЗаполнитьЗначенияСвойств(Описание, ПоставляемаяНастройка);
		Описание.АлгоритмыПроверкиПодписи = АлгоритмыПроверкиПодписи(ПоставляемаяНастройка);
		ФиксированноеОписание = Новый ФиксированнаяСтруктура(Описание);
		
		ПрограммыПоИменамСТипом.Вставить(КлючПоискаПрограммыПоИмениСТипом, ФиксированноеОписание);
		
		ИдентификаторОткрытогоКлюча = Неопределено;
		Для Каждого ТекущийЭлемент Из НаборыАлгоритмовДляСозданияПодписи Цикл
			Если ТекущийЭлемент.ИменаАлгоритмаПодписи.Найти(ПоставляемаяНастройка.АлгоритмПодписи) <> Неопределено Тогда
				ИдентификаторОткрытогоКлюча = ТекущийЭлемент.ИдентификаторАлгоритмаОткрытогоКлюча;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если ИдентификаторОткрытогоКлюча <> Неопределено Тогда
			ПрограммыПоОткрытомуКлючу = ПрограммыПоИдентификаторамАлгоритмовОткрытогоКлюча.Получить(ИдентификаторОткрытогоКлюча);
			Если ПрограммыПоОткрытомуКлючу = Неопределено Тогда
				ПрограммыПоОткрытомуКлючу = Новый Соответствие; 
			КонецЕсли;
			ПрограммыПоОткрытомуКлючу.Вставить(КлючПоискаПрограммыПоИмениСТипом, ПоставляемаяНастройка.Идентификатор);
			ПрограммыПоИдентификаторамАлгоритмовОткрытогоКлюча.Вставить(ИдентификаторОткрытогоКлюча, ПрограммыПоОткрытомуКлючу);
		КонецЕсли;
		
	КонецЦикла;
	
	Пока Выборка.Следующий() Цикл
		Отбор = Новый Структура("ИмяПрограммы, ТипПрограммы", Выборка.ИмяПрограммы, Выборка.ТипПрограммы);
		Строки = ПоставляемыеНастройки.НайтиСтроки(Отбор);
		Если Строки.Количество() = 0 Тогда
			Идентификатор = "";
			АлгоритмыПроверкиПодписи = Новый Массив;
		Иначе
			Строка = Строки[0]; // СтрокаТаблицыЗначений из см. ЭлектроннаяПодписьСлужебный.ПоставляемыеНастройкиПрограмм
			Идентификатор = Строка.Идентификатор;
			АлгоритмыПроверкиПодписи = АлгоритмыПроверкиПодписи(Строка);
		КонецЕсли;
		
		Описание = ОписаниеПрограммы();
		ЗаполнитьЗначенияСвойств(Описание, Выборка);
		Описание.Идентификатор = Идентификатор;
		Описание.АлгоритмыПроверкиПодписи = АлгоритмыПроверкиПодписи;
		
		ФиксированноеОписание = Новый ФиксированнаяСтруктура(Описание);
		ОписанияПрограмм.Добавить(ФиксированноеОписание);
		
		Если Выборка.РежимИспользования <> Перечисления.РежимыИспользованияПрограммыЭлектроннойПодписи.Автоматически Тогда
			КлючПоискаПрограммыПоИмениСТипом = ЭлектроннаяПодписьСлужебныйКлиентСервер.КлючПоискаПрограммыПоИмениСТипом(
				Выборка.ИмяПрограммы, Выборка.ТипПрограммы);
			// Замена поставляемой настройки настройкой из справочника.
			ПрограммыПоИменамСТипом.Вставить(КлючПоискаПрограммыПоИмениСТипом, ФиксированноеОписание);
		КонецЕсли;
		
		ОписанияПрограммПоСсылке.Вставить(Описание.Ссылка, ФиксированноеОписание);
	КонецЦикла;
	
	ОбщиеНастройки.Вставить("ОписанияПрограмм", Новый ФиксированныйМассив(ОписанияПрограмм));
	ОбщиеНастройки.Вставить("ОписанияПрограммПоСсылке", Новый ФиксированноеСоответствие(ОписанияПрограммПоСсылке));
	ОбщиеНастройки.Вставить("ПоставляемыеПутиКМодулямПрограмм",
		Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеПутиКМодулямПрограмм());
	
	ОбщиеНастройки.Вставить("ВерсияНастроек", Строка(Новый УникальныйИдентификатор));
	ОбщиеНастройки.Вставить("ДоступнаУсовершенствованнаяПодпись", ДоступнаУсовершенствованнаяПодпись());
	
	АдресаСерверовМетокВремени = Константы.АдресаСерверовМетокВремени.Получить();
	Если Не ПустаяСтрока(АдресаСерверовМетокВремени) Тогда
		ОбщиеНастройки.Вставить("АдресаСерверовМетокВремени", СтрРазделить(АдресаСерверовМетокВремени, ", ;" + Символы.ПС));
	Иначе
		ОбщиеНастройки.Вставить("АдресаСерверовМетокВремени", Новый Массив);
	КонецЕсли;
	
	ОбщиеНастройки.Вставить("ЭтоМодельСервисаСДоступнымУсовершенствованием",
		ЭтоМодельСервисаСДоступнымУсовершенствованием());
	ОбщиеНастройки.Вставить("ДоступнаПроверкаПоСпискуУЦ",
		Метаданные.ОбщиеМодули.Найти("ЭлектроннаяПодписьСлужебныйЛокализация") <> Неопределено);
		
	ОбщиеНастройки.Вставить("ДоступнаПроверкаСертификатаВОблачномСервисеСПараметрами", 
		ДоступнаПроверкаСертификатаВОблачномСервисеСПараметрами());
	
	ОбщиеНастройки.Вставить("ПрограммыПоИменамСТипом", Новый ФиксированноеСоответствие(ПрограммыПоИменамСТипом));
	ОбщиеНастройки.Вставить("ПрограммыПоИдентификаторамАлгоритмовОткрытогоКлюча",
		Новый ФиксированноеСоответствие(ПрограммыПоИдентификаторамАлгоритмовОткрытогоКлюча));
	
	ФизическоеЛицоИспользуется = Не (Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.Типы().Количество() = 1
		И Метаданные.ОпределяемыеТипы.ФизическоеЛицо.Тип.Типы()[0] = Тип("Строка"));
		
	ОрганизацияИспользуется = Не (Метаданные.ОпределяемыеТипы.Организация.Тип.Типы().Количество() = 1
		И Метаданные.ОпределяемыеТипы.Организация.Тип.Типы()[0] = Тип("Строка"));
	ОбщиеНастройки.Вставить("ОрганизацияИспользуется", ОрганизацияИспользуется);
	
	ПереопределяемыеНастройки = Новый Структура("ФизическоеЛицоИспользуется", ФизическоеЛицоИспользуется);
	ЭлектроннаяПодписьПереопределяемый.ПриОпределенииНастроек(ПереопределяемыеНастройки);
	ОбщиеНастройки.Вставить("ФизическоеЛицоИспользуется", ПереопределяемыеНастройки.ФизическоеЛицоИспользуется);
		
	Возврат Новый ФиксированнаяСтруктура(ОбщиеНастройки);
	
КонецФункции

// Возвращаемое значение:
//  Структура:
//   * Ссылка - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования
//   * Представление - Строка
//   * ИмяПрограммы - Строка
//   * ТипПрограммы - Число
//   * АлгоритмПодписи - Строка
//   * АлгоритмХеширования - Строка
//   * АлгоритмШифрования - Строка
//   * Идентификатор - Строка
//
Функция ОписаниеПрограммы() Экспорт
	
	Описание = Новый Структура;
	Описание.Вставить("Ссылка");
	Описание.Вставить("Представление");
	Описание.Вставить("ИмяПрограммы");
	Описание.Вставить("ТипПрограммы");
	Описание.Вставить("АлгоритмПодписи");
	Описание.Вставить("АлгоритмХеширования");
	Описание.Вставить("АлгоритмШифрования");
	Описание.Вставить("Идентификатор");
	Описание.Вставить("АлгоритмыПроверкиПодписи");
	Описание.Вставить("РежимИспользования");

	Возврат Описание;
	
КонецФункции

Функция ТипыВладельцев(ТолькоСсылки = Ложь) Экспорт
	
	Результат = Новый Соответствие;
	Типы = Метаданные.ОпределяемыеТипы.ПодписанныйОбъект.Тип.Типы();
	
	ИсключаемыеТипы = Новый Соответствие;
	ИсключаемыеТипы.Вставить(Тип("Неопределено"), Истина);
	ИсключаемыеТипы.Вставить(Тип("Строка"), Истина);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		ИсключаемыеТипы.Вставить(Тип("СправочникСсылка." + "ВерсииФайлов"), Истина);
	КонецЕсли;
	
	Для Каждого Тип Из Типы Цикл
		Если ИсключаемыеТипы.Получить(Тип) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Результат.Вставить(Тип, Истина);
		Если Не ТолькоСсылки Тогда
			ИмяТипаОбъекта = СтрЗаменить(Метаданные.НайтиПоТипу(Тип).ПолноеИмя(), ".", "Объект.");
			Результат.Вставить(Тип(ИмяТипаОбъекта), Истина);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция КлассификаторОшибокКриптографии() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.КлассификаторОшибокКриптографии();
	
КонецФункции

Функция ОшибкаПоКлассификатору(ТекстДляПоискаВКлассификаторе, ОшибкаНаСервере, ОшибкаПроверкиПодписи) Экспорт
	
	КлассификаторОшибок = ЭлектроннаяПодписьСлужебныйПовтИсп.КлассификаторОшибокКриптографии();
	
	Если Не ЗначениеЗаполнено(КлассификаторОшибок) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТекстДляПоиска = НРег(ТекстДляПоискаВКлассификаторе);
	
	Если ОшибкаПроверкиПодписи Тогда
		Если ОшибкаНаСервере Тогда
			Отбор = Новый Структура("ТолькоКлиент, ОшибкаПриПроверкеПодписи", Ложь, Истина);
		Иначе
			Отбор = Новый Структура("ТолькоСервер, ОшибкаПриПроверкеПодписи", Ложь, Истина);
		КонецЕсли;

		СтрокаОшибки = НайтиСтрокуОшибки(КлассификаторОшибок, Отбор, ТекстДляПоиска, ОшибкаНаСервере, ТекстДляПоискаВКлассификаторе);
		Если СтрокаОшибки <> Неопределено Тогда
			Возврат СтрокаОшибки;
		КонецЕсли;
	КонецЕсли;

	Если ОшибкаНаСервере Тогда
		Отбор = Новый Структура("ТолькоКлиент", Ложь);
	Иначе
		Отбор = Новый Структура("ТолькоСервер", Ложь);
	КонецЕсли;

	Возврат НайтиСтрокуОшибки(КлассификаторОшибок, Отбор, ТекстДляПоиска, ОшибкаНаСервере, ТекстДляПоискаВКлассификаторе);

КонецФункции

Функция НайтиСтрокуОшибки(КлассификаторОшибок, Отбор, ТекстДляПоиска, ОшибкаНаСервере, ТекстОшибки)
	
	Строки = КлассификаторОшибок.НайтиСтроки(Отбор);
	Для Каждого СтрокаКлассификатора Из Строки Цикл

		Если СтрНайти(ТекстДляПоиска, СтрокаКлассификатора.ТекстОшибкиНижнийРегистр) <> 0 Тогда

			ПредставлениеОшибки = ЭлектроннаяПодписьСлужебный.ПредставлениеОшибки();
			ЗаполнитьЗначенияСвойств(ПредставлениеОшибки, СтрокаКлассификатора);
			ПредставлениеОшибки.ДействияДляУстранения = ПрочитанныеДействияДляУстраненияОшибок(
				ПредставлениеОшибки.СпособУстранения);
			
			ДополнитьРешениеАвтоматическимиДействиями(ПредставлениеОшибки.Решение,
				ПредставлениеОшибки.ДействияДляУстранения, ОшибкаНаСервере, ТекстОшибки);
			ДополнитьПараметрами(ПредставлениеОшибки.Причина, ПредставлениеОшибки.Решение,
				ПредставлениеОшибки.ДействияДляУстранения, ТекстОшибки);
			
			ПредставлениеОшибки.Причина = СтроковыеФункции.ФорматированнаяСтрока(ПредставлениеОшибки.Причина);
			ПредставлениеОшибки.Решение = СтроковыеФункции.ФорматированнаяСтрока(ПредставлениеОшибки.Решение);

			Возврат Новый ФиксированнаяСтруктура(ПредставлениеОшибки);

		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ДополнитьРешениеАвтоматическимиДействиями(Решение, ДействияДляУстранения, ОшибкаНаСервере, ТекстОшибки)
	
	Если Не ЗначениеЗаполнено(ДействияДляУстранения) Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьПолучениеФайловИзИнтернета = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета");
	
	Для Каждого Действие Из ДействияДляУстранения Цикл
		
		Если Действие = "УстановитьСписокОтзываСертификата" И Не ОшибкаНаСервере И ЕстьПолучениеФайловИзИнтернета Тогда
			Решение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '• <a href=%1>Установите список отзыва</a> удостоверяющего центра автоматически.
				|%2'"), Действие, Решение);
		ИначеЕсли Действие = "УстановитьКорневойСертификат" И Не ОшибкаНаСервере Тогда
			Решение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '• <a href=%1>Установите корневой сертификат</a> удостоверяющего центра автоматически.
				|%2'"), Действие, Решение);
		ИначеЕсли Действие = "УстановитьСертификат" И Не ОшибкаНаСервере Тогда
			Решение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '• <a href=%1>Установите сертификат</a> в Личное хранилище сертификатов пользователя операционной системы автоматически.
				|%2'"), Действие, Решение);
		ИначеЕсли Действие = "УстановитьСертификатВКонтейнер" И Не ОшибкаНаСервере Тогда
			Решение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '• <a href=%1>Установите сертификат в контейнер</a> прямо из приложения.
				|%2'"), Действие, Решение);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДополнитьПараметрами(Причина, Решение, ДействияДляУстранения, ТекстОшибки)
	
	Если Не ЗначениеЗаполнено(ДействияДляУстранения) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Действие Из ДействияДляУстранения Цикл
		
		Если Действие = "УказатьВПричинеСсылкуНаСервис" Тогда
			ДобавитьСсылкуНаСервис(Причина, ТекстОшибки);
		ИначеЕсли Действие = "УказатьВРешенииСсылкуНаСервис" Тогда
			ДобавитьСсылкуНаСервис(Решение, ТекстОшибки);
		КонецЕсли;
		
	КонецЦикла;
	
	УдалитьПараметрыИзСтроки(Причина);
	УдалитьПараметрыИзСтроки(Решение);
	
КонецПроцедуры

Процедура ДобавитьСсылкуНаСервис(Строка, ТекстОшибки)

	Шаблон = "(?i)\b(https?|ftps?|file)://[-A-Z0-9+&@#/%?=~_|$!:,.;]*[A-Z0-9+&@#/%?=_|$]";
	РезультатПоиска = ВычислитьСтрНайтиПоРегулярномуВыражению(ТекстОшибки, Шаблон);
	Если РезультатПоиска.НачальнаяПозиция <> 0 Тогда
		Адрес = СРед(ТекстОшибки, РезультатПоиска.НачальнаяПозиция, РезультатПоиска.Длина);
		Если СтрНачинаетсяС(Адрес, "http") Тогда
			Адрес = СтрШаблон("<a href=%1>%1</a>", Адрес);
		КонецЕсли;
		Строка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Строка,
			Адрес);
	КонецЕсли;

КонецПроцедуры

Процедура УдалитьПараметрыИзСтроки(Строка)
	
	Для НомерПараметра = 1 По 3 Цикл
		Строка = СтрЗаменить(Строка, ":%" + НомерПараметра, "");
		Строка = СтрЗаменить(Строка, " %" + НомерПараметра, "");
		Строка = СтрЗаменить(Строка, "%"  + НомерПараметра, "");
	КонецЦикла;
	
КонецПроцедуры

// Возвращаемое значение:
//  Структура:
//   * Длина            - Число
//   * Значение         - Строка
//   * НачальнаяПозиция - Число
//
Функция ВычислитьСтрНайтиПоРегулярномуВыражению(Текст, ВыражениеДляПоиска)
	
	РезультатВычисления = Новый Структура("НачальнаяПозиция, Длина, Значение",0);
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ВерсияПриложения = СистемнаяИнформация.ВерсияПриложения;
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ВерсияПриложения, "8.3.23.1437") < 0 Тогда
		Возврат РезультатВычисления;
	КонецЕсли;
	
	Выражение = "СтрНайтиПоРегулярномуВыражению(Текст, ВыражениеДляПоиска)";
	
	Попытка
		РезультатВычисления = Вычислить(Выражение); // АПК:488 Исполняемый код - статический, безопасен.
	Исключение
		Возврат РезультатВычисления;
	КонецПопытки;
	
	Возврат РезультатВычисления; // РезультатПоискаПоРегулярномуВыражению
	
КонецФункции

// Только для внутреннего использования.
Функция ПрочитанныеДействияДляУстраненияОшибок(Знач СпособУстранения)
	
	Если Не ЗначениеЗаполнено(СпособУстранения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СпособУстранения = ОбщегоНазначения.JSONВЗначение(СпособУстранения, , Ложь); // Структура
	Возврат СпособУстранения.МетодикиУстранения;
	
КонецФункции

Функция ПутиКПрограммамНаСерверахLinux(ИмяКомпьютера) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ИмяКомпьютера", ИмяКомпьютера);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПутиКПрограмме.Программа,
	|	ПутиКПрограмме.ПутьКПрограмме
	|ИЗ
	|	РегистрСведений.ПутиКПрограммамЭлектроннойПодписиИШифрованияНаСерверахLinux КАК ПутиКПрограмме
	|ГДЕ
	|	ПутиКПрограмме.ИмяКомпьютера = &ИмяКомпьютера";
	
	ПутиКПрограммамНаСерверахLinux = Новый Соответствие;
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	УстановитьПривилегированныйРежим(Ложь);
	Пока Выборка.Следующий() Цикл
		ТекстыОшибок = Новый Массив;
		ОписаниеПути = Новый Структура;
		ОписаниеПути.Вставить("ПутьКПрограмме", Выборка.ПутьКПрограмме);
		ОписаниеПути.Вставить("Существует", ОдинИзМодулейСуществует(Выборка.ПутьКПрограмме, ТекстыОшибок));
		ОписаниеПути.Вставить("ТекстОшибки", ?(ОписаниеПути.Существует, "",
			СтрСоединить(ТекстыОшибок, Символы.ПС)));
		ПутиКПрограммамНаСерверахLinux.Вставить(Выборка.Программа, ОписаниеПути);
	КонецЦикла;
	
	ОбщиеНастройки = ЭлектроннаяПодпись.ОбщиеНастройки();
	ИмяТипаПлатформы = ОбщегоНазначенияКлиентСервер.ИмяТипаПлатформы();
	
	Для Каждого ОписаниеПрограммы Из ОбщиеНастройки.ОписанияПрограмм Цикл
		Если ПутиКПрограммамНаСерверахLinux.Получить(ОписаниеПрограммы.Ссылка) <> Неопределено Тогда
			Если ЗначениеЗаполнено(ОписаниеПрограммы.Идентификатор) Тогда
				ПутиКПрограммамНаСерверахLinux.Вставить(ОписаниеПрограммы.Идентификатор,
					ПутиКПрограммамНаСерверахLinux.Получить(ОписаниеПрограммы.Ссылка));
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		ОписаниеПути = ОписаниеПутиПоИдентификаторуПрограммы(ОписаниеПрограммы.Идентификатор,
			ОбщиеНастройки.ПоставляемыеПутиКМодулямПрограмм, ИмяТипаПлатформы);
		Если ОписаниеПути <> Неопределено Тогда
			ПутиКПрограммамНаСерверахLinux.Вставить(ОписаниеПрограммы.Ссылка, ОписаниеПути);
			ПутиКПрограммамНаСерверахLinux.Вставить(ОписаниеПрограммы.Идентификатор, ОписаниеПути);
		КонецЕсли;
	КонецЦикла;
	
	ПоставляемыеНастройки = Справочники.ПрограммыЭлектроннойПодписиИШифрования.ПоставляемыеНастройкиПрограмм();
	Для Каждого ПоставляемаяНастройка Из ПоставляемыеНастройки Цикл
		Если ПутиКПрограммамНаСерверахLinux.Получить(ПоставляемаяНастройка.Идентификатор) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ОписаниеПути = ОписаниеПутиПоИдентификаторуПрограммы(ПоставляемаяНастройка.Идентификатор,
			ОбщиеНастройки.ПоставляемыеПутиКМодулямПрограмм, ИмяТипаПлатформы);
		Если ОписаниеПути <> Неопределено Тогда
			ПутиКПрограммамНаСерверахLinux.Вставить(ПоставляемаяНастройка.Идентификатор, ОписаниеПути);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ПутиКПрограммамНаСерверахLinux);
	
КонецФункции

Функция ОписаниеПутиПоИдентификаторуПрограммы(Идентификатор,
			ПоставляемыеПутиКМодулямПрограмм, ТипПлатформыСтрокой)
	
	ОписаниеПути = Неопределено;
	
	Для Каждого ПутиКМодулямПрограмм Из ПоставляемыеПутиКМодулямПрограмм Цикл
		Если Не СтрНачинаетсяС(Идентификатор, ПутиКМодулямПрограмм.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		ПутиКМодулямПрограммы = ПутиКМодулямПрограмм.Значение.Получить(ТипПлатформыСтрокой);
		Если ПутиКМодулямПрограммы = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		ТекстыОшибок = Новый Массив;
		ОписаниеПути = Новый Структура("ПутьКПрограмме, Существует, ТекстОшибки",
			ПутиКМодулямПрограммы[0], Ложь, "");
		Для Каждого ПутиКМодулям Из ПутиКМодулямПрограммы Цикл
			Если Не ОдинИзМодулейСуществует(ПутиКМодулям, ТекстыОшибок) Тогда
				Продолжить;
			КонецЕсли;
			ОписаниеПути.ПутьКПрограмме = ПутиКМодулям;
			ОписаниеПути.Существует = Истина;
			Прервать;
		КонецЦикла;
		Если Не ОписаниеПути.Существует Тогда
			ОписаниеПути.ТекстОшибки = СтрСоединить(ТекстыОшибок, Символы.ПС);
		КонецЕсли;
		Прервать;
	КонецЦикла;
	
	Возврат ОписаниеПути;
	
КонецФункции

Функция ОдинИзМодулейСуществует(ПутиКМодулям, ТекстыОшибок)
	
	МодулиПрограммы = СтрРазделить(ПутиКМодулям, ":");
	Результат = Ложь;
	Для Каждого МодульПрограммы Из МодулиПрограммы Цикл
		Файл = Новый Файл(МодульПрограммы);
		Попытка
			Существует = Файл.Существует();
		Исключение
			Существует = Ложь;
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстыОшибок.Добавить(ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		КонецПопытки;
		Если Существует Тогда
			Результат = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ДоступнаПроверкаСертификатаВОблачномСервисеСПараметрами()
	
	Если Не ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	МодульТехнологияСервиса = ОбщегоНазначения.ОбщийМодуль("ТехнологияСервиса");
	Версия = МодульТехнологияСервиса.ВерсияБиблиотеки();
	
	Возврат ОбщегоНазначенияКлиентСервер.СравнитьВерсии(Версия, "2.0.3.0") > 0;
	
КонецФункции

// Функция - Доступна усовершенствованная подпись
// Определяет наличие в платформе типа ПодписьКриптографии
// ЗначениеВСтрокуВнутр(Тип("ПодписьКриптографии")) = "{""T"",a338a24d-6470-4101-8735-008988fb74d8}"
// 
// Возвращаемое значение:
//   Булево
//
Функция ДоступнаУсовершенствованнаяПодпись() Экспорт
	
	Возврат Не ЗначениеИзСтрокиВнутр("{""T"",a338a24d-6470-4101-8735-008988fb74d8}") = Тип("Неопределено");
	
КонецФункции

Функция ЭтоМодельСервисаСДоступнымУсовершенствованием()
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
			
			МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
			НастройкиПодключения = МодульСервисКриптографииDSS.НастройкиПодключенияСлужебнойУчетнойЗаписи();
			
			Возврат НастройкиПодключения.Выполнено;
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ДанныеУдостоверяющегоЦентра(ЗначенияПоиска) Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти("ЭлектроннаяПодписьСлужебныйЛокализация") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	АккредитованныеУдостоверяющиеЦентры = ЭлектроннаяПодписьСлужебныйПовтИсп.АккредитованныеУдостоверяющиеЦентры();
	Если АккредитованныеУдостоверяющиеЦентры = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ЭлектроннаяПодписьКлиентСерверЛокализация.ДанныеУдостоверяющегоЦентра(ЗначенияПоиска, АккредитованныеУдостоверяющиеЦентры);
	
КонецФункции

Функция АккредитованныеУдостоверяющиеЦентры() Экспорт
	
	Если Метаданные.ОбщиеМодули.Найти("ЭлектроннаяПодписьСлужебныйЛокализация") = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МодульЭлектроннаяПодписьСлужебныйЛокализация = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьСлужебныйЛокализация");
	Возврат МодульЭлектроннаяПодписьСлужебныйЛокализация.АккредитованныеУдостоверяющиеЦентры();
	
КонецФункции

Функция КаталогиСписковОтзываУЦ() Экспорт
	
	АккредитованныеУдостоверяющиеЦентры = ЭлектроннаяПодписьСлужебныйПовтИсп.АккредитованныеУдостоверяющиеЦентры();
	МодульЭлектроннаяПодписьКлиентСерверЛокализация = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодписьКлиентСерверЛокализация");
	Возврат МодульЭлектроннаяПодписьКлиентСерверЛокализация.КаталогиСписковОтзываУЦ(АккредитованныеУдостоверяющиеЦентры);
	
КонецФункции

Функция УстановленныеКриптопровайдеры() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.УстановленныеКриптопровайдеры();
	
КонецФункции

Функция АлгоритмыПроверкиПодписи(ПоставляемаяНастройка)
	
	АлгоритмыПроверкиПодписи = ПоставляемаяНастройка.АлгоритмыПроверкиПодписи;
	Если АлгоритмыПроверкиПодписи.Найти(ПоставляемаяНастройка.АлгоритмПодписи) = Неопределено Тогда
		АлгоритмыПроверкиПодписи.Вставить(0, ПоставляемаяНастройка.АлгоритмПодписи);
	КонецЕсли;

	Для Каждого АлгоритмПодписи Из ПоставляемаяНастройка.АлгоритмыПодписи Цикл
		Если АлгоритмыПроверкиПодписи.Найти(АлгоритмПодписи) = Неопределено Тогда
			АлгоритмыПроверкиПодписи.Добавить(АлгоритмПодписи);
		КонецЕсли;
	КонецЦикла;
	
	Возврат АлгоритмыПроверкиПодписи;
	
КонецФункции

#КонецОбласти
