﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
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
	editorTitle : 'Teksverwerker, %1, druk op ALT 0 vir hulp.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Teksverwerker',

	// Toolbar buttons without dialogs.
	source			: 'Bron',
	newPage			: 'Nuwe bladsy',
	save			: 'Bewaar',
	preview			: 'Voorbeeld',
	cut				: 'Knip',
	copy			: 'Kopiëer',
	paste			: 'Plak',
	print			: 'Druk',
	underline		: 'Onderstreep',
	bold			: 'Vet',
	italic			: 'Skuins',
	selectAll		: 'Selekteer alles',
	removeFormat	: 'Verwyder opmaak',
	strike			: 'Deurstreep',
	subscript		: 'Onderskrif',
	superscript		: 'Bo-skrif',
	horizontalrule	: 'Horisontale lyn invoeg',
	pagebreak		: 'Bladsy-einde invoeg',
	pagebreakAlt		: 'Bladsy-einde',
	unlink			: 'Verwyder skakel',
	undo			: 'Ontdoen',
	redo			: 'Oordoen',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Blaai op bediener',
		url				: 'URL',
		protocol		: 'Protokol',
		upload			: 'Oplaai',
		uploadSubmit	: 'Stuur na bediener',
		image			: 'Afbeelding',
		flash			: 'Flash',
		form			: 'Vorm',
		checkbox		: 'Merkhokkie',
		radio			: 'Radioknoppie',
		textField		: 'Teksveld',
		textarea		: 'Teks-area',
		hiddenField		: 'Blinde veld',
		button			: 'Knop',
		select			: 'Keuseveld',
		imageButton		: 'Afbeeldingsknop',
		notSet			: '<geen instelling>',
		id				: 'Id',
		name			: 'Naam',
		langDir			: 'Skryfrigting',
		langDirLtr		: 'Links na regs (LTR)',
		langDirRtl		: 'Regs na links (RTL)',
		langCode		: 'Taalkode',
		longDescr		: 'Lang beskrywing URL',
		cssClass		: 'CSS klasse',
		advisoryTitle	: 'Aanbevole titel',
		cssStyle		: 'Styl',
		ok				: 'OK',
		cancel			: 'Kanselleer',
		close			: 'Sluit',
		preview			: 'Voorbeeld',
		generalTab		: 'Algemeen',
		advancedTab		: 'Gevorderd',
		validateNumberFailed : 'Hierdie waarde is nie \'n getal nie.',
		confirmNewPage	: 'Alle wysiginge sal verlore gaan. Is u seker dat u \'n nuwe bladsy wil laai?',
		confirmCancel	: 'Sommige opsies is gewysig. Is u seker dat u hierdie dialoogvenster wil sluit?',
		options			: 'Opsies',
		target			: 'Doel',
		targetNew		: 'Nuwe venster (_blank)',
		targetTop		: 'Boonste venster (_top)',
		targetSelf		: 'Selfde venster (_self)',
		targetParent	: 'Oorspronklike venster (_parent)',
		langDirLTR		: 'Links na Regs (LTR)',
		langDirRTL		: 'Regs na Links (RTL)',
		styles			: 'Styl',
		cssClasses		: 'CSS klasse',
		width			: 'Breedte',
		height			: 'Hoogte',
		align			: 'Oplyn',
		alignLeft		: 'Links',
		alignRight		: 'Regs',
		alignCenter		: 'Sentreer',
		alignTop		: 'Bo',
		alignMiddle		: 'Middel',
		alignBottom		: 'Onder',
		invalidHeight	: 'Hoogte moet \'n getal wees',
		invalidWidth	: 'Breedte moet \'n getal wees.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, nie beskikbaar nie</span>'
	},

	contextmenu :
	{
		options : 'Konteks Spyskaart-opsies'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Voeg spesiaale karakter in',
		title		: 'Kies spesiale karakter',
		options : 'Spesiale karakter-opsies'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Skakel invoeg/wysig',
		other 		: '<ander>',
		menu		: 'Wysig skakel',
		title		: 'Skakel',
		info		: 'Skakel informasie',
		target		: 'Doel',
		upload		: 'Oplaai',
		advanced	: 'Gevorderd',
		type		: 'Skakelsoort',
		toUrl		: 'URL',
		toAnchor	: 'Anker in bladsy',
		toEmail		: 'E-pos',
		targetFrame		: '<raam>',
		targetPopup		: '<opspringvenster>',
		targetFrameName	: 'Naam van doelraam',
		targetPopupName	: 'Naam van opspringvenster',
		popupFeatures	: 'Eienskappe van opspringvenster',
		popupResizable	: 'Herskaalbaar',
		popupStatusBar	: 'Statusbalk',
		popupLocationBar: 'Adresbalk',
		popupToolbar	: 'Werkbalk',
		popupMenuBar	: 'Spyskaartbalk',
		popupFullScreen	: 'Volskerm (IE)',
		popupScrollBars	: 'Skuifbalke',
		popupDependent	: 'Afhanklik (Netscape)',
		popupLeft		: 'Posisie links',
		popupTop		: 'Posisie bo',
		id				: 'Id',
		langDir			: 'Skryfrigting',
		langDirLTR		: 'Links na regs (LTR)',
		langDirRTL		: 'Regs na links (RTL)',
		acccessKey		: 'Toegangsleutel',
		name			: 'Naam',
		langCode			: 'Taalkode',
		tabIndex			: 'Tab indeks',
		advisoryTitle		: 'Aanbevole titel',
		advisoryContentType	: 'Aanbevole inhoudstipe',
		cssClasses		: 'CSS klasse',
		charset			: 'Karakterstel van geskakelde bron',
		styles			: 'Styl',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Kies \'n anker',
		anchorName		: 'Op ankernaam',
		anchorId			: 'Op element Id',
		emailAddress		: 'E-posadres',
		emailSubject		: 'Berig-onderwerp',
		emailBody		: 'Berig-inhoud',
		noAnchors		: '(Geen ankers beskikbaar in dokument)',
		noUrl			: 'Gee die skakel se URL',
		noEmail			: 'Gee die e-posadres'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Anker byvoeg/verander',
		menu		: 'Anker-eienskappe',
		title		: 'Anker-eienskappe',
		name		: 'Ankernaam',
		errorName	: 'Voltooi die ankernaam asseblief'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Eienskappe van genommerde lys',
		bulletedTitle		: 'Eienskappe van ongenommerde lys',
		type				: 'Tipe',
		start				: 'Begin',
		validateStartNumber				:'Beginnommer van lys moet \'n heelgetal wees.',
		circle				: 'Sirkel',
		disc				: 'Skyf',
		square				: 'Vierkant',
		none				: 'Geen',
		notset				: '<nie ingestel nie>',
		armenian			: 'Armeense nommering',
		georgian			: 'Georgiese nommering (an, ban, gan, ens.)',
		lowerRoman			: 'Romeinse kleinletters (i, ii, iii, iv, v, ens.)',
		upperRoman			: 'Romeinse hoofletters (I, II, III, IV, V, ens.)',
		lowerAlpha			: 'Kleinletters (a, b, c, d, e, ens.)',
		upperAlpha			: 'Hoofletters (A, B, C, D, E, ens.)',
		lowerGreek			: 'Griekse kleinletters (alpha, beta, gamma, ens.)',
		decimal				: 'Desimale syfers (1, 2, 3, ens.)',
		decimalLeadingZero	: 'Desimale syfers met voorloopnul (01, 02, 03, ens.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Soek en vervang',
		find				: 'Soek',
		replace				: 'Vervang',
		findWhat			: 'Soek na:',
		replaceWith			: 'Vervang met:',
		notFoundMsg			: 'Teks nie gevind nie.',
		matchCase			: 'Hoof/kleinletter sensitief',
		matchWord			: 'Hele woord moet voorkom',
		matchCyclic			: 'Soek deurlopend',
		replaceAll			: 'Vervang alles',
		replaceSuccessMsg	: '%1 voorkoms(te) vervang.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabel',
		title		: 'Tabel eienskappe',
		menu		: 'Tabel eienskappe',
		deleteTable	: 'Verwyder tabel',
		rows		: 'Rye',
		columns		: 'Kolomme',
		border		: 'Randbreedte',
		widthPx		: 'piksels',
		widthPc		: 'persent',
		widthUnit	: 'breedte-eenheid',
		cellSpace	: 'Sel-afstand',
		cellPad		: 'Sel-spasie',
		caption		: 'Naam',
		summary		: 'Opsomming',
		headers		: 'Opskrifte',
		headersNone		: 'Geen',
		headersColumn	: 'Eerste kolom',
		headersRow		: 'Eerste ry',
		headersBoth		: 'Beide    ',
		invalidRows		: 'Aantal rye moet \'n getal groter as 0 wees.',
		invalidCols		: 'Aantal kolomme moet \'n getal groter as 0 wees.',
		invalidBorder	: 'Randbreedte moet \'n getal wees.',
		invalidWidth	: 'Tabelbreedte moet \'n getal wees.',
		invalidHeight	: 'Tabelhoogte moet \'n getal wees.',
		invalidCellSpacing	: 'Sel-afstand moet \'n getal wees.',
		invalidCellPadding	: 'Sel-spasie moet \'n getal wees.',

		cell :
		{
			menu			: 'Sel',
			insertBefore	: 'Voeg sel in voor',
			insertAfter		: 'Voeg sel in na',
			deleteCell		: 'Verwyder sel',
			merge			: 'Voeg selle saam',
			mergeRight		: 'Voeg saam na regs',
			mergeDown		: 'Voeg saam ondertoe',
			splitHorizontal	: 'Splits sel horisontaal',
			splitVertical	: 'Splits sel vertikaal',
			title			: 'Sel eienskappe',
			cellType		: 'Sel tipe',
			rowSpan			: 'Omspan rye',
			colSpan			: 'Omspan kolomme',
			wordWrap		: 'Woord terugloop',
			hAlign			: 'Horisontale oplyning',
			vAlign			: 'Vertikale oplyning',
			alignBaseline	: 'Basislyn',
			bgColor			: 'Agtergrondkleur',
			borderColor		: 'Randkleur',
			data			: 'Inhoud',
			header			: 'Opskrif',
			yes				: 'Ja',
			no				: 'Nee',
			invalidWidth	: 'Selbreedte moet \'n getal wees.',
			invalidHeight	: 'Selhoogte moet \'n getal wees.',
			invalidRowSpan	: 'Omspan rye moet \'n heelgetal wees.',
			invalidColSpan	: 'Omspan kolomme moet \'n heelgetal wees.',
			chooseColor		: 'Kies'
		},

		row :
		{
			menu			: 'Ry',
			insertBefore	: 'Voeg ry in voor',
			insertAfter		: 'Voeg ry in na',
			deleteRow		: 'Verwyder ry'
		},

		column :
		{
			menu			: 'Kolom',
			insertBefore	: 'Voeg kolom in voor',
			insertAfter		: 'Voeg kolom in na',
			deleteColumn	: 'Verwyder kolom'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Knop eienskappe',
		text		: 'Teks (Waarde)',
		type		: 'Soort',
		typeBtn		: 'Knop',
		typeSbm		: 'Stuur',
		typeRst		: 'Maak leeg'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Merkhokkie eienskappe',
		radioTitle	: 'Radioknoppie eienskappe',
		value		: 'Waarde',
		selected	: 'Geselekteer'
	},

	// Form Dialog.
	form :
	{
		title		: 'Vorm eienskappe',
		menu		: 'Vorm eienskappe',
		action		: 'Aksie',
		method		: 'Metode',
		encoding	: 'Kodering'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Keuseveld eienskappe',
		selectInfo	: 'Info',
		opAvail		: 'Beskikbare opsies',
		value		: 'Waarde',
		size		: 'Grootte',
		lines		: 'Lyne',
		chkMulti	: 'Laat meer as een keuse toe',
		opText		: 'Teks',
		opValue		: 'Waarde',
		btnAdd		: 'Byvoeg',
		btnModify	: 'Wysig',
		btnUp		: 'Op',
		btnDown		: 'Af',
		btnSetValue : 'Stel as geselekteerde waarde',
		btnDelete	: 'Verwyder'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Teks-area eienskappe',
		cols		: 'Kolomme',
		rows		: 'Rye'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Teksveld eienskappe',
		name		: 'Naam',
		value		: 'Waarde',
		charWidth	: 'Breedte (karakters)',
		maxChars	: 'Maksimum karakters',
		type		: 'Soort',
		typeText	: 'Teks',
		typePass	: 'Wagwoord'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Verborge veld eienskappe',
		name	: 'Naam',
		value	: 'Waarde'
	},

	// Image Dialog.
	image :
	{
		title		: 'Afbeelding eienskappe',
		titleButton	: 'Afbeeldingsknop eienskappe',
		menu		: 'Afbeelding eienskappe',
		infoTab		: 'Afbeelding informasie',
		btnUpload	: 'Stuur na bediener',
		upload		: 'Oplaai',
		alt			: 'Alternatiewe teks',
		lockRatio	: 'Vaste proporsie',
		unlockRatio	: 'Vrye proporsie',
		resetSize	: 'Herstel grootte',
		border		: 'Rand',
		hSpace		: 'HSpasie',
		vSpace		: 'VSpasie',
		alertUrl	: 'Gee URL van afbeelding.',
		linkTab		: 'Skakel',
		button2Img	: 'Wil u die geselekteerde afbeeldingsknop vervang met \'n eenvoudige afbeelding?',
		img2Button	: 'Wil u die geselekteerde afbeelding vervang met \'n afbeeldingsknop?',
		urlMissing	: 'Die URL na die afbeelding ontbreek.',
		validateBorder	: 'Rand moet \'n heelgetal wees.',
		validateHSpace	: 'HSpasie moet \'n heelgetal wees.',
		validateVSpace	: 'VSpasie moet \'n heelgetal wees.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Flash eienskappe',
		propertiesTab	: 'Eienskappe',
		title			: 'Flash eienskappe',
		chkPlay			: 'Speel outomaties',
		chkLoop			: 'Herhaal',
		chkMenu			: 'Flash spyskaart aan',
		chkFull			: 'Laat volledige skerm toe',
 		scale			: 'Skaal',
		scaleAll		: 'Wys alles',
		scaleNoBorder	: 'Geen rand',
		scaleFit		: 'Presiese pas',
		access			: 'Skrip toegang',
		accessAlways	: 'Altyd',
		accessSameDomain: 'Selfde domeinnaam',
		accessNever		: 'Nooit',
		alignAbsBottom	: 'Absoluut-onder',
		alignAbsMiddle	: 'Absoluut-middel',
		alignBaseline	: 'Basislyn',
		alignTextTop	: 'Teks bo',
		quality			: 'Kwaliteit',
		qualityBest		: 'Beste',
		qualityHigh		: 'Hoog',
		qualityAutoHigh	: 'Outomaties hoog',
		qualityMedium	: 'Gemiddeld',
		qualityAutoLow	: 'Outomaties laag',
		qualityLow		: 'Laag',
		windowModeWindow: 'Venster',
		windowModeOpaque: 'Ondeursigtig',
		windowModeTransparent : 'Deursigtig',
		windowMode		: 'Venster modus',
		flashvars		: 'Veranderlikes vir Flash',
		bgcolor			: 'Agtergrondkleur',
		hSpace			: 'HSpasie',
		vSpace			: 'VSpasie',
		validateSrc		: 'Voeg die URL in',
		validateHSpace	: 'HSpasie moet \'n heelgetal wees.',
		validateVSpace	: 'VSpasie moet \'n heelgetal wees.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Speltoets',
		title			: 'Speltoetser',
		notAvailable	: 'Jammer, hierdie diens is nie nou beskikbaar nie.',
		errorLoading	: 'Fout by inlaai van diens: %s.',
		notInDic		: 'Nie in woordeboek nie',
		changeTo		: 'Verander na',
		btnIgnore		: 'Ignoreer',
		btnIgnoreAll	: 'Ignoreer alles',
		btnReplace		: 'Vervang',
		btnReplaceAll	: 'vervang alles',
		btnUndo			: 'Ontdoen',
		noSuggestions	: '- Geen voorstel -',
		progress		: 'Spelling word getoets...',
		noMispell		: 'Klaar met speltoets: Geen foute nie',
		noChanges		: 'Klaar met speltoets: Geen woorde verander nie',
		oneChange		: 'Klaar met speltoets: Een woord verander',
		manyChanges		: 'Klaar met speltoets: %1 woorde verander',
		ieSpellDownload	: 'Speltoetser is nie geïnstalleer nie. Wil u dit nou aflaai?'
	},

	smiley :
	{
		toolbar	: 'Lagbekkie',
		title	: 'Voeg lagbekkie by',
		options : 'Lagbekkie opsies'
	},

	elementsPath :
	{
		eleLabel : 'Elemente-pad',
		eleTitle : '%1 element'
	},

	numberedlist	: 'Genommerde lys',
	bulletedlist	: 'Ongenommerde lys',
	indent			: 'Vergroot inspring',
	outdent			: 'Verklein inspring',

	justify :
	{
		left	: 'Links oplyn',
		center	: 'Sentreer',
		right	: 'Regs oplyn',
		block	: 'Uitvul'
	},

	blockquote : 'Sitaatblok',

	clipboard :
	{
		title		: 'Byvoeg',
		cutError	: 'U blaaier se sekuriteitsinstelling belet die outomatiese knip-aksie. Gebruik die sleutelbordkombinasie (Ctrl/Cmd+X).',
		copyError	: 'U blaaier se sekuriteitsinstelling belet die kopiëringsaksie. Gebruik die sleutelbordkombinasie (Ctrl/Cmd+C).',
		pasteMsg	: 'Plak die teks in die volgende teks-area met die sleutelbordkombinasie (<STRONG>Ctrl/Cmd+V</STRONG>) en druk <STRONG>OK</STRONG>.',
		securityMsg	: 'Weens u blaaier se sekuriteitsinstelling is data op die knipbord nie toeganklik nie. U kan dit eers weer in hierdie venster plak.',
		pasteArea	: 'Plak-area'
	},

	pastefromword :
	{
		confirmCleanup	: 'Die teks wat u wil plak lyk asof dit uit Word gekopiëer is. Wil u dit eers skoonmaak voordat dit geplak word?',
		toolbar			: 'Plak vanuit Word',
		title			: 'Plak vanuit Word',
		error			: 'Die geplakte teks kon nie skoongemaak word nie, weens \'n interne fout'
	},

	pasteText :
	{
		button	: 'Plak as eenvoudige teks',
		title	: 'Plak as eenvoudige teks'
	},

	templates :
	{
		button			: 'Sjablone',
		title			: 'Inhoud Sjablone',
		options : 'Sjabloon opsies',
		insertOption	: 'Vervang huidige inhoud',
		selectPromptMsg	: 'Kies die sjabloon om te gebruik in die redigeerder (huidige inhoud gaan verlore):',
		emptyListMsg	: '(Geen sjablone gedefineer nie)'
	},

	showBlocks : 'Toon blokke',

	stylesCombo :
	{
		label		: 'Styl',
		panelTitle	: 'Opmaak style',
		panelTitle1	: 'Blok style',
		panelTitle2	: 'Inlyn style',
		panelTitle3	: 'Objek style'
	},

	format :
	{
		label		: 'Opmaak',
		panelTitle	: 'Opmaak',

		tag_p		: 'Normaal',
		tag_pre		: 'Opgemaak',
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
		title				: 'Skep Div houer',
		toolbar				: 'Skep Div houer',
		cssClassInputLabel	: 'CSS klasse',
		styleSelectLabel	: 'Styl',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Taalkode',
		inlineStyleInputLabel	: 'Inlyn Styl',
		advisoryTitleInputLabel	: 'Aanbevole Titel',
		langDirLabel		: 'Skryfrigting',
		langDirLTRLabel		: 'Links na regs (LTR)',
		langDirRTLLabel		: 'Regs na links (RTL)',
		edit				: 'Wysig Div',
		remove				: 'Verwyder Div'
  	},

	iframe :
	{
		title		: 'IFrame Eienskappe',
		toolbar		: 'IFrame',
		noUrl		: 'Gee die iframe URL',
		scrolling	: 'Skuifbalke aan',
		border		: 'Wys rand van raam'
	},

	font :
	{
		label		: 'Font',
		voiceLabel	: 'Font',
		panelTitle	: 'Fontnaam'
	},

	fontSize :
	{
		label		: 'Grootte',
		voiceLabel	: 'Fontgrootte',
		panelTitle	: 'Fontgrootte'
	},

	colorButton :
	{
		textColorTitle	: 'Tekskleur',
		bgColorTitle	: 'Agtergrondkleur',
		panelTitle		: 'Kleure',
		auto			: 'Outomaties',
		more			: 'Meer Kleure...'
	},

	colors :
	{
		'000' : 'Swart',
		'800000' : 'Meroen',
		'8B4513' : 'Sjokoladebruin',
		'2F4F4F' : 'Donkerleisteengrys',
		'008080' : 'Blougroen',
		'000080' : 'Vlootblou',
		'4B0082' : 'Indigo',
		'696969' : 'Donkergrys',
		'B22222' : 'Rooibaksteen',
		'A52A2A' : 'Bruin',
		'DAA520' : 'Donkergeel',
		'006400' : 'Donkergroen',
		'40E0D0' : 'Turkoois',
		'0000CD' : 'Middelblou',
		'800080' : 'Pers',
		'808080' : 'Grys',
		'F00' : 'Rooi',
		'FF8C00' : 'Donkeroranje',
		'FFD700' : 'Goud',
		'008000' : 'Groen',
		'0FF' : 'Siaan',
		'00F' : 'Blou',
		'EE82EE' : 'Viooltjieblou',
		'A9A9A9' : 'Donkergrys',
		'FFA07A' : 'Ligsalm',
		'FFA500' : 'Oranje',
		'FFFF00' : 'Geel',
		'00FF00' : 'Lemmetjie',
		'AFEEEE' : 'Ligturkoois',
		'ADD8E6' : 'Ligblou',
		'DDA0DD' : 'Pruim',
		'D3D3D3' : 'Liggrys',
		'FFF0F5' : 'Linne',
		'FAEBD7' : 'Ivoor',
		'FFFFE0' : 'Liggeel',
		'F0FFF0' : 'Heuningdou',
		'F0FFFF' : 'Asuur',
		'F0F8FF' : 'Ligte hemelsblou',
		'E6E6FA' : 'Laventel',
		'FFF' : 'Wit'
	},

	scayt :
	{
		title			: 'Speltoets terwyl u tik',
		opera_title		: 'Nie ondersteun deur Opera nie',
		enable			: 'SCAYT aan',
		disable			: 'SCAYT af',
		about			: 'SCAYT info',
		toggle			: 'SCAYT wissel aan/af',
		options			: 'Opsies',
		langs			: 'Tale',
		moreSuggestions	: 'Meer voorstelle',
		ignore			: 'Ignoreer',
		ignoreAll		: 'Ignoreer alles',
		addWord			: 'Voeg woord by',
		emptyDic		: 'Woordeboeknaam mag nie leeg wees nie.',

		optionsTab		: 'Opsies',
		allCaps			: 'Ignoreer woorde in hoofletters',
		ignoreDomainNames : 'Ignoreer domeinname',
		mixedCase		: 'Ignoreer woorde met hoof- en kleinletters',
		mixedWithDigits	: 'Ignoreer woorde met syfers',

		languagesTab	: 'Tale',

		dictionariesTab	: 'Woordeboeke',
		dic_field_name	: 'Naam van woordeboek',
		dic_create		: 'Skep',
		dic_restore		: 'Herstel',
		dic_delete		: 'Verwijder',
		dic_rename		: 'Hernoem',
		dic_info		: 'Aanvanklik word die gebruikerswoordeboek in \'n koekie gestoor. Koekies is egter beperk in grootte. Wanneer die gebruikerswoordeboek te groot vir \'n koekie geword het, kan dit op ons bediener gestoor word. Om u persoonlike woordeboek op ons bediener te stoor, gee asb. \'n naam vir u woordeboek. Indien u alreeds \'n gestoorde woordeboek het, tik die naam en kliek op die Herstel knop.',

		aboutTab		: 'Info'
	},

	about :
	{
		title		: 'Info oor CKEditor',
		dlgTitle	: 'Info oor CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Vir lisensie-informasie, besoek asb. ons webwerf:',
		copy		: 'Kopiereg &copy; $1. Alle regte voorbehou.'
	},

	maximize : 'Maksimaliseer',
	minimize : 'Minimaliseer',

	fakeobjects :
	{
		anchor		: 'Anker',
		flash		: 'Flash animasie',
		iframe		: 'IFrame',
		hiddenfield	: 'Verborge veld',
		unknown		: 'Onbekende objek'
	},

	resize : 'Sleep om te herskaal',

	colordialog :
	{
		title		: 'Kies kleur',
		options	:	'Kleuropsies',
		highlight	: 'Aktief',
		selected	: 'Geselekteer',
		clear		: 'Herstel'
	},

	toolbarCollapse	: 'Verklein werkbalk',
	toolbarExpand	: 'Vergroot werkbalk',

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
		ltr : 'Skryfrigting van links na regs',
		rtl : 'Skryfrigting van regs na links'
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
