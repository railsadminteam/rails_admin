/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Esperanto language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['eo'] =
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
	source			: 'Fonto',
	newPage			: 'Nova Paĝo',
	save			: 'Sekurigi',
	preview			: 'Vidigi Aspekton',
	cut				: 'Eltondi',
	copy			: 'Kopii',
	paste			: 'Interglui',
	print			: 'Presi',
	underline		: 'Substreko',
	bold			: 'Grasa',
	italic			: 'Kursiva',
	selectAll		: 'Elekti ĉion',
	removeFormat	: 'Forigi Formaton',
	strike			: 'Trastreko',
	subscript		: 'Subskribo',
	superscript		: 'Superskribo',
	horizontalrule	: 'Enmeti Horizonta Linio',
	pagebreak		: 'Insert Page Break for Printing', // MISSING
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Forigi Ligilon',
	undo			: 'Malfari',
	redo			: 'Refari',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Foliumi en la Servilo',
		url				: 'URL',
		protocol		: 'Protokolo',
		upload			: 'Alŝuti',
		uploadSubmit	: 'Sendu al Servilo',
		image			: 'Bildo',
		flash			: 'Flash', // MISSING
		form			: 'Formularo',
		checkbox		: 'Markobutono',
		radio			: 'Radiobutono',
		textField		: 'Teksta kampo',
		textarea		: 'Teksta Areo',
		hiddenField		: 'Kaŝita Kampo',
		button			: 'Butono',
		select			: 'Elekta Kampo',
		imageButton		: 'Bildbutono',
		notSet			: '<Defaŭlta>',
		id				: 'Id',
		name			: 'Nomo',
		langDir			: 'Skribdirekto',
		langDirLtr		: 'De maldekstro dekstren (LTR)',
		langDirRtl		: 'De dekstro maldekstren (RTL)',
		langCode		: 'Lingva Kodo',
		longDescr		: 'URL de Longa Priskribo',
		cssClass		: 'Klasoj de Stilfolioj',
		advisoryTitle	: 'Indika Titolo',
		cssStyle		: 'Stilo',
		ok				: 'Akcepti',
		cancel			: 'Rezigni',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'General', // MISSING
		advancedTab		: 'Speciala',
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
		width			: 'Larĝo',
		height			: 'Alto',
		align			: 'Ĝisrandigo',
		alignLeft		: 'Maldekstre',
		alignRight		: 'Dekstre',
		alignCenter		: 'Centre',
		alignTop		: 'Supre',
		alignMiddle		: 'Centre',
		alignBottom		: 'Malsupre',
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
		toolbar		: 'Enmeti Specialan Signon',
		title		: 'Enmeti Specialan Signon',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Enmeti/Ŝanĝi Ligilon',
		other 		: '<other>', // MISSING
		menu		: 'Modifier Ligilon',
		title		: 'Ligilo',
		info		: 'Informoj pri la Ligilo',
		target		: 'Celo',
		upload		: 'Alŝuti',
		advanced	: 'Speciala',
		type		: 'Tipo de Ligilo',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Ankri en tiu ĉi paĝo',
		toEmail		: 'Retpoŝto',
		targetFrame		: '<kadro>',
		targetPopup		: '<ŝprucfenestro>',
		targetFrameName	: 'Nomo de Kadro',
		targetPopupName	: 'Nomo de Ŝprucfenestro',
		popupFeatures	: 'Atributoj de la Ŝprucfenestro',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'Statobreto',
		popupLocationBar: 'Adresobreto',
		popupToolbar	: 'Ilobreto',
		popupMenuBar	: 'Menubreto',
		popupFullScreen	: 'Tutekrane (IE)',
		popupScrollBars	: 'Rulumlisteloj',
		popupDependent	: 'Dependa (Netscape)',
		popupLeft		: 'Pozicio de Maldekstro',
		popupTop		: 'Pozicio de Supro',
		id				: 'Id', // MISSING
		langDir			: 'Skribdirekto',
		langDirLTR		: 'De maldekstro dekstren (LTR)',
		langDirRTL		: 'De dekstro maldekstren (RTL)',
		acccessKey		: 'Fulmoklavo',
		name			: 'Nomo',
		langCode		: 'Skribdirekto',
		tabIndex		: 'Taba Ordo',
		advisoryTitle	: 'Indika Titolo',
		advisoryContentType	: 'Indika Enhavotipo',
		cssClasses		: 'Klasoj de Stilfolioj',
		charset			: 'Signaro de la Ligita Rimedo',
		styles			: 'Stilo',
		selectAnchor	: 'Elekti Ankron',
		anchorName		: 'Per Ankronomo',
		anchorId		: 'Per Elementidentigilo',
		emailAddress	: 'Retadreso',
		emailSubject	: 'Temlinio',
		emailBody		: 'Mesaĝa korpo',
		noAnchors		: '<Ne disponeblas ankroj en la dokumento>',
		noUrl			: 'Bonvolu entajpi la URL-on',
		noEmail			: 'Bonvolu entajpi la retadreson'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Enmeti/Ŝanĝi Ankron',
		menu		: 'Ankraj Atributoj',
		title		: 'Ankraj Atributoj',
		name		: 'Ankra Nomo',
		errorName	: 'Bv tajpi la ankran nomon'
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
		find				: 'Serĉi',
		replace				: 'Anstataŭigi',
		findWhat			: 'Serĉi:',
		replaceWith			: 'Anstataŭigi per:',
		notFoundMsg			: 'La celteksto ne estas trovita.',
		matchCase			: 'Kongruigi Usklecon',
		matchWord			: 'Tuta Vorto',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'Anstataŭigi Ĉiun',
		replaceSuccessMsg	: '%1 occurrence(s) replaced.' // MISSING
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabelo',
		title		: 'Atributoj de Tabelo',
		menu		: 'Atributoj de Tabelo',
		deleteTable	: 'Delete Table', // MISSING
		rows		: 'Linioj',
		columns		: 'Kolumnoj',
		border		: 'Bordero',
		widthPx		: 'Bitbilderoj',
		widthPc		: 'elcentoj',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Interspacigo de Ĉeloj',
		cellPad		: 'Ĉirkaŭenhava Plenigado',
		caption		: 'Titolo',
		summary		: 'Summary', // MISSING
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
			menu			: 'Cell', // MISSING
			insertBefore	: 'Insert Cell Before', // MISSING
			insertAfter		: 'Insert Cell After', // MISSING
			deleteCell		: 'Forigi Ĉelojn',
			merge			: 'Kunfandi Ĉelojn',
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
			menu			: 'Row', // MISSING
			insertBefore	: 'Insert Row Before', // MISSING
			insertAfter		: 'Insert Row After', // MISSING
			deleteRow		: 'Forigi Liniojn'
		},

		column :
		{
			menu			: 'Column', // MISSING
			insertBefore	: 'Insert Column Before', // MISSING
			insertAfter		: 'Insert Column After', // MISSING
			deleteColumn	: 'Forigi Kolumnojn'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Butonaj Atributoj',
		text		: 'Teksto (Valoro)',
		type		: 'Tipo',
		typeBtn		: 'Button', // MISSING
		typeSbm		: 'Submit', // MISSING
		typeRst		: 'Reset' // MISSING
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Markobutonaj Atributoj',
		radioTitle	: 'Radiobutonaj Atributoj',
		value		: 'Valoro',
		selected	: 'Elektita'
	},

	// Form Dialog.
	form :
	{
		title		: 'Formularaj Atributoj',
		menu		: 'Formularaj Atributoj',
		action		: 'Ago',
		method		: 'Metodo',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Atributoj de Elekta Kampo',
		selectInfo	: 'Select Info', // MISSING
		opAvail		: 'Elektoj Disponeblaj',
		value		: 'Valoro',
		size		: 'Grando',
		lines		: 'Linioj',
		chkMulti	: 'Permesi Plurajn Elektojn',
		opText		: 'Teksto',
		opValue		: 'Valoro',
		btnAdd		: 'Aldoni',
		btnModify	: 'Modifi',
		btnUp		: 'Supren',
		btnDown		: 'Malsupren',
		btnSetValue : 'Agordi kiel Elektitan Valoron',
		btnDelete	: 'Forigi'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Atributoj de Teksta Areo',
		cols		: 'Kolumnoj',
		rows		: 'Vicoj'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Atributoj de Teksta Kampo',
		name		: 'Nomo',
		value		: 'Valoro',
		charWidth	: 'Signolarĝo',
		maxChars	: 'Maksimuma Nombro da Signoj',
		type		: 'Tipo',
		typeText	: 'Teksto',
		typePass	: 'Pasvorto'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Atributoj de Kaŝita Kampo',
		name	: 'Nomo',
		value	: 'Valoro'
	},

	// Image Dialog.
	image :
	{
		title		: 'Atributoj de Bildo',
		titleButton	: 'Bildbutonaj Atributoj',
		menu		: 'Atributoj de Bildo',
		infoTab		: 'Informoj pri Bildo',
		btnUpload	: 'Sendu al Servilo',
		upload		: 'Alŝuti',
		alt			: 'Anstataŭiga Teksto',
		lockRatio	: 'Konservi Proporcion',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Origina Grando',
		border		: 'Bordero',
		hSpace		: 'HSpaco',
		vSpace		: 'VSpaco',
		alertUrl	: 'Bonvolu tajpi la URL de la bildo',
		linkTab		: 'Link', // MISSING
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
		properties		: 'Flash Properties', // MISSING
		propertiesTab	: 'Properties', // MISSING
		title			: 'Flash Properties', // MISSING
		chkPlay			: 'Auto Play', // MISSING
		chkLoop			: 'Loop', // MISSING
		chkMenu			: 'Enable Flash Menu', // MISSING
		chkFull			: 'Allow Fullscreen', // MISSING
 		scale			: 'Scale', // MISSING
		scaleAll		: 'Show all', // MISSING
		scaleNoBorder	: 'No Border', // MISSING
		scaleFit		: 'Exact Fit', // MISSING
		access			: 'Script Access', // MISSING
		accessAlways	: 'Always', // MISSING
		accessSameDomain: 'Same domain', // MISSING
		accessNever		: 'Never', // MISSING
		alignAbsBottom	: 'Abs Malsupre',
		alignAbsMiddle	: 'Abs Centre',
		alignBaseline	: 'Je Malsupro de Teksto',
		alignTextTop	: 'Je Supro de Teksto',
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
		bgcolor			: 'Fona Koloro',
		hSpace			: 'HSpaco',
		vSpace			: 'VSpaco',
		validateSrc		: 'Bonvolu entajpi la URL-on',
		validateHSpace	: 'HSpace must be a number.', // MISSING
		validateVSpace	: 'VSpace must be a number.' // MISSING
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Literumada Kontrolilo',
		title			: 'Spell Check', // MISSING
		notAvailable	: 'Sorry, but service is unavailable now.', // MISSING
		errorLoading	: 'Error loading application service host: %s.', // MISSING
		notInDic		: 'Ne trovita en la vortaro',
		changeTo		: 'Ŝanĝi al',
		btnIgnore		: 'Malatenti',
		btnIgnoreAll	: 'Malatenti Ĉiun',
		btnReplace		: 'Anstataŭigi',
		btnReplaceAll	: 'Anstataŭigi Ĉiun',
		btnUndo			: 'Malfari',
		noSuggestions	: '- Neniu propono -',
		progress		: 'Literumkontrolado daŭras...',
		noMispell		: 'Literumkontrolado finita: neniu fuŝo trovita',
		noChanges		: 'Literumkontrolado finita: neniu vorto ŝanĝita',
		oneChange		: 'Literumkontrolado finita: unu vorto ŝanĝita',
		manyChanges		: 'Literumkontrolado finita: %1 vortoj ŝanĝitaj',
		ieSpellDownload	: 'Literumada Kontrolilo ne instalita. Ĉu vi volas elŝuti ĝin nun?'
	},

	smiley :
	{
		toolbar	: 'Mienvinjeto',
		title	: 'Enmeti Mienvinjeton',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element' // MISSING
	},

	numberedlist	: 'Numera Listo',
	bulletedlist	: 'Bula Listo',
	indent			: 'Pligrandigi Krommarĝenon',
	outdent			: 'Malpligrandigi Krommarĝenon',

	justify :
	{
		left	: 'Maldekstrigi',
		center	: 'Centrigi',
		right	: 'Dekstrigi',
		block	: 'Ĝisrandigi Ambaŭflanke'
	},

	blockquote : 'Block Quote', // MISSING

	clipboard :
	{
		title		: 'Interglui',
		cutError	: 'La sekurecagordo de via TTT-legilo ne permesas, ke la redaktilo faras eltondajn operaciojn. Bonvolu uzi la klavaron por tio (Ctrl/Cmd-X).',
		copyError	: 'La sekurecagordo de via TTT-legilo ne permesas, ke la redaktilo faras kopiajn operaciojn. Bonvolu uzi la klavaron por tio (Ctrl/Cmd-C).',
		pasteMsg	: 'Please paste inside the following box using the keyboard (<strong>Ctrl/Cmd+V</strong>) and hit OK', // MISSING
		securityMsg	: 'Because of your browser security settings, the editor is not able to access your clipboard data directly. You are required to paste it again in this window.', // MISSING
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'The text you want to paste seems to be copied from Word. Do you want to clean it before pasting?', // MISSING
		toolbar			: 'Interglui el Word',
		title			: 'Interglui el Word',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Interglui kiel Tekston',
		title	: 'Interglui kiel Tekston'
	},

	templates :
	{
		button			: 'Templates', // MISSING
		title			: 'Content Templates', // MISSING
		options : 'Template Options', // MISSING
		insertOption	: 'Replace actual contents', // MISSING
		selectPromptMsg	: 'Please select the template to open in the editor', // MISSING
		emptyListMsg	: '(No templates defined)' // MISSING
	},

	showBlocks : 'Show Blocks', // MISSING

	stylesCombo :
	{
		label		: 'Stilo',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block Styles', // MISSING
		panelTitle2	: 'Inline Styles', // MISSING
		panelTitle3	: 'Object Styles' // MISSING
	},

	format :
	{
		label		: 'Formato',
		panelTitle	: 'Formato',

		tag_p		: 'Normala',
		tag_pre		: 'Formatita',
		tag_address	: 'Adreso',
		tag_h1		: 'Titolo 1',
		tag_h2		: 'Titolo 2',
		tag_h3		: 'Titolo 3',
		tag_h4		: 'Titolo 4',
		tag_h5		: 'Titolo 5',
		tag_h6		: 'Titolo 6',
		tag_div		: 'Paragrafo (DIV)'
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
		label		: 'Tiparo',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'Tiparo'
	},

	fontSize :
	{
		label		: 'Grando',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'Grando'
	},

	colorButton :
	{
		textColorTitle	: 'Teksta Koloro',
		bgColorTitle	: 'Fona Koloro',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Aŭtomata',
		more			: 'Pli da Koloroj...'
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
