﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * German language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['de'] =
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
	editorTitle : 'WYSIWYG-Editor, %1, drücken Sie ALT 0 für Hilfe.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'WYSIWYG-Editor',

	// Toolbar buttons without dialogs.
	source			: 'Quellcode',
	newPage			: 'Neue Seite',
	save			: 'Speichern',
	preview			: 'Vorschau',
	cut				: 'Ausschneiden',
	copy			: 'Kopieren',
	paste			: 'Einfügen',
	print			: 'Drucken',
	underline		: 'Unterstrichen',
	bold			: 'Fett',
	italic			: 'Kursiv',
	selectAll		: 'Alles auswählen',
	removeFormat	: 'Formatierungen entfernen',
	strike			: 'Durchgestrichen',
	subscript		: 'Tiefgestellt',
	superscript		: 'Hochgestellt',
	horizontalrule	: 'Horizontale Linie einfügen',
	pagebreak		: 'Seitenumbruch einfügen',
	pagebreakAlt		: 'Seitenumbruch einfügen',
	unlink			: 'Link entfernen',
	undo			: 'Rückgängig',
	redo			: 'Wiederherstellen',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Server durchsuchen',
		url				: 'URL',
		protocol		: 'Protokoll',
		upload			: 'Hochladen',
		uploadSubmit	: 'Zum Server senden',
		image			: 'Bild',
		flash			: 'Flash',
		form			: 'Formular',
		checkbox		: 'Checkbox',
		radio			: 'Radiobutton',
		textField		: 'Textfeld einzeilig',
		textarea		: 'Textfeld mehrzeilig',
		hiddenField		: 'Verstecktes Feld',
		button			: 'Klickbutton',
		select			: 'Auswahlfeld',
		imageButton		: 'Bildbutton',
		notSet			: '<nichts>',
		id				: 'ID',
		name			: 'Name',
		langDir			: 'Schreibrichtung',
		langDirLtr		: 'Links nach Rechts (LTR)',
		langDirRtl		: 'Rechts nach Links (RTL)',
		langCode		: 'Sprachenkürzel',
		longDescr		: 'Langform URL',
		cssClass		: 'Stylesheet Klasse',
		advisoryTitle	: 'Titel Beschreibung',
		cssStyle		: 'Style',
		ok				: 'OK',
		cancel			: 'Abbrechen',
		close			: 'Schließen',
		preview			: 'Vorschau',
		generalTab		: 'Allgemein',
		advancedTab		: 'Erweitert',
		validateNumberFailed : 'Dieser Wert ist keine Nummer.',
		confirmNewPage	: 'Alle nicht gespeicherten Änderungen gehen verlohren. Sind Sie sicher die neue Seite zu laden?',
		confirmCancel	: 'Einige Optionen wurden geändert. Wollen Sie den Dialog dennoch schließen?',
		options			: 'Optionen',
		target			: 'Zielseite',
		targetNew		: 'Neues Fenster (_blank)',
		targetTop		: 'Oberstes Fenster (_top)',
		targetSelf		: 'Gleiches Fenster (_self)',
		targetParent	: 'Oberes Fenster (_parent)',
		langDirLTR		: 'Links nach Rechts (LNR)',
		langDirRTL		: 'Rechts nach Links (RNL)',
		styles			: 'Style',
		cssClasses		: 'Stylesheet Klasse',
		width			: 'Breite',
		height			: 'Höhe',
		align			: 'Ausrichtung',
		alignLeft		: 'Links',
		alignRight		: 'Rechts',
		alignCenter		: 'Zentriert',
		alignTop		: 'Oben',
		alignMiddle		: 'Mitte',
		alignBottom		: 'Unten',
		invalidHeight	: 'Höhe muss eine Zahl sein.',
		invalidWidth	: 'Breite muss eine Zahl sein.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, nicht verfügbar</span>'
	},

	contextmenu :
	{
		options : 'Kontextmenü Optionen'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Sonderzeichen einfügen/editieren',
		title		: 'Sonderzeichen auswählen',
		options : 'Sonderzeichen Optionen'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Link einfügen/editieren',
		other 		: '<andere>',
		menu		: 'Link editieren',
		title		: 'Link',
		info		: 'Link-Info',
		target		: 'Zielseite',
		upload		: 'Hochladen',
		advanced	: 'Erweitert',
		type		: 'Link-Typ',
		toUrl		: 'URL',
		toAnchor	: 'Anker in dieser Seite',
		toEmail		: 'E-Mail',
		targetFrame		: '<Frame>',
		targetPopup		: '<Pop-up Fenster>',
		targetFrameName	: 'Ziel-Fenster-Name',
		targetPopupName	: 'Pop-up Fenster-Name',
		popupFeatures	: 'Pop-up Fenster-Eigenschaften',
		popupResizable	: 'Größe änderbar',
		popupStatusBar	: 'Statusleiste',
		popupLocationBar: 'Adress-Leiste',
		popupToolbar	: 'Werkzeugleiste',
		popupMenuBar	: 'Menü-Leiste',
		popupFullScreen	: 'Vollbild (IE)',
		popupScrollBars	: 'Rollbalken',
		popupDependent	: 'Abhängig (Netscape)',
		popupLeft		: 'Linke Position',
		popupTop		: 'Obere Position',
		id				: 'Id',
		langDir			: 'Schreibrichtung',
		langDirLTR		: 'Links nach Rechts (LTR)',
		langDirRTL		: 'Rechts nach Links (RTL)',
		acccessKey		: 'Zugriffstaste',
		name			: 'Name',
		langCode			: 'Sprachenkürzel',
		tabIndex			: 'Tab-Index',
		advisoryTitle		: 'Titel Beschreibung',
		advisoryContentType	: 'Inhaltstyp',
		cssClasses		: 'Stylesheet Klasse',
		charset			: 'Ziel-Zeichensatz',
		styles			: 'Style',
		rel			: 'Beziehung',
		selectAnchor		: 'Anker auswählen',
		anchorName		: 'nach Anker Name',
		anchorId			: 'nach Element Id',
		emailAddress		: 'E-Mail Addresse',
		emailSubject		: 'Betreffzeile',
		emailBody		: 'Nachrichtentext',
		noAnchors		: '(keine Anker im Dokument vorhanden)',
		noUrl			: 'Bitte geben Sie die Link-URL an',
		noEmail			: 'Bitte geben Sie e-Mail Adresse an'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Anker einfügen/editieren',
		menu		: 'Anker-Eigenschaften',
		title		: 'Anker-Eigenschaften',
		name		: 'Anker Name',
		errorName	: 'Bitte geben Sie den Namen des Ankers ein'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Nummerierte Listen-Eigenschaften',
		bulletedTitle		: 'Listen-Eigenschaften',
		type				: 'Typ',
		start				: 'Start',
		validateStartNumber				:'List Startnummer muss eine ganze Zahl sein.',
		circle				: 'Ring',
		disc				: 'Kreis',
		square				: 'Quadrat',
		none				: 'Keine',
		notset				: '<nicht gesetzt>',
		armenian			: 'Armenisch Nummerierung',
		georgian			: 'Georgisch Nummerierung (an, ban, gan, etc.)',
		lowerRoman			: 'Klein römisch (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Groß römisch (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Klein alpha (a, b, c, d, e, etc.)',
		upperAlpha			: 'Groß alpha (A, B, C, D, E, etc.)',
		lowerGreek			: 'Klein griechisch (alpha, beta, gamma, etc.)',
		decimal				: 'Dezimal (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Dezimal mit führende  Null (01, 02, 03, etc.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Suchen und Ersetzen',
		find				: 'Suchen',
		replace				: 'Ersetzen',
		findWhat			: 'Suche nach:',
		replaceWith			: 'Ersetze mit:',
		notFoundMsg			: 'Der gesuchte Text wurde nicht gefunden.',
		matchCase			: 'Groß-Kleinschreibung beachten',
		matchWord			: 'Nur ganze Worte suchen',
		matchCyclic			: 'Zyklische Suche',
		replaceAll			: 'Alle ersetzen',
		replaceSuccessMsg	: '%1 vorkommen ersetzt.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabelle',
		title		: 'Tabellen-Eigenschaften',
		menu		: 'Tabellen-Eigenschaften',
		deleteTable	: 'Tabelle löschen',
		rows		: 'Zeile',
		columns		: 'Spalte',
		border		: 'Rahmen',
		widthPx		: 'Pixel',
		widthPc		: '%',
		widthUnit	: 'Breite Einheit',
		cellSpace	: 'Zellenabstand außen',
		cellPad		: 'Zellenabstand innen',
		caption		: 'Überschrift',
		summary		: 'Inhaltsübersicht',
		headers		: 'Kopfzeile',
		headersNone		: 'Keine',
		headersColumn	: 'Erste Spalte',
		headersRow		: 'Erste Zeile',
		headersBoth		: 'Beide',
		invalidRows		: 'Die Anzahl der Zeilen muß größer als 0 sein.',
		invalidCols		: 'Die Anzahl der Spalten muß größer als 0 sein..',
		invalidBorder	: 'Die Rahmenbreite muß eine Zahl sein.',
		invalidWidth	: 'Die Tabellenbreite muss eine Zahl sein.',
		invalidHeight	: 'Die Tabellenbreite muß eine Zahl sein.',
		invalidCellSpacing	: 'Der Zellenabstand außen muß eine Zahl sein.',
		invalidCellPadding	: 'Der Zellenabstand innen muß eine Zahl sein.',

		cell :
		{
			menu			: 'Zelle',
			insertBefore	: 'Zelle davor einfügen',
			insertAfter		: 'Zelle danach einfügen',
			deleteCell		: 'Zelle löschen',
			merge			: 'Zellen verbinden',
			mergeRight		: 'Nach rechts verbinden',
			mergeDown		: 'Nach unten verbinden',
			splitHorizontal	: 'Zelle horizontal teilen',
			splitVertical	: 'Zelle vertikal teilen',
			title			: 'Zellen Eigenschaften',
			cellType		: 'Zellart',
			rowSpan			: 'Anzahl Zeilen verbinden',
			colSpan			: 'Anzahl Spalten verbinden',
			wordWrap		: 'Zeilenumbruch',
			hAlign			: 'Horizontale Ausrichtung',
			vAlign			: 'Vertikale Ausrichtung',
			alignBaseline	: 'Grundlinie',
			bgColor			: 'Hintergrundfarbe',
			borderColor		: 'Rahmenfarbe',
			data			: 'Daten',
			header			: 'Überschrift',
			yes				: 'Ja',
			no				: 'Nein',
			invalidWidth	: 'Zellenbreite muß eine Zahl sein.',
			invalidHeight	: 'Zellenhöhe muß eine Zahl sein.',
			invalidRowSpan	: '"Anzahl Zeilen verbinden" muss eine Ganzzahl sein.',
			invalidColSpan	: '"Anzahl Spalten verbinden" muss eine Ganzzahl sein.',
			chooseColor		: 'Wählen'
		},

		row :
		{
			menu			: 'Zeile',
			insertBefore	: 'Zeile oberhalb einfügen',
			insertAfter		: 'Zeile unterhalb einfügen',
			deleteRow		: 'Zeile entfernen'
		},

		column :
		{
			menu			: 'Spalte',
			insertBefore	: 'Spalte links davor einfügen',
			insertAfter		: 'Spalte rechts danach einfügen',
			deleteColumn	: 'Spalte löschen'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Button-Eigenschaften',
		text		: 'Text (Wert)',
		type		: 'Typ',
		typeBtn		: 'Button',
		typeSbm		: 'Absenden',
		typeRst		: 'Zurücksetzen'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Checkbox-Eigenschaften',
		radioTitle	: 'Optionsfeld-Eigenschaften',
		value		: 'Wert',
		selected	: 'ausgewählt'
	},

	// Form Dialog.
	form :
	{
		title		: 'Formular-Eigenschaften',
		menu		: 'Formular-Eigenschaften',
		action		: 'Action',
		method		: 'Method',
		encoding	: 'Zeichenkodierung'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Auswahlfeld-Eigenschaften',
		selectInfo	: 'Info',
		opAvail		: 'Mögliche Optionen',
		value		: 'Wert',
		size		: 'Größe',
		lines		: 'Linien',
		chkMulti	: 'Erlaube Mehrfachauswahl',
		opText		: 'Text',
		opValue		: 'Wert',
		btnAdd		: 'Hinzufügen',
		btnModify	: 'Ändern',
		btnUp		: 'Hoch',
		btnDown		: 'Runter',
		btnSetValue : 'Setze als Standardwert',
		btnDelete	: 'Entfernen'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Textfeld (mehrzeilig) Eigenschaften',
		cols		: 'Spalten',
		rows		: 'Reihen'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Textfeld (einzeilig) Eigenschaften',
		name		: 'Name',
		value		: 'Wert',
		charWidth	: 'Zeichenbreite',
		maxChars	: 'Max. Zeichen',
		type		: 'Typ',
		typeText	: 'Text',
		typePass	: 'Passwort'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Verstecktes Feld-Eigenschaften',
		name	: 'Name',
		value	: 'Wert'
	},

	// Image Dialog.
	image :
	{
		title		: 'Bild-Eigenschaften',
		titleButton	: 'Bildbutton-Eigenschaften',
		menu		: 'Bild-Eigenschaften',
		infoTab		: 'Bild-Info',
		btnUpload	: 'Zum Server senden',
		upload		: 'Hochladen',
		alt			: 'Alternativer Text',
		lockRatio	: 'Größenverhältnis beibehalten',
		unlockRatio	: 'Ratio freischalten',
		resetSize	: 'Größe zurücksetzen',
		border		: 'Rahmen',
		hSpace		: 'Horizontal-Abstand',
		vSpace		: 'Vertikal-Abstand',
		alertUrl	: 'Bitte geben Sie die Bild-URL an',
		linkTab		: 'Link',
		button2Img	: 'Möchten Sie den gewählten Bild-Button in ein einfaches Bild umwandeln?',
		img2Button	: 'Möchten Sie das gewählten Bild in einen Bild-Button umwandeln?',
		urlMissing	: 'Imagequelle URL fehlt.',
		validateBorder	: 'Rahmen muß eine ganze Zahl sein.',
		validateHSpace	: 'Horizontal-Abstand muß eine ganze Zahl sein.',
		validateVSpace	: 'Vertikal-Abstand muß eine ganze Zahl sein.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Flash-Eigenschaften',
		propertiesTab	: 'Eigenschaften',
		title			: 'Flash-Eigenschaften',
		chkPlay			: 'Automatisch Abspielen',
		chkLoop			: 'Endlosschleife',
		chkMenu			: 'Flash-Menü aktivieren',
		chkFull			: 'Vollbildmodus erlauben',
 		scale			: 'Skalierung',
		scaleAll		: 'Alles anzeigen',
		scaleNoBorder	: 'Ohne Rand',
		scaleFit		: 'Passgenau',
		access			: 'Skript Zugang',
		accessAlways	: 'Immer',
		accessSameDomain: 'Gleiche Domain',
		accessNever		: 'Nie',
		alignAbsBottom	: 'Abs Unten',
		alignAbsMiddle	: 'Abs Mitte',
		alignBaseline	: 'Baseline',
		alignTextTop	: 'Text Oben',
		quality			: 'Qualität',
		qualityBest		: 'Beste',
		qualityHigh		: 'Hoch',
		qualityAutoHigh	: 'Auto Hoch',
		qualityMedium	: 'Medium',
		qualityAutoLow	: 'Auto Niedrig',
		qualityLow		: 'Niedrig',
		windowModeWindow: 'Fenster',
		windowModeOpaque: 'Deckend',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Fenster Modus',
		flashvars		: 'Variablen für Flash',
		bgcolor			: 'Hintergrundfarbe',
		hSpace			: 'Horizontal-Abstand',
		vSpace			: 'Vertikal-Abstand',
		validateSrc		: 'Bitte geben Sie die Link-URL an',
		validateHSpace	: 'HSpace muss eine Zahl sein.',
		validateVSpace	: 'VSpace muss eine Zahl sein.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Rechtschreibprüfung',
		title			: 'Rechtschreibprüfung',
		notAvailable	: 'Entschuldigung, aber dieser Dienst steht im Moment nicht zur Verfügung.',
		errorLoading	: 'Fehler beim laden des Dienstanbieters: %s.',
		notInDic		: 'Nicht im Wörterbuch',
		changeTo		: 'Ändern in',
		btnIgnore		: 'Ignorieren',
		btnIgnoreAll	: 'Alle Ignorieren',
		btnReplace		: 'Ersetzen',
		btnReplaceAll	: 'Alle Ersetzen',
		btnUndo			: 'Rückgängig',
		noSuggestions	: ' - keine Vorschläge - ',
		progress		: 'Rechtschreibprüfung läuft...',
		noMispell		: 'Rechtschreibprüfung abgeschlossen - keine Fehler gefunden',
		noChanges		: 'Rechtschreibprüfung abgeschlossen - keine Worte geändert',
		oneChange		: 'Rechtschreibprüfung abgeschlossen - ein Wort geändert',
		manyChanges		: 'Rechtschreibprüfung abgeschlossen - %1 Wörter geändert',
		ieSpellDownload	: 'Rechtschreibprüfung nicht installiert. Möchten Sie sie jetzt herunterladen?'
	},

	smiley :
	{
		toolbar	: 'Smiley',
		title	: 'Smiley auswählen',
		options : 'Smiley Optionen'
	},

	elementsPath :
	{
		eleLabel : 'Elements Pfad',
		eleTitle : '%1 Element'
	},

	numberedlist	: 'Nummerierte Liste',
	bulletedlist	: 'Liste',
	indent			: 'Einzug erhöhen',
	outdent			: 'Einzug verringern',

	justify :
	{
		left	: 'Linksbündig',
		center	: 'Zentriert',
		right	: 'Rechtsbündig',
		block	: 'Blocksatz'
	},

	blockquote : 'Zitatblock',

	clipboard :
	{
		title		: 'Einfügen',
		cutError	: 'Die Sicherheitseinstellungen Ihres Browsers lassen es nicht zu, den Text automatisch auszuschneiden. Bitte benutzen Sie die System-Zwischenablage über STRG-X (ausschneiden) und STRG-V (einfügen).',
		copyError	: 'Die Sicherheitseinstellungen Ihres Browsers lassen es nicht zu, den Text automatisch kopieren. Bitte benutzen Sie die System-Zwischenablage über STRG-C (kopieren).',
		pasteMsg	: 'Bitte fügen Sie den Text in der folgenden Box über die Tastatur (mit <STRONG>Strg+V</STRONG>) ein und bestätigen Sie mit <STRONG>OK</STRONG>.',
		securityMsg	: 'Aufgrund von Sicherheitsbeschränkungen Ihres Browsers kann der Editor nicht direkt auf die Zwischenablage zugreifen. Bitte fügen Sie den Inhalt erneut in diesem Fenster ein.',
		pasteArea	: 'Einfügebereich'
	},

	pastefromword :
	{
		confirmCleanup	: 'Der Text, den Sie einfügen möchten, scheint aus MS-Word kopiert zu sein. Möchten Sie ihn zuvor bereinigen lassen?',
		toolbar			: 'Aus MS-Word einfügen',
		title			: 'Aus MS-Word einfügen',
		error			: 'Aufgrund eines internen Fehlers war es nicht möglich die eingefügten Daten zu bereinigen'
	},

	pasteText :
	{
		button	: 'Als Text einfügen',
		title	: 'Als Text einfügen'
	},

	templates :
	{
		button			: 'Vorlagen',
		title			: 'Vorlagen',
		options : 'Vorlagen Optionen',
		insertOption	: 'Aktuellen Inhalt ersetzen',
		selectPromptMsg	: 'Klicken Sie auf eine Vorlage, um sie im Editor zu öffnen (der aktuelle Inhalt wird dabei gelöscht!):',
		emptyListMsg	: '(keine Vorlagen definiert)'
	},

	showBlocks : 'Blöcke anzeigen',

	stylesCombo :
	{
		label		: 'Stil',
		panelTitle	: 'Formatierungenstil',
		panelTitle1	: 'Block Stilart',
		panelTitle2	: 'Inline Stilart',
		panelTitle3	: 'Objekt Stilart'
	},

	format :
	{
		label		: 'Format',
		panelTitle	: 'Format',

		tag_p		: 'Normal',
		tag_pre		: 'Formatiert',
		tag_address	: 'Addresse',
		tag_h1		: 'Überschrift 1',
		tag_h2		: 'Überschrift 2',
		tag_h3		: 'Überschrift 3',
		tag_h4		: 'Überschrift 4',
		tag_h5		: 'Überschrift 5',
		tag_h6		: 'Überschrift 6',
		tag_div		: 'Normal (DIV)'
	},

	div :
	{
		title				: 'Div Container erzeugen',
		toolbar				: 'Div Container erzeugen',
		cssClassInputLabel	: 'Stylesheet Klasse',
		styleSelectLabel	: 'Style',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: 'Sprachenkürzel',
		inlineStyleInputLabel	: 'Inline Stil',
		advisoryTitleInputLabel	: 'Tooltip',
		langDirLabel		: 'Sprache Richtung',
		langDirLTRLabel		: 'Links nach Rechs (LTR)',
		langDirRTLLabel		: 'Rechs nach Links (RTL)',
		edit				: 'Div bearbeiten',
		remove				: 'Div entfernen'
  	},

	iframe :
	{
		title		: 'IFrame-Eigenschaften',
		toolbar		: 'IFrame',
		noUrl		: 'Bitte geben Sie die IFrame-URL an',
		scrolling	: 'Rollbalken anzeigen',
		border		: 'Rahmen anzeigen'
	},

	font :
	{
		label		: 'Schriftart',
		voiceLabel	: 'Schriftart',
		panelTitle	: 'Schriftart'
	},

	fontSize :
	{
		label		: 'Größe',
		voiceLabel	: 'Schrifgröße',
		panelTitle	: 'Größe'
	},

	colorButton :
	{
		textColorTitle	: 'Textfarbe',
		bgColorTitle	: 'Hintergrundfarbe',
		panelTitle		: 'Farben',
		auto			: 'Automatisch',
		more			: 'Weitere Farben...'
	},

	colors :
	{
		'000' : 'Schwarz',
		'800000' : 'Kastanienbraun',
		'8B4513' : 'Braun',
		'2F4F4F' : 'Dunkles Schiefergrau',
		'008080' : 'Blaugrün',
		'000080' : 'Navy',
		'4B0082' : 'Indigo',
		'696969' : 'Dunkelgrau',
		'B22222' : 'Ziegelrot',
		'A52A2A' : 'Braun',
		'DAA520' : 'Goldgelb',
		'006400' : 'Dunkelgrün',
		'40E0D0' : 'Türkis',
		'0000CD' : 'Medium Blau',
		'800080' : 'Lila',
		'808080' : 'Grau',
		'F00' : 'Rot',
		'FF8C00' : 'Dunkelorange',
		'FFD700' : 'Gold',
		'008000' : 'Grün',
		'0FF' : 'Cyan',
		'00F' : 'Blau',
		'EE82EE' : 'Hellviolett',
		'A9A9A9' : 'Dunkelgrau',
		'FFA07A' : 'Helles Lachsrosa',
		'FFA500' : 'Orange',
		'FFFF00' : 'Gelb',
		'00FF00' : 'Lime',
		'AFEEEE' : 'Blaß-Türkis',
		'ADD8E6' : 'Hellblau',
		'DDA0DD' : 'Pflaumenblau',
		'D3D3D3' : 'Hellgrau',
		'FFF0F5' : 'Lavendel',
		'FAEBD7' : 'Antik Weiß',
		'FFFFE0' : 'Hellgelb',
		'F0FFF0' : 'Honigtau',
		'F0FFFF' : 'Azurblau',
		'F0F8FF' : 'Alice Blau',
		'E6E6FA' : 'Lavendel',
		'FFF' : 'Weiß'
	},

	scayt :
	{
		title			: 'Rechtschreibprüfung während der Texteingabe (SCAYT)',
		opera_title		: 'Nicht von Opera unterstützt',
		enable			: 'SCAYT einschalten',
		disable			: 'SCAYT ausschalten',
		about			: 'Über SCAYT',
		toggle			: 'SCAYT umschalten',
		options			: 'Optionen',
		langs			: 'Sprachen',
		moreSuggestions	: 'Mehr Vorschläge',
		ignore			: 'Ignorieren',
		ignoreAll		: 'Alle ignorieren',
		addWord			: 'Wort hinzufügen',
		emptyDic		: 'Wörterbuchname sollte leer sein.',

		optionsTab		: 'Optionen',
		allCaps			: 'Groß geschriebenen Wörter ignorieren',
		ignoreDomainNames : 'Domain-Namen ignorieren',
		mixedCase		: 'Wörter mit gemischte Setzkasten ignorieren',
		mixedWithDigits	: 'Wörter mit Zahlen ignorieren',

		languagesTab	: 'Sprachen',

		dictionariesTab	: 'Wörterbücher',
		dic_field_name	: 'Wörterbuchname',
		dic_create		: 'Erzeugen',
		dic_restore		: 'Wiederherstellen',
		dic_delete		: 'Löschen',
		dic_rename		: 'Umbenennen',
		dic_info		: 'Anfangs wird das Benutzerwörterbuch in einem Cookie gespeichert. Allerdings sind Cookies in der Größe begrenzt. Wenn das Benutzerwörterbuch bis zu einem Punkt wächst, wo es nicht mehr in einem Cookie gespeichert werden kann, wird das Benutzerwörterbuch auf dem Server gespeichert. Um Ihr persönliches Wörterbuch auf dem Server zu speichern, müssen Sie einen Namen für das Wörterbuch angeben. Falls  Sie schon ein gespeicherte Wörterbuch haben, geben Sie bitte dessen Namen ein und klicken Sie auf die Schaltfläche Wiederherstellen.',

		aboutTab		: 'Über'
	},

	about :
	{
		title		: 'Über CKEditor',
		dlgTitle	: 'Über CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Für Informationen über unsere Lizenzbestimmungen besuchen sie bitte unsere Webseite:',
		copy		: 'Copyright &copy; $1. Alle Rechte vorbehalten.'
	},

	maximize : 'Maximieren',
	minimize : 'Minimieren',

	fakeobjects :
	{
		anchor		: 'Anker',
		flash		: 'Flash Animation',
		iframe		: 'IFrame',
		hiddenfield	: 'Verstecktes Feld',
		unknown		: 'Unbekanntes Objekt'
	},

	resize : 'Zum Vergrößern ziehen',

	colordialog :
	{
		title		: 'Farbe wählen',
		options	:	'Farbeoptionen',
		highlight	: 'Hervorheben',
		selected	: 'Ausgewählte Farbe',
		clear		: 'Entfernen'
	},

	toolbarCollapse	: 'Symbolleiste einklappen',
	toolbarExpand	: 'Symbolleiste ausklappen',

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
		ltr : 'Leserichtung von Links nach Rechts',
		rtl : 'Leserichtung von Rechts nach Links'
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
