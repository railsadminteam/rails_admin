/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Swedish language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['sv'] =
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
	editorTitle : 'Rich text editor, %1, press ALT 0 for help.', // MISSING

	// ARIA descriptions.
	toolbar	: 'Toolbar', // MISSING
	editor	: 'Rich Text Editor', // MISSING

	// Toolbar buttons without dialogs.
	source			: 'Källa',
	newPage			: 'Ny sida',
	save			: 'Spara',
	preview			: 'Förhandsgranska',
	cut				: 'Klipp ut',
	copy			: 'Kopiera',
	paste			: 'Klistra in',
	print			: 'Skriv ut',
	underline		: 'Understruken',
	bold			: 'Fet',
	italic			: 'Kursiv',
	selectAll		: 'Markera allt',
	removeFormat	: 'Radera formatering',
	strike			: 'Genomstruken',
	subscript		: 'Nedsänkta tecken',
	superscript		: 'Upphöjda tecken',
	horizontalrule	: 'Infoga horisontal linje',
	pagebreak		: 'Infoga sidbrytning',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Radera länk',
	undo			: 'Ångra',
	redo			: 'Gör om',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Bläddra på server',
		url				: 'URL',
		protocol		: 'Protokoll',
		upload			: 'Ladda upp',
		uploadSubmit	: 'Skicka till server',
		image			: 'Bild',
		flash			: 'Flash',
		form			: 'Formulär',
		checkbox		: 'Kryssruta',
		radio			: 'Alternativknapp',
		textField		: 'Textfält',
		textarea		: 'Textruta',
		hiddenField		: 'Dolt fält',
		button			: 'Knapp',
		select			: 'Flervalslista',
		imageButton		: 'Bildknapp',
		notSet			: '<ej angivet>',
		id				: 'Id',
		name			: 'Namn',
		langDir			: 'Språkriktning',
		langDirLtr		: 'Vänster till Höger (VTH)',
		langDirRtl		: 'Höger till Vänster (HTV)',
		langCode		: 'Språkkod',
		longDescr		: 'URL-beskrivning',
		cssClass		: 'Stylesheet class',
		advisoryTitle	: 'Titel',
		cssStyle		: 'Style',
		ok				: 'OK',
		cancel			: 'Avbryt',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'General', // MISSING
		advancedTab		: 'Avancerad',
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
		width			: 'Bredd',
		height			: 'Höjd',
		align			: 'Justering',
		alignLeft		: 'Vänster',
		alignRight		: 'Höger',
		alignCenter		: 'Centrerad',
		alignTop		: 'Överkant',
		alignMiddle		: 'Mitten',
		alignBottom		: 'Nederkant',
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
		toolbar		: 'Klistra in utökat tecken',
		title		: 'Välj utökat tecken',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Infoga/Redigera länk',
		other 		: '<annan>',
		menu		: 'Redigera länk',
		title		: 'Länk',
		info		: 'Länkinformation',
		target		: 'Mål',
		upload		: 'Ladda upp',
		advanced	: 'Avancerad',
		type		: 'Länktyp',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Ankare i sidan',
		toEmail		: 'E-post',
		targetFrame		: '<ram>',
		targetPopup		: '<popup-fönster>',
		targetFrameName	: 'Målets ramnamn',
		targetPopupName	: 'Popup-fönstrets namn',
		popupFeatures	: 'Popup-fönstrets egenskaper',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'Statusfält',
		popupLocationBar: 'Adressfält',
		popupToolbar	: 'Verktygsfält',
		popupMenuBar	: 'Menyfält',
		popupFullScreen	: 'Helskärm (endast IE)',
		popupScrollBars	: 'Scrolllista',
		popupDependent	: 'Beroende (endest Netscape)',
		popupLeft		: 'Position från vänster',
		popupTop		: 'Position från sidans topp',
		id				: 'Id', // MISSING
		langDir			: 'Språkriktning',
		langDirLTR		: 'Vänster till Höger (VTH)',
		langDirRTL		: 'Höger till Vänster (HTV)',
		acccessKey		: 'Behörighetsnyckel',
		name			: 'Namn',
		langCode		: 'Språkriktning',
		tabIndex		: 'Tabindex',
		advisoryTitle	: 'Titel',
		advisoryContentType	: 'Innehållstyp',
		cssClasses		: 'Stylesheet class',
		charset			: 'Teckenuppställning',
		styles			: 'Style',
		selectAnchor	: 'Välj ett ankare',
		anchorName		: 'efter ankarnamn',
		anchorId		: 'efter objektid',
		emailAddress	: 'E-postadress',
		emailSubject	: 'Ämne',
		emailBody		: 'Innehåll',
		noAnchors		: '(Inga ankare kunde hittas)',
		noUrl			: 'Var god ange länkens URL',
		noEmail			: 'Var god ange E-postadress'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Infoga/Redigera ankarlänk',
		menu		: 'Egenskaper för ankarlänk',
		title		: 'Egenskaper för ankarlänk',
		name		: 'Ankarnamn',
		errorName	: 'Var god ange ett ankarnamn'
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
		title				: 'Sök och ersätt',
		find				: 'Sök',
		replace				: 'Ersätt',
		findWhat			: 'Sök efter:',
		replaceWith			: 'Ersätt med:',
		notFoundMsg			: 'Angiven text kunde ej hittas.',
		matchCase			: 'Skiftläge',
		matchWord			: 'Inkludera hela ord',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'Ersätt alla',
		replaceSuccessMsg	: '%1 occurrence(s) replaced.' // MISSING
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabell',
		title		: 'Tabellegenskaper',
		menu		: 'Tabellegenskaper',
		deleteTable	: 'Radera tabell',
		rows		: 'Rader',
		columns		: 'Kolumner',
		border		: 'Kantstorlek',
		widthPx		: 'pixlar',
		widthPc		: 'procent',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Cellavstånd',
		cellPad		: 'Cellutfyllnad',
		caption		: 'Rubrik',
		summary		: 'Sammanfattning',
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
			menu			: 'Cell',
			insertBefore	: 'Lägg till Cell Före',
			insertAfter		: 'Lägg till Cell Efter',
			deleteCell		: 'Radera celler',
			merge			: 'Sammanfoga celler',
			mergeRight		: 'Sammanfoga Höger',
			mergeDown		: 'Sammanfoga Ner',
			splitHorizontal	: 'Dela Cell Horisontellt',
			splitVertical	: 'Dela Cell Vertikalt',
			title			: 'Cell Properties', // MISSING
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
			menu			: 'Rad',
			insertBefore	: 'Lägg till Rad Före',
			insertAfter		: 'Lägg till Rad Efter',
			deleteRow		: 'Radera rad'
		},

		column :
		{
			menu			: 'Kolumn',
			insertBefore	: 'Lägg till Kolumn Före',
			insertAfter		: 'Lägg till Kolumn Efter',
			deleteColumn	: 'Radera kolumn'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Egenskaper för knapp',
		text		: 'Text (Värde)',
		type		: 'Typ',
		typeBtn		: 'Knapp',
		typeSbm		: 'Skicka',
		typeRst		: 'Återställ'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Egenskaper för kryssruta',
		radioTitle	: 'Egenskaper för alternativknapp',
		value		: 'Värde',
		selected	: 'Vald'
	},

	// Form Dialog.
	form :
	{
		title		: 'Egenskaper för formulär',
		menu		: 'Egenskaper för formulär',
		action		: 'Funktion',
		method		: 'Metod',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Egenskaper för flervalslista',
		selectInfo	: 'Information',
		opAvail		: 'Befintliga val',
		value		: 'Värde',
		size		: 'Storlek',
		lines		: 'Linjer',
		chkMulti	: 'Tillåt flerval',
		opText		: 'Text',
		opValue		: 'Värde',
		btnAdd		: 'Lägg till',
		btnModify	: 'Redigera',
		btnUp		: 'Upp',
		btnDown		: 'Ner',
		btnSetValue : 'Markera som valt värde',
		btnDelete	: 'Radera'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Egenskaper för textruta',
		cols		: 'Kolumner',
		rows		: 'Rader'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Egenskaper för textfält',
		name		: 'Namn',
		value		: 'Värde',
		charWidth	: 'Teckenbredd',
		maxChars	: 'Max antal tecken',
		type		: 'Typ',
		typeText	: 'Text',
		typePass	: 'Lösenord'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Egenskaper för dolt fält',
		name	: 'Namn',
		value	: 'Värde'
	},

	// Image Dialog.
	image :
	{
		title		: 'Bildegenskaper',
		titleButton	: 'Egenskaper för bildknapp',
		menu		: 'Bildegenskaper',
		infoTab		: 'Bildinformation',
		btnUpload	: 'Skicka till server',
		upload		: 'Ladda upp',
		alt			: 'Alternativ text',
		lockRatio	: 'Lås höjd/bredd förhållanden',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Återställ storlek',
		border		: 'Kant',
		hSpace		: 'Horis. marginal',
		vSpace		: 'Vert. marginal',
		alertUrl	: 'Var god och ange bildens URL',
		linkTab		: 'Länk',
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
		properties		: 'Flashegenskaper',
		propertiesTab	: 'Properties', // MISSING
		title			: 'Flashegenskaper',
		chkPlay			: 'Automatisk uppspelning',
		chkLoop			: 'Upprepa/Loopa',
		chkMenu			: 'Aktivera Flashmeny',
		chkFull			: 'Allow Fullscreen', // MISSING
 		scale			: 'Skala',
		scaleAll		: 'Visa allt',
		scaleNoBorder	: 'Ingen ram',
		scaleFit		: 'Exakt passning',
		access			: 'Script Access', // MISSING
		accessAlways	: 'Always', // MISSING
		accessSameDomain: 'Same domain', // MISSING
		accessNever		: 'Never', // MISSING
		alignAbsBottom	: 'Absolut nederkant',
		alignAbsMiddle	: 'Absolut centrering',
		alignBaseline	: 'Baslinje',
		alignTextTop	: 'Text överkant',
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
		bgcolor			: 'Bakgrundsfärg',
		hSpace			: 'Horis. marginal',
		vSpace			: 'Vert. marginal',
		validateSrc		: 'Var god ange länkens URL',
		validateHSpace	: 'HSpace must be a number.', // MISSING
		validateVSpace	: 'VSpace must be a number.' // MISSING
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Stavningskontroll',
		title			: 'Spell Check', // MISSING
		notAvailable	: 'Sorry, but service is unavailable now.', // MISSING
		errorLoading	: 'Error loading application service host: %s.', // MISSING
		notInDic		: 'Saknas i ordlistan',
		changeTo		: 'Ändra till',
		btnIgnore		: 'Ignorera',
		btnIgnoreAll	: 'Ignorera alla',
		btnReplace		: 'Ersätt',
		btnReplaceAll	: 'Ersätt alla',
		btnUndo			: 'Ångra',
		noSuggestions	: '- Förslag saknas -',
		progress		: 'Stavningskontroll pågår...',
		noMispell		: 'Stavningskontroll slutförd: Inga stavfel påträffades.',
		noChanges		: 'Stavningskontroll slutförd: Inga ord rättades.',
		oneChange		: 'Stavningskontroll slutförd: Ett ord rättades.',
		manyChanges		: 'Stavningskontroll slutförd: %1 ord rättades.',
		ieSpellDownload	: 'Stavningskontrollen är ej installerad. Vill du göra det nu?'
	},

	smiley :
	{
		toolbar	: 'Smiley',
		title	: 'Infoga smiley',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element' // MISSING
	},

	numberedlist	: 'Numrerad lista',
	bulletedlist	: 'Punktlista',
	indent			: 'Öka indrag',
	outdent			: 'Minska indrag',

	justify :
	{
		left	: 'Vänsterjustera',
		center	: 'Centrera',
		right	: 'Högerjustera',
		block	: 'Justera till marginaler'
	},

	blockquote : 'Block Quote', // MISSING

	clipboard :
	{
		title		: 'Klistra in',
		cutError	: 'Säkerhetsinställningar i Er webläsare tillåter inte åtgården Klipp ut. Använd (Ctrl/Cmd+X) istället.',
		copyError	: 'Säkerhetsinställningar i Er webläsare tillåter inte åtgården Kopiera. Använd (Ctrl/Cmd+C) istället',
		pasteMsg	: 'Var god och klistra in Er text i rutan nedan genom att använda (<STRONG>Ctrl/Cmd+V</STRONG>) klicka sen på <STRONG>OK</STRONG>.',
		securityMsg	: 'På grund av din webläsares säkerhetsinställningar kan verktyget inte få åtkomst till urklippsdatan. Var god och använd detta fönster istället.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'The text you want to paste seems to be copied from Word. Do you want to clean it before pasting?', // MISSING
		toolbar			: 'Klistra in från Word',
		title			: 'Klistra in från Word',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Klistra in som vanlig text',
		title	: 'Klistra in som vanlig text'
	},

	templates :
	{
		button			: 'Sidmallar',
		title			: 'Sidmallar',
		options : 'Template Options', // MISSING
		insertOption	: 'Ersätt aktuellt innehåll',
		selectPromptMsg	: 'Var god välj en mall att använda med editorn<br>(allt nuvarande innehåll raderas):',
		emptyListMsg	: '(Ingen mall är vald)'
	},

	showBlocks : 'Show Blocks', // MISSING

	stylesCombo :
	{
		label		: 'Anpassad stil',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block Styles', // MISSING
		panelTitle2	: 'Inline Styles', // MISSING
		panelTitle3	: 'Object Styles' // MISSING
	},

	format :
	{
		label		: 'Teckenformat',
		panelTitle	: 'Teckenformat',

		tag_p		: 'Normal',
		tag_pre		: 'Formaterad',
		tag_address	: 'Adress',
		tag_h1		: 'Rubrik 1',
		tag_h2		: 'Rubrik 2',
		tag_h3		: 'Rubrik 3',
		tag_h4		: 'Rubrik 4',
		tag_h5		: 'Rubrik 5',
		tag_h6		: 'Rubrik 6',
		tag_div		: 'Normal (DIV)'
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
		label		: 'Typsnitt',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'Typsnitt'
	},

	fontSize :
	{
		label		: 'Storlek',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'Storlek'
	},

	colorButton :
	{
		textColorTitle	: 'Textfärg',
		bgColorTitle	: 'Bakgrundsfärg',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automatisk',
		more			: 'Fler färger...'
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
