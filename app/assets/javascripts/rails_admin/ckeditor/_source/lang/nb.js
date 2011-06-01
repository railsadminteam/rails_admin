﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Norwegian Bokmål language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['nb'] =
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
	editorTitle : 'Rikteksteditor, %1, trykk ALT 0 for hjelp.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Rikteksteditor',

	// Toolbar buttons without dialogs.
	source			: 'Kilde',
	newPage			: 'Ny side',
	save			: 'Lagre',
	preview			: 'Forhåndsvis',
	cut				: 'Klipp ut',
	copy			: 'Kopier',
	paste			: 'Lim inn',
	print			: 'Skriv ut',
	underline		: 'Understreking',
	bold			: 'Fet',
	italic			: 'Kursiv',
	selectAll		: 'Merk alt',
	removeFormat	: 'Fjern formatering',
	strike			: 'Gjennomstreking',
	subscript		: 'Senket skrift',
	superscript		: 'Hevet skrift',
	horizontalrule	: 'Sett inn horisontal linje',
	pagebreak		: 'Sett inn sideskift for utskrift',
	pagebreakAlt		: 'Sideskift',
	unlink			: 'Fjern lenke',
	undo			: 'Angre',
	redo			: 'Gjør om',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Bla igjennom server',
		url				: 'URL',
		protocol		: 'Protokoll',
		upload			: 'Last opp',
		uploadSubmit	: 'Send det til serveren',
		image			: 'Bilde',
		flash			: 'Flash',
		form			: 'Skjema',
		checkbox		: 'Avmerkingsboks',
		radio			: 'Alternativknapp',
		textField		: 'Tekstboks',
		textarea		: 'Tekstområde',
		hiddenField		: 'Skjult felt',
		button			: 'Knapp',
		select			: 'Rullegardinliste',
		imageButton		: 'Bildeknapp',
		notSet			: '<ikke satt>',
		id				: 'Id',
		name			: 'Navn',
		langDir			: 'Språkretning',
		langDirLtr		: 'Venstre til høyre (VTH)',
		langDirRtl		: 'Høyre til venstre (HTV)',
		langCode		: 'Språkkode',
		longDescr		: 'Utvidet beskrivelse',
		cssClass		: 'Stilarkklasser',
		advisoryTitle	: 'Tittel',
		cssStyle		: 'Stil',
		ok				: 'OK',
		cancel			: 'Avbryt',
		close			: 'Lukk',
		preview			: 'Forhåndsvis',
		generalTab		: 'Generelt',
		advancedTab		: 'Avansert',
		validateNumberFailed : 'Denne verdien er ikke et tall.',
		confirmNewPage	: 'Alle ulagrede endringer som er gjort i dette innholdet vil bli tapt. Er du sikker på at du vil laste en ny side?',
		confirmCancel	: 'Noen av valgene har blitt endret. Er du sikker på at du vil lukke dialogen?',
		options			: 'Valg',
		target			: 'Mål',
		targetNew		: 'Nytt vindu (_blank)',
		targetTop		: 'Hele vindu (_top)',
		targetSelf		: 'Samme vindu (_self)',
		targetParent	: 'Foreldrevindu (_parent)',
		langDirLTR		: 'Venstre til høyre (VTH)',
		langDirRTL		: 'Høyre til venstre (HTV)',
		styles			: 'Stil',
		cssClasses		: 'Stilarkklasser',
		width			: 'Bredde',
		height			: 'Høyde',
		align			: 'Juster',
		alignLeft		: 'Venstre',
		alignRight		: 'Høyre',
		alignCenter		: 'Midtjuster',
		alignTop		: 'Topp',
		alignMiddle		: 'Midten',
		alignBottom		: 'Bunn',
		invalidHeight	: 'Høyde må være et tall.',
		invalidWidth	: 'Bredde må være et tall.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, utilgjenglig</span>'
	},

	contextmenu :
	{
		options : 'Alternativer for høyreklikkmeny'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Sett inn spesialtegn',
		title		: 'Velg spesialtegn',
		options : 'Alternativer for spesialtegn'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Sett inn/Rediger lenke',
		other 		: '<annen>',
		menu		: 'Rediger lenke',
		title		: 'Lenke',
		info		: 'Lenkeinfo',
		target		: 'Mål',
		upload		: 'Last opp',
		advanced	: 'Avansert',
		type		: 'Lenketype',
		toUrl		: 'URL',
		toAnchor	: 'Lenke til anker i teksten',
		toEmail		: 'E-post',
		targetFrame		: '<ramme>',
		targetPopup		: '<popup-vindu>',
		targetFrameName	: 'Målramme',
		targetPopupName	: 'Navn på popup-vindu',
		popupFeatures	: 'Egenskaper for popup-vindu',
		popupResizable	: 'Skalerbar',
		popupStatusBar	: 'Statuslinje',
		popupLocationBar: 'Adresselinje',
		popupToolbar	: 'Verktøylinje',
		popupMenuBar	: 'Menylinje',
		popupFullScreen	: 'Fullskjerm (IE)',
		popupScrollBars	: 'Scrollbar',
		popupDependent	: 'Avhenging (Netscape)',
		popupLeft		: 'Venstre posisjon',
		popupTop		: 'Topp-posisjon',
		id				: 'Id',
		langDir			: 'Språkretning',
		langDirLTR		: 'Venstre til høyre (VTH)',
		langDirRTL		: 'Høyre til venstre (HTV)',
		acccessKey		: 'Aksessknapp',
		name			: 'Navn',
		langCode			: 'Språkkode',
		tabIndex			: 'Tabindeks',
		advisoryTitle		: 'Tittel',
		advisoryContentType	: 'Type',
		cssClasses		: 'Stilarkklasser',
		charset			: 'Lenket tegnsett',
		styles			: 'Stil',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Velg et anker',
		anchorName		: 'Anker etter navn',
		anchorId			: 'Element etter ID',
		emailAddress		: 'E-postadresse',
		emailSubject		: 'Meldingsemne',
		emailBody		: 'Melding',
		noAnchors		: '(Ingen anker i dokumentet)',
		noUrl			: 'Vennligst skriv inn lenkens URL',
		noEmail			: 'Vennligst skriv inn e-postadressen'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Sett inn/Rediger anker',
		menu		: 'Egenskaper for anker',
		title		: 'Egenskaper for anker',
		name		: 'Ankernavn',
		errorName	: 'Vennligst skriv inn ankernavnet'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Egenskaper for nummerert liste',
		bulletedTitle		: 'Egenskaper for punktmerket liste',
		type				: 'Type',
		start				: 'Start',
		validateStartNumber				:'Starten på listen må være et heltall.',
		circle				: 'Sirkel',
		disc				: 'Disk',
		square				: 'Firkant',
		none				: 'Ingen',
		notset				: '<ikke satt>',
		armenian			: 'Armensk nummerering',
		georgian			: 'Georgisk nummerering (an, ban, gan, osv.)',
		lowerRoman			: 'Romertall, små (i, ii, iii, iv, v, osv.)',
		upperRoman			: 'Romertall, store (I, II, III, IV, V, osv.)',
		lowerAlpha			: 'Alfabetisk, små (a, b, c, d, e, osv.)',
		upperAlpha			: 'Alfabetisk, store (A, B, C, D, E, osv.)',
		lowerGreek			: 'Gresk, små (alpha, beta, gamma, osv.)',
		decimal				: 'Tall (1, 2, 3, osv.)',
		decimalLeadingZero	: 'Tall, med førstesiffer null (01, 02, 03, osv.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Søk og erstatt',
		find				: 'Søk',
		replace				: 'Erstatt',
		findWhat			: 'Søk etter:',
		replaceWith			: 'Erstatt med:',
		notFoundMsg			: 'Fant ikke søketeksten.',
		matchCase			: 'Skill mellom store og små bokstaver',
		matchWord			: 'Bare hele ord',
		matchCyclic			: 'Søk i hele dokumentet',
		replaceAll			: 'Erstatt alle',
		replaceSuccessMsg	: '%1 tilfelle(r) erstattet.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabell',
		title		: 'Egenskaper for tabell',
		menu		: 'Egenskaper for tabell',
		deleteTable	: 'Slett tabell',
		rows		: 'Rader',
		columns		: 'Kolonner',
		border		: 'Rammestørrelse',
		widthPx		: 'piksler',
		widthPc		: 'prosent',
		widthUnit	: 'Bredde-enhet',
		cellSpace	: 'Cellemarg',
		cellPad		: 'Cellepolstring',
		caption		: 'Tittel',
		summary		: 'Sammendrag',
		headers		: 'Overskrifter',
		headersNone		: 'Ingen',
		headersColumn	: 'Første kolonne',
		headersRow		: 'Første rad',
		headersBoth		: 'Begge',
		invalidRows		: 'Antall rader må være et tall større enn 0.',
		invalidCols		: 'Antall kolonner må være et tall større enn 0.',
		invalidBorder	: 'Rammestørrelse må være et tall.',
		invalidWidth	: 'Tabellbredde må være et tall.',
		invalidHeight	: 'Tabellhøyde må være et tall.',
		invalidCellSpacing	: 'Cellemarg må være et tall.',
		invalidCellPadding	: 'Cellepolstring må være et tall.',

		cell :
		{
			menu			: 'Celle',
			insertBefore	: 'Sett inn celle før',
			insertAfter		: 'Sett inn celle etter',
			deleteCell		: 'Slett celler',
			merge			: 'Slå sammen celler',
			mergeRight		: 'Slå sammen høyre',
			mergeDown		: 'Slå sammen ned',
			splitHorizontal	: 'Del celle horisontalt',
			splitVertical	: 'Del celle vertikalt',
			title			: 'Celleegenskaper',
			cellType		: 'Celletype',
			rowSpan			: 'Radspenn',
			colSpan			: 'Kolonnespenn',
			wordWrap		: 'Tekstbrytning',
			hAlign			: 'Horisontal justering',
			vAlign			: 'Vertikal justering',
			alignBaseline	: 'Grunnlinje',
			bgColor			: 'Bakgrunnsfarge',
			borderColor		: 'Rammefarge',
			data			: 'Data',
			header			: 'Overskrift',
			yes				: 'Ja',
			no				: 'Nei',
			invalidWidth	: 'Cellebredde må være et tall.',
			invalidHeight	: 'Cellehøyde må være et tall.',
			invalidRowSpan	: 'Radspenn må være et heltall.',
			invalidColSpan	: 'Kolonnespenn må være et heltall.',
			chooseColor		: 'Velg'
		},

		row :
		{
			menu			: 'Rader',
			insertBefore	: 'Sett inn rad før',
			insertAfter		: 'Sett inn rad etter',
			deleteRow		: 'Slett rader'
		},

		column :
		{
			menu			: 'Kolonne',
			insertBefore	: 'Sett inn kolonne før',
			insertAfter		: 'Sett inn kolonne etter',
			deleteColumn	: 'Slett kolonner'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Egenskaper for knapp',
		text		: 'Tekst (verdi)',
		type		: 'Type',
		typeBtn		: 'Knapp',
		typeSbm		: 'Send',
		typeRst		: 'Nullstill'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Egenskaper for avmerkingsboks',
		radioTitle	: 'Egenskaper for alternativknapp',
		value		: 'Verdi',
		selected	: 'Valgt'
	},

	// Form Dialog.
	form :
	{
		title		: 'Egenskaper for skjema',
		menu		: 'Egenskaper for skjema',
		action		: 'Handling',
		method		: 'Metode',
		encoding	: 'Encoding'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Egenskaper for rullegardinliste',
		selectInfo	: 'Info',
		opAvail		: 'Tilgjenglige alternativer',
		value		: 'Verdi',
		size		: 'Størrelse',
		lines		: 'Linjer',
		chkMulti	: 'Tillat flervalg',
		opText		: 'Tekst',
		opValue		: 'Verdi',
		btnAdd		: 'Legg til',
		btnModify	: 'Endre',
		btnUp		: 'Opp',
		btnDown		: 'Ned',
		btnSetValue : 'Sett som valgt',
		btnDelete	: 'Slett'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Egenskaper for tekstområde',
		cols		: 'Kolonner',
		rows		: 'Rader'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Egenskaper for tekstfelt',
		name		: 'Navn',
		value		: 'Verdi',
		charWidth	: 'Tegnbredde',
		maxChars	: 'Maks antall tegn',
		type		: 'Type',
		typeText	: 'Tekst',
		typePass	: 'Passord'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Egenskaper for skjult felt',
		name	: 'Navn',
		value	: 'Verdi'
	},

	// Image Dialog.
	image :
	{
		title		: 'Bildeegenskaper',
		titleButton	: 'Egenskaper for bildeknapp',
		menu		: 'Bildeegenskaper',
		infoTab		: 'Bildeinformasjon',
		btnUpload	: 'Send det til serveren',
		upload		: 'Last opp',
		alt			: 'Alternativ tekst',
		lockRatio	: 'Lås forhold',
		unlockRatio	: 'Ikke lås forhold',
		resetSize	: 'Tilbakestill størrelse',
		border		: 'Ramme',
		hSpace		: 'HMarg',
		vSpace		: 'VMarg',
		alertUrl	: 'Vennligst skriv bilde-urlen',
		linkTab		: 'Lenke',
		button2Img	: 'Vil du endre den valgte bildeknappen til et vanlig bilde?',
		img2Button	: 'Vil du endre det valgte bildet til en bildeknapp?',
		urlMissing	: 'Bildets adresse mangler.',
		validateBorder	: 'Ramme må være et heltall.',
		validateHSpace	: 'HMarg må være et heltall.',
		validateVSpace	: 'VMarg må være et heltall.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Egenskaper for Flash-objekt',
		propertiesTab	: 'Egenskaper',
		title			: 'Flash-egenskaper',
		chkPlay			: 'Autospill',
		chkLoop			: 'Loop',
		chkMenu			: 'Slå på Flash-meny',
		chkFull			: 'Tillat fullskjerm',
 		scale			: 'Skaler',
		scaleAll		: 'Vis alt',
		scaleNoBorder	: 'Ingen ramme',
		scaleFit		: 'Skaler til å passe',
		access			: 'Scripttilgang',
		accessAlways	: 'Alltid',
		accessSameDomain: 'Samme domene',
		accessNever		: 'Aldri',
		alignAbsBottom	: 'Abs bunn',
		alignAbsMiddle	: 'Abs midten',
		alignBaseline	: 'Bunnlinje',
		alignTextTop	: 'Tekst topp',
		quality			: 'Kvalitet',
		qualityBest		: 'Best',
		qualityHigh		: 'Høy',
		qualityAutoHigh	: 'Auto høy',
		qualityMedium	: 'Medium',
		qualityAutoLow	: 'Auto lav',
		qualityLow		: 'Lav',
		windowModeWindow: 'Vindu',
		windowModeOpaque: 'Opaque',
		windowModeTransparent : 'Gjennomsiktig',
		windowMode		: 'Vindumodus',
		flashvars		: 'Variabler for flash',
		bgcolor			: 'Bakgrunnsfarge',
		hSpace			: 'HMarg',
		vSpace			: 'VMarg',
		validateSrc		: 'Vennligst skriv inn lenkens url.',
		validateHSpace	: 'HMarg må være et tall.',
		validateVSpace	: 'VMarg må være et tall.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Stavekontroll',
		title			: 'Stavekontroll',
		notAvailable	: 'Beklager, tjenesten er utilgjenglig nå.',
		errorLoading	: 'Feil under lasting av applikasjonstjenestetjener: %s.',
		notInDic		: 'Ikke i ordboken',
		changeTo		: 'Endre til',
		btnIgnore		: 'Ignorer',
		btnIgnoreAll	: 'Ignorer alle',
		btnReplace		: 'Erstatt',
		btnReplaceAll	: 'Erstatt alle',
		btnUndo			: 'Angre',
		noSuggestions	: '- Ingen forslag -',
		progress		: 'Stavekontroll pågår...',
		noMispell		: 'Stavekontroll fullført: ingen feilstavinger funnet',
		noChanges		: 'Stavekontroll fullført: ingen ord endret',
		oneChange		: 'Stavekontroll fullført: Ett ord endret',
		manyChanges		: 'Stavekontroll fullført: %1 ord endret',
		ieSpellDownload	: 'Stavekontroll er ikke installert. Vil du laste den ned nå?'
	},

	smiley :
	{
		toolbar	: 'Smil',
		title	: 'Sett inn smil',
		options : 'Alternativer for smil'
	},

	elementsPath :
	{
		eleLabel : 'Element-sti',
		eleTitle : '%1 element'
	},

	numberedlist	: 'Legg til/Fjern nummerert liste',
	bulletedlist	: 'Legg til/Fjern punktmerket liste',
	indent			: 'Øk innrykk',
	outdent			: 'Reduser innrykk',

	justify :
	{
		left	: 'Venstrejuster',
		center	: 'Midtstill',
		right	: 'Høyrejuster',
		block	: 'Blokkjuster'
	},

	blockquote : 'Sitatblokk',

	clipboard :
	{
		title		: 'Lim inn',
		cutError	: 'Din nettlesers sikkerhetsinstillinger tillater ikke automatisk klipping av tekst. Vennligst bruk snareveien (Ctrl/Cmd+X).',
		copyError	: 'Din nettlesers sikkerhetsinstillinger tillater ikke automatisk kopiering av tekst. Vennligst bruk snareveien (Ctrl/Cmd+C).',
		pasteMsg	: 'Vennligst lim inn i følgende boks med tastaturet (<STRONG>Ctrl/Cmd+V</STRONG>) og trykk <STRONG>OK</STRONG>.',
		securityMsg	: 'Din nettlesers sikkerhetsinstillinger gir ikke redigeringsverktøyet direkte tilgang til utklippstavlen. Du må derfor lime det inn på nytt i dette vinduet.',
		pasteArea	: 'Innlimingsområde'
	},

	pastefromword :
	{
		confirmCleanup	: 'Teksten du limer inn ser ut til å være kopiert fra Word. Vil du renske den før du limer den inn?',
		toolbar			: 'Lim inn fra Word',
		title			: 'Lim inn fra Word',
		error			: 'Det var ikke mulig å renske den innlimte teksten på grunn av en intern feil'
	},

	pasteText :
	{
		button	: 'Lim inn som ren tekst',
		title	: 'Lim inn som ren tekst'
	},

	templates :
	{
		button			: 'Maler',
		title			: 'Innholdsmaler',
		options : 'Alternativer for mal',
		insertOption	: 'Erstatt gjeldende innhold',
		selectPromptMsg	: 'Velg malen du vil åpne i redigeringsverktøyet:',
		emptyListMsg	: '(Ingen maler definert)'
	},

	showBlocks : 'Vis blokker',

	stylesCombo :
	{
		label		: 'Stil',
		panelTitle	: 'Stilformater',
		panelTitle1	: 'Blokkstiler',
		panelTitle2	: 'Inlinestiler',
		panelTitle3	: 'Objektstiler'
	},

	format :
	{
		label		: 'Format',
		panelTitle	: 'Avsnittsformat',

		tag_p		: 'Normal',
		tag_pre		: 'Formatert',
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
		title				: 'Sett inn Div Container',
		toolbar				: 'Sett inn Div Container',
		cssClassInputLabel	: 'Stilark-klasser',
		styleSelectLabel	: 'Stil',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Språkkode',
		inlineStyleInputLabel	: 'Inlinestiler',
		advisoryTitleInputLabel	: 'Tittel',
		langDirLabel		: 'Språkretning',
		langDirLTRLabel		: 'Venstre til høyre (VTH)',
		langDirRTLLabel		: 'Høyre til venstre (HTV)',
		edit				: 'Rediger Div',
		remove				: 'Fjern Div'
  	},

	iframe :
	{
		title		: 'Egenskaper for IFrame',
		toolbar		: 'IFrame',
		noUrl		: 'Vennligst skriv inn URL for iframe',
		scrolling	: 'Aktiver scrollefelt',
		border		: 'Viss ramme rundt iframe'
	},

	font :
	{
		label		: 'Skrift',
		voiceLabel	: 'Font',
		panelTitle	: 'Skrift'
	},

	fontSize :
	{
		label		: 'Størrelse',
		voiceLabel	: 'Font Størrelse',
		panelTitle	: 'Størrelse'
	},

	colorButton :
	{
		textColorTitle	: 'Tekstfarge',
		bgColorTitle	: 'Bakgrunnsfarge',
		panelTitle		: 'Farger',
		auto			: 'Automatisk',
		more			: 'Flere farger...'
	},

	colors :
	{
		'000' : 'Svart',
		'800000' : 'Rødbrun',
		'8B4513' : 'Salbrun',
		'2F4F4F' : 'Grønnsvart',
		'008080' : 'Blågrønn',
		'000080' : 'Marineblått',
		'4B0082' : 'Indigo',
		'696969' : 'Mørk grå',
		'B22222' : 'Mørkerød',
		'A52A2A' : 'Brun',
		'DAA520' : 'Lys brun',
		'006400' : 'Mørk grønn',
		'40E0D0' : 'Turkis',
		'0000CD' : 'Medium blå',
		'800080' : 'Purpur',
		'808080' : 'Grå',
		'F00' : 'Rød',
		'FF8C00' : 'Mørk oransje',
		'FFD700' : 'Gull',
		'008000' : 'Grønn',
		'0FF' : 'Cyan',
		'00F' : 'Blå',
		'EE82EE' : 'Fiolett',
		'A9A9A9' : 'Svak grå',
		'FFA07A' : 'Rosa-oransje',
		'FFA500' : 'Oransje',
		'FFFF00' : 'Gul',
		'00FF00' : 'Lime',
		'AFEEEE' : 'Svak turkis',
		'ADD8E6' : 'Lys Blå',
		'DDA0DD' : 'Plomme',
		'D3D3D3' : 'Lys grå',
		'FFF0F5' : 'Svak lavendelrosa',
		'FAEBD7' : 'Antikk-hvit',
		'FFFFE0' : 'Lys gul',
		'F0FFF0' : 'Honningmelon',
		'F0FFFF' : 'Svakt asurblått',
		'F0F8FF' : 'Svak cyan',
		'E6E6FA' : 'Lavendel',
		'FFF' : 'Hvit'
	},

	scayt :
	{
		title			: 'Stavekontroll mens du skriver',
		opera_title		: 'Ikke støttet av Opera',
		enable			: 'Slå på SCAYT',
		disable			: 'Slå av SCAYT',
		about			: 'Om SCAYT',
		toggle			: 'Veksle SCAYT',
		options			: 'Valg',
		langs			: 'Språk',
		moreSuggestions	: 'Flere forslag',
		ignore			: 'Ignorer',
		ignoreAll		: 'Ignorer Alle',
		addWord			: 'Legg til ord',
		emptyDic		: 'Ordboknavn bør ikke være tom.',

		optionsTab		: 'Valg',
		allCaps			: 'Ikke kontroller ord med kun store bokstaver',
		ignoreDomainNames : 'Ikke kontroller domenenavn',
		mixedCase		: 'Ikke kontroller ord med blandet små og store bokstaver',
		mixedWithDigits	: 'Ikke kontroller ord som inneholder tall',

		languagesTab	: 'Språk',

		dictionariesTab	: 'Ordbøker',
		dic_field_name	: 'Ordboknavn',
		dic_create		: 'Opprett',
		dic_restore		: 'Gjenopprett',
		dic_delete		: 'Slett',
		dic_rename		: 'Gi nytt navn',
		dic_info		: 'Brukerordboken lagres først i en informasjonskapsel på din maskin, men det er en begrensning på hvor mye som kan lagres her. Når ordboken blir for stor til å lagres i en informasjonskapsel, vil vi i stedet lagre ordboken på vår server. For å lagre din personlige ordbok på vår server, burde du velge et navn for ordboken din. Hvis du allerede har lagret en ordbok, vennligst skriv inn ordbokens navn og klikk på Gjenopprett-knappen.',

		aboutTab		: 'Om'
	},

	about :
	{
		title		: 'Om CKEditor',
		dlgTitle	: 'Om CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'For lisensieringsinformasjon, vennligst besøk vårt nettsted:',
		copy		: 'Copyright &copy; $1. Alle rettigheter reservert.'
	},

	maximize : 'Maksimer',
	minimize : 'Minimer',

	fakeobjects :
	{
		anchor		: 'Anker',
		flash		: 'Flash-animasjon',
		iframe		: 'IFrame',
		hiddenfield	: 'Skjult felt',
		unknown		: 'Ukjent objekt'
	},

	resize : 'Dra for å skalere',

	colordialog :
	{
		title		: 'Velg farge',
		options	:	'Alternativer for farge',
		highlight	: 'Merk',
		selected	: 'Valgt',
		clear		: 'Tøm'
	},

	toolbarCollapse	: 'Skjul verktøylinje',
	toolbarExpand	: 'Vis verktøylinje',

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
		ltr : 'Tekstretning fra venstre til høyre',
		rtl : 'Tekstretning fra høyre til venstre'
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
