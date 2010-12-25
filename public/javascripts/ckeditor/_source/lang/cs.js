/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Czech language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['cs'] =
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
	source			: 'Zdroj',
	newPage			: 'Nová stránka',
	save			: 'Uložit',
	preview			: 'Náhled',
	cut				: 'Vyjmout',
	copy			: 'Kopírovat',
	paste			: 'Vložit',
	print			: 'Tisk',
	underline		: 'Podtržené',
	bold			: 'Tučné',
	italic			: 'Kurzíva',
	selectAll		: 'Vybrat vše',
	removeFormat	: 'Odstranit formátování',
	strike			: 'Přeškrtnuté',
	subscript		: 'Dolní index',
	superscript		: 'Horní index',
	horizontalrule	: 'Vložit vodorovnou linku',
	pagebreak		: 'Vložit konec stránky',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Odstranit odkaz',
	undo			: 'Zpět',
	redo			: 'Znovu',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Vybrat na serveru',
		url				: 'URL',
		protocol		: 'Protokol',
		upload			: 'Odeslat',
		uploadSubmit	: 'Odeslat na server',
		image			: 'Obrázek',
		flash			: 'Flash',
		form			: 'Formulář',
		checkbox		: 'Zaškrtávací políčko',
		radio			: 'Přepínač',
		textField		: 'Textové pole',
		textarea		: 'Textová oblast',
		hiddenField		: 'Skryté pole',
		button			: 'Tlačítko',
		select			: 'Seznam',
		imageButton		: 'Obrázkové tlačítko',
		notSet			: '<nenastaveno>',
		id				: 'Id',
		name			: 'Jméno',
		langDir			: 'Orientace jazyka',
		langDirLtr		: 'Zleva do prava (LTR)',
		langDirRtl		: 'Zprava do leva (RTL)',
		langCode		: 'Kód jazyka',
		longDescr		: 'Dlouhý popis URL',
		cssClass		: 'Třída stylu',
		advisoryTitle	: 'Pomocný titulek',
		cssStyle		: 'Styl',
		ok				: 'OK',
		cancel			: 'Storno',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'Obecné',
		advancedTab		: 'Rozšířené',
		validateNumberFailed : 'Zadaná hodnota není číselná.',
		confirmNewPage	: 'Jakékoliv neuložené změny obsahu budou ztraceny. Skutečně chete otevrít novou stránku?',
		confirmCancel	: 'Některá z nastavení byla změněna. Skutečně chete zavřít dialogové okno?',
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
		width			: 'Šířka',
		height			: 'Výška',
		align			: 'Zarovnání',
		alignLeft		: 'Vlevo',
		alignRight		: 'Vpravo',
		alignCenter		: 'Na střed',
		alignTop		: 'Nahoru',
		alignMiddle		: 'Na střed',
		alignBottom		: 'Dolů',
		invalidHeight	: 'Zadaná výška musí být číslo.',
		invalidWidth	: 'Zadaná šířka musí být číslo.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, nedostupné</span>'
	},

	contextmenu :
	{
		options : 'Context Menu Options' // MISSING
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Vložit speciální znaky',
		title		: 'Výběr speciálního znaku',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Vložit/změnit odkaz',
		other 		: '<jiný>',
		menu		: 'Změnit odkaz',
		title		: 'Odkaz',
		info		: 'Informace o odkazu',
		target		: 'Cíl',
		upload		: 'Odeslat',
		advanced	: 'Rozšířené',
		type		: 'Typ odkazu',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Kotva v této stránce',
		toEmail		: 'E-Mail',
		targetFrame		: '<rámec>',
		targetPopup		: '<vyskakovací okno>',
		targetFrameName	: 'Název cílového rámu',
		targetPopupName	: 'Název vyskakovacího okna',
		popupFeatures	: 'Vlastnosti vyskakovacího okna',
		popupResizable	: 'Umožňující měnit velikost',
		popupStatusBar	: 'Stavový řádek',
		popupLocationBar: 'Panel umístění',
		popupToolbar	: 'Panel nástrojů',
		popupMenuBar	: 'Panel nabídky',
		popupFullScreen	: 'Celá obrazovka (IE)',
		popupScrollBars	: 'Posuvníky',
		popupDependent	: 'Závislost (Netscape)',
		popupLeft		: 'Levý okraj',
		popupTop		: 'Horní okraj',
		id				: 'Id',
		langDir			: 'Orientace jazyka',
		langDirLTR		: 'Zleva do prava (LTR)',
		langDirRTL		: 'Zprava do leva (RTL)',
		acccessKey		: 'Přístupový klíč',
		name			: 'Jméno',
		langCode		: 'Orientace jazyka',
		tabIndex		: 'Pořadí prvku',
		advisoryTitle	: 'Pomocný titulek',
		advisoryContentType	: 'Pomocný typ obsahu',
		cssClasses		: 'Třída stylu',
		charset			: 'Přiřazená znaková sada',
		styles			: 'Styl',
		selectAnchor	: 'Vybrat kotvu',
		anchorName		: 'Podle jména kotvy',
		anchorId		: 'Podle Id objektu',
		emailAddress	: 'E-Mailová adresa',
		emailSubject	: 'Předmět zprávy',
		emailBody		: 'Tělo zprávy',
		noAnchors		: '(Ve stránce není definována žádná kotva!)',
		noUrl			: 'Zadejte prosím URL odkazu',
		noEmail			: 'Zadejte prosím e-mailovou adresu'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Vložít/změnit záložku',
		menu		: 'Vlastnosti záložky',
		title		: 'Vlastnosti záložky',
		name		: 'Název záložky',
		errorName	: 'Zadejte prosím název záložky'
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
		title				: 'Najít a nahradit',
		find				: 'Hledat',
		replace				: 'Nahradit',
		findWhat			: 'Co hledat:',
		replaceWith			: 'Čím nahradit:',
		notFoundMsg			: 'Hledaný text nebyl nalezen.',
		matchCase			: 'Rozlišovat velikost písma',
		matchWord			: 'Pouze celá slova',
		matchCyclic			: 'Procházet opakovaně',
		replaceAll			: 'Nahradit vše',
		replaceSuccessMsg	: '%1 nahrazení.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabulka',
		title		: 'Vlastnosti tabulky',
		menu		: 'Vlastnosti tabulky',
		deleteTable	: 'Smazat tabulku',
		rows		: 'Řádky',
		columns		: 'Sloupce',
		border		: 'Ohraničení',
		widthPx		: 'bodů',
		widthPc		: 'procent',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Vzdálenost buněk',
		cellPad		: 'Odsazení obsahu v buňce',
		caption		: 'Popis',
		summary		: 'Souhrn',
		headers		: 'Záhlaví',
		headersNone		: 'Žádné',
		headersColumn	: 'První sloupec',
		headersRow		: 'První řádek',
		headersBoth		: 'Obojí',
		invalidRows		: 'Počet řádků musí být číslo větší než 0.',
		invalidCols		: 'Počet sloupců musí být číslo větší než 0.',
		invalidBorder	: 'Zdaná velikost okraje musí být číselná.',
		invalidWidth	: 'Zadaná šířka tabulky musí být číselná.',
		invalidHeight	: 'zadaná výška tabulky musí být číselná.',
		invalidCellSpacing	: 'Zadaná vzdálenost buněk musí být číselná.',
		invalidCellPadding	: 'Zadané odsazení obsahu v buňce musí být číselné.',

		cell :
		{
			menu			: 'Buňka',
			insertBefore	: 'Vložit buňku před',
			insertAfter		: 'Vložit buňku za',
			deleteCell		: 'Smazat buňky',
			merge			: 'Sloučit buňky',
			mergeRight		: 'Sloučit doprava',
			mergeDown		: 'Sloučit dolů',
			splitHorizontal	: 'Rozdělit buňky vodorovně',
			splitVertical	: 'Rozdělit buňky svisle',
			title			: 'Vlastnosti buňky',
			cellType		: 'Typ buňky',
			rowSpan			: 'Spojit řádky',
			colSpan			: 'Spojit sloupce',
			wordWrap		: 'Zalamování',
			hAlign			: 'Vodorovné zarovnání',
			vAlign			: 'Svislé zarovnání',
			alignBaseline	: 'Na účaří',
			bgColor			: 'Barva pozadí',
			borderColor		: 'Barva okraje',
			data			: 'Data',
			header			: 'Hlavička',
			yes				: 'Ano',
			no				: 'Ne',
			invalidWidth	: 'Zadaná šířka buňky musí být číslená.',
			invalidHeight	: 'Zadaná výška buňky musí být číslená.',
			invalidRowSpan	: 'Zadaný počet sloučených řádků musí být celé číslo.',
			invalidColSpan	: 'Zadaný počet sloučených sloupců musí být celé číslo.',
			chooseColor		: 'Výběr'
		},

		row :
		{
			menu			: 'Řádek',
			insertBefore	: 'Vložit řádek před',
			insertAfter		: 'Vložit řádek za',
			deleteRow		: 'Smazat řádky'
		},

		column :
		{
			menu			: 'Sloupec',
			insertBefore	: 'Vložit sloupec před',
			insertAfter		: 'Vložit sloupec za',
			deleteColumn	: 'Smazat sloupec'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Vlastnosti tlačítka',
		text		: 'Popisek',
		type		: 'Typ',
		typeBtn		: 'Tlačítko',
		typeSbm		: 'Odeslat',
		typeRst		: 'Obnovit'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Vlastnosti zaškrtávacího políčka',
		radioTitle	: 'Vlastnosti přepínače',
		value		: 'Hodnota',
		selected	: 'Zaškrtnuto'
	},

	// Form Dialog.
	form :
	{
		title		: 'Vlastnosti formuláře',
		menu		: 'Vlastnosti formuláře',
		action		: 'Akce',
		method		: 'Metoda',
		encoding	: 'Kódování'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Vlastnosti seznamu',
		selectInfo	: 'Info',
		opAvail		: 'Dostupná nastavení',
		value		: 'Hodnota',
		size		: 'Velikost',
		lines		: 'Řádků',
		chkMulti	: 'Povolit mnohonásobné výběry',
		opText		: 'Text',
		opValue		: 'Hodnota',
		btnAdd		: 'Přidat',
		btnModify	: 'Změnit',
		btnUp		: 'Nahoru',
		btnDown		: 'Dolů',
		btnSetValue : 'Nastavit jako vybranou hodnotu',
		btnDelete	: 'Smazat'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Vlastnosti textové oblasti',
		cols		: 'Sloupců',
		rows		: 'Řádků'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Vlastnosti textového pole',
		name		: 'Název',
		value		: 'Hodnota',
		charWidth	: 'Šířka ve znacích',
		maxChars	: 'Maximální počet znaků',
		type		: 'Typ',
		typeText	: 'Text',
		typePass	: 'Heslo'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Vlastnosti skrytého pole',
		name	: 'Název',
		value	: 'Hodnota'
	},

	// Image Dialog.
	image :
	{
		title		: 'Vlastnosti obrázku',
		titleButton	: 'Vlastností obrázkového tlačítka',
		menu		: 'Vlastnosti obrázku',
		infoTab		: 'Informace o obrázku',
		btnUpload	: 'Odeslat na server',
		upload		: 'Odeslat',
		alt			: 'Alternativní text',
		lockRatio	: 'Zámek',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Původní velikost',
		border		: 'Okraje',
		hSpace		: 'H-mezera',
		vSpace		: 'V-mezera',
		alertUrl	: 'Zadejte prosím URL obrázku',
		linkTab		: 'Odkaz',
		button2Img	: 'Skutečně chcete převést zvolené obrázkové tlačítko na obyčejný obrázek?',
		img2Button	: 'Skutečně chcete převést zvolený obrázek na obrázkové tlačítko?',
		urlMissing	: 'Zadané URL zdroje obrázku nebylo nalezeno.',
		validateBorder	: 'Border must be a whole number.', // MISSING
		validateHSpace	: 'HSpace must be a whole number.', // MISSING
		validateVSpace	: 'VSpace must be a whole number.' // MISSING
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Vlastnosti Flashe',
		propertiesTab	: 'Vlastnosti',
		title			: 'Vlastnosti Flashe',
		chkPlay			: 'Automatické spuštění',
		chkLoop			: 'Opakování',
		chkMenu			: 'Nabídka Flash',
		chkFull			: 'Povolit celoobrazovkový režim',
 		scale			: 'Zobrazit',
		scaleAll		: 'Zobrazit vše',
		scaleNoBorder	: 'Bez okraje',
		scaleFit		: 'Přizpůsobit',
		access			: 'Přístup ke skriptu',
		accessAlways	: 'Vždy',
		accessSameDomain: 'Ve stejné doméně',
		accessNever		: 'Nikdy',
		alignAbsBottom	: 'Zcela dolů',
		alignAbsMiddle	: 'Doprostřed',
		alignBaseline	: 'Na účaří',
		alignTextTop	: 'Na horní okraj textu',
		quality			: 'Kvalita',
		qualityBest		: 'Nejlepší',
		qualityHigh		: 'Vysoká',
		qualityAutoHigh	: 'Vysoká - auto',
		qualityMedium	: 'Střední',
		qualityAutoLow	: 'Nízká - auto',
		qualityLow		: 'Nejnižší',
		windowModeWindow: 'Okno',
		windowModeOpaque: 'Neprůhledné',
		windowModeTransparent : 'Průhledné',
		windowMode		: 'Režim okna',
		flashvars		: 'Proměnné pro Flash',
		bgcolor			: 'Barva pozadí',
		hSpace			: 'H-mezera',
		vSpace			: 'V-mezera',
		validateSrc		: 'Zadejte prosím URL odkazu',
		validateHSpace	: 'Zadaná H-mezera musí být číslo.',
		validateVSpace	: 'Zadaná V-mezera musí být číslo.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Zkontrolovat pravopis',
		title			: 'Kontrola pravopisu',
		notAvailable	: 'Omlouváme se, ale služba nyní není dostupná.',
		errorLoading	: 'Chyba nahrávání služby aplikace z: %s.',
		notInDic		: 'Není ve slovníku',
		changeTo		: 'Změnit na',
		btnIgnore		: 'Přeskočit',
		btnIgnoreAll	: 'Přeskakovat vše',
		btnReplace		: 'Zaměnit',
		btnReplaceAll	: 'Zaměňovat vše',
		btnUndo			: 'Zpět',
		noSuggestions	: '- žádné návrhy -',
		progress		: 'Probíhá kontrola pravopisu...',
		noMispell		: 'Kontrola pravopisu dokončena: Žádné pravopisné chyby nenalezeny',
		noChanges		: 'Kontrola pravopisu dokončena: Beze změn',
		oneChange		: 'Kontrola pravopisu dokončena: Jedno slovo změněno',
		manyChanges		: 'Kontrola pravopisu dokončena: %1 slov změněno',
		ieSpellDownload	: 'Kontrola pravopisu není nainstalována. Chcete ji nyní stáhnout?'
	},

	smiley :
	{
		toolbar	: 'Smajlíky',
		title	: 'Vkládání smajlíků',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : '%1 objekt'
	},

	numberedlist	: 'Číslování',
	bulletedlist	: 'Odrážky',
	indent			: 'Zvětšit odsazení',
	outdent			: 'Zmenšit odsazení',

	justify :
	{
		left	: 'Zarovnat vlevo',
		center	: 'Zarovnat na střed',
		right	: 'Zarovnat vpravo',
		block	: 'Zarovnat do bloku'
	},

	blockquote : 'Citace',

	clipboard :
	{
		title		: 'Vložit',
		cutError	: 'Bezpečnostní nastavení Vašeho prohlížeče nedovolují editoru spustit funkci pro vyjmutí zvoleného textu do schránky. Prosím vyjměte zvolený text do schránky pomocí klávesnice (Ctrl/Cmd+X).',
		copyError	: 'Bezpečnostní nastavení Vašeho prohlížeče nedovolují editoru spustit funkci pro kopírování zvoleného textu do schránky. Prosím zkopírujte zvolený text do schránky pomocí klávesnice (Ctrl/Cmd+C).',
		pasteMsg	: 'Do následujícího pole vložte požadovaný obsah pomocí klávesnice (<STRONG>Ctrl/Cmd+V</STRONG>) a stiskněte <STRONG>OK</STRONG>.',
		securityMsg	: 'Z důvodů nastavení bezpečnosti Vašeho prohlížeče nemůže editor přistupovat přímo do schránky. Obsah schránky prosím vložte znovu do tohoto okna.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'Jak je vidět, vkládaný text je kopírován z Wordu. Chcete jej před vložením vyčistit?',
		toolbar			: 'Vložit z Wordu',
		title			: 'Vložit z Wordu',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Vložit jako čistý text',
		title	: 'Vložit jako čistý text'
	},

	templates :
	{
		button			: 'Šablony',
		title			: 'Šablony obsahu',
		options : 'Template Options', // MISSING
		insertOption	: 'Nahradit aktuální obsah',
		selectPromptMsg	: 'Prosím zvolte šablonu pro otevření v editoru<br>(aktuální obsah editoru bude ztracen):',
		emptyListMsg	: '(Není definována žádná šablona)'
	},

	showBlocks : 'Ukázat bloky',

	stylesCombo :
	{
		label		: 'Styl',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Blokové styly',
		panelTitle2	: 'Řádkové styly',
		panelTitle3	: 'Objektové styly'
	},

	format :
	{
		label		: 'Formát',
		panelTitle	: 'Formát',

		tag_p		: 'Normální',
		tag_pre		: 'Naformátováno',
		tag_address	: 'Adresa',
		tag_h1		: 'Nadpis 1',
		tag_h2		: 'Nadpis 2',
		tag_h3		: 'Nadpis 3',
		tag_h4		: 'Nadpis 4',
		tag_h5		: 'Nadpis 5',
		tag_h6		: 'Nadpis 6',
		tag_div		: 'Normální (DIV)'
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
		label		: 'Písmo',
		voiceLabel	: 'Písmo',
		panelTitle	: 'Písmo'
	},

	fontSize :
	{
		label		: 'Velikost',
		voiceLabel	: 'Velikost písma',
		panelTitle	: 'Velikost'
	},

	colorButton :
	{
		textColorTitle	: 'Barva textu',
		bgColorTitle	: 'Barva pozadí',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automaticky',
		more			: 'Více barev...'
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
		title			: 'Kontrola pravopisu během psaní (SCAYT)',
		opera_title		: 'Not supported by Opera', // MISSING
		enable			: 'Zapnout SCAYT',
		disable			: 'Vypnout SCAYT',
		about			: 'O aplikaci SCAYT',
		toggle			: 'Vypínač SCAYT',
		options			: 'Nastavení',
		langs			: 'Jazyky',
		moreSuggestions	: 'Více návrhů',
		ignore			: 'Přeskočit',
		ignoreAll		: 'Přeskočit vše',
		addWord			: 'Přidat slovo',
		emptyDic		: 'Název slovníku nesmí být prázdný.',

		optionsTab		: 'Nastavení',
		allCaps			: 'Ignore All-Caps Words', // MISSING
		ignoreDomainNames : 'Ignore Domain Names', // MISSING
		mixedCase		: 'Ignore Words with Mixed Case', // MISSING
		mixedWithDigits	: 'Ignore Words with Numbers', // MISSING

		languagesTab	: 'Jazyky',

		dictionariesTab	: 'Slovníky',
		dic_field_name	: 'Dictionary name', // MISSING
		dic_create		: 'Create', // MISSING
		dic_restore		: 'Restore', // MISSING
		dic_delete		: 'Delete', // MISSING
		dic_rename		: 'Rename', // MISSING
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'O aplikaci'
	},

	about :
	{
		title		: 'O aplikaci CKEditor',
		dlgTitle	: 'O aplikaci CKEditor',
		moreInfo	: 'Pro informace o lincenci navštivte naši webovou stránku:',
		copy		: 'Copyright &copy; $1. All rights reserved.'
	},

	maximize : 'Maximalizovat',
	minimize : 'Minimalizovat',

	fakeobjects :
	{
		anchor		: 'Záložka',
		flash		: 'Flash animace',
		iframe		: 'iFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Neznámý objekt'
	},

	resize : 'Uchopit pro změnu velikosti',

	colordialog :
	{
		title		: 'Výběr barvy',
		options	:	'Color Options', // MISSING
		highlight	: 'Zvýraznit',
		selected	: 'Vybráno',
		clear		: 'Vyčistit'
	},

	toolbarCollapse	: 'Collapse Toolbar', // MISSING
	toolbarExpand	: 'Expand Toolbar', // MISSING

	bidi :
	{
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
	}
};
