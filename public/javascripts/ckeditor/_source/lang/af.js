/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Afrikaans language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['af'] =
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
	source			: 'Source',
	newPage			: 'Nuwe Bladsy',
	save			: 'Bewaar',
	preview			: 'Voorskou',
	cut				: 'Uitsny ',
	copy			: 'Kopieer',
	paste			: 'Byvoeg',
	print			: 'Druk',
	underline		: 'Onderstreep',
	bold			: 'Vet',
	italic			: 'Skuins',
	selectAll		: 'Selekteer alles',
	removeFormat	: 'Formaat verweider',
	strike			: 'Gestreik',
	subscript		: 'Subscript',
	superscript		: 'Superscript',
	horizontalrule	: 'Horisontale lyn byvoeg',
	pagebreak		: 'Bladsy breek byvoeg',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Skakel verweider',
	undo			: 'Ont-skep',
	redo			: 'Her-skep',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Server deurblaai',
		url				: 'URL',
		protocol		: 'Protokol',
		upload			: 'Oplaai',
		uploadSubmit	: 'Stuur dit na die Server',
		image			: 'Beeld',
		flash			: 'Flash',
		form			: 'Form',
		checkbox		: 'HakBox',
		radio			: 'PuntBox',
		textField		: 'Byvoegbare karakter strook',
		textarea		: 'Byvoegbare karakter area',
		hiddenField		: 'Blinde strook',
		button			: 'Knop',
		select			: 'Opklapbare keuse strook',
		imageButton		: 'Beeld knop',
		notSet			: '<geen instelling>',
		id				: 'Id',
		name			: 'Naam',
		langDir			: 'Taal rigting',
		langDirLtr		: 'Links na regs (LTR)',
		langDirRtl		: 'Regs na links (RTL)',
		langCode		: 'Taal kode',
		longDescr		: 'Lang beskreiwing URL',
		cssClass		: 'Skakel Tiepe',
		advisoryTitle	: 'Voorbeveelings Titel',
		cssStyle		: 'Styl',
		ok				: 'OK',
		cancel			: 'Kanseleer',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'General', // MISSING
		advancedTab		: 'Ingewikkeld',
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
		width			: 'Weidte',
		height			: 'Hoogde',
		align			: 'Paradeer',
		alignLeft		: 'Links',
		alignRight		: 'Regs',
		alignCenter		: 'Middel',
		alignTop		: 'Bo',
		alignMiddle		: 'Middel',
		alignBottom		: 'Onder',
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
		toolbar		: 'Spesiaale Karakter byvoeg',
		title		: 'Kies spesiale karakter',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Skakel byvoeg/verander',
		other 		: '<ander>',
		menu		: 'Verander skakel',
		title		: 'Skakel',
		info		: 'Skakel informasie',
		target		: 'Mikpunt',
		upload		: 'Oplaai',
		advanced	: 'Ingewikkeld',
		type		: 'Skakel soort',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Skakel na plekhouers in text',
		toEmail		: 'E-Mail',
		targetFrame		: '<raam>',
		targetPopup		: '<popup venster>',
		targetFrameName	: 'Mikpunt Venster Naam',
		targetPopupName	: 'Popup Venster Naam',
		popupFeatures	: 'Popup Venster Geaartheid',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'Status Balk',
		popupLocationBar: 'Adres Balk',
		popupToolbar	: 'Gereedskap Balk',
		popupMenuBar	: 'Menu Balk',
		popupFullScreen	: 'Voll Skerm (IE)',
		popupScrollBars	: 'Gleibalkstuk',
		popupDependent	: 'Afhanklik (Netscape)',
		popupLeft		: 'Links Posisie',
		popupTop		: 'Bo Posisie',
		id				: 'Id', // MISSING
		langDir			: 'Taal rigting',
		langDirLTR		: 'Links na regs (LTR)',
		langDirRTL		: 'Regs na links (RTL)',
		acccessKey		: 'Toegang sleutel',
		name			: 'Naam',
		langCode		: 'Taal rigting',
		tabIndex		: 'Tab Index',
		advisoryTitle	: 'Voorbeveelings Titel',
		advisoryContentType	: 'Voorbeveelings inhoud soort',
		cssClasses		: 'Skakel Tiepe',
		charset			: 'Geskakelde voorbeeld karakterstel',
		styles			: 'Styl',
		selectAnchor	: 'Kies \'n plekhouer',
		anchorName		: 'Volgens plekhouer naam',
		anchorId		: 'Volgens element Id',
		emailAddress	: 'E-Mail Adres',
		emailSubject	: 'Boodskap Opskrif',
		emailBody		: 'Boodskap Inhoud',
		noAnchors		: '(Geen plekhouers beskikbaar in dokument}',
		noUrl			: 'Voeg asseblief die URL in',
		noEmail			: 'Voeg asseblief die e-mail adres in'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Plekhouer byvoeg/verander',
		menu		: 'Plekhouer eienskappe',
		title		: 'Plekhouer eienskappe',
		name		: 'Plekhouer Naam',
		errorName	: 'Voltooi die plekhouer naam asseblief'
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
		title				: 'Find and Replace', // MISSING
		find				: 'Vind',
		replace				: 'Vervang',
		findWhat			: 'Soek wat:',
		replaceWith			: 'Vervang met:',
		notFoundMsg			: 'Die gespesifiseerde karakters word nie gevind nie.',
		matchCase			: 'Vergelyk karakter skryfweise',
		matchWord			: 'Vergelyk komplete woord',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'Vervang alles',
		replaceSuccessMsg	: '%1 occurrence(s) replaced.' // MISSING
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabel',
		title		: 'Tabel eienskappe',
		menu		: 'Tabel eienskappe',
		deleteTable	: 'Tabel verweider',
		rows		: 'Reie',
		columns		: 'Kolome',
		border		: 'Kant groote',
		widthPx		: 'pixels',
		widthPc		: 'percent',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Cell spasieering',
		cellPad		: 'Cell buffer',
		caption		: 'Beskreiwing',
		summary		: 'Opsomming',
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
			insertBefore	: 'Insert Cell Before', // MISSING
			insertAfter		: 'Insert Cell After', // MISSING
			deleteCell		: 'Cell verweider',
			merge			: 'Cell verenig',
			mergeRight		: 'Merge Right', // MISSING
			mergeDown		: 'Merge Down', // MISSING
			splitHorizontal	: 'Split Cell Horizontally', // MISSING
			splitVertical	: 'Split Cell Vertically', // MISSING
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
			menu			: 'Ry',
			insertBefore	: 'Insert Row Before', // MISSING
			insertAfter		: 'Insert Row After', // MISSING
			deleteRow		: 'Ry verweider'
		},

		column :
		{
			menu			: 'Kolom',
			insertBefore	: 'Insert Column Before', // MISSING
			insertAfter		: 'Insert Column After', // MISSING
			deleteColumn	: 'Kolom verweider'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Knop eienskappe',
		text		: 'Karakters (Waarde)',
		type		: 'Soort',
		typeBtn		: 'Knop',
		typeSbm		: 'Indien',
		typeRst		: 'Reset'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'HakBox eienskappe',
		radioTitle	: 'PuntBox eienskappe',
		value		: 'Waarde',
		selected	: 'Uitgekies'
	},

	// Form Dialog.
	form :
	{
		title		: 'Form eienskappe',
		menu		: 'Form eienskappe',
		action		: 'Aksie',
		method		: 'Metode',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Opklapbare keuse strook eienskappe',
		selectInfo	: 'Info',
		opAvail		: 'Beskikbare Opsies',
		value		: 'Waarde',
		size		: 'Grote',
		lines		: 'lyne',
		chkMulti	: 'Laat meerere keuses toe',
		opText		: 'Karakters',
		opValue		: 'Waarde',
		btnAdd		: 'Byvoeg',
		btnModify	: 'Verander',
		btnUp		: 'Op',
		btnDown		: 'Af',
		btnSetValue : 'Stel as uitgekiesde waarde',
		btnDelete	: 'Verweider'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Karakter area eienskappe',
		cols		: 'Kolom',
		rows		: 'Reie'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Karakter strook eienskappe',
		name		: 'Naam',
		value		: 'Waarde',
		charWidth	: 'Karakter weite',
		maxChars	: 'Maximale karakters',
		type		: 'Soort',
		typeText	: 'Karakters',
		typePass	: 'Wagwoord'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Blinde strook eienskappe',
		name	: 'Naam',
		value	: 'Waarde'
	},

	// Image Dialog.
	image :
	{
		title		: 'Beeld eienskappe',
		titleButton	: 'Beeld knop eienskappe',
		menu		: 'Beeld eienskappe',
		infoTab		: 'Beeld informasie',
		btnUpload	: 'Stuur dit na die Server',
		upload		: 'Uplaai',
		alt			: 'Alternatiewe beskrywing',
		lockRatio	: 'Behou preporsie',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Herstel groote',
		border		: 'Kant',
		hSpace		: 'HSpasie',
		vSpace		: 'VSpasie',
		alertUrl	: 'Voeg asseblief Beeld URL in.',
		linkTab		: 'Skakel',
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
		properties		: 'Flash eienskappe',
		propertiesTab	: 'Properties', // MISSING
		title			: 'Flash eienskappe',
		chkPlay			: 'Automaties Speel',
		chkLoop			: 'Herhaling',
		chkMenu			: 'Laat Flash Menu toe',
		chkFull			: 'Allow Fullscreen', // MISSING
 		scale			: 'Scale',
		scaleAll		: 'Wys alles',
		scaleNoBorder	: 'Geen kante',
		scaleFit		: 'Presiese pas',
		access			: 'Script Access', // MISSING
		accessAlways	: 'Always', // MISSING
		accessSameDomain: 'Same domain', // MISSING
		accessNever		: 'Never', // MISSING
		alignAbsBottom	: 'Abs Onder',
		alignAbsMiddle	: 'Abs Middel',
		alignBaseline	: 'Baseline',
		alignTextTop	: 'Text Bo',
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
		bgcolor			: 'Agtergrond kleur',
		hSpace			: 'HSpasie',
		vSpace			: 'VSpasie',
		validateSrc		: 'Voeg asseblief die URL in',
		validateHSpace	: 'HSpace must be a number.', // MISSING
		validateVSpace	: 'VSpace must be a number.' // MISSING
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Spelling nagaan',
		title			: 'Spell Check', // MISSING
		notAvailable	: 'Sorry, but service is unavailable now.', // MISSING
		errorLoading	: 'Error loading application service host: %s.', // MISSING
		notInDic		: 'Nie in woordeboek nie',
		changeTo		: 'Verander na',
		btnIgnore		: 'Ignoreer',
		btnIgnoreAll	: 'Ignoreer na-volgende',
		btnReplace		: 'Vervang',
		btnReplaceAll	: 'vervang na-volgende',
		btnUndo			: 'Ont-skep',
		noSuggestions	: '- Geen voorstel -',
		progress		: 'Spelling word beproef...',
		noMispell		: 'Spellproef kompleet: Geen foute',
		noChanges		: 'Spellproef kompleet: Geen woord veranderings',
		oneChange		: 'Spellproef kompleet: Een woord verander',
		manyChanges		: 'Spellproef kompleet: %1 woorde verander',
		ieSpellDownload	: 'Geen Spellproefer geinstaleer nie. Wil U dit aflaai?'
	},

	smiley :
	{
		toolbar	: 'Smiley',
		title	: 'Voeg Smiley by',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element' // MISSING
	},

	numberedlist	: 'Genommerde lys',
	bulletedlist	: 'Gepunkte lys',
	indent			: 'Paradeering verleng',
	outdent			: 'Paradeering verkort',

	justify :
	{
		left	: 'Links rig',
		center	: 'Rig Middel',
		right	: 'Regs rig',
		block	: 'Blok paradeer'
	},

	blockquote : 'Block Quote', // MISSING

	clipboard :
	{
		title		: 'Byvoeg',
		cutError	: 'U browser se sekuriteit instelling behinder die uitsny aksie. Gebruik asseblief die sleutel kombenasie(Ctrl/Cmd+X).',
		copyError	: 'U browser se sekuriteit instelling behinder die kopieerings aksie. Gebruik asseblief die sleutel kombenasie(Ctrl/Cmd+C).',
		pasteMsg	: 'Voeg asseblief die inhoud in die gegewe box by met sleutel kombenasie(<STRONG>Ctrl/Cmd+V</STRONG>) en druk <STRONG>OK</STRONG>.',
		securityMsg	: 'Because of your browser security settings, the editor is not able to access your clipboard data directly. You are required to paste it again in this window.', // MISSING
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'The text you want to paste seems to be copied from Word. Do you want to clean it before pasting?', // MISSING
		toolbar			: 'Van Word af byvoeg',
		title			: 'Van Word af byvoeg',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Voeg slegs karakters by',
		title	: 'Voeg slegs karakters by'
	},

	templates :
	{
		button			: 'Templates',
		title			: 'Inhoud Templates',
		options : 'Template Options', // MISSING
		insertOption	: 'Vervang bestaande inhoud',
		selectPromptMsg	: 'Kies die template om te gebruik in die editor<br>(Inhoud word vervang!):',
		emptyListMsg	: '(Geen templates gedefinieerd)'
	},

	showBlocks : 'Show Blocks', // MISSING

	stylesCombo :
	{
		label		: 'Styl',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block Styles', // MISSING
		panelTitle2	: 'Inline Styles', // MISSING
		panelTitle3	: 'Object Styles' // MISSING
	},

	format :
	{
		label		: 'Karakter formaat',
		panelTitle	: 'Karakter formaat',

		tag_p		: 'Normaal',
		tag_pre		: 'Geformateerd',
		tag_address	: 'Adres',
		tag_h1		: 'Opskrif 1',
		tag_h2		: 'Opskrif 2',
		tag_h3		: 'Opskrif 3',
		tag_h4		: 'Opskrif 4',
		tag_h5		: 'Opskrif 5',
		tag_h6		: 'Opskrif 6',
		tag_div		: 'Normaal (DIV)'
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
		label		: 'Karakters',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'Karakters'
	},

	fontSize :
	{
		label		: 'Karakter grote',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'Karakter grote'
	},

	colorButton :
	{
		textColorTitle	: 'Karakter kleur',
		bgColorTitle	: 'Agtergrond kleur',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automaties',
		more			: 'Meer Kleure...'
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
