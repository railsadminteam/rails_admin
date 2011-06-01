﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
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
	editorTitle : 'Rich text editor, %1, trýst ALT og 0 fyri vegleiðing.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Rich Text Editor',

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
	pagebreakAlt		: 'Síðuskift',
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
		confirmNewPage	: 'Allar ikki goymdar broytingar í hesum innihaldið hvørva. Skal nýggj síða lesast kortini?',
		confirmCancel	: 'Nakrir valmøguleikar eru broyttir. Ert tú vísur í, at dialogurin skal latast aftur?',
		options			: 'Options',
		target			: 'Target',
		targetNew		: 'Nýtt vindeyga (_blank)',
		targetTop		: 'Vindeyga ovast (_top)',
		targetSelf		: 'Sama vindeyga (_self)',
		targetParent	: 'Upphavligt vindeyga (_parent)',
		langDirLTR		: 'Frá vinstru til høgru (LTR)',
		langDirRTL		: 'Frá høgru til vinstru (RTL)',
		styles			: 'Style',
		cssClasses		: 'Stylesheet Classes',
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
		options : 'Context Menu Options'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Set inn sertekn',
		title		: 'Vel sertekn',
		options : 'Møguleikar við serteknum'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Ger/broyt tilknýti',
		other 		: '<annað>',
		menu		: 'Broyt tilknýti',
		title		: 'Tilknýti',
		info		: 'Tilknýtis upplýsingar',
		target		: 'Target',
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
		popupResizable	: 'Stødd kann broytast',
		popupStatusBar	: 'Støðufrágreiðingarbjálki',
		popupLocationBar: 'Adressulinja',
		popupToolbar	: 'Amboðsbjálki',
		popupMenuBar	: 'Skrábjálki',
		popupFullScreen	: 'Fullur skermur (IE)',
		popupScrollBars	: 'Rullibjálki',
		popupDependent	: 'Bundið (Netscape)',
		popupLeft		: 'Frástøða frá vinstru',
		popupTop		: 'Frástøða frá íerva',
		id				: 'Id',
		langDir			: 'Tekstkós',
		langDirLTR		: 'Frá vinstru til høgru (LTR)',
		langDirRTL		: 'Frá høgru til vinstru (RTL)',
		acccessKey		: 'Snarvegisknöttur',
		name			: 'Navn',
		langCode			: 'Tekstkós',
		tabIndex			: 'Tabulator indeks',
		advisoryTitle		: 'Vegleiðandi heiti',
		advisoryContentType	: 'Vegleiðandi innihaldsslag',
		cssClasses		: 'Typografi klassar',
		charset			: 'Atknýtt teknsett',
		styles			: 'Typografi',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Vel ein marknastein',
		anchorName		: 'Eftir navni á marknasteini',
		anchorId			: 'Eftir element Id',
		emailAddress		: 'Teldupost-adressa',
		emailSubject		: 'Evni',
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
		numberedTitle		: 'Eginleikar fyri lista við tølum',
		bulletedTitle		: 'Eginleikar fyri lista við prikkum',
		type				: 'Slag',
		start				: 'Byrjan',
		validateStartNumber				:'Byrjunartalið fyri lista má vera eitt heiltal.',
		circle				: 'Sirkul',
		disc				: 'Disc',
		square				: 'Fýrkantur',
		none				: 'Einki',
		notset				: '<ikki sett>',
		armenian			: 'Armensk talskipan',
		georgian			: 'Georgisk talskipan (an, ban, gan, osv.)',
		lowerRoman			: 'Lítil rómaratøl (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Stór rómaratøl (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Lítlir bókstavir (a, b, c, d, e, etc.)',
		upperAlpha			: 'Stórir bókstavir (A, B, C, D, E, etc.)',
		lowerGreek			: 'Grikskt við lítlum (alpha, beta, gamma, etc.)',
		decimal				: 'Vanlig tøl (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Tøl við null frammanfyri (01, 02, 03, etc.)'
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
		matchCyclic			: 'Match cyclic',
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
		headers		: 'Yvirskriftir',
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
			wordWrap		: 'Orðkloyving',
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
		encoding	: 'Encoding'
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
		button2Img	: 'Skal valdi myndaknøttur gerast til vanliga mynd?',
		img2Button	: 'Skal valda mynd gerast til myndaknøtt?',
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
		windowModeWindow: 'Rútur',
		windowModeOpaque: 'Ikki transparent',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Slag av rúti',
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
		options : 'Møguleikar fyri Smiley'
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
		pasteArea	: 'Avritingarumráði'
	},

	pastefromword :
	{
		confirmCleanup	: 'Teksturin, tú roynir at seta inn, sýnist at stava frá Word. Skal teksturin reinsast fyrst?',
		toolbar			: 'Innrita frá Word',
		title			: 'Innrita frá Word',
		error			: 'Tað eydnaðist ikki at reinsa tekstin vegna ein internan feil'
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
		options : 'Møguleikar fyri Template',
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
		tag_div		: 'Vanligt (DIV)'
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
		title		: 'Møguleikar fyri IFrame',
		toolbar		: 'IFrame',
		noUrl		: 'Vinarliga skriva URL til iframe',
		scrolling	: 'Loyv scrollbars',
		border		: 'Vís frame kant'
	},

	font :
	{
		label		: 'Skrift',
		voiceLabel	: 'Skrift',
		panelTitle	: 'Skrift'
	},

	fontSize :
	{
		label		: 'Skriftstødd',
		voiceLabel	: 'Skriftstødd',
		panelTitle	: 'Skriftstødd'
	},

	colorButton :
	{
		textColorTitle	: 'Tekstlitur',
		bgColorTitle	: 'Bakgrundslitur',
		panelTitle		: 'Litir',
		auto			: 'Automatiskt',
		more			: 'Fleiri litir...'
	},

	colors :
	{
		'000' : 'Svart',
		'800000' : 'Maroon',
		'8B4513' : 'Saðilsbrúnt',
		'2F4F4F' : 'Dark Slate Gray',
		'008080' : 'Teal',
		'000080' : 'Navy',
		'4B0082' : 'Indigo',
		'696969' : 'Myrkagrátt',
		'B22222' : 'Fire Brick',
		'A52A2A' : 'Brúnt',
		'DAA520' : 'Gullstavur',
		'006400' : 'Myrkagrønt',
		'40E0D0' : 'Turquoise',
		'0000CD' : 'Meðal blátt',
		'800080' : 'Purple',
		'808080' : 'Grátt',
		'F00' : 'Reytt',
		'FF8C00' : 'Myrkt appelsingult',
		'FFD700' : 'Gull',
		'008000' : 'Grønt',
		'0FF' : 'Cyan',
		'00F' : 'Blátt',
		'EE82EE' : 'Violet',
		'A9A9A9' : 'Døkt grátt',
		'FFA07A' : 'Ljósur laksur',
		'FFA500' : 'Appelsingult',
		'FFFF00' : 'Gult',
		'00FF00' : 'Lime',
		'AFEEEE' : 'Pale Turquoise',
		'ADD8E6' : 'Ljósablátt',
		'DDA0DD' : 'Plum',
		'D3D3D3' : 'Ljósagrátt',
		'FFF0F5' : 'Lavender Blush',
		'FAEBD7' : 'Klassiskt hvítt',
		'FFFFE0' : 'Ljósagult',
		'F0FFF0' : 'Hunangsdøggur',
		'F0FFFF' : 'Azure',
		'F0F8FF' : 'Alice Blátt',
		'E6E6FA' : 'Lavender',
		'FFF' : 'Hvítt'
	},

	scayt :
	{
		title			: 'Kanna stavseting, meðan tú skrivar',
		opera_title		: 'Ikki stuðlað í Opera',
		enable			: 'Loyv SCAYT',
		disable			: 'Nokta SCAYT',
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
		allCaps			: 'Loyp orð við bert stórum stavum um',
		ignoreDomainNames : 'loyp økisnøvn um',
		mixedCase		: 'Loyp orð við blandaðum smáum og stórum stavum um',
		mixedWithDigits	: 'Loyp orð við tølum um',

		languagesTab	: 'Tungumál',

		dictionariesTab	: 'Orðabøkur',
		dic_field_name	: 'Orðabókanavn',
		dic_create		: 'Upprætta nýggja',
		dic_restore		: 'Endurskapa',
		dic_delete		: 'Strika',
		dic_rename		: 'Broyt',
		dic_info		: 'Upprunaliga er brúkara-orðabókin goymd í eini cookie í tínum egna kaga. Men hesar eru avmarkaðar í stødd. Tá brúkara-orðabókin veksur seg ov stóra til eina cookie, so er møguligt at goyma hana á ambætara okkara. Fyri at goyma persónligu orðabókina á ambætaranum eigur tú at velja eitt navn til tína skuffu. Hevur tú longu goymt eina orðabók, so vinarliga skriva navnið og klikk á knøttin Endurskapa.',

		aboutTab		: 'Um'
	},

	about :
	{
		title		: 'Um CKEditor',
		dlgTitle	: 'Um CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Licens upplýsingar finnast á heimasíðu okkara:',
		copy		: 'Copyright &copy; $1. All rights reserved.'
	},

	maximize : 'Maksimera',
	minimize : 'Minimera',

	fakeobjects :
	{
		anchor		: 'Anchor',
		flash		: 'Flash Animation',
		iframe		: 'IFrame',
		hiddenfield	: 'Fjaldur teigur',
		unknown		: 'Ókent Object'
	},

	resize : 'Drag fyri at broyta stødd',

	colordialog :
	{
		title		: 'Vel lit',
		options	:	'Litmøguleikar',
		highlight	: 'Framheva',
		selected	: 'Valdur litur',
		clear		: 'Strika'
	},

	toolbarCollapse	: 'Lat Toolbar aftur',
	toolbarExpand	: 'Vís Toolbar',

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
		ltr : 'Tekstkós frá vinstru til høgru',
		rtl : 'Tekstkós frá høgru til vinstru'
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
