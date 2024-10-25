///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// При начале выбора кода налогового органа.
// 
// Параметры:
//  Организации - Массив из ОпределяемыйТип.СторонаМЧД
//  Оповещение - ОписаниеОповещения - оповещение, которое вернет результат выбора кодов.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеВыбораКодаНалоговогоОргана(Организации, Оповещение, СтандартнаяОбработка) Экспорт
		
КонецПроцедуры

// При начале выбора полномочий.
// 
// Параметры:
//  Оповещение  - ОписаниеОповещения - оповещение, которое вернет результат выбора полномочий.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеВыбораПолномочий(Оповещение, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// При начале подписания.
// 
// Параметры:
//  Организации - Массив из ОпределяемыйТип.СторонаМЧД
//  Файл - СправочникСсылка.МашиночитаемыеДоверенностиПрисоединенныеФайлы
//  Полномочия - ТабличнаяЧасть - СправочникОбъект.МашиночитаемыеДоверенности.Полномочия.
//  Оповещение  - ОписаниеОповещения - оповещение, которое вернет результат подписания.
//  СтандартнаяОбработка - Булево
//
Процедура ПриНачалеПодписания(Организации, Файл, Полномочия, Оповещение, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// Для прикладной проверки доверенности.
// 
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение о результате выполнения:
//   Структура:
//    # Верна - Булево
//    # ТребуетсяПроверка - Булево
//    # ЕстьВсеПодписи - Булево - есть все подписи доверителей.
//    # Статус - ПеречислениеСсылка.СтатусыМЧД
//    # ЕстьВРеестреФНС - Булево
//    # ТекстОшибки - Строка
//    # РезультатыПроверкиПодписей - Массив из Структура:
//     ## Верна - Булево
//     ## КомуВыданСертификат - Строка
//     ## ДатаПодписи - Дата
//     ## ИдентификаторПодписи - УникальныйИдентификатор
//     ## ТребуетсяПроверка - Булево
//     ## Соответствует -  Булево - подпись соответствует доверителю.
//     ## ТекстОшибки - Строка
//     ## ТекстОшибкиСоответствия - Строка
//     ## РезультатПроверки - Неопределено - если подпись не требовалось проверять или не удалось ее проверить.
//                         - см. ЭлектроннаяПодписьКлиентСервер.РезультатПроверкиПодписи
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//  ИдентификаторФормы - УникальныйИдентификатор - используется при проверке подписей на клиенте.
//   Если не указан, подписи, требующие проверки, не будут проверены на клиенте.
//  СтандартнаяОбработка - Булево
//
Процедура ПриПроверкеДоверенности(Оповещение, Доверенность, ИдентификаторФормы, СтандартнаяОбработка) Экспорт

КонецПроцедуры

// При обработке навигационной ссылки состояния в другом реестре в форме машиночитаемой доверенности,
// сформированной в МашиночитаемыеДоверенностиФНСПереопределяемый.ПриПолученииСтатусаРегистрации
// 
// Параметры:
//  Доверенность - СправочникОбъект.МашиночитаемыеДоверенности
//  НавигационнаяСсылкаФорматированнойСтроки - Строка
//  СтандартнаяОбработка - Булево
//
Процедура ПриОбработкеНавигационнойСсылки(Доверенность, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается при изменении статуса доверенности, например, когда статус обновляется из реестра ФНС, для обработки
// изменившегося статуса доверенности. К примеру, в процедуре можно сообщить о том, что доверенность готова и 
// можно продолжить отправку отчетности или документов по ЭДО.
//
// Параметры:
//  СтатусыДоверенностей - Соответствие из КлючИЗначение:
//   * Ключ - СправочникСсылка.МашиночитаемыеДоверенности - доверенность с изменившимся статусом
//   * Значение - Структура:
//    ** СтатусДоИзменения - ПеречислениеСсылка.ТехническиеСтатусыМЧД
//    ** НовыйСтатус - ПеречислениеСсылка.ТехническиеСтатусыМЧД
//
Процедура ПриИзмененииСтатусаДоверенности(СтатусыДоверенностей) Экспорт

	
	
КонецПроцедуры

// Переопределяет процедуру регистрации в реестре Федеральной таможенной службы или другом.
// 
// Параметры:
//  Доверенность - СправочникСсылка.МашиночитаемыеДоверенности
//  СтандартнаяОбработка - Булево - при установке значения Ложь регистрация доверенности не будет выполнена.
//  ОбработчикЗавершения - ОписаниеОповещения - процедура, которую необходимо вызвать для продолжения регистрации
//                                              доверенности в случае, если стандартная обработка
//                                              была прервана при помощи параметра СтандартнаяОбработка;
//
Процедура ПриРегистрацииДоверенности(Доверенность, СтандартнаяОбработка, ОбработчикЗавершения) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
