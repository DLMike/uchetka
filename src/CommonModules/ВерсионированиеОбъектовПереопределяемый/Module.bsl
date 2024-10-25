///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается для получения версионируемых табличных документов во время записи версии объекта.
// Табличный документ прикладывается к версии объекта в случае, когда в отчете по версии объекта требуется
// заменить "техногенную" табличную часть объекта на ее представление в виде табличного документа.
//
// Параметры:
//  Ссылка             - ЛюбаяСсылка - версионируемый объект конфигурации.
//  ТабличныеДокументы - Структура:
//   * Ключ     - Строка    - имя табличного документа;
//   * Значение - Структура:
//    ** Наименование - Строка            - наименование табличного документа;
//    ** Данные       - ТабличныйДокумент - версионируемый табличный документ.
//
Процедура ПриПолученииТабличныхДокументовОбъекта(Ссылка, ТабличныеДокументы) Экспорт
	
КонецПроцедуры

// Вызывается после разбора прочитанной из регистра версии объекта,
//  может использоваться для дополнительной обработки результата разбора версии.
// 
// Параметры:
//  Ссылка    - ЛюбаяСсылка - версионируемый объект конфигурации.
//  Результат - Структура - результат разбора версии подсистемой версионирования.
//
Процедура ПослеРазбораВерсииОбъекта(Ссылка, Результат) Экспорт
	
КонецПроцедуры

// Вызывается после определения реквизитов объекта из формы 
// РегистрСведений.ВерсииОбъектов.ВыборРеквизитовОбъекта.
// 
// Параметры:
//  Ссылка           - ЛюбаяСсылка       - версионируемый объект конфигурации.
//  ДеревоРеквизитов - ДанныеФормыДерево - дерево реквизитов объектов.
//
Процедура ПриВыбореРеквизитовОбъекта(Ссылка, ДеревоРеквизитов) Экспорт
	
КонецПроцедуры

// Вызывается при получении представления реквизита объекта.
// 
// Параметры:
//  Ссылка                - ЛюбаяСсылка - версионируемый объект конфигурации.
//  ИмяРеквизита          - Строка      - ИмяРеквизита, как оно задано в конфигураторе.
//  НаименованиеРеквизита - Строка      - выходной параметр, можно переопределить полученный синоним.
//  Видимость             - Булево      - выводить реквизит в отчетах по версиям.
//
Процедура ПриОпределенииНаименованияРеквизитаОбъекта(Ссылка, ИмяРеквизита, НаименованиеРеквизита, Видимость) Экспорт
	
КонецПроцедуры

// Дополняет объект реквизитами, хранящимися отдельно от объекта либо в служебной части самого объекта,
// не предназначенной для вывода в отчетах.
//
// Параметры:
//  Объект - СправочникОбъект
//         - ДокументОбъект
//         - ПланВидовРасчетаОбъект
//         - ПланСчетовОбъект
//         - ПланВидовХарактеристикОбъект -
//           версионируемый объект.
//  ДополнительныеРеквизиты - ТаблицаЗначений - коллекция дополнительных реквизитов, которые требуется сохранить вместе
//                                              с версией объекта:
//   * Идентификатор - Произвольный - уникальный идентификатор реквизита. Требуется при восстановлении из версии
//                                    объекта в случае, когда значение реквизита хранится отдельно от объекта.
//   * Наименование - Строка - название реквизита.
//   * Значение - Произвольный - значение реквизита.
//
Процедура ПриПодготовкеДанныхОбъекта(Объект, ДополнительныеРеквизиты) Экспорт 
	
	
	
КонецПроцедуры

// Восстанавливает значения реквизитов объекта, хранящихся отдельно от объекта.
//
// Параметры:
//  Объект - СправочникОбъект
//         - ДокументОбъект
//         - ПланВидовРасчетаОбъект
//         - ПланСчетовОбъект
//         - ПланВидовХарактеристикОбъект -
//           версионируемый объект:
//   * Ссылка - ЛюбаяСсылка
//  ДополнительныеРеквизиты - ТаблицаЗначений - коллекция дополнительных реквизитов, которые были сохранены вместе с
//                                              версией объекта:
//   * Идентификатор - Произвольный - уникальный идентификатор реквизита.
//   * Наименование - Строка - название реквизита.
//   * Значение - Произвольный - значение реквизита.
//
Процедура ПриВосстановленииВерсииОбъекта(Объект, ДополнительныеРеквизиты) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти