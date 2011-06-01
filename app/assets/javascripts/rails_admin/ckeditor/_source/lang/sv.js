﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
* @fileOverview
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
	editorTitle : 'Rich text editor, %1, tryck ALT 0 för hjälp.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Rich Text Editor',

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
	pagebreakAlt		: 'Sidbrytning',
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
		cssClass		: 'Stilmall',
		advisoryTitle	: 'Titel',
		cssStyle		: 'Stilmall',
		ok				: 'OK',
		cancel			: 'Avbryt',
		close			: 'Stäng',
		preview			: 'Förhandsgranska',
		generalTab		: 'Allmänt',
		advancedTab		: 'Avancerad',
		validateNumberFailed : 'Värdet är inte ett nummer.',
		confirmNewPage	: 'Alla ändringar i innehållet kommer att förloras. Är du säker på att du vill ladda en ny sida?',
		confirmCancel	: 'Några av de alternativ har ändrats. Är du säker på att stänga dialogrutan?',
		options			: 'Alternativ',
		target			: 'Mål',
		targetNew		: 'Nytt fönster (_blank)',
		targetTop		: 'Översta fönstret (_top)',
		targetSelf		: 'Samma fönster (_self)',
		targetParent	: 'Föregående fönster (_parent)',
		langDirLTR		: 'Vänster till höger (LTR)',
		langDirRTL		: 'Höger till vänster (RTL)',
		styles			: 'Stil',
		cssClasses		: 'Stilmallar',
		width			: 'Bredd',
		height			: 'Höjd',
		align			: 'Justering',
		alignLeft		: 'Vänster',
		alignRight		: 'Höger',
		alignCenter		: 'Centrerad',
		alignTop		: 'Överkant',
		alignMiddle		: 'Mitten',
		alignBottom		: 'Nederkant',
		invalidHeight	: 'Höjd måste vara ett nummer.',
		invalidWidth	: 'Bredd måste vara ett nummer.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, Ej tillgänglig</span>'
	},

	contextmenu :
	{
		options : 'Context Menu Options'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Klistra in utökat tecken',
		title		: 'Välj utökat tecken',
		options : 'Special Character Options'
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
		toUrl		: 'URL',
		toAnchor	: 'Ankare i sidan',
		toEmail		: 'E-post',
		targetFrame		: '<ram>',
		targetPopup		: '<popup-fönster>',
		targetFrameName	: 'Målets ramnamn',
		targetPopupName	: 'Popup-fönstrets namn',
		popupFeatures	: 'Popup-fönstrets egenskaper',
		popupResizable	: 'Resizable',
		popupStatusBar	: 'Statusfält',
		popupLocationBar: 'Adressfält',
		popupToolbar	: 'Verktygsfält',
		popupMenuBar	: 'Menyfält',
		popupFullScreen	: 'Helskärm (endast IE)',
		popupScrollBars	: 'Scrolllista',
		popupDependent	: 'Beroende (endast Netscape)',
		popupLeft		: 'Position från vänster',
		popupTop		: 'Position från sidans topp',
		id				: 'Id',
		langDir			: 'Språkriktning',
		langDirLTR		: 'Vänster till höger (VTH)',
		langDirRTL		: 'Höger till vänster (HTV)',
		acccessKey		: 'Behörighetsnyckel',
		name			: 'Namn',
		langCode			: 'Språkriktning',
		tabIndex			: 'Tabindex',
		advisoryTitle		: 'Titel',
		advisoryContentType	: 'Innehållstyp',
		cssClasses		: 'Stylesheet class',
		charset			: 'Teckenuppställning',
		styles			: 'Stilmall',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Välj ett ankare',
		anchorName		: 'efter ankarnamn',
		anchorId			: 'efter objektid',
		emailAddress		: 'E-postadress',
		emailSubject		: 'Ämne',
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
		numberedTitle		: 'Egenskaper för punktlista',
		bulletedTitle		: 'Egenskaper för punktlista',
		type				: 'Typ',
		start				: 'Start',
		validateStartNumber				:'List start number must be a whole number.',
		circle				: 'Cirkel',
		disc				: 'Disk',
		square				: 'Fyrkant',
		none				: 'Ingen',
		notset				: '<ej angiven>',
		armenian			: 'Armenisk numrering',
		georgian			: 'Georgisk numrering (an, ban, gan, etc.)',
		lowerRoman			: 'Romerska gemener (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Romerska versaler (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Alpha gemener (a, b, c, d, e, etc.)',
		upperAlpha			: 'Alpha versaler (A, B, C, D, E, etc.)',
		lowerGreek			: 'Grekiska gemener (alpha, beta, gamma, etc.)',
		decimal				: 'Decimal (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Decimal nolla (01, 02, 03, etc.)'
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
		matchCyclic			: 'Matcha cykliska',
		replaceAll			: 'Ersätt alla',
		replaceSuccessMsg	: '%1 förekomst(er) ersatta.'
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
		widthUnit	: 'enhet bredd',
		cellSpace	: 'Cellavstånd',
		cellPad		: 'Cellutfyllnad',
		caption		: 'Rubrik',
		summary		: 'Sammanfattning',
		headers		: 'Ruberiker',
		headersNone		: 'Ingen',
		headersColumn	: 'Första kolumnen',
		headersRow		: 'Första raden',
		headersBoth		: 'Båda',
		invalidRows		: 'Antal rader måste vara större än 0.',
		invalidCols		: 'Antal kolumner måste vara ett nummer större än 0.',
		invalidBorder	: 'Ram måste vara ett nummer.',
		invalidWidth	: 'Tabell måste vara ett nummer.',
		invalidHeight	: 'Tabellens höjd måste vara ett nummer.',
		invalidCellSpacing	: 'Luft i cell måste vara ett nummer.',
		invalidCellPadding	: 'Luft i cell måste vara ett nummer.',

		cell :
		{
			menu			: 'Cell',
			insertBefore	: 'Lägg till cell före',
			insertAfter		: 'Lägg till cell efter',
			deleteCell		: 'Radera celler',
			merge			: 'Sammanfoga celler',
			mergeRight		: 'Sammanfoga höger',
			mergeDown		: 'Sammanfoga ner',
			splitHorizontal	: 'Dela cell horisontellt',
			splitVertical	: 'Dela cell vertikalt',
			title			: 'Egenskaper för cell',
			cellType		: 'Celltyp',
			rowSpan			: 'Rad spann',
			colSpan			: 'Kolumnen spann',
			wordWrap		: 'Radbrytning',
			hAlign			: 'Horisontell justering',
			vAlign			: 'Vertikal justering',
			alignBaseline	: 'Baslinje',
			bgColor			: 'Bakgrundsfärg',
			borderColor		: 'Ramfärg',
			data			: 'Data',
			header			: 'Rubrik',
			yes				: 'Ja',
			no				: 'Nej',
			invalidWidth	: 'Cellens bredd måste vara ett nummer.',
			invalidHeight	: 'Cellens höjd måste vara ett nummer.',
			invalidRowSpan	: 'Radutvidgning måste vara ett heltal.',
			invalidColSpan	: 'Kolumn måste vara ett heltal.',
			chooseColor		: 'Välj'
		},

		row :
		{
			menu			: 'Rad',
			insertBefore	: 'Lägg till Rad Före',
			insertAfter		: 'Lägg till rad efter',
			deleteRow		: 'Radera rad'
		},

		column :
		{
			menu			: 'Kolumn',
			insertBefore	: 'Lägg till kolumn före',
			insertAfter		: 'Lägg till kolumn efter',
			deleteColumn	: 'Radera kolumn'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Egenskaper för knapp',
		text		: 'Text (värde)',
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
		encoding	: 'Kodning'
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
		unlockRatio	: 'Lås upp förhållanden',
		resetSize	: 'Återställ storlek',
		border		: 'Kant',
		hSpace		: 'Horis. marginal',
		vSpace		: 'Vert. marginal',
		alertUrl	: 'Var god och ange bildens URL',
		linkTab		: 'Länk',
		button2Img	: 'Vill du omvandla den valda bildknappen på en enkel bild?',
		img2Button	: 'Vill du omvandla den valda bildknappen på en enkel bild?',
		urlMissing	: 'Bildkällans URL saknas.',
		validateBorder	: 'Kantlinje måste vara ett heltal.',
		validateHSpace	: 'HSpace måste vara ett heltal.',
		validateVSpace	: 'VSpace måste vara ett heltal.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Flashegenskaper',
		propertiesTab	: 'Egenskaper',
		title			: 'Flashegenskaper',
		chkPlay			: 'Automatisk uppspelning',
		chkLoop			: 'Upprepa/Loopa',
		chkMenu			: 'Aktivera Flashmeny',
		chkFull			: 'Tillåt helskärm',
 		scale			: 'Skala',
		scaleAll		: 'Visa allt',
		scaleNoBorder	: 'Ingen ram',
		scaleFit		: 'Exakt passning',
		access			: 'Script-tillgång',
		accessAlways	: 'Alltid',
		accessSameDomain: 'Samma domän',
		accessNever		: 'Aldrig',
		alignAbsBottom	: 'Absolut nederkant',
		alignAbsMiddle	: 'Absolut centrering',
		alignBaseline	: 'Baslinje',
		alignTextTop	: 'Text överkant',
		quality			: 'Kvalitet',
		qualityBest		: 'Bäst',
		qualityHigh		: 'Hög',
		qualityAutoHigh	: 'Auto Hög',
		qualityMedium	: 'Medium',
		qualityAutoLow	: 'Auto Låg',
		qualityLow		: 'Låg',
		windowModeWindow: 'Fönster',
		windowModeOpaque: 'Opaque',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Fönsterläge',
		flashvars		: 'Variabler för Flash',
		bgcolor			: 'Bakgrundsfärg',
		hSpace			: 'Horis. marginal',
		vSpace			: 'Vert. marginal',
		validateSrc		: 'Var god ange länkens URL',
		validateHSpace	: 'HSpace måste vara ett nummer.',
		validateVSpace	: 'VSpace måste vara ett nummer.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Stavningskontroll',
		title			: 'Kontrollera stavning',
		notAvailable	: 'Tyvärr är tjänsten ej tillgänglig nu',
		errorLoading	: 'Tjänsten är ej tillgänglig: %s.',
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
		options : 'Smileyinställningar'
	},

	elementsPath :
	{
		eleLabel : 'Elementets sökväg',
		eleTitle : '%1 element'
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

	blockquote : 'Blockcitat',

	clipboard :
	{
		title		: 'Klistra in',
		cutError	: 'Säkerhetsinställningar i Er webläsare tillåter inte åtgården Klipp ut. Använd (Ctrl/Cmd+X) istället.',
		copyError	: 'Säkerhetsinställningar i Er webläsare tillåter inte åtgården Kopiera. Använd (Ctrl/Cmd+C) istället',
		pasteMsg	: 'Var god och klistra in Er text i rutan nedan genom att använda (<STRONG>Ctrl/Cmd+V</STRONG>) klicka sen på <STRONG>OK</STRONG>.',
		securityMsg	: 'På grund av din webbläsares säkerhetsinställningar kan verktyget inte få åtkomst till urklippsdatan. Var god och använd detta fönster istället.',
		pasteArea	: 'Paste Area'
	},

	pastefromword :
	{
		confirmCleanup	: 'Texten du vill klistra in verkar vara kopierad från Word. Vill du rensa innan du klistrar?',
		toolbar			: 'Klistra in från Word',
		title			: 'Klistra in från Word',
		error			: 'Det var inte möjligt att städa upp den inklistrade data på grund av ett internt fel'
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
		options : 'Inställningar för mall',
		insertOption	: 'Ersätt aktuellt innehåll',
		selectPromptMsg	: 'Var god välj en mall att använda med editorn<br>(allt nuvarande innehåll raderas):',
		emptyListMsg	: '(Ingen mall är vald)'
	},

	showBlocks : 'Visa block',

	stylesCombo :
	{
		label		: 'Anpassad stil',
		panelTitle	: 'Formatmallar',
		panelTitle1	: 'Blockstil',
		panelTitle2	: 'Inbäddad stil',
		panelTitle3	: 'Objektets stil'
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
		title				: 'Skapa Div container',
		toolbar				: 'Skapa Div container',
		cssClassInputLabel	: 'Stilmallar',
		styleSelectLabel	: 'Stil',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Språkkod',
		inlineStyleInputLabel	: 'Inline Style',
		advisoryTitleInputLabel	: 'Rådgivande titel',
		langDirLabel		: 'Språkriktning',
		langDirLTRLabel		: 'Vänster till Höger (LTR)',
		langDirRTLLabel		: 'Höger till vänster (RTL)',
		edit				: 'Redigera Div',
		remove				: 'Ta bort Div'
  	},

	iframe :
	{
		title		: 'iFrame Egenskaper',
		toolbar		: 'iFrame',
		noUrl		: 'Skriv in URL för iFrame',
		scrolling	: 'Aktivera rullningslister',
		border		: 'Visa ramkant'
	},

	font :
	{
		label		: 'Typsnitt',
		voiceLabel	: 'Typsnitt',
		panelTitle	: 'Typsnitt'
	},

	fontSize :
	{
		label		: 'Storlek',
		voiceLabel	: 'Teckenstorlek',
		panelTitle	: 'Storlek'
	},

	colorButton :
	{
		textColorTitle	: 'Textfärg',
		bgColorTitle	: 'Bakgrundsfärg',
		panelTitle		: 'Färger',
		auto			: 'Automatisk',
		more			: 'Fler färger...'
	},

	colors :
	{
		'000' : 'Svart',
		'800000' : 'Rödbrun',
		'8B4513' : 'Mörkbrun',
		'2F4F4F' : 'Skiffergrå',
		'008080' : 'Kricka',
		'000080' : 'Marinblå',
		'4B0082' : 'Indigo',
		'696969' : 'Mörkgrå',
		'B22222' : 'Tegelsten',
		'A52A2A' : 'Brun',
		'DAA520' : 'Mörk guld',
		'006400' : 'Mörkgrön',
		'40E0D0' : 'Turkos',
		'0000CD' : 'Medium blå',
		'800080' : 'Lila',
		'808080' : 'Grå',
		'F00' : 'Röd',
		'FF8C00' : 'Mörkorange',
		'FFD700' : 'Guld',
		'008000' : 'Grön',
		'0FF' : 'Turkos',
		'00F' : 'Blå',
		'EE82EE' : 'Violett',
		'A9A9A9' : 'Matt grå',
		'FFA07A' : 'Laxrosa',
		'FFA500' : 'Orange',
		'FFFF00' : 'Gul',
		'00FF00' : 'Lime',
		'AFEEEE' : 'Ljusturkos',
		'ADD8E6' : 'Ljusblå',
		'DDA0DD' : 'Plommon',
		'D3D3D3' : 'Ljusgrå',
		'FFF0F5' : 'Ljus lavender',
		'FAEBD7' : 'Antikvit',
		'FFFFE0' : 'Ljusgul',
		'F0FFF0' : 'Honung',
		'F0FFFF' : 'Azurblå',
		'F0F8FF' : 'Aliceblå',
		'E6E6FA' : 'Lavender',
		'FFF' : 'Vit'
	},

	scayt :
	{
		title			: 'Stavningskontroll medan du skriver',
		opera_title		: 'Stöds ej av Opera',
		enable			: 'Aktivera SCAYT',
		disable			: 'Inaktivera SCAYT',
		about			: 'Om SCAYT',
		toggle			: 'Växla SCAYT',
		options			: 'Inställningar',
		langs			: 'Språk',
		moreSuggestions	: 'Fler förslag',
		ignore			: 'Ignorera',
		ignoreAll		: 'Ignorera alla',
		addWord			: 'Lägg till ord',
		emptyDic		: 'Ordlistans namn får ej vara tomt.',

		optionsTab		: 'Inställningar',
		allCaps			: 'Ignorera alla ord med enbart versaler',
		ignoreDomainNames : 'Ignorera domännamn',
		mixedCase		: 'Ignorera ord med blandat shiftläge',
		mixedWithDigits	: 'Ignorera ord med nummer',

		languagesTab	: 'Språk',

		dictionariesTab	: 'Ordlistor',
		dic_field_name	: 'Ordlistans namn',
		dic_create		: 'Skapa',
		dic_restore		: 'Återställ',
		dic_delete		: 'Ta bort',
		dic_rename		: 'Byt namn',
		dic_info		: 'Inledningsvis lagras ordlistan i en cookie. När ordlista växer till en punkt där det inte kan lagras i en cookie, lagras den på vår server. För att lagra din personliga ordlista på vår server du ska ange ett namn för din ordbok. Om du redan har en lagrad ordbok, skriv namnet och klicka på knappen Återställ.',

		aboutTab		: 'Om'
	},

	about :
	{
		title		: 'Om CKEditor',
		dlgTitle	: 'Om CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'För information av licenciering besök vår hemsida:',
		copy		: 'Copyright &copy; $1. Alla rättigheter reserverade.'
	},

	maximize : 'Maximera',
	minimize : 'Minimera',

	fakeobjects :
	{
		anchor		: 'Ankare',
		flash		: 'Flashanimation',
		iframe		: 'iFrame',
		hiddenfield	: 'Gömt fält',
		unknown		: 'Okänt objekt'
	},

	resize : 'Dra för att ändra storlek',

	colordialog :
	{
		title		: 'Välj färg',
		options	:	'Färgalternativ',
		highlight	: 'Markera',
		selected	: 'Vald färg',
		clear		: 'Rensa'
	},

	toolbarCollapse	: 'Dölj verktygsfält',
	toolbarExpand	: 'Visa verktygsfält',

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
		ltr : 'Text riktning från vänster till höger',
		rtl : 'Text riktning från höger till vänster'
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
