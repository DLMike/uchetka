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

// См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов")
	 Или Не ПравоДоступа("Просмотр", Метаданные.Отчеты.ИзменениеУчетныхЗаписей)
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		Возврат;
	КонецЕсли;
	
	Представление = Неопределено;
	
	Если Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаСписка"
	 Или Параметры.ИмяФормы = "Справочник.ВнешниеПользователи.Форма.ФормаСписка" Тогда
		
		Представление = НСтр("ru = 'Изменение учетных записей пользователей'");
		
	ИначеЕсли Параметры.ИмяФормы = "Справочник.Пользователи.Форма.ФормаЭлемента"
	      Или Параметры.ИмяФормы = "Справочник.ВнешниеПользователи.Форма.ФормаЭлемента" Тогда
		
		Представление = НСтр("ru = 'Изменение учетной записи пользователя'");
	КонецЕсли;
	
	Если Представление = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Команда = КомандыОтчетов.Добавить();
	Команда.Представление = Представление;
	Команда.Менеджер = "Отчет.ИзменениеУчетныхЗаписей";
	Команда.КлючВарианта = "Основной";
	Команда.ТолькоВоВсехДействиях = Истина;
	Команда.Важность = "СмТакже";

КонецПроцедуры

// Параметры:
//   Настройки - см. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов.Настройки.
//   НастройкиОтчета - см. ВариантыОтчетов.ОписаниеОтчета.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВариантыОтчетов") Тогда
		Возврат;
	КонецЕсли;
	
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.ОпределитьНастройкиФормы = Истина;
	
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "Основной");
	НастройкиВарианта.Описание = 
		НСтр("ru = 'Выводит изменения свойств пользователей информационной базы за указанный период по событиям журнала регистрации.'");
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти

#КонецЕсли
