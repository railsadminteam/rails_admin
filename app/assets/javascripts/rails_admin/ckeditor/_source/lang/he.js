﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Hebrew language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['he'] =
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
	editorTitle : 'עורך טקסט עשיר, %1, לחץ אלט (ALT) + 0 לעזרה.',

	// ARIA descriptions.
	toolbars	: 'סרגלי כלים של העורך',
	editor		: 'עורך טקסט עשיר',

	// Toolbar buttons without dialogs.
	source			: 'מקור',
	newPage			: 'דף חדש',
	save			: 'שמירה',
	preview			: 'תצוגה מקדימה',
	cut				: 'גזירה',
	copy			: 'העתקה',
	paste			: 'הדבקה',
	print			: 'הדפסה',
	underline		: 'קו תחתון',
	bold			: 'מודגש',
	italic			: 'נטוי',
	selectAll		: 'בחירת הכל',
	removeFormat	: 'הסרת העיצוב',
	strike			: 'כתיב מחוק',
	subscript		: 'כתיב תחתון',
	superscript		: 'כתיב עליון',
	horizontalrule	: 'הוספת קו אופקי',
	pagebreak		: 'הוספת שבירת דף',
	pagebreakAlt		: 'שבירת דף',
	unlink			: 'הסרת הקישור',
	undo			: 'ביטול צעד אחרון',
	redo			: 'חזרה על צעד אחרון',

	// Common messages and labels.
	common :
	{
		browseServer	: 'סייר השרת',
		url				: 'כתובת (URL)',
		protocol		: 'פרוטוקול',
		upload			: 'העלאה',
		uploadSubmit	: 'שליחה לשרת',
		image			: 'תמונה',
		flash			: 'פלאש',
		form			: 'טופס',
		checkbox		: 'תיבת סימון',
		radio			: 'לחצן אפשרויות',
		textField		: 'שדה טקסט',
		textarea		: 'איזור טקסט',
		hiddenField		: 'שדה חבוי',
		button			: 'כפתור',
		select			: 'שדה בחירה',
		imageButton		: 'כפתור תמונה',
		notSet			: '<לא נקבע>',
		id				: 'זיהוי (ID)',
		name			: 'שם',
		langDir			: 'כיוון שפה',
		langDirLtr		: 'שמאל לימין (LTR)',
		langDirRtl		: 'ימין לשמאל (RTL)',
		langCode		: 'קוד שפה',
		longDescr		: 'קישור לתיאור מפורט',
		cssClass		: 'מחלקת עיצוב (CSS Class)',
		advisoryTitle	: 'כותרת מוצעת',
		cssStyle		: 'סגנון',
		ok				: 'אישור',
		cancel			: 'ביטול',
		close			: 'סגירה',
		preview			: 'תצוגה מקדימה',
		generalTab		: 'כללי',
		advancedTab		: 'אפשרויות מתקדמות',
		validateNumberFailed : 'הערך חייב להיות מספרי.',
		confirmNewPage	: 'כל השינויים שלא נשמרו יאבדו. האם להעלות דף חדש?',
		confirmCancel	: 'חלק מהאפשרויות שונו, האם לסגור את הדיאלוג?',
		options			: 'אפשרויות',
		target			: 'מטרה',
		targetNew		: 'חלון חדש (_blank)',
		targetTop		: 'החלון העליון ביותר (_top)',
		targetSelf		: 'אותו חלון (_self)',
		targetParent	: 'חלון האב (_parent)',
		langDirLTR		: 'שמאל לימין (LTR)',
		langDirRTL		: 'ימין לשמאל (RTL)',
		styles			: 'סגנון',
		cssClasses		: 'מחלקות גליונות סגנון',
		width			: 'רוחב',
		height			: 'גובה',
		align			: 'יישור',
		alignLeft		: 'לשמאל',
		alignRight		: 'לימין',
		alignCenter		: 'מרכז',
		alignTop		: 'למעלה',
		alignMiddle		: 'לאמצע',
		alignBottom		: 'לתחתית',
		invalidHeight	: 'הגובה חייב להיות מספר.',
		invalidWidth	: 'הרוחב חייב להיות מספר.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, לא זמין</span>'
	},

	contextmenu :
	{
		options : 'אפשרויות תפריט ההקשר'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'הוספת תו מיוחד',
		title		: 'בחירת תו מיוחד',
		options : 'אפשרויות תווים מיוחדים'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'הוספת/עריכת קישור',
		other 		: '<אחר>',
		menu		: 'מאפייני קישור',
		title		: 'קישור',
		info		: 'מידע על הקישור',
		target		: 'מטרה',
		upload		: 'העלאה',
		advanced	: 'אפשרויות מתקדמות',
		type		: 'סוג קישור',
		toUrl		: 'כתובת (URL)',
		toAnchor	: 'עוגן בעמוד זה',
		toEmail		: 'דוא"ל',
		targetFrame		: '<מסגרת>',
		targetPopup		: '<חלון קופץ>',
		targetFrameName	: 'שם מסגרת היעד',
		targetPopupName	: 'שם החלון הקופץ',
		popupFeatures	: 'תכונות החלון הקופץ',
		popupResizable	: 'שינוי גודל',
		popupStatusBar	: 'סרגל חיווי',
		popupLocationBar: 'סרגל כתובת',
		popupToolbar	: 'סרגל הכלים',
		popupMenuBar	: 'סרגל תפריט',
		popupFullScreen	: 'מסך מלא (IE)',
		popupScrollBars	: 'ניתן לגלילה',
		popupDependent	: 'תלוי (Netscape)',
		popupLeft		: 'מיקום צד שמאל',
		popupTop		: 'מיקום צד עליון',
		id				: 'זיהוי (ID)',
		langDir			: 'כיוון שפה',
		langDirLTR		: 'שמאל לימין (LTR)',
		langDirRTL		: 'ימין לשמאל (RTL)',
		acccessKey		: 'מקש גישה',
		name			: 'שם',
		langCode			: 'קוד שפה',
		tabIndex			: 'מספר טאב',
		advisoryTitle		: 'כותרת מוצעת',
		advisoryContentType	: 'Content Type מוצע',
		cssClasses		: 'גיליונות עיצוב קבוצות',
		charset			: 'קידוד המשאב המקושר',
		styles			: 'סגנון',
		rel			: 'קשר גומלין',
		selectAnchor		: 'בחירת עוגן',
		anchorName		: 'עפ"י שם העוגן',
		anchorId			: 'עפ"י זיהוי (ID) האלמנט',
		emailAddress		: 'כתובת הדוא"ל',
		emailSubject		: 'נושא ההודעה',
		emailBody		: 'גוף ההודעה',
		noAnchors		: '(אין עוגנים זמינים בדף)',
		noUrl			: 'יש להקליד את כתובת הקישור (URL)',
		noEmail			: 'יש להקליד את כתובת הדוא"ל'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'הוספת/עריכת נקודת עיגון',
		menu		: 'מאפייני נקודת עיגון',
		title		: 'מאפייני נקודת עיגון',
		name		: 'שם לנקודת עיגון',
		errorName	: 'יש להקליד שם לנקודת עיגון'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'תכונות רשימה ממוספרת',
		bulletedTitle		: 'תכונות רשימת תבליטים',
		type				: 'סוג',
		start				: 'תחילת מספור',
		validateStartNumber				:'שדה תחילת המספור חייב להכיל מספר שלם.',
		circle				: 'עיגול ריק',
		disc				: 'עיגול מלא',
		square				: 'ריבוע',
		none				: 'ללא',
		notset				: '<לא נקבע>',
		armenian			: 'ספרות ארמניות',
		georgian			: 'ספרות גיאורגיות (an, ban, gan וכו\')',
		lowerRoman			: 'ספירה רומית באותיות קטנות (i, ii, iii, iv, v וכו\')',
		upperRoman			: 'ספירה רומיות באותיות גדולות (I, II, III, IV, V וכו\')',
		lowerAlpha			: 'אותיות אנגליות קטנות (a, b, c, d, e וכו\')',
		upperAlpha			: 'אותיות אנגליות גדולות (A, B, C, D, E וכו\')',
		lowerGreek			: 'אותיות יווניות קטנות (alpha, beta, gamma וכו\')',
		decimal				: 'ספרות (1, 2, 3 וכו\')',
		decimalLeadingZero	: 'ספרות עם 0 בהתחלה (01, 02, 03 וכו\')'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'חיפוש והחלפה',
		find				: 'חיפוש',
		replace				: 'החלפה',
		findWhat			: 'חיפוש מחרוזת:',
		replaceWith			: 'החלפה במחרוזת:',
		notFoundMsg			: 'הטקסט המבוקש לא נמצא.',
		matchCase			: 'הבחנה בין אותיות רשיות לקטנות (Case)',
		matchWord			: 'התאמה למילה המלאה',
		matchCyclic			: 'התאמה מחזורית',
		replaceAll			: 'החלפה בכל העמוד',
		replaceSuccessMsg	: '%1 טקסטים הוחלפו.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'טבלה',
		title		: 'מאפייני טבלה',
		menu		: 'מאפייני טבלה',
		deleteTable	: 'מחק טבלה',
		rows		: 'שורות',
		columns		: 'עמודות',
		border		: 'גודל מסגרת',
		widthPx		: 'פיקסלים',
		widthPc		: 'אחוז',
		widthUnit	: 'יחידת רוחב',
		cellSpace	: 'מרווח תא',
		cellPad		: 'ריפוד תא',
		caption		: 'כיתוב',
		summary		: 'תקציר',
		headers		: 'כותרות',
		headersNone		: 'אין',
		headersColumn	: 'עמודה ראשונה',
		headersRow		: 'שורה ראשונה',
		headersBoth		: 'שניהם',
		invalidRows		: 'שדה מספר השורות חייב להיות מספר גדול מ 0.',
		invalidCols		: 'שדה מספר העמודות חייב להיות מספר גדול מ 0.',
		invalidBorder	: 'שדה גודל המסגרת חייב להיות מספר.',
		invalidWidth	: 'שדה רוחב הטבלה חייב להיות מספר.',
		invalidHeight	: 'שדה גובה הטבלה חייב להיות מספר.',
		invalidCellSpacing	: 'שדה ריווח התאים חייב להיות מספר.',
		invalidCellPadding	: 'שדה ריפוד התאים חייב להיות מספר.',

		cell :
		{
			menu			: 'מאפייני תא',
			insertBefore	: 'הוספת תא לפני',
			insertAfter		: 'הוספת תא אחרי',
			deleteCell		: 'מחיקת תאים',
			merge			: 'מיזוג תאים',
			mergeRight		: 'מזג ימינה',
			mergeDown		: 'מזג למטה',
			splitHorizontal	: 'פיצול תא אופקית',
			splitVertical	: 'פיצול תא אנכית',
			title			: 'תכונות התא',
			cellType		: 'סוג התא',
			rowSpan			: 'מתיחת השורות',
			colSpan			: 'מתיחת התאים',
			wordWrap		: 'מניעת גלישת שורות',
			hAlign			: 'יישור אופקי',
			vAlign			: 'יישור אנכי',
			alignBaseline	: 'שורת בסיס',
			bgColor			: 'צבע רקע',
			borderColor		: 'צבע מסגרת',
			data			: 'מידע',
			header			: 'כותרת',
			yes				: 'כן',
			no				: 'לא',
			invalidWidth	: 'שדה רוחב התא חייב להיות מספר.',
			invalidHeight	: 'שדה גובה התא חייב להיות מספר.',
			invalidRowSpan	: 'שדה מתיחת השורות חייב להיות מספר שלם.',
			invalidColSpan	: 'שדה מתיחת העמודות חייב להיות מספר שלם.',
			chooseColor		: 'בחר'
		},

		row :
		{
			menu			: 'שורה',
			insertBefore	: 'הוספת שורה לפני',
			insertAfter		: 'הוספת שורה אחרי',
			deleteRow		: 'מחיקת שורות'
		},

		column :
		{
			menu			: 'עמודה',
			insertBefore	: 'הוספת עמודה לפני',
			insertAfter		: 'הוספת עמודה אחרי',
			deleteColumn	: 'מחיקת עמודות'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'מאפייני כפתור',
		text		: 'טקסט (ערך)',
		type		: 'סוג',
		typeBtn		: 'כפתור',
		typeSbm		: 'שליחה',
		typeRst		: 'איפוס'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'מאפייני תיבת סימון',
		radioTitle	: 'מאפייני לחצן אפשרויות',
		value		: 'ערך',
		selected	: 'מסומן'
	},

	// Form Dialog.
	form :
	{
		title		: 'מאפיני טופס',
		menu		: 'מאפיני טופס',
		action		: 'שלח אל',
		method		: 'סוג שליחה',
		encoding	: 'קידוד'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'מאפייני שדה בחירה',
		selectInfo	: 'מידע',
		opAvail		: 'אפשרויות זמינות',
		value		: 'ערך',
		size		: 'גודל',
		lines		: 'שורות',
		chkMulti	: 'איפשור בחירות מרובות',
		opText		: 'טקסט',
		opValue		: 'ערך',
		btnAdd		: 'הוספה',
		btnModify	: 'שינוי',
		btnUp		: 'למעלה',
		btnDown		: 'למטה',
		btnSetValue : 'קביעה כברירת מחדל',
		btnDelete	: 'מחיקה'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'מאפייני איזור טקסט',
		cols		: 'עמודות',
		rows		: 'שורות'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'מאפייני שדה טקסט',
		name		: 'שם',
		value		: 'ערך',
		charWidth	: 'רוחב לפי תווים',
		maxChars	: 'מקסימום תווים',
		type		: 'סוג',
		typeText	: 'טקסט',
		typePass	: 'סיסמה'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'מאפיני שדה חבוי',
		name	: 'שם',
		value	: 'ערך'
	},

	// Image Dialog.
	image :
	{
		title		: 'מאפייני התמונה',
		titleButton	: 'מאפיני כפתור תמונה',
		menu		: 'תכונות התמונה',
		infoTab		: 'מידע על התמונה',
		btnUpload	: 'שליחה לשרת',
		upload		: 'העלאה',
		alt			: 'טקסט חלופי',
		lockRatio	: 'נעילת היחס',
		unlockRatio	: 'ביטול נעילת היחס',
		resetSize	: 'איפוס הגודל',
		border		: 'מסגרת',
		hSpace		: 'מרווח אופקי',
		vSpace		: 'מרווח אנכי',
		alertUrl	: 'יש להקליד את כתובת התמונה',
		linkTab		: 'קישור',
		button2Img	: 'האם להפוך את תמונת הכפתור לתמונה פשוטה?',
		img2Button	: 'האם להפוך את התמונה לכפתור תמונה?',
		urlMissing	: 'כתובת התמונה חסרה.',
		validateBorder	: 'שדה המסגרת חייב להיות מספר שלם.',
		validateHSpace	: 'שדה המרווח האופקי חייב להיות מספר שלם.',
		validateVSpace	: 'שדה המרווח האנכי חייב להיות מספר שלם.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'מאפייני פלאש',
		propertiesTab	: 'מאפיינים',
		title			: 'מאפיני פלאש',
		chkPlay			: 'ניגון אוטומטי',
		chkLoop			: 'לולאה',
		chkMenu			: 'אפשר תפריט פלאש',
		chkFull			: 'אפשר חלון מלא',
 		scale			: 'גודל',
		scaleAll		: 'הצג הכל',
		scaleNoBorder	: 'ללא גבולות',
		scaleFit		: 'התאמה מושלמת',
		access			: 'גישת סקריפט',
		accessAlways	: 'תמיד',
		accessSameDomain: 'דומיין זהה',
		accessNever		: 'אף פעם',
		alignAbsBottom	: 'לתחתית האבסולוטית',
		alignAbsMiddle	: 'מרכוז אבסולוטי',
		alignBaseline	: 'לקו התחתית',
		alignTextTop	: 'לראש הטקסט',
		quality			: 'איכות',
		qualityBest		: 'מעולה',
		qualityHigh		: 'גבוהה',
		qualityAutoHigh	: 'גבוהה אוטומטית',
		qualityMedium	: 'ממוצעת',
		qualityAutoLow	: 'נמוכה אוטומטית',
		qualityLow		: 'נמוכה',
		windowModeWindow: 'חלון',
		windowModeOpaque: 'אטום',
		windowModeTransparent : 'שקוף',
		windowMode		: 'מצב חלון',
		flashvars		: 'משתנים לפלאש',
		bgcolor			: 'צבע רקע',
		hSpace			: 'מרווח אופקי',
		vSpace			: 'מרווח אנכי',
		validateSrc		: 'יש להקליד את כתובת סרטון הפלאש (URL)',
		validateHSpace	: 'המרווח האופקי חייב להיות מספר.',
		validateVSpace	: 'המרווח האנכי חייב להיות מספר.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'בדיקת איות',
		title			: 'בדיקת איות',
		notAvailable	: 'לא נמצא שירות זמין.',
		errorLoading	: 'שגיאה בהעלאת השירות: %s.',
		notInDic		: 'לא נמצא במילון',
		changeTo		: 'שינוי ל',
		btnIgnore		: 'התעלמות',
		btnIgnoreAll	: 'התעלמות מהכל',
		btnReplace		: 'החלפה',
		btnReplaceAll	: 'החלפת הכל',
		btnUndo			: 'החזרה',
		noSuggestions	: '- אין הצעות -',
		progress		: 'בודק האיות בתהליך בדיקה....',
		noMispell		: 'בדיקות איות הסתיימה: לא נמצאו שגיאות כתיב',
		noChanges		: 'בדיקות איות הסתיימה: לא שונתה אף מילה',
		oneChange		: 'בדיקות איות הסתיימה: שונתה מילה אחת',
		manyChanges		: 'בדיקות איות הסתיימה: %1 מילים שונו',
		ieSpellDownload	: 'בודק האיות לא מותקן, האם להורידו?'
	},

	smiley :
	{
		toolbar	: 'סמיילי',
		title	: 'הוספת סמיילי',
		options : 'אפשרויות סמיילים'
	},

	elementsPath :
	{
		eleLabel : 'עץ האלמנטים',
		eleTitle : '%1 אלמנט'
	},

	numberedlist	: 'רשימה ממוספרת',
	bulletedlist	: 'רשימת נקודות',
	indent			: 'הגדלת הזחה',
	outdent			: 'הקטנת הזחה',

	justify :
	{
		left	: 'יישור לשמאל',
		center	: 'מרכוז',
		right	: 'יישור לימין',
		block	: 'יישור לשוליים'
	},

	blockquote : 'בלוק ציטוט',

	clipboard :
	{
		title		: 'הדבקה',
		cutError	: 'הגדרות האבטחה בדפדפן שלך לא מאפשרות לעורך לבצע פעולות גזירה אוטומטיות. יש להשתמש במקלדת לשם כך (Ctrl/Cmd+X).',
		copyError	: 'הגדרות האבטחה בדפדפן שלך לא מאפשרות לעורך לבצע פעולות העתקה אוטומטיות. יש להשתמש במקלדת לשם כך (Ctrl/Cmd+C).',
		pasteMsg	: 'נא להדביק בתוך הקופסה באמצעות (<b>Ctrl/Cmd+V</b>) וללחוץ על <b>אישור</b>.',
		securityMsg	: 'עקב הגדרות אבטחה בדפדפן, לא ניתן לגשת אל לוח הגזירים (Clipboard) בצורה ישירה. נא להדביק שוב בחלון זה.',
		pasteArea	: 'איזור הדבקה'
	},

	pastefromword :
	{
		confirmCleanup	: 'נראה הטקסט שבכוונתך להדביק מקורו בקובץ וורד. האם ברצונך לנקות אותו טרם ההדבקה?',
		toolbar			: 'הדבקה מ-Word',
		title			: 'הדבקה מ-Word',
		error			: 'לא ניתן היה לנקות את המידע בשל תקלה פנימית.'
	},

	pasteText :
	{
		button	: 'הדבקה כטקסט פשוט',
		title	: 'הדבקה כטקסט פשוט'
	},

	templates :
	{
		button			: 'תבניות',
		title			: 'תביות תוכן',
		options : 'אפשרויות התבניות',
		insertOption	: 'החלפת תוכן ממשי',
		selectPromptMsg	: 'יש לבחור תבנית לפתיחה בעורך.<br />התוכן המקורי ימחק:',
		emptyListMsg	: '(לא הוגדרו תבניות)'
	},

	showBlocks : 'הצגת בלוקים',

	stylesCombo :
	{
		label		: 'סגנון',
		panelTitle	: 'סגנונות פורמט',
		panelTitle1	: 'סגנונות בלוק',
		panelTitle2	: 'סגנונות רצף',
		panelTitle3	: 'סגנונות אובייקט'
	},

	format :
	{
		label		: 'עיצוב',
		panelTitle	: 'עיצוב',

		tag_p		: 'נורמלי',
		tag_pre		: 'קוד',
		tag_address	: 'כתובת',
		tag_h1		: 'כותרת',
		tag_h2		: 'כותרת 2',
		tag_h3		: 'כותרת 3',
		tag_h4		: 'כותרת 4',
		tag_h5		: 'כותרת 5',
		tag_h6		: 'כותרת 6',
		tag_div		: 'נורמלי (DIV)'
	},

	div :
	{
		title				: 'יצירת מיכל (Div)',
		toolbar				: 'יצירת מיכל (Div)',
		cssClassInputLabel	: 'מחלקת עיצוב',
		styleSelectLabel	: 'סגנון',
		IdInputLabel		: 'מזהה (ID)',
		languageCodeInputLabel	: 'קוד שפה',
		inlineStyleInputLabel	: 'סגנון פנימי',
		advisoryTitleInputLabel	: 'כותרת מוצעת',
		langDirLabel		: 'כיוון שפה',
		langDirLTRLabel		: 'שמאל לימין (LTR)',
		langDirRTLLabel		: 'ימין לשמאל (RTL)',
		edit				: 'עריכת מיכל (Div)',
		remove				: 'הסרת מיכל (Div)'
  	},

	iframe :
	{
		title		: 'מאפייני חלון פנימי (iframe)',
		toolbar		: 'חלון פנימי (iframe)',
		noUrl		: 'יש להכניס כתובת לחלון.',
		scrolling	: 'אפשר פסי גלילה',
		border		: 'הראה מסגרת לחלון'
	},

	font :
	{
		label		: 'גופן',
		voiceLabel	: 'גופן',
		panelTitle	: 'גופן'
	},

	fontSize :
	{
		label		: 'גודל',
		voiceLabel	: 'גודל',
		panelTitle	: 'גודל'
	},

	colorButton :
	{
		textColorTitle	: 'צבע טקסט',
		bgColorTitle	: 'צבע רקע',
		panelTitle		: 'צבעים',
		auto			: 'אוטומטי',
		more			: 'צבעים נוספים...'
	},

	colors :
	{
		'000' : 'שחור',
		'800000' : 'סגול כהה',
		'8B4513' : 'חום בהיר',
		'2F4F4F' : 'אפור צפחה',
		'008080' : 'כחול-ירוק',
		'000080' : 'כחול-סגול',
		'4B0082' : 'אינדיגו',
		'696969' : 'אפור מעומעם',
		'B22222' : 'אדום-חום',
		'A52A2A' : 'חום',
		'DAA520' : 'כתום זהב',
		'006400' : 'ירוק כהה',
		'40E0D0' : 'טורקיז',
		'0000CD' : 'כחול בינוני',
		'800080' : 'סגול',
		'808080' : 'אפור',
		'F00' : 'אדום',
		'FF8C00' : 'כתום כהה',
		'FFD700' : 'זהב',
		'008000' : 'ירוק',
		'0FF' : 'ציאן',
		'00F' : 'כחול',
		'EE82EE' : 'סגלגל',
		'A9A9A9' : 'אפור כהה',
		'FFA07A' : 'כתום-וורוד',
		'FFA500' : 'כתום',
		'FFFF00' : 'צהוב',
		'00FF00' : 'ליים',
		'AFEEEE' : 'טורקיז בהיר',
		'ADD8E6' : 'כחול בהיר',
		'DDA0DD' : 'שזיף',
		'D3D3D3' : 'אפור בהיר',
		'FFF0F5' : 'לבנדר מסמיק',
		'FAEBD7' : 'לבן עתיק',
		'FFFFE0' : 'צהוב בהיר',
		'F0FFF0' : 'טל דבש',
		'F0FFFF' : 'תכלת',
		'F0F8FF' : 'כחול טיפת מים',
		'E6E6FA' : 'לבנדר',
		'FFF' : 'לבן'
	},

	scayt :
	{
		title			: 'בדיקת איות בזמן כתיבה (SCAYT)',
		opera_title		: 'לא זמין בדפדפן אופרה',
		enable			: 'אפשר SCAYT',
		disable			: 'בטל SCAYT',
		about			: 'אודות SCAYT',
		toggle			: 'שינוי SCAYT',
		options			: 'אפשרויות',
		langs			: 'שפות',
		moreSuggestions	: 'הצעות נוספות',
		ignore			: 'התעלמות',
		ignoreAll		: 'התעלמות מהכל',
		addWord			: 'הוספת מילה',
		emptyDic		: 'יש לבחור מילון.',

		optionsTab		: 'אפשרויות',
		allCaps			: 'התעלם ממילים שכל אותיותיהן גדולות',
		ignoreDomainNames : 'התעלם משמות מתחם',
		mixedCase		: 'התעלם ממילים עם אותיות גדולות וקטנות ביחד',
		mixedWithDigits	: 'התעלם ממילים עם מספרים',

		languagesTab	: 'שפות',

		dictionariesTab	: 'מילון',
		dic_field_name	: 'שם המילון',
		dic_create		: 'יצירה',
		dic_restore		: 'שחזור',
		dic_delete		: 'מחיקה',
		dic_rename		: 'שינוי שם',
		dic_info		: 'בהתחלה מילון המשתמש מאוחסן בעוגיה, אך עוגיות מוגבלות במקום. כאשר המילון מגיע לגודל בו הוא אינו יכול להתאכסן בעוגיה, המילון צריך להתאכסן בשרתנו. לשם כך עליך לתת שם למילון. אם כבר יש לך מילון מאוחסן, יש להכניס את שמו וללחוץ על כפתור השחזור.',

		aboutTab		: 'אודות'
	},

	about :
	{
		title		: 'אודות CKEditor',
		dlgTitle	: 'אודות CKEditor',
		help	: 'היכנסו ל$1 לעזרה.',
		userGuide : 'מדריך המשתמש של CKEditor',
		moreInfo	: 'למידע נוסף בקרו באתרנו:',
		copy		: 'Copyright &copy; $1. כל הזכויות שמורות.'
	},

	maximize : 'הגדלה למקסימום',
	minimize : 'הקטנה למינימום',

	fakeobjects :
	{
		anchor		: 'עוגן',
		flash		: 'סרטון פלאש',
		iframe		: 'חלון פנימי (iframe)',
		hiddenfield	: 'שדה חבוי',
		unknown		: 'אובייקט לא ידוע'
	},

	resize : 'יש לגרור בכדי לשנות את הגודל',

	colordialog :
	{
		title		: 'בחירת צבע',
		options	:	'אפשרויות צבע',
		highlight	: 'סימון',
		selected	: 'בחירה',
		clear		: 'ניקוי'
	},

	toolbarCollapse	: 'מזעור סרגל כלים',
	toolbarExpand	: 'הרחבת סרגל כלים',

	toolbarGroups :
	{
		document : 'מסמך',
		clipboard : 'לוח הגזירים (Clipboard)/צעד אחרון',
		editing : 'עריכה',
		forms : 'טפסים',
		basicstyles : 'עיצוב בסיסי',
		paragraph : 'פסקה',
		links : 'קישורים',
		insert : 'הכנסה',
		styles : 'עיצוב',
		colors : 'צבעים',
		tools : 'כלים'
	},

	bidi :
	{
		ltr : 'כיוון טקסט משמאל לימין (LTR)',
		rtl : 'כיוון טקסט מימין לשמאל (RTL)'
	},

	docprops :
	{
		label : 'מאפייני מסמך',
		title : 'מאפייני מסמך',
		design : 'עיצוב',
		meta : 'תגי Meta',
		chooseColor : 'בחירה',
		other : 'אחר...',
		docTitle :	'כותרת עמוד',
		charset : 	'קידוד תווים',
		charsetOther : 'קידוד תווים אחר',
		charsetASCII : 'ASCII',
		charsetCE : 'מרכז אירופאי',
		charsetCT : 'סיני מסורתי (Big5)',
		charsetCR : 'קירילי',
		charsetGR : 'יווני',
		charsetJP : 'יפני',
		charsetKR : 'קוריאני',
		charsetTR : 'טורקי',
		charsetUN : 'יוניקוד (UTF-8)',
		charsetWE : 'מערב אירופאי',
		docType : 'כותר סוג מסמך',
		docTypeOther : 'כותר סוג מסמך אחר',
		xhtmlDec : 'כלול הכרזות XHTML',
		bgColor : 'צבע רקע',
		bgImage : 'כתובת של תמונת רקע',
		bgFixed : 'רקע לא נגלל (צמוד)',
		txtColor : 'צבע טקסט',
		margin : 'מרווחי עמוד',
		marginTop : 'עליון',
		marginLeft : 'שמאלי',
		marginRight : 'ימני',
		marginBottom : 'תחתון',
		metaKeywords : 'מילות מפתח של המסמך (מופרדות בפסיק)',
		metaDescription : 'תיאור המסמך',
		metaAuthor : 'מחבר/ת',
		metaCopyright : 'זכויות יוצרים',
		previewHtml : '<p>זהו <strong>טקסט הדגמה</strong>. את/ה משתמש/ת ב<a href="javascript:void(0)">CKEditor</a>.</p>'
	}
};
