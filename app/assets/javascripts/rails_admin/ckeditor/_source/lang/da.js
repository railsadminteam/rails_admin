/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Danish language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['da'] =
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
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Rich Text Editor', // MISSING

	// Toolbar buttons without dialogs.
	source			: 'Kilde',
	newPage			: 'Ny side',
	save			: 'Gem',
	preview			: 'Vis eksempel',
	cut				: 'Klip',
	copy			: 'Kopiér',
	paste			: 'Indsæt',
	print			: 'Udskriv',
	underline		: 'Understreget',
	bold			: 'Fed',
	italic			: 'Kursiv',
	selectAll		: 'Vælg alt',
	removeFormat	: 'Fjern formatering',
	strike			: 'Gennemstreget',
	subscript		: 'Sænket skrift',
	superscript		: 'Hævet skrift',
	horizontalrule	: 'Indsæt vandret streg',
	pagebreak		: 'Indsæt sideskift',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Fjern hyperlink',
	undo			: 'Fortryd',
	redo			: 'Annullér fortryd',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Gennemse...',
		url				: 'URL',
		protocol		: 'Protokol',
		upload			: 'Upload',
		uploadSubmit	: 'Upload',
		image			: 'Indsæt billede',
		flash			: 'Indsæt Flash',
		form			: 'Indsæt formular',
		checkbox		: 'Indsæt afkrydsningsfelt',
		radio			: 'Indsæt alternativknap',
		textField		: 'Indsæt tekstfelt',
		textarea		: 'Indsæt tekstboks',
		hiddenField		: 'Indsæt skjult felt',
		button			: 'Indsæt knap',
		select			: 'Indsæt liste',
		imageButton		: 'Indsæt billedknap',
		notSet			: '<intet valgt>',
		id				: 'Id',
		name			: 'Navn',
		langDir			: 'Tekstretning',
		langDirLtr		: 'Fra venstre mod højre (LTR)',
		langDirRtl		: 'Fra højre mod venstre (RTL)',
		langCode		: 'Sprogkode',
		longDescr		: 'Udvidet beskrivelse',
		cssClass		: 'Typografiark (CSS)',
		advisoryTitle	: 'Titel',
		cssStyle		: 'Typografi (CSS)',
		ok				: 'OK',
		cancel			: 'Annullér',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'Generelt',
		advancedTab		: 'Avanceret',
		validateNumberFailed : 'Værdien er ikke et tal.',
		confirmNewPage	: 'Alt indhold, der ikke er blevet gemt, vil gå tabt. Er du sikker på, at du vil indlæse en ny side?',
		confirmCancel	: 'Nogle af indstillingerne er blevet ændret. Er du sikker på, at du vil lukke vinduet?',
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
		width			: 'Bredde',
		height			: 'Højde',
		align			: 'Justering',
		alignLeft		: 'Venstre',
		alignRight		: 'Højre',
		alignCenter		: 'Centreret',
		alignTop		: 'Øverst',
		alignMiddle		: 'Centreret',
		alignBottom		: 'Nederst',
		invalidHeight	: 'Højde skal være et tal.',
		invalidWidth	: 'Bredde skal være et tal.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, ikke tilgængelig</span>'
	},

	contextmenu :
	{
		options : 'Context Menu Options' // MISSING
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Indsæt symbol',
		title		: 'Vælg symbol',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Indsæt/redigér hyperlink',
		other 		: '<anden>',
		menu		: 'Redigér hyperlink',
		title		: 'Egenskaber for hyperlink',
		info		: 'Generelt',
		target		: 'Mål',
		upload		: 'Upload',
		advanced	: 'Avanceret',
		type		: 'Type',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Bogmærke på denne side',
		toEmail		: 'E-mail',
		targetFrame		: '<ramme>',
		targetPopup		: '<popup vindue>',
		targetFrameName	: 'Destinationsvinduets navn',
		targetPopupName	: 'Popup vinduets navn',
		popupFeatures	: 'Egenskaber for popup',
		popupResizable	: 'Justérbar',
		popupStatusBar	: 'Statuslinje',
		popupLocationBar: 'Adresselinje',
		popupToolbar	: 'Værktøjslinje',
		popupMenuBar	: 'Menulinje',
		popupFullScreen	: 'Fuld skærm (IE)',
		popupScrollBars	: 'Scrollbar',
		popupDependent	: 'Koblet/dependent (Netscape)',
		popupLeft		: 'Position fra venstre',
		popupTop		: 'Position fra toppen',
		id				: 'Id',
		langDir			: 'Tekstretning',
		langDirLTR		: 'Fra venstre mod højre (LTR)',
		langDirRTL		: 'Fra højre mod venstre (RTL)',
		acccessKey		: 'Genvejstast',
		name			: 'Navn',
		langCode			: 'Tekstretning',
		tabIndex			: 'Tabulator indeks',
		advisoryTitle		: 'Titel',
		advisoryContentType	: 'Indholdstype',
		cssClasses		: 'Typografiark',
		charset			: 'Tegnsæt',
		styles			: 'Typografi',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Vælg et anker',
		anchorName		: 'Efter anker navn',
		anchorId			: 'Efter element Id',
		emailAddress		: 'E-mail adresse',
		emailSubject		: 'Emne',
		emailBody		: 'Besked',
		noAnchors		: '(Ingen bogmærker i dokumentet)',
		noUrl			: 'Indtast hyperlink URL!',
		noEmail			: 'Indtast e-mail adresse!'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Indsæt/redigér bogmærke',
		menu		: 'Egenskaber for bogmærke',
		title		: 'Egenskaber for bogmærke',
		name		: 'Bogmærke navn',
		errorName	: 'Indtast bogmærke navn'
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
		title				: 'Søg og erstat',
		find				: 'Søg',
		replace				: 'Erstat',
		findWhat			: 'Søg efter:',
		replaceWith			: 'Erstat med:',
		notFoundMsg			: 'Søgeteksten blev ikke fundet',
		matchCase			: 'Forskel på store og små bogstaver',
		matchWord			: 'Kun hele ord',
		matchCyclic			: 'Match cyklisk',
		replaceAll			: 'Erstat alle',
		replaceSuccessMsg	: '%1 forekomst(er) erstattet.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabel',
		title		: 'Egenskaber for tabel',
		menu		: 'Egenskaber for tabel',
		deleteTable	: 'Slet tabel',
		rows		: 'Rækker',
		columns		: 'Kolonner',
		border		: 'Rammebredde',
		widthPx		: 'pixels',
		widthPc		: 'procent',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Celleafstand',
		cellPad		: 'Cellemargen',
		caption		: 'Titel',
		summary		: 'Resumé',
		headers		: 'Header',
		headersNone		: 'Ingen',
		headersColumn	: 'Første kolonne',
		headersRow		: 'Første række',
		headersBoth		: 'Begge',
		invalidRows		: 'Antallet af rækker skal være større end 0.',
		invalidCols		: 'Antallet af kolonner skal være større end 0.',
		invalidBorder	: 'Rammetykkelse skal være et tal.',
		invalidWidth	: 'Tabelbredde skal være et tal.',
		invalidHeight	: 'Tabelhøjde skal være et tal.',
		invalidCellSpacing	: 'Celleafstand skal være et tal.',
		invalidCellPadding	: 'Cellemargen skal være et tal.',

		cell :
		{
			menu			: 'Celle',
			insertBefore	: 'Indsæt celle før',
			insertAfter		: 'Indsæt celle efter',
			deleteCell		: 'Slet celle',
			merge			: 'Flet celler',
			mergeRight		: 'Flet til højre',
			mergeDown		: 'Flet nedad',
			splitHorizontal	: 'Del celle vandret',
			splitVertical	: 'Del celle lodret',
			title			: 'Celleegenskaber',
			cellType		: 'Celletype',
			rowSpan			: 'Række span (rows span)',
			colSpan			: 'Kolonne span (columns span)',
			wordWrap		: 'Tekstombrydning',
			hAlign			: 'Vandret justering',
			vAlign			: 'Lodret justering',
			alignBaseline	: 'Grundlinje',
			bgColor			: 'Baggrundsfarve',
			borderColor		: 'Rammefarve',
			data			: 'Data',
			header			: 'Header',
			yes				: 'Ja',
			no				: 'Nej',
			invalidWidth	: 'Cellebredde skal være et tal.',
			invalidHeight	: 'Cellehøjde skal være et tal.',
			invalidRowSpan	: 'Række span skal være et heltal.',
			invalidColSpan	: 'Kolonne span skal være et heltal.',
			chooseColor		: 'Choose' // MISSING
		},

		row :
		{
			menu			: 'Række',
			insertBefore	: 'Indsæt række før',
			insertAfter		: 'Indsæt række efter',
			deleteRow		: 'Slet række'
		},

		column :
		{
			menu			: 'Kolonne',
			insertBefore	: 'Indsæt kolonne før',
			insertAfter		: 'Indsæt kolonne efter',
			deleteColumn	: 'Slet kolonne'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Egenskaber for knap',
		text		: 'Tekst',
		type		: 'Type',
		typeBtn		: 'Knap',
		typeSbm		: 'Send',
		typeRst		: 'Nulstil'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Egenskaber for afkrydsningsfelt',
		radioTitle	: 'Egenskaber for alternativknap',
		value		: 'Værdi',
		selected	: 'Valgt'
	},

	// Form Dialog.
	form :
	{
		title		: 'Egenskaber for formular',
		menu		: 'Egenskaber for formular',
		action		: 'Handling',
		method		: 'Metode',
		encoding	: 'Kodning (encoding)'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Egenskaber for liste',
		selectInfo	: 'Generelt',
		opAvail		: 'Valgmuligheder',
		value		: 'Værdi',
		size		: 'Størrelse',
		lines		: 'Linjer',
		chkMulti	: 'Tillad flere valg',
		opText		: 'Tekst',
		opValue		: 'Værdi',
		btnAdd		: 'Tilføj',
		btnModify	: 'Redigér',
		btnUp		: 'Op',
		btnDown		: 'Ned',
		btnSetValue : 'Sæt som valgt',
		btnDelete	: 'Slet'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Egenskaber for tekstboks',
		cols		: 'Kolonner',
		rows		: 'Rækker'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Egenskaber for tekstfelt',
		name		: 'Navn',
		value		: 'Værdi',
		charWidth	: 'Bredde (tegn)',
		maxChars	: 'Max. antal tegn',
		type		: 'Type',
		typeText	: 'Tekst',
		typePass	: 'Adgangskode'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Egenskaber for skjult felt',
		name	: 'Navn',
		value	: 'Værdi'
	},

	// Image Dialog.
	image :
	{
		title		: 'Egenskaber for billede',
		titleButton	: 'Egenskaber for billedknap',
		menu		: 'Egenskaber for billede',
		infoTab		: 'Generelt',
		btnUpload	: 'Upload',
		upload		: 'Upload',
		alt			: 'Alternativ tekst',
		lockRatio	: 'Lås størrelsesforhold',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Nulstil størrelse',
		border		: 'Ramme',
		hSpace		: 'Vandret margen',
		vSpace		: 'Lodret margen',
		alertUrl	: 'Indtast stien til billedet',
		linkTab		: 'Hyperlink',
		button2Img	: 'Vil du lave billedknappen om til et almindeligt billede?',
		img2Button	: 'Vil du lave billedet om til en billedknap?',
		urlMissing	: 'Image source URL is missing.', // MISSING
		validateBorder	: 'Border must be a whole number.', // MISSING
		validateHSpace	: 'HSpace must be a whole number.', // MISSING
		validateVSpace	: 'VSpace must be a whole number.' // MISSING
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Egenskaber for Flash',
		propertiesTab	: 'Egenskaber',
		title			: 'Egenskaber for Flash',
		chkPlay			: 'Automatisk afspilning',
		chkLoop			: 'Gentagelse',
		chkMenu			: 'Vis Flash menu',
		chkFull			: 'Tillad fuldskærm',
 		scale			: 'Skalér',
		scaleAll		: 'Vis alt',
		scaleNoBorder	: 'Ingen ramme',
		scaleFit		: 'Tilpas størrelse',
		access			: 'Script adgang',
		accessAlways	: 'Altid',
		accessSameDomain: 'Samme domæne',
		accessNever		: 'Aldrig',
		alignAbsBottom	: 'Absolut nederst',
		alignAbsMiddle	: 'Absolut centreret',
		alignBaseline	: 'Grundlinje',
		alignTextTop	: 'Toppen af teksten',
		quality			: 'Kvalitet',
		qualityBest		: 'Bedste',
		qualityHigh		: 'Høj',
		qualityAutoHigh	: 'Auto høj',
		qualityMedium	: 'Medium',
		qualityAutoLow	: 'Auto lav',
		qualityLow		: 'Lav',
		windowModeWindow: 'Vindue',
		windowModeOpaque: 'Gennemsigtig (opaque)',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Vinduestilstand',
		flashvars		: 'Variabler for Flash',
		bgcolor			: 'Baggrundsfarve',
		hSpace			: 'Vandret margen',
		vSpace			: 'Lodret margen',
		validateSrc		: 'Indtast hyperlink URL!',
		validateHSpace	: 'Vandret margen skal være et tal.',
		validateVSpace	: 'Lodret margen skal være et tal.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Stavekontrol',
		title			: 'Stavekontrol',
		notAvailable	: 'Stavekontrol er desværre ikke tilgængelig.',
		errorLoading	: 'Fejl ved indlæsning af host: %s.',
		notInDic		: 'Ikke i ordbogen',
		changeTo		: 'Forslag',
		btnIgnore		: 'Ignorér',
		btnIgnoreAll	: 'Ignorér alle',
		btnReplace		: 'Erstat',
		btnReplaceAll	: 'Erstat alle',
		btnUndo			: 'Tilbage',
		noSuggestions	: '(ingen forslag)',
		progress		: 'Stavekontrollen arbejder...',
		noMispell		: 'Stavekontrol færdig: Ingen fejl fundet',
		noChanges		: 'Stavekontrol færdig: Ingen ord ændret',
		oneChange		: 'Stavekontrol færdig: Et ord ændret',
		manyChanges		: 'Stavekontrol færdig: %1 ord ændret',
		ieSpellDownload	: 'Stavekontrol ikke installeret. Vil du installere den nu?'
	},

	smiley :
	{
		toolbar	: 'Smiley',
		title	: 'Vælg smiley',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element'
	},

	numberedlist	: 'Talopstilling',
	bulletedlist	: 'Punktopstilling',
	indent			: 'Forøg indrykning',
	outdent			: 'Formindsk indrykning',

	justify :
	{
		left	: 'Venstrestillet',
		center	: 'Centreret',
		right	: 'Højrestillet',
		block	: 'Lige margener'
	},

	blockquote : 'Blokcitat',

	clipboard :
	{
		title		: 'Indsæt',
		cutError	: 'Din browsers sikkerhedsindstillinger tillader ikke editoren at få automatisk adgang til udklipsholderen.<br><br>Brug i stedet tastaturet til at klippe teksten (Ctrl/Cmd+X).',
		copyError	: 'Din browsers sikkerhedsindstillinger tillader ikke editoren at få automatisk adgang til udklipsholderen.<br><br>Brug i stedet tastaturet til at kopiere teksten (Ctrl/Cmd+C).',
		pasteMsg	: 'Indsæt i feltet herunder (<STRONG>Ctrl/Cmd+V</STRONG>) og klik på <STRONG>OK</STRONG>.',
		securityMsg	: 'Din browsers sikkerhedsindstillinger tillader ikke editoren at få automatisk adgang til udklipsholderen.<br><br>Du skal indsætte udklipsholderens indhold i dette vindue igen.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'Den tekst du forsøger at indsætte ser ud til at komme fra Word. Vil du rense teksten før den indsættes?',
		toolbar			: 'Indsæt fra Word',
		title			: 'Indsæt fra Word',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Indsæt som ikke-formateret tekst',
		title	: 'Indsæt som ikke-formateret tekst'
	},

	templates :
	{
		button			: 'Skabeloner',
		title			: 'Indholdsskabeloner',
		options : 'Template Options', // MISSING
		insertOption	: 'Erstat det faktiske indhold',
		selectPromptMsg	: 'Vælg den skabelon, som skal åbnes i editoren (nuværende indhold vil blive overskrevet):',
		emptyListMsg	: '(Der er ikke defineret nogen skabelon)'
	},

	showBlocks : 'Vis afsnitsmærker',

	stylesCombo :
	{
		label		: 'Typografi',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block typografi',
		panelTitle2	: 'Inline typografi',
		panelTitle3	: 'Object typografi'
	},

	format :
	{
		label		: 'Formatering',
		panelTitle	: 'Formatering',

		tag_p		: 'Normal',
		tag_pre		: 'Formateret',
		tag_address	: 'Adresse',
		tag_h1		: 'Overskrift 1',
		tag_h2		: 'Overskrift 2',
		tag_h3		: 'Overskrift 3',
		tag_h4		: 'Overskrift 4',
		tag_h5		: 'Overskrift 5',
		tag_h6		: 'Overskrift 6',
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
		title		: 'IFrame Properties', // MISSING
		toolbar		: 'IFrame', // MISSING
		noUrl		: 'Please type the iframe URL', // MISSING
		scrolling	: 'Enable scrollbars', // MISSING
		border		: 'Show frame border' // MISSING
	},

	font :
	{
		label		: 'Skrifttype',
		voiceLabel	: 'Skrifttype',
		panelTitle	: 'Skrifttype'
	},

	fontSize :
	{
		label		: 'Skriftstørrelse',
		voiceLabel	: 'Skriftstørrelse',
		panelTitle	: 'Skriftstørrelse'
	},

	colorButton :
	{
		textColorTitle	: 'Tekstfarve',
		bgColorTitle	: 'Baggrundsfarve',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automatisk',
		more			: 'Flere farver...'
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
		title			: 'Stavekontrol mens du skriver',
		opera_title		: 'Not supported by Opera', // MISSING
		enable			: 'Aktivér SCAYT',
		disable			: 'Deaktivér SCAYT',
		about			: 'Om SCAYT',
		toggle			: 'Skift/toggle SCAYT',
		options			: 'Indstillinger',
		langs			: 'Sprog',
		moreSuggestions	: 'Flere forslag',
		ignore			: 'Ignorér',
		ignoreAll		: 'Ignorér alle',
		addWord			: 'Tilføj ord',
		emptyDic		: 'Ordbogsnavn må ikke være tom.',

		optionsTab		: 'Indstillinger',
		allCaps			: 'Ignore All-Caps Words', // MISSING
		ignoreDomainNames : 'Ignore Domain Names', // MISSING
		mixedCase		: 'Ignore Words with Mixed Case', // MISSING
		mixedWithDigits	: 'Ignore Words with Numbers', // MISSING

		languagesTab	: 'Sprog',

		dictionariesTab	: 'Ordbøger',
		dic_field_name	: 'Dictionary name', // MISSING
		dic_create		: 'Create', // MISSING
		dic_restore		: 'Restore', // MISSING
		dic_delete		: 'Delete', // MISSING
		dic_rename		: 'Rename', // MISSING
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'Om'
	},

	about :
	{
		title		: 'Om CKEditor',
		dlgTitle	: 'Om CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'For informationer omkring licens, se venligst vores hjemmeside (på engelsk):',
		copy		: 'Copyright &copy; $1. Alle rettigheder forbeholdes.'
	},

	maximize : 'Maximér',
	minimize : 'Minimize', // MISSING

	fakeobjects :
	{
		anchor		: 'Anker',
		flash		: 'Flashanimation',
		iframe		: 'IFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Ukendt objekt'
	},

	resize : 'Træk for at skalere',

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
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
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
