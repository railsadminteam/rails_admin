﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Ukrainian language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['uk'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default 'ltr'
	 */
	dir : 'ltr',

	/*
	 * Screenreader titles. Please note that screenreaders are not always capable
	 * of reading non-English words. So be careful while translating it.
	 */
	editorTitle : 'Текстовий редактор, %1, натисніть ALT 0 для довідки.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Текстовий редактор',

	// Toolbar buttons without dialogs.
	source			: 'Джерело',
	newPage			: 'Нова сторінка',
	save			: 'Зберегти',
	preview			: 'Попередній перегляд',
	cut				: 'Вирізати',
	copy			: 'Копіювати',
	paste			: 'Вставити',
	print			: 'Друк',
	underline		: 'Підкреслений',
	bold			: 'Жирний',
	italic			: 'Курсив',
	selectAll		: 'Виділити все',
	removeFormat	: 'Очистити форматування',
	strike			: 'Закреслений',
	subscript		: 'Нижній індекс',
	superscript		: 'Верхній індекс',
	horizontalrule	: 'Горизонтальна лінія',
	pagebreak		: 'Вставити розрив сторінки',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Видалити посилання',
	undo			: 'Повернути',
	redo			: 'Повторити',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Огляд',
		url				: 'URL',
		protocol		: 'Протокол',
		upload			: 'Надіслати',
		uploadSubmit	: 'Надіслати на сервер',
		image			: 'Зображення',
		flash			: 'Flash',
		form			: 'Форма',
		checkbox		: 'Галочка',
		radio			: 'Кнопка вибору',
		textField		: 'Текстове поле',
		textarea		: 'Текстова область',
		hiddenField		: 'Приховане поле',
		button			: 'Кнопка',
		select			: 'Список',
		imageButton		: 'Кнопка із зображенням',
		notSet			: '<не визначено>',
		id				: 'Ідентифікатор',
		name			: 'Ім\'я',
		langDir			: 'Напрямок мови',
		langDirLtr		: 'Зліва направо (LTR)',
		langDirRtl		: 'Справа наліво (RTL)',
		langCode		: 'Код мови',
		longDescr		: 'Довгий опис URL',
		cssClass		: 'Клас CSS',
		advisoryTitle	: 'Заголовок',
		cssStyle		: 'Стиль CSS',
		ok				: 'ОК',
		cancel			: 'Скасувати',
		close			: 'Закрити',
		preview			: 'Попередній перегляд',
		generalTab		: 'Основне',
		advancedTab		: 'Додаткове',
		validateNumberFailed : 'Значення не є цілим числом.',
		confirmNewPage	: 'Всі незбережені зміни будуть втрачені. Ви впевнені, що хочете завантажити нову сторінку?',
		confirmCancel	: 'Деякі опції змінено. Закрити вікно без збереження змін?',
		options			: 'Опції',
		target			: 'Ціль',
		targetNew		: 'Нове вікно (_blank)',
		targetTop		: 'Поточне вікно (_top)',
		targetSelf		: 'Поточний фрейм/вікно (_self)',
		targetParent	: 'Батьківський фрейм/вікно (_parent)',
		langDirLTR		: 'Зліва направо (LTR)',
		langDirRTL		: 'Справа наліво (RTL)',
		styles			: 'Стиль CSS',
		cssClasses		: 'Клас CSS',
		width			: 'Ширина',
		height			: 'Висота',
		align			: 'Вирівнювання',
		alignLeft		: 'По лівому краю',
		alignRight		: 'По правому краю',
		alignCenter		: 'По центру',
		alignTop		: 'По верхньому краю',
		alignMiddle		: 'По середині',
		alignBottom		: 'По нижньому краю',
		invalidHeight	: 'Висота повинна бути цілим числом.',
		invalidWidth	: 'Ширина повинна бути цілим числом.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, не доступне</span>'
	},

	contextmenu :
	{
		options : 'Опції контекстного меню'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Спеціальний символ',
		title		: 'Оберіть спеціальний символ',
		options : 'Опції'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Вставити/Редагувати посилання',
		other 		: '<інший>',
		menu		: 'Вставити посилання',
		title		: 'Посилання',
		info		: 'Інформація посилання',
		target		: 'Ціль',
		upload		: 'Надіслати',
		advanced	: 'Додаткове',
		type		: 'Тип посилання',
		toUrl		: 'URL',
		toAnchor	: 'Якір на цю сторінку',
		toEmail		: 'Ел. пошта',
		targetFrame		: '<фрейм>',
		targetPopup		: '<випливаюче вікно>',
		targetFrameName	: 'Ім\'я цільового фрейму',
		targetPopupName	: 'Ім\'я випливаючого вікна',
		popupFeatures	: 'Властивості випливаючого вікна',
		popupResizable	: 'Масштабоване',
		popupStatusBar	: 'Рядок статусу',
		popupLocationBar: 'Панель локації',
		popupToolbar	: 'Панель інструментів',
		popupMenuBar	: 'Панель меню',
		popupFullScreen	: 'Повний екран (IE)',
		popupScrollBars	: 'Стрічки прокрутки',
		popupDependent	: 'Залежний (Netscape)',
		popupLeft		: 'Позиція зліва',
		popupTop		: 'Позиція зверху',
		id				: 'Ідентифікатор',
		langDir			: 'Напрямок мови',
		langDirLTR		: 'Зліва направо (LTR)',
		langDirRTL		: 'Справа наліво (RTL)',
		acccessKey		: 'Гаряча клавіша',
		name			: 'Ім\'я',
		langCode			: 'Код мови',
		tabIndex			: 'Послідовність переходу',
		advisoryTitle		: 'Заголовок',
		advisoryContentType	: 'Тип вмісту',
		cssClasses		: 'Клас CSS',
		charset			: 'Кодування',
		styles			: 'Стиль CSS',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Оберіть якір',
		anchorName		: 'За ім\'ям елементу',
		anchorId			: 'За ідентифікатором елементу',
		emailAddress		: 'Адреса ел. пошти',
		emailSubject		: 'Тема листа',
		emailBody		: 'Тіло повідомлення',
		noAnchors		: '(В цьому документі немає якорів)',
		noUrl			: 'Будь ласка, вкажіть URL посилання',
		noEmail			: 'Будь ласка, вкажіть адрес ел. пошти'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Вставити/Редагувати якір',
		menu		: 'Властивості якоря',
		title		: 'Властивості якоря',
		name		: 'Ім\'я якоря',
		errorName	: 'Будь ласка, вкажіть ім\'я якоря'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Опції нумерованого списку',
		bulletedTitle		: 'Опції маркірованого списку',
		type				: 'Тип',
		start				: 'Почати з...',
		validateStartNumber				:'Початковий номер списку повинен бути цілим числом.',
		circle				: 'Кільце',
		disc				: 'Кружечок',
		square				: 'Квадратик',
		none				: 'Нема',
		notset				: '<не вказано>',
		armenian			: 'Вірменська нумерація',
		georgian			: 'Грузинська нумерація (an, ban, gan і т.д.)',
		lowerRoman			: 'Малі римські (i, ii, iii, iv, v і т.д.)',
		upperRoman			: 'Великі римські (I, II, III, IV, V і т.д.)',
		lowerAlpha			: 'Малі лат. букви (a, b, c, d, e і т.д.)',
		upperAlpha			: 'Великі лат. букви (A, B, C, D, E і т.д.)',
		lowerGreek			: 'Малі гр. букви (альфа, бета, гамма і т.д.)',
		decimal				: 'Десяткові (1, 2, 3 і т.д.)',
		decimalLeadingZero	: 'Десяткові з нулем (01, 02, 03 і т.д.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Знайти і замінити',
		find				: 'Пошук',
		replace				: 'Заміна',
		findWhat			: 'Шукати:',
		replaceWith			: 'Замінити на:',
		notFoundMsg			: 'Вказаний текст не знайдено.',
		matchCase			: 'Враховувати регістр',
		matchWord			: 'Збіг цілих слів',
		matchCyclic			: 'Циклічна заміна',
		replaceAll			: 'Замінити все',
		replaceSuccessMsg	: '%1 співпадінь(ня) замінено.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Таблиця',
		title		: 'Властивості таблиці',
		menu		: 'Властивості таблиці',
		deleteTable	: 'Видалити таблицю',
		rows		: 'Рядки',
		columns		: 'Стовбці',
		border		: 'Розмір рамки',
		widthPx		: 'пікселів',
		widthPc		: 'відсотків',
		widthUnit	: 'Одиниці вимір.',
		cellSpace	: 'Проміжок',
		cellPad		: 'Внутр. відступ',
		caption		: 'Заголовок таблиці',
		summary		: 'Детальний опис заголовку таблиці',
		headers		: 'Заголовки стовбців/рядків',
		headersNone		: 'Без заголовків',
		headersColumn	: 'Стовбці',
		headersRow		: 'Рядки',
		headersBoth		: 'Стовбці і рядки',
		invalidRows		: 'Кількість рядків повинна бути більшою 0.',
		invalidCols		: 'Кількість стовбців повинна бути більшою 0.',
		invalidBorder	: 'Розмір рамки повинен бути цілим числом.',
		invalidWidth	: 'Ширина таблиці повинна бути цілим числом.',
		invalidHeight	: 'Висота таблиці повинна бути цілим числом.',
		invalidCellSpacing	: 'Проміжок між комірками повинен бути цілим числом.',
		invalidCellPadding	: 'Внутр. відступ комірки повинен бути цілим числом.',

		cell :
		{
			menu			: 'Комірки',
			insertBefore	: 'Вставити комірку перед',
			insertAfter		: 'Вставити комірку після',
			deleteCell		: 'Видалити комірки',
			merge			: 'Об\'єднати комірки',
			mergeRight		: 'Об\'єднати справа',
			mergeDown		: 'Об\'єднати донизу',
			splitHorizontal	: 'Розділити комірку по горизонталі',
			splitVertical	: 'Розділити комірку по вертикалі',
			title			: 'Властивості комірки',
			cellType		: 'Тип комірки',
			rowSpan			: 'Об\'єднання рядків',
			colSpan			: 'Об\'єднання стовпців',
			wordWrap		: 'Автоперенесення тексту',
			hAlign			: 'Гориз. вирівнювання',
			vAlign			: 'Верт. вирівнювання',
			alignBaseline	: 'По базовій лінії',
			bgColor			: 'Колір фону',
			borderColor		: 'Колір рамки',
			data			: 'Дані',
			header			: 'Заголовок',
			yes				: 'Так',
			no				: 'Ні',
			invalidWidth	: 'Ширина комірки повинна бути цілим числом.',
			invalidHeight	: 'Висота комірки повинна бути цілим числом.',
			invalidRowSpan	: 'Кількість об\'єднуваних рядків повинна бути цілим числом.',
			invalidColSpan	: 'Кількість об\'єднуваних стовбців повинна бути цілим числом.',
			chooseColor		: 'Обрати'
		},

		row :
		{
			menu			: 'Рядки',
			insertBefore	: 'Вставити рядок перед',
			insertAfter		: 'Вставити рядок після',
			deleteRow		: 'Видалити рядки'
		},

		column :
		{
			menu			: 'Стовбці',
			insertBefore	: 'Вставити стовбець перед',
			insertAfter		: 'Вставити стовбець після',
			deleteColumn	: 'Видалити стовбці'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Властивості кнопки',
		text		: 'Значення',
		type		: 'Тип',
		typeBtn		: 'Кнопка (button)',
		typeSbm		: 'Надіслати (submit)',
		typeRst		: 'Очистити (reset)'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Властивості галочки',
		radioTitle	: 'Властивості кнопки вибору',
		value		: 'Значення',
		selected	: 'Обрана'
	},

	// Form Dialog.
	form :
	{
		title		: 'Властивості форми',
		menu		: 'Властивості форми',
		action		: 'Дія',
		method		: 'Метод',
		encoding	: 'Кодування'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Властивості списку',
		selectInfo	: 'Інфо',
		opAvail		: 'Доступні варіанти',
		value		: 'Значення',
		size		: 'Кількість',
		lines		: 'видимих позицій у списку',
		chkMulti	: 'Список з мультивибором',
		opText		: 'Текст',
		opValue		: 'Значення',
		btnAdd		: 'Добавити',
		btnModify	: 'Змінити',
		btnUp		: 'Вгору',
		btnDown		: 'Вниз',
		btnSetValue : 'Встановити як обране значення',
		btnDelete	: 'Видалити'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Властивості текстової області',
		cols		: 'Стовбці',
		rows		: 'Рядки'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Властивості текстового поля',
		name		: 'Ім\'я',
		value		: 'Значення',
		charWidth	: 'Ширина',
		maxChars	: 'Макс. к-ть символів',
		type		: 'Тип',
		typeText	: 'Текст',
		typePass	: 'Пароль'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Властивості прихованого поля',
		name	: 'Ім\'я',
		value	: 'Значення'
	},

	// Image Dialog.
	image :
	{
		title		: 'Властивості зображення',
		titleButton	: 'Властивості кнопки із зображенням',
		menu		: 'Властивості зображення',
		infoTab		: 'Інформація про зображення',
		btnUpload	: 'Надіслати на сервер',
		upload		: 'Надіслати',
		alt			: 'Альтернативний текст',
		lockRatio	: 'Зберегти пропорції',
		unlockRatio	: 'Не зберігати пропорції',
		resetSize	: 'Очистити поля розмірів',
		border		: 'Рамка',
		hSpace		: 'Гориз. відступ',
		vSpace		: 'Верт. відступ',
		alertUrl	: 'Будь ласка, вкажіть URL зображення',
		linkTab		: 'Посилання',
		button2Img	: 'Бажаєте перетворити обрану кнопку-зображення на просте зображення?',
		img2Button	: 'Бажаєте перетворити обране зображення на кнопку-зображення?',
		urlMissing	: 'Вкажіть URL зображення.',
		validateBorder	: 'Ширина рамки повинна бути цілим числом.',
		validateHSpace	: 'Гориз. відступ повинен бути цілим числом.',
		validateVSpace	: 'Верт. відступ повинен бути цілим числом.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Властивості Flash',
		propertiesTab	: 'Властивості',
		title			: 'Властивості Flash',
		chkPlay			: 'Автопрогравання',
		chkLoop			: 'Циклічно',
		chkMenu			: 'Дозволити меню Flash',
		chkFull			: 'Дозволити повноекранний перегляд',
 		scale			: 'Масштаб',
		scaleAll		: 'Показати все',
		scaleNoBorder	: 'Без рамки',
		scaleFit		: 'Поч. розмір',
		access			: 'Доступ до скрипта',
		accessAlways	: 'Завжди',
		accessSameDomain: 'З того ж домена',
		accessNever		: 'Ніколи',
		alignAbsBottom	: 'По нижньому краю (abs)',
		alignAbsMiddle	: 'По середині (abs)',
		alignBaseline	: 'По базовій лінії',
		alignTextTop	: 'Текст по верхньому краю',
		quality			: 'Якість',
		qualityBest		: 'Відмінна',
		qualityHigh		: 'Висока',
		qualityAutoHigh	: 'Автом. відмінна',
		qualityMedium	: 'Середня',
		qualityAutoLow	: 'Автом. низька',
		qualityLow		: 'Низька',
		windowModeWindow: 'Вікно',
		windowModeOpaque: 'Непрозорість',
		windowModeTransparent : 'Прозорість',
		windowMode		: 'Віконний режим',
		flashvars		: 'Змінні Flash',
		bgcolor			: 'Колір фону',
		hSpace			: 'Гориз. відступ',
		vSpace			: 'Верт. відступ',
		validateSrc		: 'Будь ласка, вкажіть URL посилання',
		validateHSpace	: 'Гориз. відступ повинен бути цілим числом.',
		validateVSpace	: 'Верт. відступ повинен бути цілим числом.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Перевірити орфографію',
		title			: 'Перевірка орфографії',
		notAvailable	: 'Вибачте, але сервіс наразі недоступний.',
		errorLoading	: 'Помилка завантаження : %s.',
		notInDic		: 'Немає в словнику',
		changeTo		: 'Замінити на',
		btnIgnore		: 'Пропустити',
		btnIgnoreAll	: 'Пропустити все',
		btnReplace		: 'Замінити',
		btnReplaceAll	: 'Замінити все',
		btnUndo			: 'Назад',
		noSuggestions	: '- немає варіантів -',
		progress		: 'Виконується перевірка орфографії...',
		noMispell		: 'Перевірку орфографії завершено: помилок не знайдено',
		noChanges		: 'Перевірку орфографії завершено: жодне слово не змінено',
		oneChange		: 'Перевірку орфографії завершено: змінено одне слово',
		manyChanges		: 'Перевірку орфографії завершено: 1% слів(ова) змінено',
		ieSpellDownload	: 'Модуль перевірки орфографії не встановлено. Бажаєте завантажити його зараз?'
	},

	smiley :
	{
		toolbar	: 'Смайлик',
		title	: 'Вставити смайлик',
		options : 'Опції смайликів'
	},

	elementsPath :
	{
		eleLabel : 'Шлях',
		eleTitle : '%1 елемент'
	},

	numberedlist	: 'Нумерований список',
	bulletedlist	: 'Маркірований список',
	indent			: 'Збільшити відступ',
	outdent			: 'Зменшити відступ',

	justify :
	{
		left	: 'По лівому краю',
		center	: 'По центру',
		right	: 'По правому краю',
		block	: 'По ширині'
	},

	blockquote : 'Цитата',

	clipboard :
	{
		title		: 'Вставити',
		cutError	: 'Налаштування безпеки Вашого браузера не дозволяють редактору автоматично виконувати операції вирізування. Будь ласка, використовуйте клавіатуру для цього (Ctrl/Cmd+X)',
		copyError	: 'Налаштування безпеки Вашого браузера не дозволяють редактору автоматично виконувати операції копіювання. Будь ласка, використовуйте клавіатуру для цього (Ctrl/Cmd+C).',
		pasteMsg	: 'Будь ласка, вставте інформацію з буфера обміну в цю область, користуючись комбінацією клавіш (<STRONG>Ctrl/Cmd+V</STRONG>), та натисніть <STRONG>OK</STRONG>.',
		securityMsg	: 'Редактор не може отримати прямий доступ до буферу обміну у зв\'язку з налаштуваннями Вашого браузера. Вам потрібно вставити інформацію в це вікно.',
		pasteArea	: 'Область вставки'
	},

	pastefromword :
	{
		confirmCleanup	: 'Текст, що Ви намагаєтесь вставити, схожий на скопійований з Word. Бажаєте очистити його форматування перед вставлянням?',
		toolbar			: 'Вставити з Word',
		title			: 'Вставити з Word',
		error			: 'Неможливо очистити форматування через внутрішню помилку.'
	},

	pasteText :
	{
		button	: 'Вставити тільки текст',
		title	: 'Вставити тільки текст'
	},

	templates :
	{
		button			: 'Шаблони',
		title			: 'Шаблони змісту',
		options : 'Опції шаблону',
		insertOption	: 'Замінити поточний вміст',
		selectPromptMsg	: 'Оберіть, будь ласка, шаблон для відкриття в редакторі<br>(поточний зміст буде втрачено):',
		emptyListMsg	: '(Не знайдено жодного шаблону)'
	},

	showBlocks : 'Показувати блоки',

	stylesCombo :
	{
		label		: 'Стиль',
		panelTitle	: 'Стилі форматування',
		panelTitle1	: 'Блочні стилі',
		panelTitle2	: 'Рядкові стилі',
		panelTitle3	: 'Об\'єктні стилі'
	},

	format :
	{
		label		: 'Форматування',
		panelTitle	: 'Форматування',

		tag_p		: 'Нормальний',
		tag_pre		: 'Форматований',
		tag_address	: 'Адреса',
		tag_h1		: 'Заголовок 1',
		tag_h2		: 'Заголовок 2',
		tag_h3		: 'Заголовок 3',
		tag_h4		: 'Заголовок 4',
		tag_h5		: 'Заголовок 5',
		tag_h6		: 'Заголовок 6',
		tag_div		: 'Нормальний (div)'
	},

	div :
	{
		title				: 'Створити блок-контейнер',
		toolbar				: 'Створити блок-контейнер',
		cssClassInputLabel	: 'Клас CSS',
		styleSelectLabel	: 'Стиль CSS',
		IdInputLabel		: 'Ідентифікатор',
		languageCodeInputLabel	: 'Код мови',
		inlineStyleInputLabel	: 'Вписаний стиль',
		advisoryTitleInputLabel	: 'Зміст випливаючої підказки',
		langDirLabel		: 'Напрямок мови',
		langDirLTRLabel		: 'Зліва направо (LTR)',
		langDirRTLLabel		: 'Справа наліво (RTL)',
		edit				: 'Редагувати блок',
		remove				: 'Видалити блок'
  	},

	iframe :
	{
		title		: 'IFrame Properties', // MISSING
		toolbar		: 'IFrame', // MISSING
		noUrl		: 'Please type the iframe URL', // MISSING
		scrolling	: 'Enable scrollbars', // MISSING
		border		: 'Show frame border' // MISSING
	},

	font :
	{
		label		: 'Шрифт',
		voiceLabel	: 'Шрифт',
		panelTitle	: 'Шрифт'
	},

	fontSize :
	{
		label		: 'Розмір',
		voiceLabel	: 'Розмір шрифту',
		panelTitle	: 'Розмір'
	},

	colorButton :
	{
		textColorTitle	: 'Колір тексту',
		bgColorTitle	: 'Колір фону',
		panelTitle		: 'Кольори',
		auto			: 'Авто',
		more			: 'Кольори...'
	},

	colors :
	{
		'000' : 'Чорний',
		'800000' : 'Бордовий',
		'8B4513' : 'Коричневий',
		'2F4F4F' : 'Темний сіро-зелений',
		'008080' : 'Морської хвилі',
		'000080' : 'Сливовий',
		'4B0082' : 'Індиго',
		'696969' : 'Темносірий',
		'B22222' : 'Темночервоний',
		'A52A2A' : 'Каштановий',
		'DAA520' : 'Бежевий',
		'006400' : 'Темнозелений',
		'40E0D0' : 'Бірюзовий',
		'0000CD' : 'Темносиній',
		'800080' : 'Пурпурний',
		'808080' : 'Сірий',
		'F00' : 'Червоний',
		'FF8C00' : 'Темнооранжевий',
		'FFD700' : 'Жовтий',
		'008000' : 'Зелений',
		'0FF' : 'Синьо-зелений',
		'00F' : 'Синій',
		'EE82EE' : 'Фіолетовий',
		'A9A9A9' : 'Світлосірий',
		'FFA07A' : 'Рожевий',
		'FFA500' : 'Оранжевий',
		'FFFF00' : 'Яскравожовтий',
		'00FF00' : 'Салатовий',
		'AFEEEE' : 'Світлобірюзовий',
		'ADD8E6' : 'Блакитний',
		'DDA0DD' : 'Світлофіолетовий',
		'D3D3D3' : 'Сріблястий',
		'FFF0F5' : 'Світлорожевий',
		'FAEBD7' : 'Світлооранжевий',
		'FFFFE0' : 'Світложовтий',
		'F0FFF0' : 'Світлозелений',
		'F0FFFF' : 'Світлий синьо-зелений',
		'F0F8FF' : 'Світлоблакитний',
		'E6E6FA' : 'Лавандовий',
		'FFF' : 'Білий'
	},

	scayt :
	{
		title			: 'Перефірка орфографії по мірі набору',
		opera_title		: 'Не підтримується в Opera',
		enable			: 'Ввімкнути SCAYT',
		disable			: 'Вимкнути SCAYT',
		about			: 'Про SCAYT',
		toggle			: 'Перемкнути SCAYT',
		options			: 'Опції',
		langs			: 'Мови',
		moreSuggestions	: 'Більше варіантів',
		ignore			: 'Пропустити',
		ignoreAll		: 'Пропустити всі',
		addWord			: 'Додати слово',
		emptyDic		: 'Назва словника повинна бути вказана.',

		optionsTab		: 'Опції',
		allCaps			: 'Пропустити прописні слова',
		ignoreDomainNames : 'Пропустити доменні назви',
		mixedCase		: 'Пропустити слова зі змішаним регістром',
		mixedWithDigits	: 'Пропустити слова, що містять цифри',

		languagesTab	: 'Мови',

		dictionariesTab	: 'Словники',
		dic_field_name	: 'Назва словника',
		dic_create		: 'Створити',
		dic_restore		: 'Відновити',
		dic_delete		: 'Видалити',
		dic_rename		: 'Перейменувати',
		dic_info		: 'Як правило, користувацькі словники зберігаються у cookie-файлах. Однак, cookie-файли мають обмеження на розмір. Якщо користувацький словник зростає в обсязі настільки, що вже не може бути збережений у cookie-файлі, тоді його можна зберегти на нашому сервері. Щоб зберегти Ваш персональний словник на нашому сервері необхідно вказати назву словника. Якщо Ви вже зберігали словник на сервері, будь ласка, вкажіть назву збереженого словника і натисніть кнопку Відновити.',

		aboutTab		: 'Про SCAYT'
	},

	about :
	{
		title		: 'Про CKEditor',
		dlgTitle	: 'Про CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Щодо інформації з ліцензування завітайте на наш сайт:',
		copy		: 'Copyright &copy; $1. Всі права застережено.'
	},

	maximize : 'Максимізувати',
	minimize : 'Мінімізувати',

	fakeobjects :
	{
		anchor		: 'Якір',
		flash		: 'Flash-анімація',
		iframe		: 'IFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Невідомий об\'єкт'
	},

	resize : 'Потягніть для зміни розмірів',

	colordialog :
	{
		title		: 'Обрати колір',
		options	:	'Опції кольорів',
		highlight	: 'Колір, на який вказує курсор',
		selected	: 'Обраний колір',
		clear		: 'Очистити'
	},

	toolbarCollapse	: 'Згорнути панель інструментів',
	toolbarExpand	: 'Розгорнути панель інструментів',

	toolbarGroups :
	{
		document : 'Document', // MISSING
		clipboard : 'Clipboard/Undo', // MISSING
		editing : 'Editing', // MISSING
		forms : 'Forms', // MISSING
		basicstyles : 'Basic Styles', // MISSING
		paragraph : 'Paragraph', // MISSING
		links : 'Links', // MISSING
		insert : 'Insert', // MISSING
		styles : 'Styles', // MISSING
		colors : 'Colors', // MISSING
		tools : 'Tools' // MISSING
	},

	bidi :
	{
		ltr : 'Напрямок тексту зліва направо',
		rtl : 'Напрямок тексту справа наліво'
	},

	docprops :
	{
		label : 'Document Properties', // MISSING
		title : 'Document Properties', // MISSING
		design : 'Design', // MISSING
		meta : 'Meta Tags', // MISSING
		chooseColor : 'Choose', // MISSING
		other : 'Other...', // MISSING
		docTitle :	'Page Title', // MISSING
		charset : 	'Character Set Encoding', // MISSING
		charsetOther : 'Other Character Set Encoding', // MISSING
		charsetASCII : 'ASCII', // MISSING
		charsetCE : 'Central European', // MISSING
		charsetCT : 'Chinese Traditional (Big5)', // MISSING
		charsetCR : 'Cyrillic', // MISSING
		charsetGR : 'Greek', // MISSING
		charsetJP : 'Japanese', // MISSING
		charsetKR : 'Korean', // MISSING
		charsetTR : 'Turkish', // MISSING
		charsetUN : 'Unicode (UTF-8)', // MISSING
		charsetWE : 'Western European', // MISSING
		docType : 'Document Type Heading', // MISSING
		docTypeOther : 'Other Document Type Heading', // MISSING
		xhtmlDec : 'Include XHTML Declarations', // MISSING
		bgColor : 'Background Color', // MISSING
		bgImage : 'Background Image URL', // MISSING
		bgFixed : 'Non-scrolling (Fixed) Background', // MISSING
		txtColor : 'Text Color', // MISSING
		margin : 'Page Margins', // MISSING
		marginTop : 'Top', // MISSING
		marginLeft : 'Left', // MISSING
		marginRight : 'Right', // MISSING
		marginBottom : 'Bottom', // MISSING
		metaKeywords : 'Document Indexing Keywords (comma separated)', // MISSING
		metaDescription : 'Document Description', // MISSING
		metaAuthor : 'Author', // MISSING
		metaCopyright : 'Copyright', // MISSING
		previewHtml : '<p>This is some <strong>sample text</strong>. You are using <a href="javascript:void(0)">CKEditor</a>.</p>' // MISSING
	}
};
