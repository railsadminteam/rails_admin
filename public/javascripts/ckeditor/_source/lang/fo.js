/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Faroese language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['fo'] =
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
	source			: 'Kelda',
	newPage			: 'Nýggj síða',
	save			: 'Goym',
	preview			: 'Frumsýning',
	cut				: 'Kvett',
	copy			: 'Avrita',
	paste			: 'Innrita',
	print			: 'Prenta',
	underline		: 'Undirstrikað',
	bold			: 'Feit skrift',
	italic			: 'Skráskrift',
	selectAll		: 'Markera alt',
	removeFormat	: 'Strika sniðgeving',
	strike			: 'Yvirstrikað',
	subscript		: 'Lækkað skrift',
	superscript		: 'Hækkað skrift',
	horizontalrule	: 'Ger vatnrætta linju',
	pagebreak		: 'Ger síðuskift',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Strika tilknýti',
	undo			: 'Angra',
	redo			: 'Vend aftur',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Ambætarakagi',
		url				: 'URL',
		protocol		: 'Protokoll',
		upload			: 'Send til ambætaran',
		uploadSubmit	: 'Send til ambætaran',
		image			: 'Myndir',
		flash			: 'Flash',
		form			: 'Formur',
		checkbox		: 'Flugubein',
		radio			: 'Radioknøttur',
		textField		: 'Tekstteigur',
		textarea		: 'Tekstumráði',
		hiddenField		: 'Fjaldur teigur',
		button			: 'Knøttur',
		select			: 'Valskrá',
		imageButton		: 'Myndaknøttur',
		notSet			: '<ikki sett>',
		id				: 'Id',
		name			: 'Navn',
		langDir			: 'Tekstkós',
		langDirLtr		: 'Frá vinstru til høgru (LTR)',
		langDirRtl		: 'Frá høgru til vinstru (RTL)',
		langCode		: 'Málkoda',
		longDescr		: 'Víðkað URL frágreiðing',
		cssClass		: 'Typografi klassar',
		advisoryTitle	: 'Vegleiðandi heiti',
		cssStyle		: 'Typografi',
		ok				: 'Góðkent',
		cancel			: 'Avlýst',
		close			: 'Lat aftur',
		preview			: 'Frumsýn',
		generalTab		: 'Generelt',
		advancedTab		: 'Fjølbroytt',
		validateNumberFailed : 'Hetta er ikki eitt tal.',
		confirmNewPage	: 'Allar ikki goymdar broytingar í hesum innihaldi hvørva. Skal nýggj síða lesast kortini?',
		confirmCancel	: 'Nakrir valmøguleikar eru broyttir. Ert tú vísur í, at dialogurin skal latast aftur?',
		options			: 'Options', // MISSING
		target			: 'Target', // MISSING
		targetNew		: 'Nýtt vindeyga (_blank)',
		targetTop		: 'Vindeyga ovast (_top)',
		targetSelf		: 'Sama vindeyga (_self)',
		targetParent	: 'Upphavligt vindeyga (_parent)',
		langDirLTR		: 'Left to Right (LTR)', // MISSING
		langDirRTL		: 'Right to Left (RTL)', // MISSING
		styles			: 'Style', // MISSING
		cssClasses		: 'Stylesheet Classes', // MISSING
		width			: 'Breidd',
		height			: 'Hædd',
		align			: 'Justering',
		alignLeft		: 'Vinstra',
		alignRight		: 'Høgra',
		alignCenter		: 'Miðsett',
		alignTop		: 'Ovast',
		alignMiddle		: 'Miðja',
		alignBottom		: 'Botnur',
		invalidHeight	: 'Hædd má vera eitt tal.',
		invalidWidth	: 'Breidd má vera eitt tal.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, ikki tøkt</span>'
	},

	contextmenu :
	{
		options : 'Context Menu Options' // MISSING
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Set inn sertekn',
		title		: 'Vel sertekn',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Ger/broyt tilknýti',
		other 		: '<other>', // MISSING
		menu		: 'Broyt tilknýti',
		title		: 'Tilknýti',
		info		: 'Tilknýtis upplýsingar',
		target		: 'Target', // MISSING
		upload		: 'Send til ambætaran',
		advanced	: 'Fjølbroytt',
		type		: 'Tilknýtisslag',
		toUrl		: 'URL',
		toAnchor	: 'Tilknýti til marknastein í tekstinum',
		toEmail		: 'Teldupostur',
		targetFrame		: '<ramma>',
		targetPopup		: '<popup vindeyga>',
		targetFrameName	: 'Vís navn vindeygans',
		targetPopupName	: 'Popup vindeygans navn',
		popupFeatures	: 'Popup vindeygans víðkaðu eginleikar',
		popupResizable	: 'Resizable', // MISSING
		popupStatusBar	: 'Støðufrágreiðingarbjálki',
		popupLocationBar: 'Adressulinja',
		popupToolbar	: 'Amboðsbjálki',
		popupMenuBar	: 'Skrábjálki',
		popupFullScreen	: 'Fullur skermur (IE)',
		popupScrollBars	: 'Rullibjálki',
		popupDependent	: 'Bundið (Netscape)',
		popupLeft		: 'Frástøða frá vinstru',
		popupTop		: 'Frástøða frá íerva',
		id				: 'Id', // MISSING
		langDir			: 'Tekstkós',
		langDirLTR		: 'Frá vinstru til høgru (LTR)',
		langDirRTL		: 'Frá høgru til vinstru (RTL)',
		acccessKey		: 'Snarvegisknappur',
		name			: 'Navn',
		langCode		: 'Tekstkós',
		tabIndex		: 'Inntriv indeks',
		advisoryTitle	: 'Vegleiðandi heiti',
		advisoryContentType	: 'Vegleiðandi innihaldsslag',
		cssClasses		: 'Typografi klassar',
		charset			: 'Atknýtt teknsett',
		styles			: 'Typografi',
		selectAnchor	: 'Vel ein marknastein',
		anchorName		: 'Eftir navni á marknasteini',
		anchorId		: 'Eftir element Id',
		emailAddress	: 'Teldupost-adressa',
		emailSubject	: 'Evni',
		emailBody		: 'Breyðtekstur',
		noAnchors		: '(Eingir marknasteinar eru í hesum dokumentið)',
		noUrl			: 'Vinarliga skriva tilknýti (URL)',
		noEmail			: 'Vinarliga skriva teldupost-adressu'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Ger/broyt marknastein',
		menu		: 'Eginleikar fyri marknastein',
		title		: 'Eginleikar fyri marknastein',
		name		: 'Heiti marknasteinsins',
		errorName	: 'Vinarliga rita marknasteinsins heiti'
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
		title				: 'Finn og broyt',
		find				: 'Leita',
		replace				: 'Yvirskriva',
		findWhat			: 'Finn:',
		replaceWith			: 'Yvirskriva við:',
		notFoundMsg			: 'Leititeksturin varð ikki funnin',
		matchCase			: 'Munur á stórum og smáum bókstavum',
		matchWord			: 'Bert heil orð',
		matchCyclic			: 'Match cyclic', // MISSING
		replaceAll			: 'Yvirskriva alt',
		replaceSuccessMsg	: '%1 úrslit broytt.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabell',
		title		: 'Eginleikar fyri tabell',
		menu		: 'Eginleikar fyri tabell',
		deleteTable	: 'Strika tabell',
		rows		: 'Røðir',
		columns		: 'Kolonnur',
		border		: 'Bordabreidd',
		widthPx		: 'pixels',
		widthPc		: 'prosent',
		widthUnit	: 'breiddar unit',
		cellSpace	: 'Fjarstøða millum meskar',
		cellPad		: 'Meskubreddi',
		caption		: 'Tabellfrágreiðing',
		summary		: 'Samandráttur',
		headers		: 'Headers', // MISSING
		headersNone		: 'Eingin',
		headersColumn	: 'Fyrsta kolonna',
		headersRow		: 'Fyrsta rað',
		headersBoth		: 'Báðir',
		invalidRows		: 'Talið av røðum má vera eitt tal størri enn 0.',
		invalidCols		: 'Talið av kolonnum má vera eitt tal størri enn 0.',
		invalidBorder	: 'Borda-stødd má vera eitt tal.',
		invalidWidth	: 'Tabell-breidd má vera eitt tal.',
		invalidHeight	: 'Tabell-hædd má vera eitt tal.',
		invalidCellSpacing	: 'Cell spacing má vera eitt tal.',
		invalidCellPadding	: 'Cell padding má vera eitt tal.',

		cell :
		{
			menu			: 'Meski',
			insertBefore	: 'Set meska inn áðrenn',
			insertAfter		: 'Set meska inn aftaná',
			deleteCell		: 'Strika meskar',
			merge			: 'Flætta meskar',
			mergeRight		: 'Flætta meskar til høgru',
			mergeDown		: 'Flætta saman',
			splitHorizontal	: 'Kloyv meska vatnrætt',
			splitVertical	: 'Kloyv meska loddrætt',
			title			: 'Mesku eginleikar',
			cellType		: 'Mesku slag',
			rowSpan			: 'Ræð spenni',
			colSpan			: 'Kolonnu spenni',
			wordWrap		: 'Word Wrap', // MISSING
			hAlign			: 'Horisontal plasering',
			vAlign			: 'Loddrøtt plasering',
			alignBaseline	: 'Basislinja',
			bgColor			: 'Bakgrundslitur',
			borderColor		: 'Bordalitur',
			data			: 'Data',
			header			: 'Header',
			yes				: 'Ja',
			no				: 'Nei',
			invalidWidth	: 'Meskubreidd má vera eitt tal.',
			invalidHeight	: 'Meskuhædd má vera eitt tal.',
			invalidRowSpan	: 'Raðspennið má vera eitt heiltal.',
			invalidColSpan	: 'Kolonnuspennið má vera eitt heiltal.',
			chooseColor		: 'Vel'
		},

		row :
		{
			menu			: 'Rað',
			insertBefore	: 'Set rað inn áðrenn',
			insertAfter		: 'Set rað inn aftaná',
			deleteRow		: 'Strika røðir'
		},

		column :
		{
			menu			: 'Kolonna',
			insertBefore	: 'Set kolonnu inn áðrenn',
			insertAfter		: 'Set kolonnu inn aftaná',
			deleteColumn	: 'Strika kolonnur'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Eginleikar fyri knøtt',
		text		: 'Tekstur',
		type		: 'Slag',
		typeBtn		: 'Knøttur',
		typeSbm		: 'Send',
		typeRst		: 'Nullstilla'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Eginleikar fyri flugubein',
		radioTitle	: 'Eginleikar fyri radioknøtt',
		value		: 'Virði',
		selected	: 'Valt'
	},

	// Form Dialog.
	form :
	{
		title		: 'Eginleikar fyri Form',
		menu		: 'Eginleikar fyri Form',
		action		: 'Hending',
		method		: 'Háttur',
		encoding	: 'Encoding' // MISSING
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Eginleikar fyri valskrá',
		selectInfo	: 'Upplýsingar',
		opAvail		: 'Tøkir møguleikar',
		value		: 'Virði',
		size		: 'Stødd',
		lines		: 'Linjur',
		chkMulti	: 'Loyv fleiri valmøguleikum samstundis',
		opText		: 'Tekstur',
		opValue		: 'Virði',
		btnAdd		: 'Legg afturat',
		btnModify	: 'Broyt',
		btnUp		: 'Upp',
		btnDown		: 'Niður',
		btnSetValue : 'Set sum valt virði',
		btnDelete	: 'Strika'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Eginleikar fyri tekstumráði',
		cols		: 'kolonnur',
		rows		: 'røðir'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Eginleikar fyri tekstteig',
		name		: 'Navn',
		value		: 'Virði',
		charWidth	: 'Breidd (sjónlig tekn)',
		maxChars	: 'Mest loyvdu tekn',
		type		: 'Slag',
		typeText	: 'Tekstur',
		typePass	: 'Loyniorð'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Eginleikar fyri fjaldan teig',
		name	: 'Navn',
		value	: 'Virði'
	},

	// Image Dialog.
	image :
	{
		title		: 'Myndaeginleikar',
		titleButton	: 'Eginleikar fyri myndaknøtt',
		menu		: 'Myndaeginleikar',
		infoTab		: 'Myndaupplýsingar',
		btnUpload	: 'Send til ambætaran',
		upload		: 'Send',
		alt			: 'Alternativur tekstur',
		lockRatio	: 'Læs lutfallið',
		unlockRatio	: 'Lutfallið ikki læst',
		resetSize	: 'Upprunastødd',
		border		: 'Bordi',
		hSpace		: 'Høgri breddi',
		vSpace		: 'Vinstri breddi',
		alertUrl	: 'Rita slóðina til myndina',
		linkTab		: 'Tilknýti',
		button2Img	: 'Do you want to transform the selected image button on a simple image?', // MISSING
		img2Button	: 'Do you want to transform the selected image on a image button?', // MISSING
		urlMissing	: 'URL til mynd manglar.',
		validateBorder	: 'Bordi má vera eitt heiltal.',
		validateHSpace	: 'HSpace má vera eitt heiltal.',
		validateVSpace	: 'VSpace má vera eitt heiltal.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Flash eginleikar',
		propertiesTab	: 'Eginleikar',
		title			: 'Flash eginleikar',
		chkPlay			: 'Avspælingin byrjar sjálv',
		chkLoop			: 'Endurspæl',
		chkMenu			: 'Ger Flash skrá virkna',
		chkFull			: 'Loyv fullan skerm',
 		scale			: 'Skalering',
		scaleAll		: 'Vís alt',
		scaleNoBorder	: 'Eingin bordi',
		scaleFit		: 'Neyv skalering',
		access			: 'Script atgongd',
		accessAlways	: 'Altíð',
		accessSameDomain: 'Sama navnaøki',
		accessNever		: 'Ongantíð',
		alignAbsBottom	: 'Abs botnur',
		alignAbsMiddle	: 'Abs miðja',
		alignBaseline	: 'Basislinja',
		alignTextTop	: 'Tekst toppur',
		quality			: 'Góðska',
		qualityBest		: 'Besta',
		qualityHigh		: 'Høg',
		qualityAutoHigh	: 'Auto høg',
		qualityMedium	: 'Meðal',
		qualityAutoLow	: 'Auto Lág',
		qualityLow		: 'Lág',
		windowModeWindow: 'Window', // MISSING
		windowModeOpaque: 'Ikki transparent',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Window mode', // MISSING
		flashvars		: 'Variablar fyri Flash',
		bgcolor			: 'Bakgrundslitur',
		hSpace			: 'Høgri breddi',
		vSpace			: 'Vinstri breddi',
		validateSrc		: 'Vinarliga skriva tilknýti (URL)',
		validateHSpace	: 'HSpace má vera eitt tal.',
		validateVSpace	: 'VSpace má vera eitt tal.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Kanna stavseting',
		title			: 'Kanna stavseting',
		notAvailable	: 'Tíverri, ikki tøkt í løtuni.',
		errorLoading	: 'Feilur við innlesing av application service host: %s.',
		notInDic		: 'Finst ikki í orðabókini',
		changeTo		: 'Broyt til',
		btnIgnore		: 'Forfjóna',
		btnIgnoreAll	: 'Forfjóna alt',
		btnReplace		: 'Yvirskriva',
		btnReplaceAll	: 'Yvirskriva alt',
		btnUndo			: 'Angra',
		noSuggestions	: '- Einki uppskot -',
		progress		: 'Rættstavarin arbeiðir...',
		noMispell		: 'Rættstavarain liðugur: Eingin feilur funnin',
		noChanges		: 'Rættstavarain liðugur: Einki orð varð broytt',
		oneChange		: 'Rættstavarain liðugur: Eitt orð er broytt',
		manyChanges		: 'Rættstavarain liðugur: %1 orð broytt',
		ieSpellDownload	: 'Rættstavarin er ikki tøkur í tekstviðgeranum. Vilt tú heinta hann nú?'
	},

	smiley :
	{
		toolbar	: 'Smiley',
		title	: 'Vel Smiley',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Slóð til elementir',
		eleTitle : '%1 element'
	},

	numberedlist	: 'Talmerktur listi',
	bulletedlist	: 'Punktmerktur listi',
	indent			: 'Økja reglubrotarinntriv',
	outdent			: 'Minka reglubrotarinntriv',

	justify :
	{
		left	: 'Vinstrasett',
		center	: 'Miðsett',
		right	: 'Høgrasett',
		block	: 'Javnir tekstkantar'
	},

	blockquote : 'Blockquote',

	clipboard :
	{
		title		: 'Innrita',
		cutError	: 'Trygdaruppseting alnótskagans forðar tekstviðgeranum í at kvetta tekstin. Vinarliga nýt knappaborðið til at kvetta tekstin (Ctrl/Cmd+X).',
		copyError	: 'Trygdaruppseting alnótskagans forðar tekstviðgeranum í at avrita tekstin. Vinarliga nýt knappaborðið til at avrita tekstin (Ctrl/Cmd+C).',
		pasteMsg	: 'Vinarliga koyr tekstin í hendan rútin við knappaborðinum (<strong>Ctrl/Cmd+V</strong>) og klikk á <strong>Góðtak</strong>.',
		securityMsg	: 'Trygdaruppseting alnótskagans forðar tekstviðgeranum í beinleiðis atgongd til avritingarminnið. Tygum mugu royna aftur í hesum rútinum.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'Teksturin, tú roynir at seta inn, sýnist at stava frá Word. Skal teksturin reinsast fyrst?',
		toolbar			: 'Innrita frá Word',
		title			: 'Innrita frá Word',
		error			: 'Tað eyðnaðist ikki at reinsa tekstin vegna ein internan feil'
	},

	pasteText :
	{
		button	: 'Innrita som reinan tekst',
		title	: 'Innrita som reinan tekst'
	},

	templates :
	{
		button			: 'Skabelónir',
		title			: 'Innihaldsskabelónir',
		options : 'Template Options', // MISSING
		insertOption	: 'Yvirskriva núverandi innihald',
		selectPromptMsg	: 'Vinarliga vel ta skabelón, ið skal opnast í tekstviðgeranum<br>(Hetta yvirskrivar núverandi innihald):',
		emptyListMsg	: '(Ongar skabelónir tøkar)'
	},

	showBlocks : 'Vís blokkar',

	stylesCombo :
	{
		label		: 'Typografi',
		panelTitle	: 'Formatterings stílir',
		panelTitle1	: 'Blokk stílir',
		panelTitle2	: 'Inline stílir',
		panelTitle3	: 'Object stílir'
	},

	format :
	{
		label		: 'Skriftsnið',
		panelTitle	: 'Skriftsnið',

		tag_p		: 'Vanligt',
		tag_pre		: 'Sniðgivið',
		tag_address	: 'Adressa',
		tag_h1		: 'Yvirskrift 1',
		tag_h2		: 'Yvirskrift 2',
		tag_h3		: 'Yvirskrift 3',
		tag_h4		: 'Yvirskrift 4',
		tag_h5		: 'Yvirskrift 5',
		tag_h6		: 'Yvirskrift 6',
		tag_div		: 'Normal (DIV)' // MISSING
	},

	div :
	{
		title				: 'Ger Div Container',
		toolbar				: 'Ger Div Container',
		cssClassInputLabel	: 'Stylesheet Classes',
		styleSelectLabel	: 'Style',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Language Code',
		inlineStyleInputLabel	: 'Inline Style',
		advisoryTitleInputLabel	: 'Advisory Title',
		langDirLabel		: 'Language Direction',
		langDirLTRLabel		: 'Vinstru til høgru (LTR)',
		langDirRTLLabel		: 'Høgru til vinstru (RTL)',
		edit				: 'Redigera Div',
		remove				: 'Strika Div'
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
		label		: 'Skrift',
		voiceLabel	: 'Font', // MISSING
		panelTitle	: 'Skrift'
	},

	fontSize :
	{
		label		: 'Skriftstødd',
		voiceLabel	: 'Font Size', // MISSING
		panelTitle	: 'Skriftstødd'
	},

	colorButton :
	{
		textColorTitle	: 'Tekstlitur',
		bgColorTitle	: 'Bakgrundslitur',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automatiskt',
		more			: 'Fleiri litir...'
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
		title			: 'Kanna stavseting, meðan tú skrivar',
		opera_title		: 'Not supported by Opera', // MISSING
		enable			: 'Enable SCAYT',
		disable			: 'Disable SCAYT',
		about			: 'Um SCAYT',
		toggle			: 'Toggle SCAYT',
		options			: 'Uppseting',
		langs			: 'Tungumál',
		moreSuggestions	: 'Fleiri tilráðingar',
		ignore			: 'Ignorera',
		ignoreAll		: 'Ignorera alt',
		addWord			: 'Legg orð afturat',
		emptyDic		: 'Heiti á orðabók eigur ikki at vera tómt.',

		optionsTab		: 'Uppseting',
		allCaps			: 'Ignore All-Caps Words', // MISSING
		ignoreDomainNames : 'Ignore Domain Names', // MISSING
		mixedCase		: 'Ignore Words with Mixed Case', // MISSING
		mixedWithDigits	: 'Ignore Words with Numbers', // MISSING

		languagesTab	: 'Tungumál',

		dictionariesTab	: 'Orðabøkur',
		dic_field_name	: 'Dictionary name', // MISSING
		dic_create		: 'Create', // MISSING
		dic_restore		: 'Restore', // MISSING
		dic_delete		: 'Delete', // MISSING
		dic_rename		: 'Rename', // MISSING
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'Um'
	},

	about :
	{
		title		: 'Um CKEditor',
		dlgTitle	: 'Um CKEditor',
		moreInfo	: 'Licens upplýsingar finnast á heimasíðu okkara:',
		copy		: 'Copyright &copy; $1. All rights reserved.' // MISSING
	},

	maximize : 'Maksimera',
	minimize : 'Minimera',

	fakeobjects :
	{
		anchor		: 'Anchor', // MISSING
		flash		: 'Flash Animation', // MISSING
		iframe		: 'iFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Ókent Object'
	},

	resize : 'Drag fyri at broyta stødd',

	colordialog :
	{
		title		: 'Vel lit',
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
