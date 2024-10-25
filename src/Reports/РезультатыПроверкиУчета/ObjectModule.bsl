///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения
//         - Неопределено
//   КлючВарианта - Строка
//                - Неопределено
//   Настройки - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.РазрешеноВыбиратьИНастраиватьВариантыБезСохранения = Истина;
	Настройки.СкрытьКомандыРассылки                              = Истина;
	Настройки.ФормироватьСразу                                   = Истина;
	
	Настройки.События.ПриСозданииНаСервере               = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере    = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   Отказ - Булево - передается из параметров стандартного обработчика ПриСозданииНаСервере "как есть".
//   СтандартнаяОбработка - Булево - передается из параметров стандартного обработчика ПриСозданииНаСервере "как есть".
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ПараметрыФормы = Форма.Параметры;
	Если ПараметрыФормы.Свойство("СсылкаНаОбъект") Тогда
		
		ИмяПроцедуры = "КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемамОбъекта";
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "Форма", Форма, Тип("ФормаКлиентскогоПриложения"));
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "ПроблемныйОбъект", ПараметрыФормы.СсылкаНаОбъект, ОбщегоНазначения.ОписаниеТипаВсеСсылки());
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр(ИмяПроцедуры, "СтандартнаяОбработка", СтандартнаяОбработка, Тип("Булево"));
		
		СтруктураПараметровДанных = Новый Структура("Контекст", ПараметрыФормы.СсылкаНаОбъект);
		УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
		
	ИначеЕсли ПараметрыФормы.Свойство("ДанныеКонтекста") Тогда
		
		Если ТипЗнч(ПараметрыФормы.ДанныеКонтекста) = Тип("Структура") Тогда
			
			ДанныеКонтекста  = ПараметрыФормы.ДанныеКонтекста;
			ВыделенныеСтроки = ДанныеКонтекста.ВыделенныеСтроки;
			
			Если ВыделенныеСтроки.Количество() > 0 Тогда
				
				ПроблемныеОбъекты = КонтрольВеденияУчетаСлужебный.ПроблемныеОбъекты(ДанныеКонтекста.ВыделенныеСтроки);
				
				Если ПроблемныеОбъекты.Количество() = 0 Тогда
					Отказ = Истина;
				Иначе
					
					СписокПроблемныхОбъектов = Новый СписокЗначений;
					СписокПроблемныхОбъектов.ЗагрузитьЗначения(ПроблемныеОбъекты);
					
					СтруктураПараметровДанных = Новый Структура("Контекст", СписокПроблемныхОбъектов);
					УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("МассивСсылок") Тогда
		
		МассивСсылок = ПараметрыФормы.МассивСсылок;
		Если МассивСсылок.Количество() > 0 Тогда
			
			СписокПроблемныхОбъектов = Новый СписокЗначений;
			СписокПроблемныхОбъектов.ЗагрузитьЗначения(МассивСсылок);
			
			СтруктураПараметровДанных = Новый Структура("Контекст", СписокПроблемныхОбъектов);
			УстановитьПараметрыДанных(КомпоновщикНастроек.Настройки, СтруктураПараметровДанных);
			
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("ВидПроверки") Тогда
		
		ТочноеСоответствие = Истина;
		Если ПараметрыФормы.Свойство("ТочноеСоответствие") Тогда
			ТочноеСоответствие = ПараметрыФормы.ТочноеСоответствие;
		КонецЕсли;
		
		ОбщегоНазначенияКлиентСервер.ПроверитьПараметр("КонтрольВеденияУчетаКлиент.ОткрытьОтчетПоПроблемам", "ВидПроверки", 
			ПараметрыФормы.ВидПроверки, КонтрольВеденияУчетаСлужебный.ОписаниеТипаВидПроверки());
		
		ПодробнаяИнформацияПоВидамПроверок = КонтрольВеденияУчета.ПодробнаяИнформацияПоВидамПроверок(ПараметрыФормы.ВидПроверки, ТочноеСоответствие);
		Если ПодробнаяИнформацияПоВидамПроверок.Количество() = 0 Тогда
			Отказ = Истина;
		Иначе
			КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СписокПроблем", ПодготовитьСписокПроверок(ОбщегоНазначенияКлиентСервер.СвернутьМассив(
				ПодробнаяИнформацияПоВидамПроверок.ВыгрузитьКолонку("ПравилоПроверки"))));
		КонецЕсли;
		
	ИначеЕсли ПараметрыФормы.Свойство("ПараметрКоманды") Тогда
		
		Если ТипЗнч(ПараметрыФормы.ПараметрКоманды) = Тип("Массив") И ПараметрыФормы.ПараметрКоманды.Количество() > 0 Тогда
			КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СписокПроблем", ПодготовитьСписокПроверок(ПараметрыФормы.ПараметрКоманды));
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("СписокПроблем") Тогда
		КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("СписокПроблем", Новый СписокЗначений);
	КонецЕсли;
	
	// Добавление команд на командную панель.
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
			МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
			Команда = МодульВерсионированиеОбъектов.КомандаИсторияИзменений(Форма);
			Если Команда <> Неопределено Тогда
				ОтчетыСервер.ВывестиКоманду(Форма, Команда, "Настройки");
			КонецЕсли;
		КонецЕсли;
		
		Команда = Форма.Команды.Добавить("КонтрольВеденияУчетаИгнорироватьПроблему");
		Команда.Действие  = "Подключаемый_Команда";
		Команда.Заголовок = НСтр("ru = 'Игнорировать проблему'");
		Команда.Подсказка = НСтр("ru = 'Игнорировать выбранную проблему'");
		Команда.Картинка  = БиблиотекаКартинок.Закрыть;
		ОтчетыСервер.ВывестиКоманду(Форма, Команда, "Настройки");
	КонецЕсли;
	
КонецПроцедуры

// Вызывается перед загрузкой новых настроек. Используется для изменения СКД отчета.
//
// Параметры:
//   Контекст - Произвольный
//   КлючСхемы - Строка
//   КлючВарианта - Строка
//                - Неопределено
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных
//                    - Неопределено
//   НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных
//                                    - Неопределено
//
Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ПараметрВыводитьОтветственного = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьОтветственного"));
	Если ПараметрВыводитьОтветственного <> Неопределено И НовыеПользовательскиеНастройкиКД <> Неопределено Тогда
		Настройка = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ПараметрВыводитьОтветственного.ИдентификаторПользовательскойНастройки);
		Если Настройка <> Неопределено Тогда
			СкрытьГруппировкуПоОтветственным(НовыеНастройкиКД, Настройка);
		КонецЕсли;
	КонецЕсли;
	
	ДополнительныеСвойства = КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("СписокПроблем") Тогда
		УстановитьОтборПоСпискуПроблем(НовыеНастройкиКД.Отбор, НовыеПользовательскиеНастройкиКД, ДополнительныеСвойства.СписокПроблем);
		ДополнительныеСвойства.Удалить("СписокПроблем");
		НовыеНастройкиКД.ДополнительныеСвойства.Удалить("СписокПроблем");
	КонецЕсли;
	
	Если КлючСхемы <> "1" Тогда
		КлючСхемы = "1";
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
// Более подробное описание можно найти в синтакс-помощнике, а именно, в разделе расширений
// управляемой формы для отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - настройки для загрузки в компоновщик настроек.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ПараметрСКД         = Новый ПараметрКомпоновкиДанных("Контекст");
	КонтекстПараметрСКД = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ПараметрСКД);
	
	Для Каждого Отбор Из НовыеНастройкиКД.Отбор.Элементы Цикл
		Если Отбор.ЛевоеЗначение <> Новый ПолеКомпоновкиДанных("Ответственный") Тогда
			Продолжить;
		КонецЕсли;
		
		ПравоеЗначениеОтбора = Отбор.ПравоеЗначение;// СписокЗначений 
		ПравоеЗначениеОтбора.Добавить(Пользователи.ТекущийПользователь());
		ПравоеЗначениеОтбора.Добавить(Справочники.Пользователи.ПустаяСсылка(), НСтр("ru = 'Без ответственного'"));
		Отбор.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ;
		Если Пользователи.ЭтоПолноправныйПользователь() Тогда
			Отбор.ИдентификаторПользовательскойНастройки = Новый УникальныйИдентификатор;
		КонецЕсли;
	КонецЦикла;
	
	Если КонтекстПараметрСКД <> Неопределено Тогда
		Контекст = КонтекстПараметрСКД.Значение;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контекст) Тогда
		УстановитьПараметрыДанных(НовыеНастройкиКД, Новый Структура("Контекст", Контекст));
	КонецЕсли;
	
	УстановитьЗначенияПараметров(НовыеНастройкиКД);
	
	ДополнительныеСвойства = КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	Если ДополнительныеСвойства.Свойство("СписокПроблем") Тогда
		НовыеНастройкиКД.ДополнительныеСвойства.Вставить("СписокПроблем", КомпоновщикНастроек.Настройки.ДополнительныеСвойства.СписокПроблем);
	КонецЕсли;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПроверкиВеденияУчета = КонтрольВеденияУчетаСлужебныйПовтИсп.ПроверкиВеденияУчета();
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ИнформацияОПоследнейПроверке", ПодсказкаОПоследнейПроверке());
	
	НастройкиКД = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКД, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, Новый Структура("ВнешняяТаблица", ПроверкиВеденияУчета.Проверки), ДанныеРасшифровки, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ДоопределитьГотовыйМакет(ДокументРезультат, СтруктураОтчетаНеИзменена());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПодсказкаОПоследнейПроверке()
	
	ИнформацияОПоследнейПроверке = КонтрольВеденияУчетаСлужебный.ИнформацияОПоследнейПроверкеВеденияУчета();
	Если ЗначениеЗаполнено(ИнформацияОПоследнейПроверке.ДатаПоследнейПроверки) Тогда
		Подсказка = НСтр("ru = 'выполнялась %1.'");
		Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Подсказка, 
			Формат(ИнформацияОПоследнейПроверке.ДатаПоследнейПроверки, "ДЛФ=Д"));
	Иначе
		Подсказка = НСтр("ru = 'еще ни разу не выполнялась.'");
	КонецЕсли;
	Если ИнформацияОПоследнейПроверке.ПредупреждатьОНеобходимостиПовторнойПроверки Тогда
		Подсказка = " " + НСтр("ru = 'Рекомендуется выполнить проверку, чтобы просмотреть актуальные результаты.'");
	КонецЕсли;
		
	Возврат Подсказка;
	
КонецФункции

Процедура ДоопределитьГотовыйМакет(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	ДоопределитьШапку(ДокументРезультат, СтруктураОтчетаНеИзменена);
	ДоопределитьВыводИтогов(ДокументРезультат, СтруктураОтчетаНеИзменена);
	ПроставитьГиперссылкиРешений(ДокументРезультат);
	
КонецПроцедуры

Процедура ДоопределитьШапку(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	КлючПоискаЛокализуемый = "[ЗаголовокСкрыт]";
	КлючПоискаНеЛокализуемый = "[ЗаголовокСкрыт]"; // @Non-NLS
	Если СтруктураОтчетаНеИзменена Тогда
		
		ПерваяСтрока    = 0;
		ПоследняяСтрока = 0;
		
		ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
		
		Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
			
			ИмяОбласти = "R" + Формат(ИндексСтрок, "ЧГ=0");
			Область    = ДокументРезультат.Область(ИмяОбласти);
			
			Если СтрНайти(Область.Текст, КлючПоискаЛокализуемый) <> 0
				Или СтрНайти(Область.Текст, КлючПоискаНеЛокализуемый) <> 0 Тогда
				Если ПерваяСтрока = 0 Тогда
					ПерваяСтрока = ИндексСтрок;
				КонецЕсли;
				ПоследняяСтрока = ПоследняяСтрока + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ПерваяСтрока = 0 И ПоследняяСтрока = 0 Тогда
			Возврат;
		КонецЕсли;
		
		ДокументРезультат.УдалитьОбласть(ДокументРезультат.Область("R" + Формат(ПерваяСтрока, "ЧГ=0") + ":R" + Формат(ПерваяСтрока + ПоследняяСтрока - 1, "ЧГ=0")),
			ТипСмещенияТабличногоДокумента.ПоВертикали);
		
		ДокументРезультат.ФиксацияСверху = 0;
		ДокументРезультат.ФиксацияСлева  = 0;
		
	Иначе
		
		ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
		ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
		
		Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
			Для ИндексКолонок = 1 По ШиринаТаблицы Цикл
			
				ИмяОбласти = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
				Область    = ДокументРезультат.Область(ИмяОбласти);
				
				Если СтрНайти(Область.Текст, КлючПоискаЛокализуемый) <> 0
					Или СтрНайти(Область.Текст, КлючПоискаНеЛокализуемый) <> 0 Тогда
					Область.Текст = СтрЗаменить(Область.Текст, КлючПоискаЛокализуемый, "");
					Область.Текст = СтрЗаменить(Область.Текст, КлючПоискаНеЛокализуемый, "");
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли
	
КонецПроцедуры

Процедура ДоопределитьВыводИтогов(ДокументРезультат, СтруктураОтчетаНеИзменена)
	
	Если Не СтруктураОтчетаНеИзменена Тогда
		Возврат;
	КонецЕсли;
	
	ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
	ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
	
	СтруктураЛокализованныхПараметров = СтруктураЛокализованныхПараметров();
	
	Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
		ИмяОбласти   = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C1";
		Область      = ДокументРезультат.Область(ИмяОбласти);
		ТекстОбласти = СокрЛП(ВРег(Область.Текст));
		
		Если ТекстОбласти =    ВРег(СтруктураЛокализованныхПараметров.НадписьОшибка)
			Или ТекстОбласти = ВРег(СтруктураЛокализованныхПараметров.НадписьВозможныеПричины)
			Или ТекстОбласти = ВРег(СтруктураЛокализованныхПараметров.НадписьРекомендации)
			Или ТекстОбласти = ВРег(СтруктураЛокализованныхПараметров.НадписьРешение) Тогда
			
			Для ИндексКолонок = 3 По ШиринаТаблицы Цикл
				ИмяОбластиРесурсов    = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
				ОбластьРесурсов       = ДокументРезультат.Область(ИмяОбластиРесурсов);
				ОбластьРесурсов.Текст = "";
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроставитьГиперссылкиРешений(ДокументРезультат)
	
	ШиринаТаблицы = ДокументРезультат.ШиринаТаблицы;
	ВысотаТаблицы = ДокументРезультат.ВысотаТаблицы;
	
	Для ИндексСтрок = 1 По ВысотаТаблицы Цикл
		
		Для ИндексКолонок = 1 По ШиринаТаблицы Цикл
			
			ИмяОбласти   = "R" + Формат(ИндексСтрок, "ЧГ=0") + "C" + Формат(ИндексКолонок, "ЧГ=0");
			Область      = ДокументРезультат.Область(ИмяОбласти);
			ТекстОбласти = Область.Текст;
			
			Если СтрНачинаетсяС(ТекстОбласти, "%") И СтрЗаканчиваетсяНа(ТекстОбласти, "%") Тогда
				
				ТекстОбласти      = СокрЛП(СтрЗаменить(ТекстОбласти, "%", ""));
				РазделеннаяСтрока = СтрРазделить(ТекстОбласти, ",");
				
				Если РазделеннаяСтрока.Количество() <> 3 Тогда
					Продолжить;
				КонецЕсли;
				
				ОбработчикПереходаКИсправлению = РазделеннаяСтрока.Получить(1);
				Если Не ЗначениеЗаполнено(ОбработчикПереходаКИсправлению) Тогда
					Область.Текст = "";
					Продолжить;
				КонецЕсли;
				
				ВидПроверки = Справочники.ВидыПроверок.ПолучитьСсылку(Новый УникальныйИдентификатор(РазделеннаяСтрока.Получить(2)));
				
				СтруктураРасшифровки = Новый Структура;
				
				СтруктураРасшифровки.Вставить("Назначение",                     "ИсправитьПроблемы");
				СтруктураРасшифровки.Вставить("ИдентификаторПроверки",          РазделеннаяСтрока.Получить(0));
				СтруктураРасшифровки.Вставить("ОбработчикПереходаКИсправлению", ОбработчикПереходаКИсправлению);
				СтруктураРасшифровки.Вставить("ВидПроверки",                    ВидПроверки);
				
				Область.Расшифровка = СтруктураРасшифровки;
				
				ОтчетыСервер.ВывестиГиперссылку(Область, СтруктураРасшифровки, НСтр("ru = 'Выполнить исправление'"));
				
			ИначеЕсли СтрНайти(ТекстОбласти, "<РасшифровкаСписка>") <> 0 Тогда
				
				СтруктураРасшифровки = Новый Структура;
				СтруктураРасшифровки.Вставить("Назначение", "ОткрытьФормуСписка");
				
				ОтборНабораЗаписей = Новый Структура;
				РазделенныйТекст   = СтрРазделить(ТекстОбласти, Символы.ПС);
				
				Для Каждого ЭлементТекста Из РазделенныйТекст Цикл
					
					Если РазделенныйТекст.Найти(ЭлементТекста) = 0 Тогда
						Продолжить;
					ИначеЕсли РазделенныйТекст.Найти(ЭлементТекста) = 1 Тогда
						СтруктураРасшифровки.Вставить("ПолноеИмяОбъекта", ЭлементТекста);
						Продолжить;
					КонецЕсли;
					
					РазделенныйЭлементТекста = СтрРазделить(ЭлементТекста, "~~~", Ложь);
					Если РазделенныйЭлементТекста.Количество() <> 3 Тогда
						Продолжить;
					КонецЕсли;
					
					ИмяОтбора             = РазделенныйЭлементТекста.Получить(0);
					ТипЗначенияОтбора     = РазделенныйЭлементТекста.Получить(1);
					ЗначениеОтбораСтрокой = РазделенныйЭлементТекста.Получить(2);
					
					Если ТипЗначенияОтбора = "Число" Или ТипЗначенияОтбора = "Строка" 
						Или ТипЗначенияОтбора = "Булево" Или ТипЗначенияОтбора = "Дата" Тогда
						
						ЗначениеОтбора = XMLЗначение(Тип(ТипЗначенияОтбора), ЗначениеОтбораСтрокой);
						
					ИначеЕсли ОбщегоНазначения.ЭтоПеречисление(ОбщегоНазначения.ОбъектМетаданныхПоПолномуИмени(ТипЗначенияОтбора)) Тогда
						
						ЗначениеОтбора = XMLЗначение(Тип(СтрЗаменить(ТипЗначенияОтбора, "Перечисление", "ПеречислениеСсылка")), ЗначениеОтбораСтрокой);
						
					Иначе
						
						МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ТипЗначенияОтбора);
						Если МенеджерОбъекта = Неопределено Тогда
							Продолжить;
						КонецЕсли;
						ЗначениеОтбора = МенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(ЗначениеОтбораСтрокой));
						
					КонецЕсли;
					
					ОтборНабораЗаписей.Вставить(ИмяОтбора, ЗначениеОтбора);
					
				КонецЦикла;
				СтруктураРасшифровки.Вставить("Отбор", ОтборНабораЗаписей);
				
				Область.Расшифровка = СтруктураРасшифровки;
				
				Если РазделенныйТекст.Количество() <> 0 Тогда
					Область.Текст = СтрЗаменить(РазделенныйТекст.Получить(0), "<РасшифровкаСписка>", "");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПодготовитьСписокПроверок(МассивПроверок)
	СписокПроверок = Новый СписокЗначений;
	ПервыйЭлемент  = МассивПроверок.Получить(0);
	
	Если Не ОбщегоНазначения.ЗначениеСсылочногоТипа(ПервыйЭлемент) Тогда
		СписокПроверок.ЗагрузитьЗначения(МассивПроверок);
	Иначе
		РезультатЗапроса = СписокПроверок(МассивПроверок, ПервыйЭлемент);
		Для Каждого ЭлементРезультата Из РезультатЗапроса Цикл
			СписокПроверок.Добавить(ЭлементРезультата.Ссылка, ЭлементРезультата.ПредставлениеСсылки);
		КонецЦикла;
	КонецЕсли;
	
	Возврат СписокПроверок;
КонецФункции

// Параметры:
//   МассивПроверок - Массив из ЛюбаяСсылка
//   ПервыйЭлемент - ЛюбаяСсылка
// Возвращаемое значение:
//   ТаблицаЗначений:
//   *Ссылка - ЛюбаяСсылка
//   *ПредставлениеСсылки - Строка
//
Функция СписокПроверок(Знач МассивПроверок, ПервыйЭлемент)
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(Таблица.Ссылка) КАК ПредставлениеСсылки
	|ИЗ
	|	&Таблица КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В(&МассивСсылок)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&Таблица", ПервыйЭлемент.Метаданные().ПолноеИмя());
	Запрос       = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("МассивСсылок", МассивПроверок);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	Возврат РезультатЗапроса
КонецФункции

Процедура УстановитьПараметрыДанных(НастройкиКД, СтруктураПараметров)
	
	ПараметрыДанных = НастройкиКД.ПараметрыДанных.Элементы;
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
	
		ТекущийПараметр   = Новый ПараметрКомпоновкиДанных(Параметр.Ключ);
		ТекущийПараметрКД = ПараметрыДанных.Найти(ТекущийПараметр);
	
		Если ТекущийПараметрКД <> Неопределено Тогда
	
			ТекущийПараметрКД.Использование = Истина;
			ТекущийПараметрКД.Значение      = Параметр.Значение;
	
		Иначе
	
			ПараметрДанных               = НастройкиКД.ПараметрыДанных.Элементы.Добавить();
			ПараметрДанных.Использование = Истина;
			ПараметрДанных.Значение      = Параметр.Значение;
			ПараметрДанных.Параметр      = Новый ПараметрКомпоновкиДанных(Параметр.Ключ);
	
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗначенияПараметров(НастройкиКД)
	
	ПараметрыДанных = НастройкиКД.ПараметрыДанных.Элементы;
	
	СтруктураЛокализованныхПараметров = СтруктураЛокализованныхПараметров();
	
	Для Каждого ЭлементСтруктуры Из СтруктураЛокализованныхПараметров Цикл
		
		ТекущийПараметрКД = ПараметрыДанных.Найти(Новый ПараметрКомпоновкиДанных(ЭлементСтруктуры.Ключ));
		Если ТекущийПараметрКД <> Неопределено Тогда
			ТекущийПараметрКД.Использование = Истина;
			ТекущийПараметрКД.Значение      = ЭлементСтруктуры.Значение;
		Иначе
			ПараметрДанных               = НастройкиКД.ПараметрыДанных.Элементы.Добавить();
			ПараметрДанных.Использование = Истина;
			ПараметрДанных.Значение      = ЭлементСтруктуры.Значение;
			ПараметрДанных.Параметр      = Новый ПараметрКомпоновкиДанных(ЭлементСтруктуры.Ключ);
		КонецЕсли;
			
	КонецЦикла;
	
КонецПроцедуры

Функция СтруктураЛокализованныхПараметров()
	
	СтруктураЛокализованныхПараметров = Новый Структура;
	СтруктураЛокализованныхПараметров.Вставить("НадписьОшибка",            НСтр("ru = 'Ошибка'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьВозможныеПричины",  НСтр("ru = 'Возможные причины'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьРекомендации",      НСтр("ru = 'Рекомендации'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьРешение",           НСтр("ru = 'Решение'"));
	СтруктураЛокализованныхПараметров.Вставить("НадписьПроблемныеОбъекты", НСтр("ru = 'Проблемные объекты'"));
	
	Возврат СтруктураЛокализованныхПараметров;
	
КонецФункции

Процедура УстановитьОтборПоСпискуПроблем(ОтборНастроекКД, ПользовательскиеНастройки, ЗначениеОтбора)
	
	ПредставлениеОтбора = "";
	Для Каждого ЭлементСпискаОтбора Из ЗначениеОтбора Цикл
		ПредставлениеОтбора = ПредставлениеОтбора + ?(ЗначениеЗаполнено(ПредставлениеОтбора), "; ", "") + Лев(ЭлементСпискаОтбора.Представление, 25) + "...";
	КонецЦикла;
	
	ЭлементыОтбора = ОтборНастроекКД.Элементы;
	ИдентификаторНастройки = Неопределено;
	Для Каждого ЭлементОтбора Из ЭлементыОтбора Цикл
		Если ЭлементОтбора.ЛевоеЗначение <> Новый ПолеКомпоновкиДанных("ПравилоПроверки") Тогда
			Продолжить;
		КонецЕсли;
		ИдентификаторНастройки = ЭлементОтбора.ИдентификаторПользовательскойНастройки;
		Прервать;
	КонецЦикла;
	
	Если ИдентификаторНастройки <> Неопределено Тогда
		Настройка = ПользовательскиеНастройки.Элементы.Найти(ИдентификаторНастройки);
		Если Настройка = Неопределено Тогда
			Возврат;
		КонецЕсли;
		Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
			Настройка.ПравоеЗначение = ЗначениеОтбора;
			Настройка.Использование  = Истина;
		Иначе
			Настройка.Использование  = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭлементОтбора                  = ЭлементыОтбора.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("ПравилоПроверки");
	ЭлементОтбора.ВидСравнения     = ВидСравнения;
	ЭлементОтбора.ПравоеЗначение   = ЗначениеОтбора;
	ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ЭлементОтбора.Представление    = НСтр("ru = 'Правило проверки В списке'") + " """ + ПредставлениеОтбора + """";
	ЭлементОтбора.Использование    = Истина;
	
КонецПроцедуры

Процедура СкрытьГруппировкуПоОтветственным(НовыеНастройкиКД, Настройка)
	
	Если НовыеНастройкиКД <> Неопределено Тогда
		НайденнаяТаблица = Неопределено;
		Для Каждого Строка Из НовыеНастройкиКД.Структура Цикл
			Если Строка.Имя = "ОбщаяТаблица" Тогда
				НайденнаяТаблица = Строка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если НайденнаяТаблица = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ГруппировкаПоОтветственномуКолонки = НайтиГруппировку(НайденнаяТаблица.Колонки, "ОтветственныйГруппировка");
		ПолеОтветственного                 = НайтиПолеГруппировки(НайденнаяТаблица.Строки, "Ответственный");
		Если ПолеОтветственного <> Неопределено Тогда
			ПолеОтветственного.Использование = Настройка.Значение;
		КонецЕсли;
		Если ГруппировкаПоОтветственномуКолонки <> Неопределено Тогда
			ГруппировкаПоОтветственномуКолонки.Состояние = ?(Настройка.Значение, СостояниеЭлементаНастройкиКомпоновкиДанных.Включен,
				СостояниеЭлементаНастройкиКомпоновкиДанных.Отключен);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция НайтиГруппировку(Структура, ИмяПоля)
	
	Для каждого Элемент Из Структура Цикл
		
		ПоляГруппировки = Элемент.ПоляГруппировки.Элементы;
		Для Каждого Поле Из ПоляГруппировки Цикл
			
			Если ТипЗнч(Поле) = Тип("АвтоПолеГруппировкиКомпоновкиДанных") Тогда
				Продолжить;
			КонецЕсли;
			Если Поле.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
				Возврат Элемент;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Элемент.Структура.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		Группировка = НайтиГруппировку(Элемент.Структура, ИмяПоля);
	
	КонецЦикла;
	
	Возврат Группировка;
	
КонецФункции

Функция НайтиПолеГруппировки(Структура, ИмяПоля)
	
	Группировка = НайтиГруппировку(Структура, ИмяПоля);
	
	Если Группировка = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ПоляГруппировки = Группировка.ПоляГруппировки.Элементы;
	НайденноеПоле   = Неопределено;
	
	Для Каждого ПолеГруппировки Из ПоляГруппировки Цикл
		ЦелевоеПоле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		Если ПолеГруппировки.Поле = ЦелевоеПоле Тогда
			НайденноеПоле = ПолеГруппировки;
		КонецЕсли;
	КонецЦикла;
	
	Возврат НайденноеПоле;
	
КонецФункции

Функция СтруктураОтчетаНеИзменена(ИсходнаяСтруктура = Неопределено, КонечнаяСтруктура = Неопределено)
	
	ИсходнаяСтруктура = СтруктураОтчетаДеревом(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонечнаяСтруктура = СтруктураОтчетаДеревом(КомпоновщикНастроек.Настройки);
	Возврат ДеревьяИдентичны(ИсходнаяСтруктура, КонечнаяСтруктура);
	
КонецФункции

Функция ДеревьяИдентичны(ПервоеДерево, ВтороеДерево, СвойстваДляСравнения = Неопределено)
	
	Если СвойстваДляСравнения = Неопределено Тогда
		СвойстваДляСравнения = Новый Массив;
		СвойстваДляСравнения.Добавить("Тип");
		СвойстваДляСравнения.Добавить("Подтип");
		СвойстваДляСравнения.Добавить("ЕстьСтруктура");
	КонецЕсли;
	
	СтрокиПервогоДерева = ПервоеДерево.Строки;
	СтрокиВторогоДерева = ВтороеДерево.Строки;
	
	КоличествоСтрокПервогоДерева  = СтрокиПервогоДерева.Количество();
	КоличествоСтрокиВторогоДерева = СтрокиВторогоДерева.Количество();
	
	Если КоличествоСтрокПервогоДерева <> КоличествоСтрокиВторогоДерева Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для ИндексСтроки = 0 По КоличествоСтрокПервогоДерева - 1 Цикл
		
		ТекущаяСтрокаПервогоДерева = СтрокиПервогоДерева.Получить(ИндексСтроки);
		ТекущаяСтрокаВторогоДерева = СтрокиВторогоДерева.Получить(ИндексСтроки);
		
		Для Каждого СвойствоДляСравнения Из СвойстваДляСравнения Цикл
			
			Если ТекущаяСтрокаПервогоДерева[СвойствоДляСравнения] <> ТекущаяСтрокаВторогоДерева[СвойствоДляСравнения] Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЦикла;
		
		Если Не НастройкиУзловКДИдентичны(ТекущаяСтрокаПервогоДерева.УзелКД, ТекущаяСтрокаВторогоДерева.УзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ДеревьяИдентичны(ТекущаяСтрокаПервогоДерева, ТекущаяСтрокаВторогоДерева, СвойстваДляСравнения) Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция НастройкиУзловКДИдентичны(ПервыйУзелКД, ВторойУзелКД)
	
	Если ТипЗнч(ПервыйУзелКД) <> ТипЗнч(ВторойУзелКД) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(ПервыйУзелКД) = Тип("НастройкиКомпоновкиДанных") Тогда
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ПользовательскиеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("ТаблицаКомпоновкиДанных") Тогда
		
		Если Не СвойстваТаблицКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("КоллекцияЭлементовСтруктурыТаблицыКомпоновкиДанных") Тогда
		
		Если Не СвойстваКоллекцийЭлементовСтруктурыТаблицыКомпоновкиДанныхИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПервыйУзелКД) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Или ТипЗнч(ПервыйУзелКД) = Тип("ГруппировкаКомпоновкиДанных") Тогда
		
		Если Не СвойстваГруппировокКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если Не ПоляГруппировокКомпоновкиИдентичны(ПервыйУзелКД, ВторойУзелКД) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Параметры:
//   ПервыйУзелКД - НастройкиКомпоновкиДанных 
//   ВторойУзелКД - НастройкиКомпоновкиДанных
// Возвращаемое значение:
//   Булево
//
Функция ВыбранныеПоляИдентичны(ПервыйУзелКД, ВторойУзелКД)
	
	ВыбранныеПоляПервогоУзла = ПервыйУзелКД.Выбор.Элементы;
	ВыбранныеПоляВторогоУзла = ВторойУзелКД.Выбор.Элементы;
	
	КоличествоВыбранныхПолейПервогоУзла = ВыбранныеПоляПервогоУзла.Количество();
	КоличествоВыбранныхПолейВторогоУзла = ВыбранныеПоляВторогоУзла.Количество();
	
	Если КоличествоВыбранныхПолейПервогоУзла <> КоличествоВыбранныхПолейВторогоУзла Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СвойстваВыбранныхПолей = Новый Массив;
	
	Для Индекс = 0 По КоличествоВыбранныхПолейПервогоУзла - 1 Цикл
		
		ТекущаяСтрокаПервойКоллекции = ВыбранныеПоляПервогоУзла.Получить(Индекс);
		ТекущаяСтрокаВторойКоллекции = ВыбранныеПоляВторогоУзла.Получить(Индекс);
		
		Если ТипЗнч(ТекущаяСтрокаПервойКоллекции) <> ТипЗнч(ТекущаяСтрокаВторойКоллекции) Тогда
			Возврат Ложь;
		КонецЕсли;
		
		Если ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("АвтоВыбранноеПолеКомпоновкиДанных") Тогда
			
			СвойстваВыбранныхПолей.Добавить("Использование");
			СвойстваВыбранныхПолей.Добавить("Родитель");
			
		ИначеЕсли ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			
			СвойстваВыбранныхПолей.Добавить("Заголовок");
			СвойстваВыбранныхПолей.Добавить("Использование");
			СвойстваВыбранныхПолей.Добавить("Поле");
			СвойстваВыбранныхПолей.Добавить("РежимОтображения");
			СвойстваВыбранныхПолей.Добавить("Родитель");
			
		ИначеЕсли ТипЗнч(ТекущаяСтрокаПервойКоллекции) = Тип("ГруппаВыбранныхПолейКомпоновкиДанных") Тогда
			
			Возврат Истина;
			
		КонецЕсли;
		
		Если Не СравнитьСущностиПоСвойствам(ТекущаяСтрокаПервойКоллекции, ТекущаяСтрокаВторойКоллекции, СвойстваВыбранныхПолей) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваТаблицКомпоновкиИдентичны(ПерваяТаблица, ВтораяТаблица)
	
	СвойстваТаблицыКомпоновки = Новый Массив;
	СвойстваТаблицыКомпоновки.Добавить("Идентификатор");
	СвойстваТаблицыКомпоновки.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("Имя");
	СвойстваТаблицыКомпоновки.Добавить("Использование");
	СвойстваТаблицыКомпоновки.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("РежимОтображения");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяТаблица, ВтораяТаблица, СвойстваТаблицыКомпоновки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваГруппировокКомпоновкиИдентичны(ПерваяТаблица, ВтораяТаблица)
	
	СвойстваТаблицыКомпоновки = Новый Массив;
	СвойстваТаблицыКомпоновки.Добавить("Идентификатор");
	СвойстваТаблицыКомпоновки.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("Имя");
	СвойстваТаблицыКомпоновки.Добавить("Использование");
	СвойстваТаблицыКомпоновки.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваТаблицыКомпоновки.Добавить("РежимОтображения");
	СвойстваТаблицыКомпоновки.Добавить("Состояние");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяТаблица, ВтораяТаблица, СвойстваТаблицыКомпоновки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СвойстваКоллекцийЭлементовСтруктурыТаблицыКомпоновкиДанныхИдентичны(ПерваяКоллекция, ВтораяКоллекция)
	
	СвойстваКоллекции = Новый Массив;
	СвойстваКоллекции.Добавить("ИдентификаторПользовательскойНастройки");
	СвойстваКоллекции.Добавить("ПредставлениеПользовательскойНастройки");
	СвойстваКоллекции.Добавить("РежимОтображения");
	
	Если Не СравнитьСущностиПоСвойствам(ПерваяКоллекция, ВтораяКоллекция, СвойстваКоллекции) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Параметры:
//   ПерваяГруппировка - ГруппировкаТаблицыКомпоновкиДанных 
//   ВтораяГруппировка - ГруппировкаТаблицыКомпоновкиДанных
// Возвращаемое значение:
//   Булево
//
Функция ПоляГруппировокКомпоновкиИдентичны(ПерваяГруппировка, ВтораяГруппировка)
	
	ПерваяКоллекцияПолей = ПерваяГруппировка.ПоляГруппировки.Элементы;
	ВтораяКоллекцияПолей = ВтораяГруппировка.ПоляГруппировки.Элементы;
	
	КоличествоПолейВПервойКоллекции  = ПерваяКоллекцияПолей.Количество();
	КоличествоПолейВоВторойКоллекции = ВтораяКоллекцияПолей.Количество();
	
	СвойстваПолей = Новый Массив;
	СвойстваПолей.Добавить("Использование");
	СвойстваПолей.Добавить("КонецПериода");
	СвойстваПолей.Добавить("НачалоПериода");
	СвойстваПолей.Добавить("Поле");
	СвойстваПолей.Добавить("ТипГруппировки");
	СвойстваПолей.Добавить("ТипДополнения");
	
	Если КоличествоПолейВПервойКоллекции <> КоличествоПолейВоВторойКоллекции Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Индекс = 0 По КоличествоПолейВПервойКоллекции - 1 Цикл
		
		ТекущаяСтрокаПервогоПоля = ПерваяКоллекцияПолей.Получить(Индекс);
		ТекущаяСтрокаВторогоПоля = ВтораяКоллекцияПолей.Получить(Индекс);
		
		Если Не СравнитьСущностиПоСвойствам(ТекущаяСтрокаПервогоПоля, ТекущаяСтрокаВторогоПоля, СвойстваПолей) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Параметры:
//   ПервыеНастройкиКД - НастройкиКомпоновкиДанных
//   ВторыеНастройкиКД - НастройкиКомпоновкиДанных
// Возвращаемое значение:
//   Булево
//
Функция ПользовательскиеПоляИдентичны(ПервыеНастройкиКД, ВторыеНастройкиКД)
	
	Если ПервыеНастройкиКД.ПользовательскиеПоля.Элементы.Количество() <> ВторыеНастройкиКД.ПользовательскиеПоля.Элементы.Количество() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция СравнитьСущностиПоСвойствам(ПерваяСущность, ВтораяСущность, Свойства)
	
	Для Каждого Свойство Из Свойства Цикл
		
		Если ЭтоИсключение(ПерваяСущность, Свойство) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПерваяСущность[Свойство] <> ВтораяСущность[Свойство] Тогда
			Возврат Ложь
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

Функция ЭтоИсключение(ПерваяСущность, Свойство)
	
	Если ТипЗнч(ПерваяСущность) = Тип("ГруппировкаТаблицыКомпоновкиДанных") Тогда
		
		Если ПерваяСущность.Имя = "Ответственный" И Свойство = "Состояние" Тогда
			Возврат Истина;
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПерваяСущность) = Тип("ПолеГруппировкиКомпоновкиДанных") Тогда
		
		Если ПерваяСущность.Поле = Новый ПолеКомпоновкиДанных("Ответственный") И Свойство = "Использование" Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция СтруктураОтчетаДеревом(НастройкиКД)
	
	ДеревоСтруктуры       = ДеревоСтруктуры();
	ЗарегистрироватьУзелДереваВарианта(НастройкиКД, НастройкиКД, ДеревоСтруктуры.Строки);
	Возврат ДеревоСтруктуры;
	
КонецФункции

// Возвращаемое значение:
//   ДеревоЗначений:
//   * УзелКД - КоллекцияЭлементовСтруктурыНастроекКомпоновкиДанных
//   * Тип - Строка
//   * Подтип - Строка
//   * ЕстьСтруктура - Булево
//
Функция ДеревоСтруктуры()
	
	ДеревоСтруктуры = Новый ДеревоЗначений;
	
	КолонкиДереваСтруктуры = ДеревоСтруктуры.Колонки;
	КолонкиДереваСтруктуры.Добавить("УзелКД");
	КолонкиДереваСтруктуры.Добавить("ДоступнаяНастройкаКД");
	КолонкиДереваСтруктуры.Добавить("Тип",                 Новый ОписаниеТипов("Строка"));
	КолонкиДереваСтруктуры.Добавить("Подтип",              Новый ОписаниеТипов("Строка"));
	КолонкиДереваСтруктуры.Добавить("ЕстьСтруктура",       Новый ОписаниеТипов("Булево"));
	
	Возврат ДеревоСтруктуры;
	
КонецФункции

Функция ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД, НаборСтрокДерева, ПодТип = "")
	
	СтрокаДерева = НаборСтрокДерева.Добавить();
	СтрокаДерева.УзелКД = УзелКД;
	СтрокаДерева.Тип    = ОтчетыКлиентСервер.ТипНастройкиСтрокой(ТипЗнч(УзелКД));
	СтрокаДерева.Подтип = ПодТип;
	
	Если СтрРазделить("Настройки,Группировка,ГруппировкаДиаграммы,ГруппировкаТаблицы", ",").Найти(СтрокаДерева.Тип) <> Неопределено Тогда
		СтрокаДерева.ЕстьСтруктура = Истина;
	ИначеЕсли СтрРазделить("Таблица,Диаграмма,НастройкиВложенногоОбъекта,КоллекцияЭлементовСтруктурыТаблицы
			|КоллекцияЭлементовСтруктурыДиаграммы", "," + Символы.ПС, Ложь).Найти(СтрокаДерева.Тип) = Неопределено Тогда
		Возврат СтрокаДерева;
	КонецЕсли;
	
	Если СтрокаДерева.ЕстьСтруктура Тогда
		Для Каждого ВложенныйЭлемент Из УзелКД.Структура Цикл
			ЗарегистрироватьУзелДереваВарианта(НастройкиКД, ВложенныйЭлемент, СтрокаДерева.Строки);
		КонецЦикла;
	КонецЕсли;
	
	Если СтрокаДерева.Тип = "Таблица" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Строки, СтрокаДерева.Строки, "ТаблицаСтроки");
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Колонки, СтрокаДерева.Строки, "ТаблицаКолонки");
	ИначеЕсли СтрокаДерева.Тип = "Диаграмма" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Точки, СтрокаДерева.Строки, "ДиаграммаТочки");
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Серии, СтрокаДерева.Строки, "ДиаграммаСерии");
	ИначеЕсли СтрокаДерева.Тип = "КоллекцияЭлементовСтруктурыТаблицы"
		Или СтрокаДерева.Тип = "КоллекцияЭлементовСтруктурыДиаграммы" Тогда
		Для Каждого ВложенныйЭлемент Из УзелКД Цикл
			ЗарегистрироватьУзелДереваВарианта(НастройкиКД, ВложенныйЭлемент, СтрокаДерева.Строки);
		КонецЦикла;
	ИначеЕсли СтрокаДерева.Тип = "НастройкиВложенногоОбъекта" Тогда
		ЗарегистрироватьУзелДереваВарианта(НастройкиКД, УзелКД.Настройки, СтрокаДерева.Строки);
	КонецЕсли;
	
	Возврат СтрокаДерева;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли