/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Estonian language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['et'] =
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
	source			: 'Lähtekood',
	newPage			: 'Uus leht',
	save			: 'Salvesta',
	preview			: 'Eelvaade',
	cut				: 'Lõika',
	copy			: 'Kopeeri',
	paste			: 'Kleebi',
	print			: 'Prindi',
	underline		: 'Allajoonitud',
	bold			: 'Paks',
	italic			: 'Kursiiv',
	selectAll		: 'Vali kõik',
	removeFormat	: 'Eemalda vorming',
	strike			: 'Läbijoonitud',
	subscript		: 'Allindeks',
	superscript		: 'Ülaindeks',
	horizontalrule	: 'Sisesta horisontaaljoon',
	pagebreak		: 'Sisesta lehevahetuskoht',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Eemalda link',
	undo			: 'Võta tagasi',
	redo			: 'Korda toimingut',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Sirvi serverit',
		url				: 'URL',
		protocol		: 'Protokoll',
		upload			: 'Lae üles',
		uploadSubmit	: 'Saada serverissee',
		image			: 'Pilt',
		flash			: 'Flash',
		form			: 'Vorm',
		checkbox		: 'Märkeruut',
		radio			: 'Raadionupp',
		textField		: 'Tekstilahter',
		textarea		: 'Tekstiala',
		hiddenField		: 'Varjatud lahter',
		button			: 'Nupp',
		select			: 'Valiklahter',
		imageButton		: 'Piltnupp',
		notSet			: '<määramata>',
		id				: 'Id',
		name			: 'Nimi',
		langDir			: 'Keele suund',
		langDirLtr		: 'Vasakult paremale (LTR)',
		langDirRtl		: 'Paremalt vasakule (RTL)',
		langCode		: 'Keele kood',
		longDescr		: 'Pikk kirjeldus URL',
		cssClass		: 'Stiilistiku klassid',
		advisoryTitle	: 'Juhendav tiitel',
		cssStyle		: 'Laad',
		ok				: 'OK',
		cancel			: 'Loobu',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'General', // MISSING
		advancedTab		: 'Täpsemalt',
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
		width			: 'Laius',
		height			: 'Kõrgus',
		align			: 'Joondus',
		alignLeft		: 'Vasak',
		alignRight		: 'Paremale',
		alignCenter		: 'Kesk',
		alignTop		: 'Üles',
		alignMiddle		: 'Keskele',
		alignBottom		: 'Alla',
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
		toolbar		: 'Sisesta erimärk',
		title		: 'Vali erimärk',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Sisesta link / Muuda linki',
		other 		: '<muu>',
		menu		: 'Muuda linki',
		title		: 'Link',
		info		: 'Lingi info',
		target		: 'Sihtkoht',
		upload		: 'Lae üles',
		advanced	: 'Täpsemalt',
		type		: 'Lingi tüüp',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Ankur sellel lehel',
		toEmail		: 'E-post',
		targetFrame		: '<raam>',
		targetPopup		: '<hüpikaken>',
		targetFrameName	: 'Sihtmärk raami nimi',
		targetPopupName	: 'Hüpikakna nimi',
		popupFeatures	: 'Hüpikakna omadused',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'Olekuriba',
		popupLocationBar: 'Aadressiriba',
		popupToolbar	: 'Tööriistariba',
		popupMenuBar	: 'Menüüriba',
		popupFullScreen	: 'Täisekraan (IE)',
		popupScrollBars	: 'Kerimisribad',
		popupDependent	: 'Sõltuv (Netscape)',
		popupLeft		: 'Vasak asukoht',
		popupTop		: 'Ülemine asukoht',
		id				: 'Id', // MISSING
		langDir			: 'Keele suund',
		langDirLTR		: 'Vasakult paremale (LTR)',
		langDirRTL		: 'Paremalt vasakule (RTL)',
		acccessKey		: 'Juurdepääsu võti',
		name			: 'Nimi',
		langCode			: 'Keele suund',
		tabIndex			: 'Tab indeks',
		advisoryTitle		: 'Juhendav tiitel',
		advisoryContentType	: 'Juhendava sisu tüüp',
		cssClasses		: 'Stiilistiku klassid',
		charset			: 'Lingitud ressurssi märgistik',
		styles			: 'Laad',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Vali ankur',
		anchorName		: 'Ankru nime järgi',
		anchorId			: 'Elemendi id järgi',
		emailAddress		: 'E-posti aadress',
		emailSubject		: 'Sõnumi teema',
		emailBody		: 'Sõnumi tekst',
		noAnchors		: '(Selles dokumendis ei ole ankruid)',
		noUrl			: 'Palun kirjuta lingi URL',
		noEmail			: 'Palun kirjuta E-Posti aadress'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Sisesta ankur / Muuda ankrut',
		menu		: 'Ankru omadused',
		title		: 'Ankru omadused',
		name		: 'Ankru nimi',
		errorName	: 'Palun sisest ankru nimi'
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
		title				: 'Otsi ja asenda',
		find				: 'Otsi',
		replace				: 'Asenda',
		findWhat			: 'Leia mida:',
		replaceWith			: 'Asenda millega:',
		notFoundMsg			: 'Valitud teksti ei leitud.',
		matchCase			: 'Erista suur- ja väiketähti',
		matchWord			: 'Otsi terviklike sõnu',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'Asenda kõik',
		replaceSuccessMsg	: '%1 occurrence(s) replaced.' // MISSING
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabel',
		title		: 'Tabeli atribuudid',
		menu		: 'Tabeli atribuudid',
		deleteTable	: 'Kustuta tabel',
		rows		: 'Read',
		columns		: 'Veerud',
		border		: 'Joone suurus',
		widthPx		: 'pikslit',
		widthPc		: 'protsenti',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Lahtri vahe',
		cellPad		: 'Lahtri täidis',
		caption		: 'Tabeli tiitel',
		summary		: 'Kokkuvõte',
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
			menu			: 'Lahter',
			insertBefore	: 'Sisesta lahter enne',
			insertAfter		: 'Sisesta lahter peale',
			deleteCell		: 'Eemalda lahtrid',
			merge			: 'Ühenda lahtrid',
			mergeRight		: 'Ühenda paremale',
			mergeDown		: 'Ühenda alla',
			splitHorizontal	: 'Poolita lahter horisontaalselt',
			splitVertical	: 'Poolita lahter vertikaalselt',
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
			menu			: 'Rida',
			insertBefore	: 'Sisesta rida enne',
			insertAfter		: 'Sisesta rida peale',
			deleteRow		: 'Eemalda read'
		},

		column :
		{
			menu			: 'Veerg',
			insertBefore	: 'Sisesta veerg enne',
			insertAfter		: 'Sisesta veerg peale',
			deleteColumn	: 'Eemalda veerud'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Nupu omadused',
		text		: 'Tekst (väärtus)',
		type		: 'Tüüp',
		typeBtn		: 'Nupp',
		typeSbm		: 'Saada',
		typeRst		: 'Lähtesta'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Märkeruudu omadused',
		radioTitle	: 'Raadionupu omadused',
		value		: 'Väärtus',
		selected	: 'Valitud'
	},

	// Form Dialog.
	form :
	{
		title		: 'Vormi omadused',
		menu		: 'Vormi omadused',
		action		: 'Toiming',
		method		: 'Meetod',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Valiklahtri omadused',
		selectInfo	: 'Info',
		opAvail		: 'Võimalikud valikud',
		value		: 'Väärtus',
		size		: 'Suurus',
		lines		: 'ridu',
		chkMulti	: 'Võimalda mitu valikut',
		opText		: 'Tekst',
		opValue		: 'Väärtus',
		btnAdd		: 'Lisa',
		btnModify	: 'Muuda',
		btnUp		: 'Üles',
		btnDown		: 'Alla',
		btnSetValue : 'Sea valitud olekuna',
		btnDelete	: 'Kustuta'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Tekstiala omadused',
		cols		: 'Veerge',
		rows		: 'Ridu'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Tekstilahtri omadused',
		name		: 'Nimi',
		value		: 'Väärtus',
		charWidth	: 'Laius (tähemärkides)',
		maxChars	: 'Maksimaalselt tähemärke',
		type		: 'Tüüp',
		typeText	: 'Tekst',
		typePass	: 'Parool'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Varjatud lahtri omadused',
		name	: 'Nimi',
		value	: 'Väärtus'
	},

	// Image Dialog.
	image :
	{
		title		: 'Pildi atribuudid',
		titleButton	: 'Piltnupu omadused',
		menu		: 'Pildi atribuudid',
		infoTab		: 'Pildi info',
		btnUpload	: 'Saada serverissee',
		upload		: 'Lae üles',
		alt			: 'Alternatiivne tekst',
		lockRatio	: 'Lukusta kuvasuhe',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Lähtesta suurus',
		border		: 'Joon',
		hSpace		: 'H. vaheruum',
		vSpace		: 'V. vaheruum',
		alertUrl	: 'Palun kirjuta pildi URL',
		linkTab		: 'Link',
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
		properties		: 'Flash omadused',
		propertiesTab	: 'Properties', // MISSING
		title			: 'Flash omadused',
		chkPlay			: 'Automaatne start ',
		chkLoop			: 'Korduv',
		chkMenu			: 'Võimalda flash menüü',
		chkFull			: 'Allow Fullscreen', // MISSING
 		scale			: 'Mastaap',
		scaleAll		: 'Näita kõike',
		scaleNoBorder	: 'Äärist ei ole',
		scaleFit		: 'Täpne sobivus',
		access			: 'Script Access', // MISSING
		accessAlways	: 'Always', // MISSING
		accessSameDomain: 'Same domain', // MISSING
		accessNever		: 'Never', // MISSING
		alignAbsBottom	: 'Abs alla',
		alignAbsMiddle	: 'Abs keskele',
		alignBaseline	: 'Baasjoonele',
		alignTextTop	: 'Tekstit üles',
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
		bgcolor			: 'Tausta värv',
		hSpace			: 'H. vaheruum',
		vSpace			: 'V. vaheruum',
		validateSrc		: 'Palun kirjuta lingi URL',
		validateHSpace	: 'HSpace must be a number.', // MISSING
		validateVSpace	: 'VSpace must be a number.' // MISSING
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Kontrolli õigekirja',
		title			: 'Spell Check', // MISSING
		notAvailable	: 'Sorry, but service is unavailable now.', // MISSING
		errorLoading	: 'Error loading application service host: %s.', // MISSING
		notInDic		: 'Puudub sõnastikust',
		changeTo		: 'Muuda',
		btnIgnore		: 'Ignoreeri',
		btnIgnoreAll	: 'Ignoreeri kõiki',
		btnReplace		: 'Asenda',
		btnReplaceAll	: 'Asenda kõik',
		btnUndo			: 'Võta tagasi',
		noSuggestions	: '- Soovitused puuduvad -',
		progress		: 'Toimub õigekirja kontroll...',
		noMispell		: 'Õigekirja kontroll sooritatud: õigekirjuvigu ei leitud',
		noChanges		: 'Õigekirja kontroll sooritatud: ühtegi sõna ei muudetud',
		oneChange		: 'Õigekirja kontroll sooritatud: üks sõna muudeti',
		manyChanges		: 'Õigekirja kontroll sooritatud: %1 sõna muudetud',
		ieSpellDownload	: 'Õigekirja kontrollija ei ole installeeritud. Soovid sa selle alla laadida?'
	},

	smiley :
	{
		toolbar	: 'Emotikon',
		title	: 'Sisesta emotikon',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 element' // MISSING
	},

	numberedlist	: 'Nummerdatud loetelu',
	bulletedlist	: 'Punktiseeritud loetelu',
	indent			: 'Suurenda taanet',
	outdent			: 'Vähenda taanet',

	justify :
	{
		left	: 'Vasakjoondus',
		center	: 'Keskjoondus',
		right	: 'Paremjoondus',
		block	: 'Rööpjoondus'
	},

	blockquote : 'Blokktsitaat',

	clipboard :
	{
		title		: 'Kleebi',
		cutError	: 'Sinu veebisirvija turvaseaded ei luba redaktoril automaatselt lõigata. Palun kasutage selleks klaviatuuri klahvikombinatsiooni (Ctrl/Cmd+X).',
		copyError	: 'Sinu veebisirvija turvaseaded ei luba redaktoril automaatselt kopeerida. Palun kasutage selleks klaviatuuri klahvikombinatsiooni (Ctrl/Cmd+C).',
		pasteMsg	: 'Palun kleebi järgnevasse kasti kasutades klaviatuuri klahvikombinatsiooni (<STRONG>Ctrl/Cmd+V</STRONG>) ja vajuta seejärel <STRONG>OK</STRONG>.',
		securityMsg	: 'Sinu veebisirvija turvaseadete tõttu, ei oma redaktor otsest ligipääsu lõikelaua andmetele. Sa pead kleepima need uuesti siia aknasse.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'The text you want to paste seems to be copied from Word. Do you want to clean it before pasting?', // MISSING
		toolbar			: 'Kleebi Wordist',
		title			: 'Kleebi Wordist',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Kleebi tavalise tekstina',
		title	: 'Kleebi tavalise tekstina'
	},

	templates :
	{
		button			: 'Šabloon',
		title			: 'Sisu šabloonid',
		options : 'Template Options', // MISSING
		insertOption	: 'Asenda tegelik sisu',
		selectPromptMsg	: 'Palun vali šabloon, et avada see redaktoris<br />(praegune sisu läheb kaotsi):',
		emptyListMsg	: '(Ühtegi šablooni ei ole defineeritud)'
	},

	showBlocks : 'Näita blokke',

	stylesCombo :
	{
		label		: 'Laad',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Block Styles', // MISSING
		panelTitle2	: 'Inline Styles', // MISSING
		panelTitle3	: 'Object Styles' // MISSING
	},

	format :
	{
		label		: 'Vorming',
		panelTitle	: 'Vorming',

		tag_p		: 'Tavaline',
		tag_pre		: 'Vormindatud',
		tag_address	: 'Aadress',
		tag_h1		: 'Pealkiri 1',
		tag_h2		: 'Pealkiri 2',
		tag_h3		: 'Pealkiri 3',
		tag_h4		: 'Pealkiri 4',
		tag_h5		: 'Pealkiri 5',
		tag_h6		: 'Pealkiri 6',
		tag_div		: 'Tavaline (DIV)'
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
		label		: 'Kiri',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'Kiri'
	},

	fontSize :
	{
		label		: 'Suurus',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'Suurus'
	},

	colorButton :
	{
		textColorTitle	: 'Teksti värv',
		bgColorTitle	: 'Tausta värv',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automaatne',
		more			: 'Rohkem värve...'
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
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'For licensing information please visit our web site:', // MISSING
		copy		: 'Copyright &copy; $1. All rights reserved.' // MISSING
	},

	maximize : 'Maximize', // MISSING
	minimize : 'Minimize', // MISSING

	fakeobjects :
	{
		anchor		: 'Anchor', // MISSING
		flash		: 'Flash Animation', // MISSING
		iframe		: 'IFrame', // MISSING
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
