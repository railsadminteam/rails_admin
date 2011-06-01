﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
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
	editorTitle : 'Edytor tekstu sformatowanego, %1, w celu uzyskania pomocy naciśnij ALT 0.',

	// ARIA descriptions.
	toolbars	: 'Paski narzędzi edytora',
	editor		: 'Edytor tekstu sformatowanego',

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
	pagebreak		: 'Wstaw pdodział strony',
	pagebreakAlt		: 'Wstaw podział strony',
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
		radio			: 'Przycisk opcji (radio)',
		textField		: 'Pole tekstowe',
		textarea		: 'Obszar tekstowy',
		hiddenField		: 'Pole ukryte',
		button			: 'Przycisk',
		select			: 'Lista wyboru',
		imageButton		: 'Przycisk graficzny',
		notSet			: '<nie ustawiono>',
		id				: 'Id',
		name			: 'Nazwa',
		langDir			: 'Kierunek tekstu',
		langDirLtr		: 'Od lewej do prawej (LTR)',
		langDirRtl		: 'Od prawej do lewej (RTL)',
		langCode		: 'Kod języka',
		longDescr		: 'Adres URL długiego opisu',
		cssClass		: 'Nazwa klasy CSS',
		advisoryTitle	: 'Opis obiektu docelowego',
		cssStyle		: 'Styl',
		ok				: 'OK',
		cancel			: 'Anuluj',
		close			: 'Zamknij',
		preview			: 'Podgląd',
		generalTab		: 'Ogólne',
		advancedTab		: 'Zaawansowane',
		validateNumberFailed : 'Ta wartość nie jest liczbą.',
		confirmNewPage	: 'Wszystkie niezapisane zmiany zostaną utracone. Czy na pewno wczytać nową stronę?',
		confirmCancel	: 'Pewne opcje zostały zmienione. Czy na pewno zamknąć okno dialogowe?',
		options			: 'Opcje',
		target			: 'Obiekt docelowy',
		targetNew		: 'Nowe okno (_blank)',
		targetTop		: 'Okno najwyżej w hierarchii (_top)',
		targetSelf		: 'To samo okno (_self)',
		targetParent	: 'Okno nadrzędne (_parent)',
		langDirLTR		: 'Od lewej do prawej (LTR)',
		langDirRTL		: 'Od prawej do lewej (RTL)',
		styles			: 'Style',
		cssClasses		: 'Klasy arkusza stylów',
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
		options : 'Opcje menu kontekstowego'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Wstaw znak specjalny',
		title		: 'Wybierz znak specjalny',
		options : 'Opcje znaków specjalnych'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Wstaw/edytuj hiperłącze',
		other 		: '<inny>',
		menu		: 'Edytuj hiperłącze',
		title		: 'Hiperłącze',
		info		: 'Informacje ',
		target		: 'Obiekt docelowy',
		upload		: 'Wyślij',
		advanced	: 'Zaawansowane',
		type		: 'Typ hiperłącza',
		toUrl		: 'Adres URL',
		toAnchor	: 'Odnośnik wewnątrz strony (kotwica)',
		toEmail		: 'Adres e-mail',
		targetFrame		: '<ramka>',
		targetPopup		: '<wyskakujące okno>',
		targetFrameName	: 'Nazwa ramki docelowej',
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
		langCode			: 'Kod języka',
		tabIndex			: 'Indeks kolejności',
		advisoryTitle		: 'Opis obiektu docelowego',
		advisoryContentType	: 'Typ MIME obiektu docelowego',
		cssClasses		: 'Nazwa klasy CSS',
		charset			: 'Kodowanie znaków obiektu docelowego',
		styles			: 'Styl',
		rel			: 'Relacja',
		selectAnchor		: 'Wybierz kotwicę',
		anchorName		: 'Wg nazwy',
		anchorId			: 'Wg identyfikatora',
		emailAddress		: 'Adres e-mail',
		emailSubject		: 'Temat',
		emailBody		: 'Treść',
		noAnchors		: '(W dokumencie nie zdefiniowano żadnych kotwic)',
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
		numberedTitle		: 'Właściwości list numerowanych',
		bulletedTitle		: 'Właściwości list wypunktowanych',
		type				: 'Typ punktora',
		start				: 'Początek',
		validateStartNumber				:'Listę musi rozpoczynać liczba całkowita.',
		circle				: 'Koło',
		disc				: 'Okrąg',
		square				: 'Kwadrat',
		none				: 'Brak',
		notset				: '<nie ustawiono>',
		armenian			: 'Numerowanie armeńskie',
		georgian			: 'Numerowanie gruzińskie (an, ban, gan itd.)',
		lowerRoman			: 'Małe cyfry rzymskie (i, ii, iii, iv, v itd.)',
		upperRoman			: 'Duże cyfry rzymskie (I, II, III, IV, V itd.)',
		lowerAlpha			: 'Małe litery (a, b, c, d, e itd.)',
		upperAlpha			: 'Duże litery (A, B, C, D, E itd.)',
		lowerGreek			: 'Małe litery greckie (alpha, beta, gamma itd.)',
		decimal				: 'Liczby (1, 2, 3 itd.)',
		decimalLeadingZero	: 'Liczby z początkowym zerem (01, 02, 03 itd.)'
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
		replaceAll			: 'Zamień wszystko',
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
		border		: 'Grubość obramowania',
		widthPx		: 'piksele',
		widthPc		: '%',
		widthUnit	: 'jednostka szerokości',
		cellSpace	: 'Odstęp pomiędzy komórkami',
		cellPad		: 'Dopełnienie komórek',
		caption		: 'Tytuł',
		summary		: 'Podsumowanie',
		headers		: 'Nagłówki',
		headersNone		: 'Brak',
		headersColumn	: 'Pierwsza kolumna',
		headersRow		: 'Pierwszy wiersz',
		headersBoth		: 'Oba',
		invalidRows		: 'Liczba wierszy musi być większa niż 0.',
		invalidCols		: 'Liczba kolumn musi być większa niż 0.',
		invalidBorder	: 'Wartość obramowania musi być liczbą.',
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
		typeRst		: 'Wyczyść'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Właściwości pola wyboru (checkbox)',
		radioTitle	: 'Właściwości przycisku opcji (radio)',
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
		lines		: 'wierszy',
		chkMulti	: 'Wielokrotny wybór',
		opText		: 'Tekst',
		opValue		: 'Wartość',
		btnAdd		: 'Dodaj',
		btnModify	: 'Zmień',
		btnUp		: 'Do góry',
		btnDown		: 'Do dołu',
		btnSetValue : 'Ustaw jako zaznaczoną',
		btnDelete	: 'Usuń'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Właściwości obszaru tekstowego',
		cols		: 'Liczba kolumn',
		rows		: 'Liczba wierszy'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Właściwości pola tekstowego',
		name		: 'Nazwa',
		value		: 'Wartość',
		charWidth	: 'Szerokość w znakach',
		maxChars	: 'Szerokość maksymalna',
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
		titleButton	: 'Właściwości przycisku graficznego',
		menu		: 'Właściwości obrazka',
		infoTab		: 'Informacje o obrazku',
		btnUpload	: 'Wyślij',
		upload		: 'Wyślij',
		alt			: 'Tekst zastępczy',
		lockRatio	: 'Zablokuj proporcje',
		unlockRatio	: 'Odblokuj proporcje',
		resetSize	: 'Przywróć rozmiar',
		border		: 'Obramowanie',
		hSpace		: 'Odstęp poziomy',
		vSpace		: 'Odstęp pionowy',
		alertUrl	: 'Podaj adres obrazka.',
		linkTab		: 'Hiperłącze',
		button2Img	: 'Czy chcesz przekonwertować zaznaczony przycisk graficzny do zwykłego obrazka?',
		img2Button	: 'Czy chcesz przekonwertować zaznaczony obrazek do przycisku graficznego?',
		urlMissing	: 'Podaj adres URL obrazka.',
		validateBorder	: 'Wartość obramowania musi być liczbą całkowitą.',
		validateHSpace	: 'Wartość odstępu poziomego musi być liczbą całkowitą.',
		validateVSpace	: 'Wartość odstępu pionowego musi być liczbą całkowitą.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Właściwości obiektu Flash',
		propertiesTab	: 'Właściwości',
		title			: 'Właściwości obiektu Flash',
		chkPlay			: 'Autoodtwarzanie',
		chkLoop			: 'Pętla',
		chkMenu			: 'Włącz menu',
		chkFull			: 'Zezwól na pełny ekran',
 		scale			: 'Skaluj',
		scaleAll		: 'Pokaż wszystko',
		scaleNoBorder	: 'Bez obramowania',
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
		windowModeOpaque: 'Nieprzezroczyste',
		windowModeTransparent : 'Przezroczyste',
		windowMode		: 'Tryb okna',
		flashvars		: 'Zmienne obiektu Flash',
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
		ieSpellDownload	: 'Słownik nie jest zainstalowany. Czy chcesz go pobrać?'
	},

	smiley :
	{
		toolbar	: 'Emotikony',
		title	: 'Wstaw emotikona',
		options : 'Opcje emotikonów'
	},

	elementsPath :
	{
		eleLabel : 'Ścieżka elementów',
		eleTitle : 'element %1'
	},

	numberedlist	: 'Lista numerowana',
	bulletedlist	: 'Lista wypunktowana',
	indent			: 'Zwiększ wcięcie',
	outdent			: 'Zmniejsz wcięcie',

	justify :
	{
		left	: 'Wyrównaj do lewej',
		center	: 'Wyśrodkuj',
		right	: 'Wyrównaj do prawej',
		block	: 'Wyjustuj'
	},

	blockquote : 'Cytat',

	clipboard :
	{
		title		: 'Wklej',
		cutError	: 'Ustawienia bezpieczeństwa Twojej przeglądarki nie pozwalają na automatyczne wycinanie tekstu. Użyj skrótu klawiszowego Ctrl/Cmd+X.',
		copyError	: 'Ustawienia bezpieczeństwa Twojej przeglądarki nie pozwalają na automatyczne kopiowanie tekstu. Użyj skrótu klawiszowego Ctrl/Cmd+C.',
		pasteMsg	: 'Wklej tekst w poniższym polu, używając skrótu klawiaturowego (<STRONG>Ctrl/Cmd+V</STRONG>), i kliknij <STRONG>OK</STRONG>.',
		securityMsg	: 'Zabezpieczenia przeglądarki uniemożliwiają wklejenie danych bezpośrednio do edytora. Proszę ponownie wkleić dane w tym oknie.',
		pasteArea	: 'Obszar wklejania'
	},

	pastefromword :
	{
		confirmCleanup	: 'Tekst, który chcesz wkleić, prawdopodobnie pochodzi z programu Microsoft Word. Czy chcesz go wyczyścić przed wklejeniem?',
		toolbar			: 'Wklej z programu MS Word',
		title			: 'Wklej z programu MS Word',
		error			: 'Wyczyszczenie wklejonych danych nie było możliwe z powodu wystąpienia błędu.'
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
		options : 'Opcje szablonów',
		insertOption	: 'Zastąp obecną zawartość',
		selectPromptMsg	: 'Wybierz szablon do otwarcia w edytorze<br>(obecna zawartość okna edytora zostanie utracona):',
		emptyListMsg	: '(Brak zdefiniowanych szablonów)'
	},

	showBlocks : 'Pokaż bloki',

	stylesCombo :
	{
		label		: 'Styl',
		panelTitle	: 'Style formatujące',
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
		title				: 'Utwórz pojemnik Div',
		toolbar				: 'Utwórz pojemnik Div',
		cssClassInputLabel	: 'Klasy arkusza stylów',
		styleSelectLabel	: 'Styl',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: 'Kod języka',
		inlineStyleInputLabel	: 'Style liniowe',
		advisoryTitleInputLabel	: 'Opis obiektu docelowego',
		langDirLabel		: 'Kierunek tekstu',
		langDirLTRLabel		: 'Od lewej do prawej (LTR)',
		langDirRTLLabel		: 'Od prawej do lewej (RTL)',
		edit				: 'Edytuj pojemnik Div',
		remove				: 'Usuń pojemnik Div'
  	},

	iframe :
	{
		title		: 'Właściwości elementu IFrame',
		toolbar		: 'IFrame',
		noUrl		: 'Podaj adres URL elementu IFrame',
		scrolling	: 'Włącz paski przewijania',
		border		: 'Pokaż obramowanie obiektu IFrame'
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
		panelTitle		: 'Kolory',
		auto			: 'Automatycznie',
		more			: 'Więcej kolorów...'
	},

	colors :
	{
		'000' : 'Czarny',
		'800000' : 'Kasztanowy',
		'8B4513' : 'Czekoladowy',
		'2F4F4F' : 'Ciemnografitowy',
		'008080' : 'Morski',
		'000080' : 'Granatowy',
		'4B0082' : 'Indygo',
		'696969' : 'Ciemnoszary',
		'B22222' : 'Czerwień żelazowa',
		'A52A2A' : 'Brązowy',
		'DAA520' : 'Ciemnozłoty',
		'006400' : 'Ciemnozielony',
		'40E0D0' : 'Turkusowy',
		'0000CD' : 'Ciemnoniebieski',
		'800080' : 'Purpurowy',
		'808080' : 'Szary',
		'F00' : 'Czerwony',
		'FF8C00' : 'Ciemnopomarańczowy',
		'FFD700' : 'Złoty',
		'008000' : 'Zielony',
		'0FF' : 'Cyjan',
		'00F' : 'Niebieski',
		'EE82EE' : 'Fioletowy',
		'A9A9A9' : 'Przygaszony szary',
		'FFA07A' : 'Łososiowy',
		'FFA500' : 'Pomarańczowy',
		'FFFF00' : 'Żółty',
		'00FF00' : 'Limonkowy',
		'AFEEEE' : 'Bladoturkusowy',
		'ADD8E6' : 'Jasnoniebieski',
		'DDA0DD' : 'Śliwkowy',
		'D3D3D3' : 'Jasnoszary',
		'FFF0F5' : 'Jasnolawendowy',
		'FAEBD7' : 'Kremowobiały',
		'FFFFE0' : 'Jasnożółty',
		'F0FFF0' : 'Bladozielony',
		'F0FFFF' : 'Jasnolazurowy',
		'F0F8FF' : 'Jasnobłękitny',
		'E6E6FA' : 'Lawendowy',
		'FFF' : 'Biały'
	},

	scayt :
	{
		title			: 'Sprawdź pisownię podczas pisania (SCAYT)',
		opera_title		: 'Funkcja nie jest obsługiwana przez przeglądarkę Opera',
		enable			: 'Włącz SCAYT',
		disable			: 'Wyłącz SCAYT',
		about			: 'Informacje o SCAYT',
		toggle			: 'Przełącz SCAYT',
		options			: 'Opcje',
		langs			: 'Języki',
		moreSuggestions	: 'Więcej sugestii',
		ignore			: 'Ignoruj',
		ignoreAll		: 'Ignoruj wszystkie',
		addWord			: 'Dodaj słowo',
		emptyDic		: 'Nazwa słownika nie może być pusta.',

		optionsTab		: 'Opcje',
		allCaps			: 'Ignoruj wyrazy pisane dużymi literami',
		ignoreDomainNames : 'Ignoruj nazwy domen',
		mixedCase		: 'Ignoruj wyrazy pisane dużymi i małymi literami',
		mixedWithDigits	: 'Ignoruj wyrazy zawierające cyfry',

		languagesTab	: 'Języki',

		dictionariesTab	: 'Słowniki',
		dic_field_name	: 'Nazwa słownika',
		dic_create		: 'Utwórz',
		dic_restore		: 'Przywróć',
		dic_delete		: 'Usuń',
		dic_rename		: 'Zmień nazwę',
		dic_info		: 'Początkowo słownik użytkownika przechowywany jest w cookie. Pliki cookie mają jednak ograniczoną pojemność. Jeśli słownik użytkownika przekroczy wielkość dopuszczalną dla pliku cookie, możliwe jest przechowanie go na naszym serwerze. W celu zapisania słownika na serwerze niezbędne jest nadanie mu nazwy. Jeśli słownik został już zapisany na serwerze, wystarczy podać jego nazwę i nacisnąć przycisk Przywróć.',

		aboutTab		: 'Informacje o SCAYT'
	},

	about :
	{
		title		: 'Informacje o programie CKEditor',
		dlgTitle	: 'Informacje o programie CKEditor',
		help	: 'Pomoc znajdziesz w $1.',
		userGuide : 'podręczniku użytkownika programu CKEditor',
		moreInfo	: 'Informacje na temat licencji można znaleźć na naszej stronie:',
		copy		: 'Copyright &copy; $1. Wszelkie prawa zastrzeżone.'
	},

	maximize : 'Maksymalizuj',
	minimize : 'Minimalizuj',

	fakeobjects :
	{
		anchor		: 'Kotwica',
		flash		: 'Animacja Flash',
		iframe		: 'IFrame',
		hiddenfield	: 'Pole ukryte',
		unknown		: 'Nieznany obiekt'
	},

	resize : 'Przeciągnij, aby zmienić rozmiar',

	colordialog :
	{
		title		: 'Wybierz kolor',
		options	:	'Opcje koloru',
		highlight	: 'Zaznacz',
		selected	: 'Wybrany',
		clear		: 'Wyczyść'
	},

	toolbarCollapse	: 'Zwiń pasek narzędzi',
	toolbarExpand	: 'Rozwiń pasek narzędzi',

	toolbarGroups :
	{
		document : 'Dokument',
		clipboard : 'Schowek/Wstecz',
		editing : 'Edycja',
		forms : 'Formularze',
		basicstyles : 'Style podstawowe',
		paragraph : 'Akapit',
		links : 'Hiperłącza',
		insert : 'Wstawianie',
		styles : 'Style',
		colors : 'Kolory',
		tools : 'Narzędzia'
	},

	bidi :
	{
		ltr : 'Kierunek tekstu od lewej strony do prawej',
		rtl : 'Kierunek tekstu od prawej strony do lewej'
	},

	docprops :
	{
		label : 'Właściwości dokumentu',
		title : 'Właściwości dokumentu',
		design : 'Projekt strony',
		meta : 'Znaczniki meta',
		chooseColor : 'Wybierz',
		other : 'Inne',
		docTitle :	'Tytuł strony',
		charset : 	'Kodowanie znaków',
		charsetOther : 'Inne kodowanie znaków',
		charsetASCII : 'ASCII',
		charsetCE : 'Środkowoeuropejskie',
		charsetCT : 'Chińskie tradycyjne (Big5)',
		charsetCR : 'Cyrylica',
		charsetGR : 'Greckie',
		charsetJP : 'Japońskie',
		charsetKR : 'Koreańskie',
		charsetTR : 'Tureckie',
		charsetUN : 'Unicode (UTF-8)',
		charsetWE : 'Zachodnioeuropejskie',
		docType : 'Definicja typu dokumentu',
		docTypeOther : 'Inna definicja typu dokumentu',
		xhtmlDec : 'Uwzględnij deklaracje XHTML',
		bgColor : 'Kolor tła',
		bgImage : 'Adres URL obrazka tła',
		bgFixed : 'Tło nieruchome (nieprzewijające się)',
		txtColor : 'Kolor tekstu',
		margin : 'Marginesy strony',
		marginTop : 'Górny',
		marginLeft : 'Lewy',
		marginRight : 'Prawy',
		marginBottom : 'Dolny',
		metaKeywords : 'Słowa kluczowe dokumentu (oddzielone przecinkami)',
		metaDescription : 'Opis dokumentu',
		metaAuthor : 'Autor',
		metaCopyright : 'Prawa autorskie',
		previewHtml : '<p>To jest <strong>przykładowy tekst</strong>. Korzystasz z programu <a href="javascript:void(0)">CKEditor</a>.</p>'
	}
};
