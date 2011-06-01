﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Finnish language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['fi'] =
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
	editorTitle : 'Rikastekstieditori, %1, paina ALT 0 nähdäksesi ohjeen.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Rikastekstieditori',

	// Toolbar buttons without dialogs.
	source			: 'Koodi',
	newPage			: 'Tyhjennä',
	save			: 'Tallenna',
	preview			: 'Esikatsele',
	cut				: 'Leikkaa',
	copy			: 'Kopioi',
	paste			: 'Liitä',
	print			: 'Tulosta',
	underline		: 'Alleviivattu',
	bold			: 'Lihavoitu',
	italic			: 'Kursivoitu',
	selectAll		: 'Valitse kaikki',
	removeFormat	: 'Poista muotoilu',
	strike			: 'Yliviivattu',
	subscript		: 'Alaindeksi',
	superscript		: 'Yläindeksi',
	horizontalrule	: 'Lisää murtoviiva',
	pagebreak		: 'Lisää sivunvaihto',
	pagebreakAlt		: 'Sivunvaihto',
	unlink			: 'Poista linkki',
	undo			: 'Kumoa',
	redo			: 'Toista',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Selaa palvelinta',
		url				: 'Osoite',
		protocol		: 'Protokolla',
		upload			: 'Lisää tiedosto',
		uploadSubmit	: 'Lähetä palvelimelle',
		image			: 'Kuva',
		flash			: 'Flash',
		form			: 'Lomake',
		checkbox		: 'Valintaruutu',
		radio			: 'Radiopainike',
		textField		: 'Tekstikenttä',
		textarea		: 'Tekstilaatikko',
		hiddenField		: 'Piilokenttä',
		button			: 'Painike',
		select			: 'Valintakenttä',
		imageButton		: 'Kuvapainike',
		notSet			: '<ei asetettu>',
		id				: 'Tunniste',
		name			: 'Nimi',
		langDir			: 'Kielen suunta',
		langDirLtr		: 'Vasemmalta oikealle (LTR)',
		langDirRtl		: 'Oikealta vasemmalle (RTL)',
		langCode		: 'Kielikoodi',
		longDescr		: 'Pitkän kuvauksen URL',
		cssClass		: 'Tyyliluokat',
		advisoryTitle	: 'Avustava otsikko',
		cssStyle		: 'Tyyli',
		ok				: 'OK',
		cancel			: 'Peruuta',
		close			: 'Sulje',
		preview			: 'Esikatselu',
		generalTab		: 'Yleinen',
		advancedTab		: 'Lisäominaisuudet',
		validateNumberFailed : 'Arvon pitää olla numero.',
		confirmNewPage	: 'Kaikki tallentamattomat muutokset tähän sisältöön menetetään. Oletko varma, että haluat ladata uuden sivun?',
		confirmCancel	: 'Jotkut asetuksista on muuttuneet. Oletko varma, että haluat sulkea valintaikkunan?',
		options			: 'Asetukset',
		target			: 'Kohde',
		targetNew		: 'Uusi ikkuna (_blank)',
		targetTop		: 'Päällimmäinen ikkuna (_top)',
		targetSelf		: 'Sama ikkuna (_self)',
		targetParent	: 'Ylemmän tason ikkuna (_parent)',
		langDirLTR		: 'Vasemmalta oikealle (LTR)',
		langDirRTL		: 'Oikealta vasemmalle (RTL)',
		styles			: 'Tyyli',
		cssClasses		: 'Tyylitiedoston luokat',
		width			: 'Leveys',
		height			: 'Korkeus',
		align			: 'Kohdistus',
		alignLeft		: 'Vasemmalle',
		alignRight		: 'Oikealle',
		alignCenter		: 'Keskelle',
		alignTop		: 'Ylös',
		alignMiddle		: 'Keskelle',
		alignBottom		: 'Alas',
		invalidHeight	: 'Korkeuden täytyy olla numero.',
		invalidWidth	: 'Leveyden täytyy olla numero.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, ei saatavissa</span>'
	},

	contextmenu :
	{
		options : 'Pikavalikon ominaisuudet'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Lisää erikoismerkki',
		title		: 'Valitse erikoismerkki',
		options : 'Erikoismerkin ominaisuudet'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Lisää linkki/muokkaa linkkiä',
		other 		: '<muu>',
		menu		: 'Muokkaa linkkiä',
		title		: 'Linkki',
		info		: 'Linkin tiedot',
		target		: 'Kohde',
		upload		: 'Lisää tiedosto',
		advanced	: 'Lisäominaisuudet',
		type		: 'Linkkityyppi',
		toUrl		: 'Osoite',
		toAnchor	: 'Ankkuri tässä sivussa',
		toEmail		: 'Sähköposti',
		targetFrame		: '<kehys>',
		targetPopup		: '<popup ikkuna>',
		targetFrameName	: 'Kohdekehyksen nimi',
		targetPopupName	: 'Popup ikkunan nimi',
		popupFeatures	: 'Popup ikkunan ominaisuudet',
		popupResizable	: 'Venytettävä',
		popupStatusBar	: 'Tilarivi',
		popupLocationBar: 'Osoiterivi',
		popupToolbar	: 'Vakiopainikkeet',
		popupMenuBar	: 'Valikkorivi',
		popupFullScreen	: 'Täysi ikkuna (IE)',
		popupScrollBars	: 'Vierityspalkit',
		popupDependent	: 'Riippuva (Netscape)',
		popupLeft		: 'Vasemmalta (px)',
		popupTop		: 'Ylhäältä (px)',
		id				: 'Tunniste',
		langDir			: 'Kielen suunta',
		langDirLTR		: 'Vasemmalta oikealle (LTR)',
		langDirRTL		: 'Oikealta vasemmalle (RTL)',
		acccessKey		: 'Pikanäppäin',
		name			: 'Nimi',
		langCode			: 'Kielen suunta',
		tabIndex			: 'Tabulaattori indeksi',
		advisoryTitle		: 'Avustava otsikko',
		advisoryContentType	: 'Avustava sisällön tyyppi',
		cssClasses		: 'Tyyliluokat',
		charset			: 'Linkitetty kirjaimisto',
		styles			: 'Tyyli',
		rel			: 'Suhde',
		selectAnchor		: 'Valitse ankkuri',
		anchorName		: 'Ankkurin nimen mukaan',
		anchorId			: 'Ankkurin ID:n mukaan',
		emailAddress		: 'Sähköpostiosoite',
		emailSubject		: 'Aihe',
		emailBody		: 'Viesti',
		noAnchors		: '(Ei ankkureita tässä dokumentissa)',
		noUrl			: 'Linkille on kirjoitettava URL',
		noEmail			: 'Kirjoita sähköpostiosoite'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Lisää ankkuri/muokkaa ankkuria',
		menu		: 'Ankkurin ominaisuudet',
		title		: 'Ankkurin ominaisuudet',
		name		: 'Nimi',
		errorName	: 'Ankkurille on kirjoitettava nimi'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Numeroidun listan ominaisuudet',
		bulletedTitle		: 'Numeroimattoman listan ominaisuudet',
		type				: 'Tyyppi',
		start				: 'Alku',
		validateStartNumber				:'Listan ensimmäisen numeron tulee olla kokonaisluku.',
		circle				: 'Ympyrä',
		disc				: 'Levy',
		square				: 'Neliö',
		none				: 'Ei mikään',
		notset				: '<ei asetettu>',
		armenian			: 'Armeenialainen numerointi',
		georgian			: 'Georgialainen numerointi (an, ban, gan, etc.)',
		lowerRoman			: 'Pienet roomalaiset (i, ii, iii, iv, v, jne.)',
		upperRoman			: 'Isot roomalaiset (I, II, III, IV, V, jne.)',
		lowerAlpha			: 'Pienet aakkoset (a, b, c, d, e, jne.)',
		upperAlpha			: 'Isot aakkoset (A, B, C, D, E, jne.)',
		lowerGreek			: 'Pienet kreikkalaiset (alpha, beta, gamma, jne.)',
		decimal				: 'Desimaalit (1, 2, 3, jne.)',
		decimalLeadingZero	: 'Desimaalit, alussa nolla (01, 02, 03, jne.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Etsi ja korvaa',
		find				: 'Etsi',
		replace				: 'Korvaa',
		findWhat			: 'Etsi mitä:',
		replaceWith			: 'Korvaa tällä:',
		notFoundMsg			: 'Etsittyä tekstiä ei löytynyt.',
		matchCase			: 'Sama kirjainkoko',
		matchWord			: 'Koko sana',
		matchCyclic			: 'Kierrä ympäri',
		replaceAll			: 'Korvaa kaikki',
		replaceSuccessMsg	: '%1 esiintymä(ä) korvattu.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Taulu',
		title		: 'Taulun ominaisuudet',
		menu		: 'Taulun ominaisuudet',
		deleteTable	: 'Poista taulu',
		rows		: 'Rivit',
		columns		: 'Sarakkeet',
		border		: 'Rajan paksuus',
		widthPx		: 'pikseliä',
		widthPc		: 'prosenttia',
		widthUnit	: 'leveysyksikkö',
		cellSpace	: 'Solujen väli',
		cellPad		: 'Solujen sisennys',
		caption		: 'Otsikko',
		summary		: 'Yhteenveto',
		headers		: 'Ylätunnisteet',
		headersNone		: 'Ei',
		headersColumn	: 'Ensimmäinen sarake',
		headersRow		: 'Ensimmäinen rivi',
		headersBoth		: 'Molemmat',
		invalidRows		: 'Rivien määrän täytyy olla suurempi kuin 0.',
		invalidCols		: 'Sarakkeiden määrän täytyy olla suurempi kuin 0.',
		invalidBorder	: 'Reunan koon täytyy olla numero.',
		invalidWidth	: 'Taulun leveyden täytyy olla numero.',
		invalidHeight	: 'Taulun korkeuden täytyy olla numero.',
		invalidCellSpacing	: 'Solujen välin täytyy olla numero.',
		invalidCellPadding	: 'Solujen sisennyksen täytyy olla numero.',

		cell :
		{
			menu			: 'Solu',
			insertBefore	: 'Lisää solu eteen',
			insertAfter		: 'Lisää solu perään',
			deleteCell		: 'Poista solut',
			merge			: 'Yhdistä solut',
			mergeRight		: 'Yhdistä oikealla olevan kanssa',
			mergeDown		: 'Yhdistä alla olevan kanssa',
			splitHorizontal	: 'Jaa solu vaakasuunnassa',
			splitVertical	: 'Jaa solu pystysuunnassa',
			title			: 'Solun ominaisuudet',
			cellType		: 'Solun tyyppi',
			rowSpan			: 'Rivin jatkuvuus',
			colSpan			: 'Solun jatkuvuus',
			wordWrap		: 'Rivitys',
			hAlign			: 'Horisontaali kohdistus',
			vAlign			: 'Vertikaali kohdistus',
			alignBaseline	: 'Alas (teksti)',
			bgColor			: 'Taustan väri',
			borderColor		: 'Reunan väri',
			data			: 'Data',
			header			: 'Ylätunniste',
			yes				: 'Kyllä',
			no				: 'Ei',
			invalidWidth	: 'Solun leveyden täytyy olla numero.',
			invalidHeight	: 'Solun korkeuden täytyy olla numero.',
			invalidRowSpan	: 'Rivin jatkuvuuden täytyy olla kokonaisluku.',
			invalidColSpan	: 'Solun jatkuvuuden täytyy olla kokonaisluku.',
			chooseColor		: 'Valitse'
		},

		row :
		{
			menu			: 'Rivi',
			insertBefore	: 'Lisää rivi yläpuolelle',
			insertAfter		: 'Lisää rivi alapuolelle',
			deleteRow		: 'Poista rivit'
		},

		column :
		{
			menu			: 'Sarake',
			insertBefore	: 'Lisää sarake vasemmalle',
			insertAfter		: 'Lisää sarake oikealle',
			deleteColumn	: 'Poista sarakkeet'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Painikkeen ominaisuudet',
		text		: 'Teksti (arvo)',
		type		: 'Tyyppi',
		typeBtn		: 'Painike',
		typeSbm		: 'Lähetä',
		typeRst		: 'Tyhjennä'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Valintaruudun ominaisuudet',
		radioTitle	: 'Radiopainikkeen ominaisuudet',
		value		: 'Arvo',
		selected	: 'Valittu'
	},

	// Form Dialog.
	form :
	{
		title		: 'Lomakkeen ominaisuudet',
		menu		: 'Lomakkeen ominaisuudet',
		action		: 'Toiminto',
		method		: 'Tapa',
		encoding	: 'Enkoodaus'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Valintakentän ominaisuudet',
		selectInfo	: 'Info',
		opAvail		: 'Ominaisuudet',
		value		: 'Arvo',
		size		: 'Koko',
		lines		: 'Rivit',
		chkMulti	: 'Salli usea valinta',
		opText		: 'Teksti',
		opValue		: 'Arvo',
		btnAdd		: 'Lisää',
		btnModify	: 'Muuta',
		btnUp		: 'Ylös',
		btnDown		: 'Alas',
		btnSetValue : 'Aseta valituksi',
		btnDelete	: 'Poista'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Tekstilaatikon ominaisuudet',
		cols		: 'Sarakkeita',
		rows		: 'Rivejä'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Tekstikentän ominaisuudet',
		name		: 'Nimi',
		value		: 'Arvo',
		charWidth	: 'Leveys',
		maxChars	: 'Maksimi merkkimäärä',
		type		: 'Tyyppi',
		typeText	: 'Teksti',
		typePass	: 'Salasana'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Piilokentän ominaisuudet',
		name	: 'Nimi',
		value	: 'Arvo'
	},

	// Image Dialog.
	image :
	{
		title		: 'Kuvan ominaisuudet',
		titleButton	: 'Kuvapainikkeen ominaisuudet',
		menu		: 'Kuvan ominaisuudet',
		infoTab		: 'Kuvan tiedot',
		btnUpload	: 'Lähetä palvelimelle',
		upload		: 'Lisää kuva',
		alt			: 'Vaihtoehtoinen teksti',
		lockRatio	: 'Lukitse suhteet',
		unlockRatio	: 'Vapauta suhteet',
		resetSize	: 'Alkuperäinen koko',
		border		: 'Kehys',
		hSpace		: 'Vaakatila',
		vSpace		: 'Pystytila',
		alertUrl	: 'Kirjoita kuvan osoite (URL)',
		linkTab		: 'Linkki',
		button2Img	: 'Haluatko muuntaa valitun kuvanäppäimen kuvaksi?',
		img2Button	: 'Haluatko muuntaa valitun kuvan kuvanäppäimeksi?',
		urlMissing	: 'Kuvan lähdeosoite puuttuu.',
		validateBorder	: 'Kehyksen täytyy olla kokonaisluku.',
		validateHSpace	: 'HSpace-määrityksen täytyy olla kokonaisluku.',
		validateVSpace	: 'VSpace-määrityksen täytyy olla kokonaisluku.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Flash-ominaisuudet',
		propertiesTab	: 'Ominaisuudet',
		title			: 'Flash ominaisuudet',
		chkPlay			: 'Automaattinen käynnistys',
		chkLoop			: 'Toisto',
		chkMenu			: 'Näytä Flash-valikko',
		chkFull			: 'Salli kokoruututila',
 		scale			: 'Levitä',
		scaleAll		: 'Näytä kaikki',
		scaleNoBorder	: 'Ei rajaa',
		scaleFit		: 'Tarkka koko',
		access			: 'Skriptien pääsy',
		accessAlways	: 'Aina',
		accessSameDomain: 'Sama verkkotunnus',
		accessNever		: 'Ei koskaan',
		alignAbsBottom	: 'Aivan alas',
		alignAbsMiddle	: 'Aivan keskelle',
		alignBaseline	: 'Alas (teksti)',
		alignTextTop	: 'Ylös (teksti)',
		quality			: 'Laatu',
		qualityBest		: 'Paras',
		qualityHigh		: 'Korkea',
		qualityAutoHigh	: 'Automaattinen korkea',
		qualityMedium	: 'Keskitaso',
		qualityAutoLow	: 'Automaattinen matala',
		qualityLow		: 'Matala',
		windowModeWindow: 'Ikkuna',
		windowModeOpaque: 'Läpinäkyvyys',
		windowModeTransparent : 'Läpinäkyvä',
		windowMode		: 'Ikkuna tila',
		flashvars		: 'Muuttujat Flash:lle',
		bgcolor			: 'Taustaväri',
		hSpace			: 'Vaakatila',
		vSpace			: 'Pystytila',
		validateSrc		: 'Linkille on kirjoitettava URL',
		validateHSpace	: 'Vaakatilan täytyy olla numero.',
		validateVSpace	: 'Pystytilan täytyy olla numero.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Tarkista oikeinkirjoitus',
		title			: 'Oikoluku',
		notAvailable	: 'Valitettavasti oikoluku ei ole käytössä tällä hetkellä.',
		errorLoading	: 'Virhe ladattaessa oikolukupalvelua isännältä: %s.',
		notInDic		: 'Ei sanakirjassa',
		changeTo		: 'Vaihda',
		btnIgnore		: 'Jätä huomioimatta',
		btnIgnoreAll	: 'Jätä kaikki huomioimatta',
		btnReplace		: 'Korvaa',
		btnReplaceAll	: 'Korvaa kaikki',
		btnUndo			: 'Kumoa',
		noSuggestions	: 'Ei ehdotuksia',
		progress		: 'Tarkistus käynnissä...',
		noMispell		: 'Tarkistus valmis: Ei virheitä',
		noChanges		: 'Tarkistus valmis: Yhtään sanaa ei muutettu',
		oneChange		: 'Tarkistus valmis: Yksi sana muutettiin',
		manyChanges		: 'Tarkistus valmis: %1 sanaa muutettiin',
		ieSpellDownload	: 'Oikeinkirjoituksen tarkistusta ei ole asennettu. Haluatko ladata sen nyt?'
	},

	smiley :
	{
		toolbar	: 'Hymiö',
		title	: 'Lisää hymiö',
		options : 'Hymiön ominaisuudet'
	},

	elementsPath :
	{
		eleLabel : 'Elementin polku',
		eleTitle : '%1 elementti'
	},

	numberedlist	: 'Numerointi',
	bulletedlist	: 'Luottelomerkit',
	indent			: 'Suurenna sisennystä',
	outdent			: 'Pienennä sisennystä',

	justify :
	{
		left	: 'Tasaa vasemmat reunat',
		center	: 'Keskitä',
		right	: 'Tasaa oikeat reunat',
		block	: 'Tasaa molemmat reunat'
	},

	blockquote : 'Lainaus',

	clipboard :
	{
		title		: 'Liitä',
		cutError	: 'Selaimesi turva-asetukset eivät salli editorin toteuttaa leikkaamista. Käytä näppäimistöä leikkaamiseen (Ctrl+X).',
		copyError	: 'Selaimesi turva-asetukset eivät salli editorin toteuttaa kopioimista. Käytä näppäimistöä kopioimiseen (Ctrl+C).',
		pasteMsg	: 'Liitä painamalla (<STRONG>Ctrl+V</STRONG>) ja painamalla <STRONG>OK</STRONG>.',
		securityMsg	: 'Selaimesi turva-asetukset eivät salli editorin käyttää leikepöytää suoraan. Sinun pitää suorittaa liittäminen tässä ikkunassa.',
		pasteArea	: 'Leikealue'
	},

	pastefromword :
	{
		confirmCleanup	: 'Liittämäsi teksti näyttäisi olevan Word-dokumentista. Haluatko siivota sen ennen liittämistä? (Suositus: Kyllä)',
		toolbar			: 'Liitä Word-dokumentista',
		title			: 'Liitä Word-dokumentista',
		error			: 'Liitetyn tiedon siivoaminen ei onnistunut sisäisen virheen takia'
	},

	pasteText :
	{
		button	: 'Liitä tekstinä',
		title	: 'Liitä tekstinä'
	},

	templates :
	{
		button			: 'Pohjat',
		title			: 'Sisältöpohjat',
		options : 'Sisältöpohjan ominaisuudet',
		insertOption	: 'Korvaa editorin koko sisältö',
		selectPromptMsg	: 'Valitse pohja editoriin<br>(aiempi sisältö menetetään):',
		emptyListMsg	: '(Ei määriteltyjä pohjia)'
	},

	showBlocks : 'Näytä elementit',

	stylesCombo :
	{
		label		: 'Tyyli',
		panelTitle	: 'Muotoilujen tyylit',
		panelTitle1	: 'Lohkojen tyylit',
		panelTitle2	: 'Rivinsisäiset tyylit',
		panelTitle3	: 'Objektien tyylit'
	},

	format :
	{
		label		: 'Muotoilu',
		panelTitle	: 'Muotoilu',

		tag_p		: 'Normaali',
		tag_pre		: 'Muotoiltu',
		tag_address	: 'Osoite',
		tag_h1		: 'Otsikko 1',
		tag_h2		: 'Otsikko 2',
		tag_h3		: 'Otsikko 3',
		tag_h4		: 'Otsikko 4',
		tag_h5		: 'Otsikko 5',
		tag_h6		: 'Otsikko 6',
		tag_div		: 'Normaali (DIV)'
	},

	div :
	{
		title				: 'Luo div-kehikko',
		toolbar				: 'Luo div-kehikko',
		cssClassInputLabel	: 'Tyylitiedoston luokat',
		styleSelectLabel	: 'Tyyli',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Kielen koodi',
		inlineStyleInputLabel	: 'Sisätyyli',
		advisoryTitleInputLabel	: 'Ohjeistava otsikko',
		langDirLabel		: 'Kielen suunta',
		langDirLTRLabel		: 'Vasemmalta oikealle (LTR)',
		langDirRTLLabel		: 'Oikealta vasemmalle (RTL)',
		edit				: 'Muokkaa Diviä',
		remove				: 'Poista Div'
  	},

	iframe :
	{
		title		: 'IFrame-kehyksen ominaisuudet',
		toolbar		: 'IFrame-kehys',
		noUrl		: 'Anna IFrame-kehykselle lähdeosoite (src)',
		scrolling	: 'Näytä vierityspalkit',
		border		: 'Näytä kehyksen reunat'
	},

	font :
	{
		label		: 'Kirjaisinlaji',
		voiceLabel	: 'Kirjaisinlaji',
		panelTitle	: 'Kirjaisinlaji'
	},

	fontSize :
	{
		label		: 'Koko',
		voiceLabel	: 'Kirjaisimen koko',
		panelTitle	: 'Koko'
	},

	colorButton :
	{
		textColorTitle	: 'Tekstiväri',
		bgColorTitle	: 'Taustaväri',
		panelTitle		: 'Värit',
		auto			: 'Automaattinen',
		more			: 'Lisää värejä...'
	},

	colors :
	{
		'000' : 'Musta',
		'800000' : 'Kastanjanruskea',
		'8B4513' : 'Satulanruskea',
		'2F4F4F' : 'Tumma liuskekivenharmaa',
		'008080' : 'Sinivihreä',
		'000080' : 'Laivastonsininen',
		'4B0082' : 'Indigonsininen',
		'696969' : 'Tummanharmaa',
		'B22222' : 'Tiili',
		'A52A2A' : 'Ruskea',
		'DAA520' : 'Kultapiisku',
		'006400' : 'Tummanvihreä',
		'40E0D0' : 'Turkoosi',
		'0000CD' : 'Keskisininen',
		'800080' : 'Purppura',
		'808080' : 'Harmaa',
		'F00' : 'Punainen',
		'FF8C00' : 'Tumma oranssi',
		'FFD700' : 'Kulta',
		'008000' : 'Vihreä',
		'0FF' : 'Syaani',
		'00F' : 'Sininen',
		'EE82EE' : 'Violetti',
		'A9A9A9' : 'Tummanharmaa',
		'FFA07A' : 'Vaaleanlohenpunainen',
		'FFA500' : 'Oranssi',
		'FFFF00' : 'Keltainen',
		'00FF00' : 'Limetin vihreä',
		'AFEEEE' : 'Haalea turkoosi',
		'ADD8E6' : 'Vaaleansininen',
		'DDA0DD' : 'Luumu',
		'D3D3D3' : 'Vaaleanharmaa',
		'FFF0F5' : 'Laventelinpunainen',
		'FAEBD7' : 'Antiikinvalkoinen',
		'FFFFE0' : 'Vaaleankeltainen',
		'F0FFF0' : 'Hunajameloni',
		'F0FFFF' : 'Asurinsininen',
		'F0F8FF' : 'Alice Blue -sininen',
		'E6E6FA' : 'Lavanteli',
		'FFF' : 'Valkoinen'
	},

	scayt :
	{
		title			: 'Oikolue kirjoitettaessa',
		opera_title		: 'Opera ei tue tätä ominaisuutta',
		enable			: 'Ota käyttöön oikoluku kirjoitettaessa',
		disable			: 'Poista käytöstä oikoluku kirjoitetaessa',
		about			: 'Tietoja oikoluvusta kirjoitetaessa',
		toggle			: 'Vaihda oikoluku kirjoittaessa tilaa',
		options			: 'Asetukset',
		langs			: 'Kielet',
		moreSuggestions	: 'Lisää ehdotuksia',
		ignore			: 'Ohita',
		ignoreAll		: 'Ohita kaikki',
		addWord			: 'Lisää sana',
		emptyDic		: 'Sanakirjan nimi on annettava.',

		optionsTab		: 'Asetukset',
		allCaps			: 'Ohita sanat, jotka on kirjoitettu kokonaan isoilla kirjaimilla',
		ignoreDomainNames : 'Ohita verkkotunnukset',
		mixedCase		: 'Ohita sanat, joissa on sekoitettu isoja ja pieniä kirjaimia',
		mixedWithDigits	: 'Ohita sanat, joissa on numeroita',

		languagesTab	: 'Kielet',

		dictionariesTab	: 'Sanakirjat',
		dic_field_name	: 'Sanakirjan nimi',
		dic_create		: 'Luo',
		dic_restore		: 'Palauta',
		dic_delete		: 'Poista',
		dic_rename		: 'Nimeä uudelleen',
		dic_info		: 'Oletuksena sanakirjat tallennetaan evästeeseen, mutta evästeiden koko on kuitenkin rajallinen. Sanakirjan kasvaessa niin suureksi, ettei se enää mahdu evästeeseen, sanakirja täytyy tallentaa palvelimellemme. Tallentaaksesi sanakirjasi palvelimellemme tulee sinun antaa sille nimi. Jos olet jo tallentanut sanakirjan, anna sen nimi ja klikkaa Palauta-painiketta',

		aboutTab		: 'Tietoa'
	},

	about :
	{
		title		: 'Tietoa CKEditorista',
		dlgTitle	: 'Tietoa CKEditorista',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Lisenssitiedot löytyvät kotisivuiltamme:',
		copy		: 'Copyright &copy; $1. Kaikki oikeuden pidätetään.'
	},

	maximize : 'Suurenna',
	minimize : 'Pienennä',

	fakeobjects :
	{
		anchor		: 'Ankkuri',
		flash		: 'Flash animaatio',
		iframe		: 'IFrame-kehys',
		hiddenfield	: 'Piilokenttä',
		unknown		: 'Tuntematon objekti'
	},

	resize : 'Raahaa muuttaaksesi kokoa',

	colordialog :
	{
		title		: 'Valitse väri',
		options	:	'Värin ominaisuudet',
		highlight	: 'Korostus',
		selected	: 'Valittu',
		clear		: 'Poista'
	},

	toolbarCollapse	: 'Kutista työkalupalkki',
	toolbarExpand	: 'Laajenna työkalupalkki',

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
		ltr : 'Tekstin suunta vasemmalta oikealle',
		rtl : 'Tekstin suunta oikealta vasemmalle'
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
