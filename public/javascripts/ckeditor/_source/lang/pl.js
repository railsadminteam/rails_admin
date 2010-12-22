/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Polish language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['pl'] =
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
	source			: 'Źródło dokumentu',
	newPage			: 'Nowa strona',
	save			: 'Zapisz',
	preview			: 'Podgląd',
	cut				: 'Wytnij',
	copy			: 'Kopiuj',
	paste			: 'Wklej',
	print			: 'Drukuj',
	underline		: 'Podkreślenie',
	bold			: 'Pogrubienie',
	italic			: 'Kursywa',
	selectAll		: 'Zaznacz wszystko',
	removeFormat	: 'Usuń formatowanie',
	strike			: 'Przekreślenie',
	subscript		: 'Indeks dolny',
	superscript		: 'Indeks górny',
	horizontalrule	: 'Wstaw poziomą linię',
	pagebreak		: 'Wstaw odstęp',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Usuń hiperłącze',
	undo			: 'Cofnij',
	redo			: 'Ponów',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Przeglądaj',
		url				: 'Adres URL',
		protocol		: 'Protokół',
		upload			: 'Wyślij',
		uploadSubmit	: 'Wyślij',
		image			: 'Obrazek',
		flash			: 'Flash',
		form			: 'Formularz',
		checkbox		: 'Pole wyboru (checkbox)',
		radio			: 'Pole wyboru (radio)',
		textField		: 'Pole tekstowe',
		textarea		: 'Obszar tekstowy',
		hiddenField		: 'Pole ukryte',
		button			: 'Przycisk',
		select			: 'Lista wyboru',
		imageButton		: 'Przycisk-obrazek',
		notSet			: '<nie ustawione>',
		id				: 'Id',
		name			: 'Nazwa',
		langDir			: 'Kierunek tekstu',
		langDirLtr		: 'Od lewej do prawej (LTR)',
		langDirRtl		: 'Od prawej do lewej (RTL)',
		langCode		: 'Kod języka',
		longDescr		: 'Długi opis hiperłącza',
		cssClass		: 'Nazwa klasy CSS',
		advisoryTitle	: 'Opis obiektu docelowego',
		cssStyle		: 'Styl',
		ok				: 'OK',
		cancel			: 'Anuluj',
		close			: 'Close', // MISSING
		preview			: 'Preview', // MISSING
		generalTab		: 'Ogólne',
		advancedTab		: 'Zaawansowane',
		validateNumberFailed : 'Ta wartość nie jest liczbą.',
		confirmNewPage	: 'Wszystkie niezapisane zmiany zostaną utracone. Czy na pewno wczytać nową stronę?',
		confirmCancel	: 'Pewne opcje zostały zmienione. Czy na pewno zamknąć okno dialogowe?',
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
		width			: 'Szerokość',
		height			: 'Wysokość',
		align			: 'Wyrównaj',
		alignLeft		: 'Do lewej',
		alignRight		: 'Do prawej',
		alignCenter		: 'Do środka',
		alignTop		: 'Do góry',
		alignMiddle		: 'Do środka',
		alignBottom		: 'Do dołu',
		invalidHeight	: 'Wysokość musi być liczbą.',
		invalidWidth	: 'Szerokość musi być liczbą.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, niedostępne</span>'
	},

	contextmenu :
	{
		options : 'Context Menu Options' // MISSING
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Wstaw znak specjalny',
		title		: 'Wybierz znak specjalny',
		options : 'Special Character Options' // MISSING
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Wstaw/edytuj hiperłącze',
		other 		: '<inny>',
		menu		: 'Edytuj hiperłącze',
		title		: 'Hiperłącze',
		info		: 'Informacje ',
		target		: 'Cel',
		upload		: 'Wyślij',
		advanced	: 'Zaawansowane',
		type		: 'Typ hiperłącza',
		toUrl		: 'URL', // MISSING
		toAnchor	: 'Odnośnik wewnątrz strony',
		toEmail		: 'Adres e-mail',
		targetFrame		: '<ramka>',
		targetPopup		: '<wyskakujące okno>',
		targetFrameName	: 'Nazwa Ramki Docelowej',
		targetPopupName	: 'Nazwa wyskakującego okna',
		popupFeatures	: 'Właściwości wyskakującego okna',
		popupResizable	: 'Skalowalny',
		popupStatusBar	: 'Pasek statusu',
		popupLocationBar: 'Pasek adresu',
		popupToolbar	: 'Pasek narzędzi',
		popupMenuBar	: 'Pasek menu',
		popupFullScreen	: 'Pełny ekran (IE)',
		popupScrollBars	: 'Paski przewijania',
		popupDependent	: 'Okno zależne (Netscape)',
		popupLeft		: 'Pozycja w poziomie',
		popupTop		: 'Pozycja w pionie',
		id				: 'Id',
		langDir			: 'Kierunek tekstu',
		langDirLTR		: 'Od lewej do prawej (LTR)',
		langDirRTL		: 'Od prawej do lewej (RTL)',
		acccessKey		: 'Klawisz dostępu',
		name			: 'Nazwa',
		langCode		: 'Kierunek tekstu',
		tabIndex		: 'Indeks tabeli',
		advisoryTitle	: 'Opis obiektu docelowego',
		advisoryContentType	: 'Typ MIME obiektu docelowego',
		cssClasses		: 'Nazwa klasy CSS',
		charset			: 'Kodowanie znaków obiektu docelowego',
		styles			: 'Styl',
		selectAnchor	: 'Wybierz etykietę',
		anchorName		: 'Wg etykiety',
		anchorId		: 'Wg identyfikatora elementu',
		emailAddress	: 'Adres e-mail',
		emailSubject	: 'Temat',
		emailBody		: 'Treść',
		noAnchors		: '(W dokumencie nie zdefiniowano żadnych etykiet)',
		noUrl			: 'Podaj adres URL',
		noEmail			: 'Podaj adres e-mail'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Wstaw/edytuj kotwicę',
		menu		: 'Właściwości kotwicy',
		title		: 'Właściwości kotwicy',
		name		: 'Nazwa kotwicy',
		errorName	: 'Wpisz nazwę kotwicy'
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
		title				: 'Znajdź i zamień',
		find				: 'Znajdź',
		replace				: 'Zamień',
		findWhat			: 'Znajdź:',
		replaceWith			: 'Zastąp przez:',
		notFoundMsg			: 'Nie znaleziono szukanego hasła.',
		matchCase			: 'Uwzględnij wielkość liter',
		matchWord			: 'Całe słowa',
		matchCyclic			: 'Cykliczne dopasowanie',
		replaceAll			: 'Zastąp wszystko',
		replaceSuccessMsg	: '%1 wystąpień zastąpionych.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabela',
		title		: 'Właściwości tabeli',
		menu		: 'Właściwości tabeli',
		deleteTable	: 'Usuń tabelę',
		rows		: 'Liczba wierszy',
		columns		: 'Liczba kolumn',
		border		: 'Grubość ramki',
		widthPx		: 'piksele',
		widthPc		: '%',
		widthUnit	: 'width unit', // MISSING
		cellSpace	: 'Odstęp pomiędzy komórkami',
		cellPad		: 'Margines wewnętrzny komórek',
		caption		: 'Tytuł',
		summary		: 'Podsumowanie',
		headers		: 'Nagłowki',
		headersNone		: 'Brak',
		headersColumn	: 'Pierwsza kolumna',
		headersRow		: 'Pierwszy wiersz',
		headersBoth		: 'Oba',
		invalidRows		: 'Liczba wierszy musi być liczbą większą niż 0.',
		invalidCols		: 'Liczba kolumn musi być liczbą większą niż 0.',
		invalidBorder	: 'Liczba obramowań musi być liczbą.',
		invalidWidth	: 'Szerokość tabeli musi być liczbą.',
		invalidHeight	: 'Wysokość tabeli musi być liczbą.',
		invalidCellSpacing	: 'Odstęp komórek musi być liczbą.',
		invalidCellPadding	: 'Dopełnienie komórek musi być liczbą.',

		cell :
		{
			menu			: 'Komórka',
			insertBefore	: 'Wstaw komórkę z lewej',
			insertAfter		: 'Wstaw komórkę z prawej',
			deleteCell		: 'Usuń komórki',
			merge			: 'Połącz komórki',
			mergeRight		: 'Połącz z komórką z prawej',
			mergeDown		: 'Połącz z komórką poniżej',
			splitHorizontal	: 'Podziel komórkę poziomo',
			splitVertical	: 'Podziel komórkę pionowo',
			title			: 'Właściwości komórki',
			cellType		: 'Typ komórki',
			rowSpan			: 'Scalenie wierszy',
			colSpan			: 'Scalenie komórek',
			wordWrap		: 'Zawijanie słów',
			hAlign			: 'Wyrównanie poziome',
			vAlign			: 'Wyrównanie pionowe',
			alignBaseline	: 'Linia bazowa',
			bgColor			: 'Kolor tła',
			borderColor		: 'Kolor obramowania',
			data			: 'Dane',
			header			: 'Nagłowek',
			yes				: 'Tak',
			no				: 'Nie',
			invalidWidth	: 'Szerokość komórki musi być liczbą.',
			invalidHeight	: 'Wysokość komórki musi być liczbą.',
			invalidRowSpan	: 'Scalenie wierszy musi być liczbą całkowitą.',
			invalidColSpan	: 'Scalenie komórek musi być liczbą całkowitą.',
			chooseColor		: 'Wybierz'
		},

		row :
		{
			menu			: 'Wiersz',
			insertBefore	: 'Wstaw wiersz powyżej',
			insertAfter		: 'Wstaw wiersz poniżej',
			deleteRow		: 'Usuń wiersze'
		},

		column :
		{
			menu			: 'Kolumna',
			insertBefore	: 'Wstaw kolumnę z lewej',
			insertAfter		: 'Wstaw kolumnę z prawej',
			deleteColumn	: 'Usuń kolumny'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Właściwości przycisku',
		text		: 'Tekst (Wartość)',
		type		: 'Typ',
		typeBtn		: 'Przycisk',
		typeSbm		: 'Wyślij',
		typeRst		: 'Wyzeruj'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Właściwości pola wyboru (checkbox)',
		radioTitle	: 'Właściwości pola wyboru (radio)',
		value		: 'Wartość',
		selected	: 'Zaznaczone'
	},

	// Form Dialog.
	form :
	{
		title		: 'Właściwości formularza',
		menu		: 'Właściwości formularza',
		action		: 'Akcja',
		method		: 'Metoda',
		encoding	: 'Kodowanie'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Właściwości listy wyboru',
		selectInfo	: 'Informacje',
		opAvail		: 'Dostępne opcje',
		value		: 'Wartość',
		size		: 'Rozmiar',
		lines		: 'linii',
		chkMulti	: 'Wielokrotny wybór',
		opText		: 'Tekst',
		opValue		: 'Wartość',
		btnAdd		: 'Dodaj',
		btnModify	: 'Zmień',
		btnUp		: 'Do góry',
		btnDown		: 'Do dołu',
		btnSetValue : 'Ustaw wartość zaznaczoną',
		btnDelete	: 'Usuń'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Właściwości obszaru tekstowego',
		cols		: 'Kolumnu',
		rows		: 'Wiersze'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Właściwości pola tekstowego',
		name		: 'Nazwa',
		value		: 'Wartość',
		charWidth	: 'Szerokość w znakach',
		maxChars	: 'Max. szerokość',
		type		: 'Typ',
		typeText	: 'Tekst',
		typePass	: 'Hasło'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Właściwości pola ukrytego',
		name	: 'Nazwa',
		value	: 'Wartość'
	},

	// Image Dialog.
	image :
	{
		title		: 'Właściwości obrazka',
		titleButton	: 'Właściwości przycisku obrazka',
		menu		: 'Właściwości obrazka',
		infoTab		: 'Informacje o obrazku',
		btnUpload	: 'Wyślij',
		upload		: 'Wyślij',
		alt			: 'Tekst zastępczy',
		lockRatio	: 'Zablokuj proporcje',
		unlockRatio	: 'Unlock Ratio', // MISSING
		resetSize	: 'Przywróć rozmiar',
		border		: 'Ramka',
		hSpace		: 'Odstęp poziomy',
		vSpace		: 'Odstęp pionowy',
		alertUrl	: 'Podaj adres obrazka.',
		linkTab		: 'Hiperłącze',
		button2Img	: 'Czy chcesz przekonwertować zaznaczony przycisk graficzny do zwykłego obrazka?',
		img2Button	: 'Czy chcesz przekonwertować zaznaczony obrazek do przycisku graficznego?',
		urlMissing	: 'Podaj adres URL obrazka.',
		validateBorder	: 'Border must be a whole number.', // MISSING
		validateHSpace	: 'HSpace must be a whole number.', // MISSING
		validateVSpace	: 'VSpace must be a whole number.' // MISSING
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Właściwości elementu Flash',
		propertiesTab	: 'Właściwości',
		title			: 'Właściwości elementu Flash',
		chkPlay			: 'Autoodtwarzanie',
		chkLoop			: 'Pętla',
		chkMenu			: 'Włącz menu',
		chkFull			: 'Dopuść pełny ekran',
 		scale			: 'Skaluj',
		scaleAll		: 'Pokaż wszystko',
		scaleNoBorder	: 'Bez Ramki',
		scaleFit		: 'Dokładne dopasowanie',
		access			: 'Dostęp skryptów',
		accessAlways	: 'Zawsze',
		accessSameDomain: 'Ta sama domena',
		accessNever		: 'Nigdy',
		alignAbsBottom	: 'Do dołu',
		alignAbsMiddle	: 'Do środka w pionie',
		alignBaseline	: 'Do linii bazowej',
		alignTextTop	: 'Do góry tekstu',
		quality			: 'Jakość',
		qualityBest		: 'Najlepsza',
		qualityHigh		: 'Wysoka',
		qualityAutoHigh	: 'Auto wysoka',
		qualityMedium	: 'Średnia',
		qualityAutoLow	: 'Auto niska',
		qualityLow		: 'Niska',
		windowModeWindow: 'Okno',
		windowModeOpaque: 'Nieprzeźroczyste',
		windowModeTransparent : 'Przeźroczyste',
		windowMode		: 'Tryb okna',
		flashvars		: 'Zmienne dla Flasha',
		bgcolor			: 'Kolor tła',
		hSpace			: 'Odstęp poziomy',
		vSpace			: 'Odstęp pionowy',
		validateSrc		: 'Podaj adres URL',
		validateHSpace	: 'Odstęp poziomy musi być liczbą.',
		validateVSpace	: 'Odstęp pionowy musi być liczbą.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Sprawdź pisownię',
		title			: 'Sprawdź pisownię',
		notAvailable	: 'Przepraszamy, ale usługa jest obecnie niedostępna.',
		errorLoading	: 'Błąd wczytywania hosta aplikacji usługi: %s.',
		notInDic		: 'Słowa nie ma w słowniku',
		changeTo		: 'Zmień na',
		btnIgnore		: 'Ignoruj',
		btnIgnoreAll	: 'Ignoruj wszystkie',
		btnReplace		: 'Zmień',
		btnReplaceAll	: 'Zmień wszystkie',
		btnUndo			: 'Cofnij',
		noSuggestions	: '- Brak sugestii -',
		progress		: 'Trwa sprawdzanie...',
		noMispell		: 'Sprawdzanie zakończone: nie znaleziono błędów',
		noChanges		: 'Sprawdzanie zakończone: nie zmieniono żadnego słowa',
		oneChange		: 'Sprawdzanie zakończone: zmieniono jedno słowo',
		manyChanges		: 'Sprawdzanie zakończone: zmieniono %l słów',
		ieSpellDownload	: 'Słownik nie jest zainstalowany. Chcesz go ściągnąć?'
	},

	smiley :
	{
		toolbar	: 'Emotikona',
		title	: 'Wstaw emotikonę',
		options : 'Smiley Options' // MISSING
	},

	elementsPath :
	{
		eleLabel : 'Elements path', // MISSING
		eleTitle : 'element %1'
	},

	numberedlist	: 'Lista numerowana',
	bulletedlist	: 'Lista wypunktowana',
	indent			: 'Zwiększ wcięcie',
	outdent			: 'Zmniejsz wcięcie',

	justify :
	{
		left	: 'Wyrównaj do lewej',
		center	: 'Wyrównaj do środka',
		right	: 'Wyrównaj do prawej',
		block	: 'Wyrównaj do lewej i prawej'
	},

	blockquote : 'Cytat',

	clipboard :
	{
		title		: 'Wklej',
		cutError	: 'Ustawienia bezpieczeństwa Twojej przeglądarki nie pozwalają na automatyczne wycinanie tekstu. Użyj skrótu klawiszowego Ctrl/Cmd+X.',
		copyError	: 'Ustawienia bezpieczeństwa Twojej przeglądarki nie pozwalają na automatyczne kopiowanie tekstu. Użyj skrótu klawiszowego Ctrl/Cmd+C.',
		pasteMsg	: 'Proszę wkleić w poniższym polu używając klawiaturowego skrótu (<STRONG>Ctrl/Cmd+V</STRONG>) i kliknąć <STRONG>OK</STRONG>.',
		securityMsg	: 'Zabezpieczenia przeglądarki uniemożliwiają wklejenie danych bezpośrednio do edytora. Proszę dane wkleić ponownie w tym okienku.',
		pasteArea	: 'Paste Area' // MISSING
	},

	pastefromword :
	{
		confirmCleanup	: 'Tekst, który chcesz wkleić, prawdopodobnie pochodzi z programu Word. Czy chcesz go wyczyścic przed wklejeniem?',
		toolbar			: 'Wklej z Worda',
		title			: 'Wklej z Worda',
		error			: 'It was not possible to clean up the pasted data due to an internal error' // MISSING
	},

	pasteText :
	{
		button	: 'Wklej jako czysty tekst',
		title	: 'Wklej jako czysty tekst'
	},

	templates :
	{
		button			: 'Szablony',
		title			: 'Szablony zawartości',
		options : 'Template Options', // MISSING
		insertOption	: 'Zastąp aktualną zawartość',
		selectPromptMsg	: 'Wybierz szablon do otwarcia w edytorze<br>(obecna zawartość okna edytora zostanie utracona):',
		emptyListMsg	: '(Brak zdefiniowanych szablonów)'
	},

	showBlocks : 'Pokaż bloki',

	stylesCombo :
	{
		label		: 'Styl',
		panelTitle	: 'Formatting Styles', // MISSING
		panelTitle1	: 'Style blokowe',
		panelTitle2	: 'Style liniowe',
		panelTitle3	: 'Style obiektowe'
	},

	format :
	{
		label		: 'Format',
		panelTitle	: 'Format',

		tag_p		: 'Normalny',
		tag_pre		: 'Tekst sformatowany',
		tag_address	: 'Adres',
		tag_h1		: 'Nagłówek 1',
		tag_h2		: 'Nagłówek 2',
		tag_h3		: 'Nagłówek 3',
		tag_h4		: 'Nagłówek 4',
		tag_h5		: 'Nagłówek 5',
		tag_h6		: 'Nagłówek 6',
		tag_div		: 'Normalny (DIV)'
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
		label		: 'Czcionka',
		voiceLabel	: 'Czcionka',
		panelTitle	: 'Czcionka'
	},

	fontSize :
	{
		label		: 'Rozmiar',
		voiceLabel	: 'Rozmiar czcionki',
		panelTitle	: 'Rozmiar'
	},

	colorButton :
	{
		textColorTitle	: 'Kolor tekstu',
		bgColorTitle	: 'Kolor tła',
		panelTitle		: 'Colors', // MISSING
		auto			: 'Automatycznie',
		more			: 'Więcej kolorów...'
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
		title			: 'Sprawdź pisownię podczas pisania (SCAYT)',
		opera_title		: 'Not supported by Opera', // MISSING
		enable			: 'Włącz SCAYT',
		disable			: 'Wyłącz SCAYT',
		about			: 'Na temat SCAYT',
		toggle			: 'Przełącz SCAYT',
		options			: 'Opcje',
		langs			: 'Języki',
		moreSuggestions	: 'Więcej sugestii',
		ignore			: 'Ignoruj',
		ignoreAll		: 'Ignoruj wszystkie',
		addWord			: 'Dodaj słowo',
		emptyDic		: 'Nazwa słownika nie może być pusta.',

		optionsTab		: 'Opcje',
		allCaps			: 'Ignore All-Caps Words', // MISSING
		ignoreDomainNames : 'Ignore Domain Names', // MISSING
		mixedCase		: 'Ignore Words with Mixed Case', // MISSING
		mixedWithDigits	: 'Ignore Words with Numbers', // MISSING

		languagesTab	: 'Języki',

		dictionariesTab	: 'Słowniki',
		dic_field_name	: 'Dictionary name', // MISSING
		dic_create		: 'Create', // MISSING
		dic_restore		: 'Restore', // MISSING
		dic_delete		: 'Delete', // MISSING
		dic_rename		: 'Rename', // MISSING
		dic_info		: 'Initially the User Dictionary is stored in a Cookie. However, Cookies are limited in size. When the User Dictionary grows to a point where it cannot be stored in a Cookie, then the dictionary may be stored on our server. To store your personal dictionary on our server you should specify a name for your dictionary. If you already have a stored dictionary, please type its name and click the Restore button.', // MISSING

		aboutTab		: 'Na temat SCAYT'
	},

	about :
	{
		title		: 'Na temat CKEditor',
		dlgTitle	: 'Na temat CKEditor',
		moreInfo	: 'Informacje na temat licencji można znaleźć na naszej stronie:',
		copy		: 'Copyright &copy; $1. Wszelkie prawa zastrzeżone.'
	},

	maximize : 'Maksymalizuj',
	minimize : 'Minimalizuj',

	fakeobjects :
	{
		anchor		: 'Kotwica',
		flash		: 'Animacja Flash',
		iframe		: 'iFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Nieznany obiekt'
	},

	resize : 'Przeciągnij, aby zmienić rozmiar',

	colordialog :
	{
		title		: 'Wybierz kolor',
		options	:	'Color Options', // MISSING
		highlight	: 'Zaznacz',
		selected	: 'Wybrany',
		clear		: 'Wyczyść'
	},

	toolbarCollapse	: 'Collapse Toolbar', // MISSING
	toolbarExpand	: 'Expand Toolbar', // MISSING

	bidi :
	{
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
	}
};
