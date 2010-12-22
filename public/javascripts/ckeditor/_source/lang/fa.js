/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Persian language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['fa'] =
{
	/**
	 * The language reading direction. Possible values are "rtl" for
	 * Right-To-Left languages (like Arabic) and "ltr" for Left-To-Right
	 * languages (like English).
	 * @default 'ltr'
	 */
	dir : 'rtl',

	/*
	 * Screenreader titles. Please note that screenreaders are not always capable
	 * of reading non-English words. So be careful while translating it.
	 */
	editorTitle : 'Rich text editor, %1, press ALT 0 for help.', // MISSING

	// ARIA descriptions.
	toolbar	: 'Toolbar', // MISSING
	editor	: 'Rich Text Editor', // MISSING

	// Toolbar buttons without dialogs.
	source			: 'منبع',
	newPage			: 'برگهٴ تازه',
	save			: 'ذخیره',
	preview			: 'پیشنمایش',
	cut				: 'برش',
	copy			: 'کپی',
	paste			: 'چسباندن',
	print			: 'چاپ',
	underline		: 'خطزیردار',
	bold			: 'درشت',
	italic			: 'خمیده',
	selectAll		: 'گزینش همه',
	removeFormat	: 'برداشتن فرمت',
	strike			: 'میانخط',
	subscript		: 'زیرنویس',
	superscript		: 'بالانویس',
	horizontalrule	: 'گنجاندن خط ِافقی',
	pagebreak		: 'گنجاندن شکستگی ِپایان ِبرگه',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'برداشتن پیوند',
	undo			: 'واچیدن',
	redo			: 'بازچیدن',

	// Common messages and labels.
	common :
	{
		browseServer	: 'فهرستنمایی سرور',
		url				: 'URL',
		protocol		: 'پروتکل',
		upload			: 'انتقال به سرور',
		uploadSubmit	: 'به سرور بفرست',
		image			: 'تصویر',
		flash			: 'Flash',
		form			: 'فرم',
		checkbox		: 'خانهٴ گزینهای',
		radio			: 'دکمهٴ رادیویی',
		textField		: 'فیلد متنی',
		textarea		: 'ناحیهٴ متنی',
		hiddenField		: 'فیلد پنهان',
		button			: 'دکمه',
		select			: 'فیلد چندگزینهای',
		imageButton		: 'دکمهٴ تصویری',
		notSet			: '<تعیننشده>',
		id				: 'شناسه',
		name			: 'نام',
		langDir			: 'جهتنمای زبان',
		langDirLtr		: 'چپ به راست (LTR)',
		langDirRtl		: 'راست به چپ (RTL)',
		langCode		: 'کد زبان',
		longDescr		: 'URL توصیف طولانی',
		cssClass		: 'کلاسهای شیوهنامه(Stylesheet)',
		advisoryTitle	: 'عنوان کمکی',
		cssStyle		: 'شیوه(style)',
		ok				: 'پذیرش',
		cancel			: 'انصراف',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'General', // MISSING
		advancedTab		: 'پیشرفته',
		validateNumberFailed : 'This value is not a number.', // MISSING
		confirmNewPage	: 'Any unsaved changes to this content will be lost. Are you sure you want to load new page?', // MISSING
		confirmCancel	: 'Some of the options have been changed. Are you sure to close the dialog?', // MISSING
		options			: 'Options', // MISSING
		target			: 'Target', // MISSING
		targetNew		: 'New Window (_blank)', // MISSING
		targetTop		: 'Topmost Window (_top)', // MISSING
		targetSelf		: 'Same Window (_self)', // MISSING
		targetParent	: 'Parent Window (_parent)', // MISSING
		langDirLTR		: 'Left to Right (LTR)', // MISSING
		langDirRTL		: 'Right to Left (RTL)', // MISSING
		styles			: 'Style', // MISSING
		cssClasses		: 'Stylesheet Classes', // MISSING
		width			: 'پهنا',
		height			: 'درازا',
		align			: 'چینش',
		alignLeft		: 'چپ',
		alignRight		: 'راست',
		alignCenter		: 'وسط',
		alignTop		: 'بالا',
		alignMiddle		: 'وسط',
		alignBottom		: 'پائین',
		invalidHeight	: 'Height must be a number.', // MISSING
		invalidWidth	: 'Width must be a number.', // MISSING

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, unavailable</span>' // MISSING
	},

	contextmenu :
	{
		options : 'Context Menu Options' // MISSING
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'گنجاندن نویسهٴ ویژه',
		title		: 'گزینش نویسهٴویژه',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'گنجاندن/ویرایش ِپیوند',
		other 		: '<سایر>',
		menu		: 'ویرایش پیوند',
		title		: 'پیوند',
		info		: 'اطلاعات پیوند',
		target		: 'مقصد',
		upload		: 'انتقال به سرور',
		advanced	: 'پیشرفته',
		type		: 'نوع پیوند',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'لنگر در همین صفحه',
		toEmail		: 'پست الکترونیکی',
		targetFrame		: '<فریم>',
		targetPopup		: '<پنجرهٴ پاپاپ>',
		targetFrameName	: 'نام فریم مقصد',
		targetPopupName	: 'نام پنجرهٴ پاپاپ',
		popupFeatures	: 'ویژگیهای پنجرهٴ پاپاپ',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'نوار وضعیت',
		popupLocationBar: 'نوار موقعیت',
		popupToolbar	: 'نوارابزار',
		popupMenuBar	: 'نوار منو',
		popupFullScreen	: 'تمامصفحه (IE)',
		popupScrollBars	: 'میلههای پیمایش',
		popupDependent	: 'وابسته (Netscape)',
		popupLeft		: 'موقعیت ِچپ',
		popupTop		: 'موقعیت ِبالا',
		id				: 'Id', // MISSING
		langDir			: 'جهتنمای زبان',
		langDirLTR		: 'چپ به راست (LTR)',
		langDirRTL		: 'راست به چپ (RTL)',
		acccessKey		: 'کلید دستیابی',
		name			: 'نام',
		langCode		: 'جهتنمای زبان',
		tabIndex		: 'نمایهٴ دسترسی با Tab',
		advisoryTitle	: 'عنوان کمکی',
		advisoryContentType	: 'نوع محتوای کمکی',
		cssClasses		: 'کلاسهای شیوهنامه(Stylesheet)',
		charset			: 'نویسهگان منبع ِپیوندشده',
		styles			: 'شیوه(style)',
		selectAnchor	: 'یک لنگر برگزینید',
		anchorName		: 'با نام لنگر',
		anchorId		: 'با شناسهٴ المان',
		emailAddress	: 'نشانی پست الکترونیکی',
		emailSubject	: 'موضوع پیام',
		emailBody		: 'متن پیام',
		noAnchors		: '(در این سند لنگری دردسترس نیست)',
		noUrl			: 'لطفا URL پیوند را بنویسید',
		noEmail			: 'لطفا نشانی پست الکترونیکی را بنویسید'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'گنجاندن/ویرایش ِلنگر',
		menu		: 'ویژگیهای لنگر',
		title		: 'ویژگیهای لنگر',
		name		: 'نام لنگر',
		errorName	: 'لطفا نام لنگر را بنویسید'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Numbered List Properties', // MISSING
		bulletedTitle		: 'Bulleted List Properties', // MISSING
		type				: 'Type', // MISSING
		start				: 'Start', // MISSING
		validateStartNumber				:'List start number must be a whole number.', // MISSING
		circle				: 'Circle', // MISSING
		disc				: 'Disc', // MISSING
		square				: 'Square', // MISSING
		none				: 'None', // MISSING
		notset				: '<not set>', // MISSING
		armenian			: 'Armenian numbering', // MISSING
		georgian			: 'Georgian numbering (an, ban, gan, etc.)', // MISSING
		lowerRoman			: 'Lower Roman (i, ii, iii, iv, v, etc.)', // MISSING
		upperRoman			: 'Upper Roman (I, II, III, IV, V, etc.)', // MISSING
		lowerAlpha			: 'Lower Alpha (a, b, c, d, e, etc.)', // MISSING
		upperAlpha			: 'Upper Alpha (A, B, C, D, E, etc.)', // MISSING
		lowerGreek			: 'Lower Greek (alpha, beta, gamma, etc.)', // MISSING
		decimal				: 'Decimal (1, 2, 3, etc.)', // MISSING
		decimalLeadingZero	: 'Decimal leading zero (01, 02, 03, etc.)' // MISSING
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'جستجو و جایگزینی',
		find				: 'جستجو',
		replace				: 'جایگزینی',
		findWhat			: 'چهچیز را مییابید:',
		replaceWith			: 'جایگزینی با:',
		notFoundMsg			: 'متن موردنظر یافت نشد.',
		matchCase			: 'همسانی در بزرگی و کوچکی نویسهها',
		matchWord			: 'همسانی با واژهٴ کامل',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'جایگزینی همهٴ یافتهها',
		replaceSuccessMsg	: '%1 occurrence(s) replaced.' // MISSING
	},

	// Table Dialog
	table :
	{
		toolbar		: 'جدول',
		title		: 'ویژگیهای جدول',
		menu		: 'ویژگیهای جدول',
		deleteTable	: 'پاککردن جدول',
		rows		: 'سطرها',
		columns		: 'ستونها',
		border		: 'اندازهٴ لبه',
		widthPx		: 'پیکسل',
		widthPc		: 'درصد',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'فاصلهٴ میان سلولها',
		cellPad		: 'فاصلهٴ پرشده در سلول',
		caption		: 'عنوان',
		summary		: 'خلاصه',
		headers		: 'Headers', // MISSING
		headersNone		: 'None', // MISSING
		headersColumn	: 'First column', // MISSING
		headersRow		: 'First Row', // MISSING
		headersBoth		: 'Both', // MISSING
		invalidRows		: 'Number of rows must be a number greater than 0.', // MISSING
		invalidCols		: 'Number of columns must be a number greater than 0.', // MISSING
		invalidBorder	: 'Border size must be a number.', // MISSING
		invalidWidth	: 'Table width must be a number.', // MISSING
		invalidHeight	: 'Table height must be a number.', // MISSING
		invalidCellSpacing	: 'Cell spacing must be a number.', // MISSING
		invalidCellPadding	: 'Cell padding must be a number.', // MISSING

		cell :
		{
			menu			: 'سلول',
			insertBefore	: 'افزودن سلول قبل از',
			insertAfter		: 'افزودن سلول بعد از',
			deleteCell		: 'حذف سلولها',
			merge			: 'ادغام سلولها',
			mergeRight		: 'ادغام به راست',
			mergeDown		: 'ادغام به پایین',
			splitHorizontal	: 'جدا کردن افقی سلول',
			splitVertical	: 'جدا کردن عمودی سلول',
			title			: 'ویژگیهای سلول',
			cellType		: 'Cell Type', // MISSING
			rowSpan			: 'Rows Span', // MISSING
			colSpan			: 'Columns Span', // MISSING
			wordWrap		: 'Word Wrap', // MISSING
			hAlign			: 'Horizontal Alignment', // MISSING
			vAlign			: 'Vertical Alignment', // MISSING
			alignBaseline	: 'Baseline', // MISSING
			bgColor			: 'Background Color', // MISSING
			borderColor		: 'Border Color', // MISSING
			data			: 'Data', // MISSING
			header			: 'Header', // MISSING
			yes				: 'Yes', // MISSING
			no				: 'No', // MISSING
			invalidWidth	: 'Cell width must be a number.', // MISSING
			invalidHeight	: 'Cell height must be a number.', // MISSING
			invalidRowSpan	: 'Rows span must be a whole number.', // MISSING
			invalidColSpan	: 'Columns span must be a whole number.', // MISSING
			chooseColor		: 'Choose' // MISSING
		},

		row :
		{
			menu			: 'سطر',
			insertBefore	: 'افزودن سطر قبل از',
			insertAfter		: 'افزودن سطر بعد از',
			deleteRow		: 'حذف سطرها'
		},

		column :
		{
			menu			: 'ستون',
			insertBefore	: 'افزودن ستون قبل از',
			insertAfter		: 'افزودن ستون بعد از',
			deleteColumn	: 'حذف ستونها'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'ویژگیهای دکمه',
		text		: 'متن (مقدار)',
		type		: 'نوع',
		typeBtn		: 'دکمه',
		typeSbm		: 'Submit',
		typeRst		: 'بازنشانی (Reset)'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'ویژگیهای خانهٴ گزینهای',
		radioTitle	: 'ویژگیهای دکمهٴ رادیویی',
		value		: 'مقدار',
		selected	: 'برگزیده'
	},

	// Form Dialog.
	form :
	{
		title		: 'ویژگیهای فرم',
		menu		: 'ویژگیهای فرم',
		action		: 'رویداد',
		method		: 'متد',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'ویژگیهای فیلد چندگزینهای',
		selectInfo	: 'اطلاعات',
		opAvail		: 'گزینههای دردسترس',
		value		: 'مقدار',
		size		: 'اندازه',
		lines		: 'خطوط',
		chkMulti	: 'گزینش چندگانه فراهم باشد',
		opText		: 'متن',
		opValue		: 'مقدار',
		btnAdd		: 'افزودن',
		btnModify	: 'ویرایش',
		btnUp		: 'بالا',
		btnDown		: 'پائین',
		btnSetValue : 'تنظیم به عنوان مقدار ِبرگزیده',
		btnDelete	: 'پاککردن'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'ویژگیهای ناحیهٴ متنی',
		cols		: 'ستونها',
		rows		: 'سطرها'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'ویژگیهای فیلد متنی',
		name		: 'نام',
		value		: 'مقدار',
		charWidth	: 'پهنای نویسه',
		maxChars	: 'بیشینهٴ نویسهها',
		type		: 'نوع',
		typeText	: 'متن',
		typePass	: 'گذرواژه'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'ویژگیهای فیلد پنهان',
		name	: 'نام',
		value	: 'مقدار'
	},

	// Image Dialog.
	image :
	{
		title		: 'ویژگیهای تصویر',
		titleButton	: 'ویژگیهای دکمهٴ تصویری',
		menu		: 'ویژگیهای تصویر',
		infoTab		: 'اطلاعات تصویر',
		btnUpload	: 'به سرور بفرست',
		upload		: 'انتقال به سرور',
		alt			: 'متن جایگزین',
		lockRatio	: 'قفلکردن ِنسبت',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'بازنشانی اندازه',
		border		: 'لبه',
		hSpace		: 'فاصلهٴ افقی',
		vSpace		: 'فاصلهٴ عمودی',
		alertUrl	: 'لطفا URL تصویر را بنویسید',
		linkTab		: 'پیوند',
		button2Img	: 'Do you want to transform the selected image button on a simple image?', // MISSING
		img2Button	: 'Do you want to transform the selected image on a image button?', // MISSING
		urlMissing	: 'Image source URL is missing.', // MISSING
		validateBorder	: 'Border must be a whole number.', // MISSING
		validateHSpace	: 'HSpace must be a whole number.', // MISSING
		validateVSpace	: 'VSpace must be a whole number.' // MISSING
	},

	// Flash Dialog
	flash :
	{
		properties		: 'ویژگیهای Flash',
		propertiesTab	: 'Properties', // MISSING
		title			: 'ویژگیهای Flash',
		chkPlay			: 'آغاز ِخودکار',
		chkLoop			: 'اجرای پیاپی',
		chkMenu			: 'دردسترسبودن منوی Flash',
		chkFull			: 'Allow Fullscreen', // MISSING
 		scale			: 'مقیاس',
		scaleAll		: 'نمایش همه',
		scaleNoBorder	: 'بدون کران',
		scaleFit		: 'جایگیری کامل',
		access			: 'Script Access', // MISSING
		accessAlways	: 'Always', // MISSING
		accessSameDomain: 'Same domain', // MISSING
		accessNever		: 'Never', // MISSING
		alignAbsBottom	: 'پائین مطلق',
		alignAbsMiddle	: 'وسط مطلق',
		alignBaseline	: 'خطپایه',
		alignTextTop	: 'متن بالا',
		quality			: 'Quality', // MISSING
		qualityBest		: 'Best', // MISSING
		qualityHigh		: 'High', // MISSING
		qualityAutoHigh	: 'Auto High', // MISSING
		qualityMedium	: 'Medium', // MISSING
		qualityAutoLow	: 'Auto Low', // MISSING
		qualityLow		: 'Low', // MISSING
		windowModeWindow: 'Window', // MISSING
		windowModeOpaque: 'Opaque', // MISSING
		windowModeTransparent : 'Transparent', // MISSING
		windowMode		: 'Window mode', // MISSING
		flashvars		: 'Variables for Flash', // MISSING
		bgcolor			: 'رنگ پسزمینه',
		hSpace			: 'فاصلهٴ افقی',
		vSpace			: 'فاصلهٴ عمودی',
		validateSrc		: 'لطفا URL پیوند را بنویسید',
		validateHSpace	: 'HSpace must be a number.', // MISSING
		validateVSpace	: 'VSpace must be a number.' // MISSING
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'بررسی املا',
		title			: 'Spell Check', // MISSING
		notAvailable	: 'Sorry, but service is unavailable now.', // MISSING
		errorLoading	: 'Error loading application service host: %s.', // MISSING
		notInDic		: 'در واژهنامه یافت نشد',
		changeTo		: 'تغییر به',
		btnIgnore		: 'چشمپوشی',
		btnIgnoreAll	: 'چشمپوشی همه',
		btnReplace		: 'جایگزینی',
		btnReplaceAll	: 'جایگزینی همه',
		btnUndo			: 'واچینش',
		noSuggestions	: '- پیشنهادی نیست -',
		progress		: 'بررسی املا در حال انجام...',
		noMispell		: 'بررسی املا انجام شد. هیچ غلطاملائی یافت نشد',
		noChanges		: 'بررسی املا انجام شد. هیچ واژهای تغییر نیافت',
		oneChange		: 'بررسی املا انجام شد. یک واژه تغییر یافت',
		manyChanges		: 'بررسی املا انجام شد. %1 واژه تغییر یافت',
		ieSpellDownload	: 'بررسیکنندهٴ املا نصب نشده است. آیا میخواهید آن را هماکنون دریافت کنید؟'
	},

	smiley :
	{
		toolbar	: 'خندانک',
		title	: 'گنجاندن خندانک',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element' // MISSING
	},

	numberedlist	: 'فهرست شمارهدار',
	bulletedlist	: 'فهرست نقطهای',
	indent			: 'افزایش تورفتگی',
	outdent			: 'کاهش تورفتگی',

	justify :
	{
		left	: 'چپچین',
		center	: 'میانچین',
		right	: 'راستچین',
		block	: 'بلوکچین'
	},

	blockquote : 'بلوک نقل قول',

	clipboard :
	{
		title		: 'چسباندن',
		cutError	: 'تنظیمات امنیتی مرورگر شما اجازه نمیدهد که ویرایشگر به طور خودکار عملکردهای برش را انجام دهد. لطفا با دکمههای صفحهکلید این کار را انجام دهید (Ctrl/Cmd+X).',
		copyError	: 'تنظیمات امنیتی مرورگر شما اجازه نمیدهد که ویرایشگر به طور خودکار عملکردهای کپیکردن را انجام دهد. لطفا با دکمههای صفحهکلید این کار را انجام دهید (Ctrl/Cmd+C).',
		pasteMsg	: 'لطفا متن را با کلیدهای (<STRONG>Ctrl/Cmd+V</STRONG>) در این جعبهٴ متنی بچسبانید و <STRONG>پذیرش</STRONG> را بزنید.',
		securityMsg	: 'به خاطر تنظیمات امنیتی مرورگر شما، ویرایشگر نمیتواند دسترسی مستقیم به دادههای clipboard داشته باشد. شما باید دوباره آنرا در این پنجره بچسبانید.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'The text you want to paste seems to be copied from Word. Do you want to clean it before pasting?', // MISSING
		toolbar			: 'چسباندن از Word',
		title			: 'چسباندن از Word',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'چسباندن به عنوان متن ِساده',
		title	: 'چسباندن به عنوان متن ِساده'
	},

	templates :
	{
		button			: 'الگوها',
		title			: 'الگوهای محتویات',
		options : 'Template Options', // MISSING
		insertOption	: 'محتویات کنونی جایگزین شوند',
		selectPromptMsg	: 'لطفا الگوی موردنظر را برای بازکردن در ویرایشگر برگزینید<br>(محتویات کنونی از دست خواهند رفت):',
		emptyListMsg	: '(الگوئی تعریف نشده است)'
	},

	showBlocks : 'نمایش بلوکها',

	stylesCombo :
	{
		label		: 'سبک',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block Styles', // MISSING
		panelTitle2	: 'Inline Styles', // MISSING
		panelTitle3	: 'Object Styles' // MISSING
	},

	format :
	{
		label		: 'فرمت',
		panelTitle	: 'فرمت',

		tag_p		: 'نرمال',
		tag_pre		: 'فرمتشده',
		tag_address	: 'آدرس',
		tag_h1		: 'سرنویس 1',
		tag_h2		: 'سرنویس 2',
		tag_h3		: 'سرنویس 3',
		tag_h4		: 'سرنویس 4',
		tag_h5		: 'سرنویس 5',
		tag_h6		: 'سرنویس 6',
		tag_div		: 'بند'
	},

	div :
	{
		title				: 'Create Div Container', // MISSING
		toolbar				: 'Create Div Container', // MISSING
		cssClassInputLabel	: 'Stylesheet Classes', // MISSING
		styleSelectLabel	: 'Style', // MISSING
		IdInputLabel		: 'Id', // MISSING
		languageCodeInputLabel	: ' Language Code', // MISSING
		inlineStyleInputLabel	: 'Inline Style', // MISSING
		advisoryTitleInputLabel	: 'Advisory Title', // MISSING
		langDirLabel		: 'Language Direction', // MISSING
		langDirLTRLabel		: 'Left to Right (LTR)', // MISSING
		langDirRTLLabel		: 'Right to Left (RTL)', // MISSING
		edit				: 'Edit Div', // MISSING
		remove				: 'Remove Div' // MISSING
  	},

	iframe :
	{
		title		: 'iFrame Properties', // MISSING
		toolbar		: 'iFrame', // MISSING
		noUrl		: 'Please type the iFrame URL', // MISSING
		scrolling	: 'Enable scrollbars', // MISSING
		border		: 'Show frame border' // MISSING
	},

	font :
	{
		label		: 'قلم',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'قلم'
	},

	fontSize :
	{
		label		: 'اندازه',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'اندازه'
	},

	colorButton :
	{
		textColorTitle	: 'رنگ متن',
		bgColorTitle	: 'رنگ پسزمینه',
		panelTitle		: 'Colors', // MISSING
		auto			: 'خودکار',
		more			: 'رنگهای بیشتر...'
	},

	colors :
	{
		'000' : 'Black', // MISSING
		'800000' : 'Maroon', // MISSING
		'8B4513' : 'Saddle Brown', // MISSING
		'2F4F4F' : 'Dark Slate Gray', // MISSING
		'008080' : 'Teal', // MISSING
		'000080' : 'Navy', // MISSING
		'4B0082' : 'Indigo', // MISSING
		'696969' : 'Dark Gray', // MISSING
		'B22222' : 'Fire Brick', // MISSING
		'A52A2A' : 'Brown', // MISSING
		'DAA520' : 'Golden Rod', // MISSING
		'006400' : 'Dark Green', // MISSING
		'40E0D0' : 'Turquoise', // MISSING
		'0000CD' : 'Medium Blue', // MISSING
		'800080' : 'Purple', // MISSING
		'808080' : 'Gray', // MISSING
		'F00' : 'Red', // MISSING
		'FF8C00' : 'Dark Orange', // MISSING
		'FFD700' : 'Gold', // MISSING
		'008000' : 'Green', // MISSING
		'0FF' : 'Cyan', // MISSING
		'00F' : 'Blue', // MISSING
		'EE82EE' : 'Violet', // MISSING
		'A9A9A9' : 'Dim Gray', // MISSING
		'FFA07A' : 'Light Salmon', // MISSING
		'FFA500' : 'Orange', // MISSING
		'FFFF00' : 'Yellow', // MISSING
		'00FF00' : 'Lime', // MISSING
		'AFEEEE' : 'Pale Turquoise', // MISSING
		'ADD8E6' : 'Light Blue', // MISSING
		'DDA0DD' : 'Plum', // MISSING
		'D3D3D3' : 'Light Grey', // MISSING
		'FFF0F5' : 'Lavender Blush', // MISSING
		'FAEBD7' : 'Antique White', // MISSING
		'FFFFE0' : 'Light Yellow', // MISSING
		'F0FFF0' : 'Honeydew', // MISSING
		'F0FFFF' : 'Azure', // MISSING
		'F0F8FF' : 'Alice Blue', // MISSING
		'E6E6FA' : 'Lavender', // MISSING
		'FFF' : 'White' // MISSING
	},

	scayt :
	{
		title			: 'Spell Check As You Type', // MISSING
		opera_title		: 'Not supported by Opera', // MISSING
		enable			: 'Enable SCAYT', // MISSING
		disable			: 'Disable SCAYT', // MISSING
		about			: 'About SCAYT', // MISSING
		toggle			: 'Toggle SCAYT', // MISSING
		options			: 'Options', // MISSING
		langs			: 'Languages', // MISSING
		moreSuggestions	: 'More suggestions', // MISSING
		ignore			: 'Ignore', // MISSING
		ignoreAll		: 'Ignore All', // MISSING
		addWord			: 'Add Word', // MISSING
		emptyDic		: 'Dictionary name should not be empty.', // MISSING

		optionsTab		: 'Options', // MISSING
		allCaps			: 'Ignore All-Caps Words', // MISSING
		ignoreDomainNames : 'Ignore Domain Names', // MISSING
		mixedCase		: 'Ignore Words with Mixed Case', // MISSING
		mixedWithDigits	: 'Ignore Words with Numbers', // MISSING

		languagesTab	: 'Languages', // MISSING

		dictionariesTab	: 'Dictionaries', // MISSING
		dic_field_name	: 'Dictionary name', // MISSING
		dic_create		: 'Create', // MISSING
		dic_restore		: 'Restore', // MISSING
		dic_delete		: 'Delete', // MISSING
		dic_rename		: 'Rename', // MISSING
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'About' // MISSING
	},

	about :
	{
		title		: 'About CKEditor', // MISSING
		dlgTitle	: 'About CKEditor', // MISSING
		moreInfo	: 'For licensing information please visit our web site:', // MISSING
		copy		: 'Copyright &copy; $1. All rights reserved.' // MISSING
	},

	maximize : 'Maximize', // MISSING
	minimize : 'Minimize', // MISSING

	fakeobjects :
	{
		anchor		: 'Anchor', // MISSING
		flash		: 'Flash Animation', // MISSING
		iframe		: 'iFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Unknown Object' // MISSING
	},

	resize : 'Drag to resize', // MISSING

	colordialog :
	{
		title		: 'Select color', // MISSING
		options	:	'Color Options', // MISSING
		highlight	: 'Highlight', // MISSING
		selected	: 'Selected Color', // MISSING
		clear		: 'Clear' // MISSING
	},

	toolbarCollapse	: 'Collapse Toolbar', // MISSING
	toolbarExpand	: 'Expand Toolbar', // MISSING

	bidi :
	{
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
	}
};
