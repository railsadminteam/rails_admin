﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Catalan language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['ca'] =
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
	editorTitle : 'Editor de text enriquit, %1, prem ALT 0 per obtenir ajuda.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Editor de text enriquit',

	// Toolbar buttons without dialogs.
	source			: 'Codi font',
	newPage			: 'Nova pàgina',
	save			: 'Desa',
	preview			: 'Visualització prèvia',
	cut				: 'Retalla',
	copy			: 'Copia',
	paste			: 'Enganxa',
	print			: 'Imprimeix',
	underline		: 'Subratllat',
	bold			: 'Negreta',
	italic			: 'Cursiva',
	selectAll		: 'Selecciona-ho tot',
	removeFormat	: 'Elimina Format',
	strike			: 'Barrat',
	subscript		: 'Subíndex',
	superscript		: 'Superíndex',
	horizontalrule	: 'Insereix línia horitzontal',
	pagebreak		: 'Insereix salt de pàgina',
	pagebreakAlt		: 'Salt de pàgina',
	unlink			: 'Elimina l\'enllaç',
	undo			: 'Desfés',
	redo			: 'Refés',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Veure servidor',
		url				: 'URL',
		protocol		: 'Protocol',
		upload			: 'Puja',
		uploadSubmit	: 'Envia-la al servidor',
		image			: 'Imatge',
		flash			: 'Flash',
		form			: 'Formulari',
		checkbox		: 'Casella de verificació',
		radio			: 'Botó d\'opció',
		textField		: 'Camp de text',
		textarea		: 'Àrea de text',
		hiddenField		: 'Camp ocult',
		button			: 'Botó',
		select			: 'Camp de selecció',
		imageButton		: 'Botó d\'imatge',
		notSet			: '<no definit>',
		id				: 'Id',
		name			: 'Nom',
		langDir			: 'Direcció de l\'idioma',
		langDirLtr		: 'D\'esquerra a dreta (LTR)',
		langDirRtl		: 'De dreta a esquerra (RTL)',
		langCode		: 'Codi d\'idioma',
		longDescr		: 'Descripció llarga de la URL',
		cssClass		: 'Classes del full d\'estil',
		advisoryTitle	: 'Títol consultiu',
		cssStyle		: 'Estil',
		ok				: 'D\'acord',
		cancel			: 'Cancel·la',
		close			: 'Tanca',
		preview			: 'Previsualitza',
		generalTab		: 'General',
		advancedTab		: 'Avançat',
		validateNumberFailed : 'Aquest valor no és un número.',
		confirmNewPage	: 'Els canvis en aquest contingut que no es desin es perdran. Esteu segur que voleu carregar una pàgina nova?',
		confirmCancel	: 'Algunes opcions s\'han canviat. Esteu segur que voleu tancar la finestra de diàleg?',
		options			: 'Opcions',
		target			: 'Destí',
		targetNew		: 'Nova finestra (_blank)',
		targetTop		: 'Finestra major (_top)',
		targetSelf		: 'Mateixa finestra (_self)',
		targetParent	: 'Finestra pare (_parent)',
		langDirLTR		: 'D\'esquerra a dreta (LTR)',
		langDirRTL		: 'De dreta a esquerra (RTL)',
		styles			: 'Estil',
		cssClasses		: 'Classes del full d\'estil',
		width			: 'Amplada',
		height			: 'Alçada',
		align			: 'Alineació',
		alignLeft		: 'Ajusta a l\'esquerra',
		alignRight		: 'Ajusta a la dreta',
		alignCenter		: 'Centre',
		alignTop		: 'Superior',
		alignMiddle		: 'Centre',
		alignBottom		: 'Inferior',
		invalidHeight	: 'L\'alçada ha de ser un nombre.',
		invalidWidth	: 'L\'amplada ha de ser un nombre.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, no disponible</span>'
	},

	contextmenu :
	{
		options : 'Opcions del menú contextual'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Insereix caràcter especial',
		title		: 'Selecciona el caràcter especial',
		options : 'Opcions de caràcters especials'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Insereix/Edita enllaç',
		other 		: '<altre>',
		menu		: 'Edita l\'enllaç',
		title		: 'Enllaç',
		info		: 'Informació de l\'enllaç',
		target		: 'Destí',
		upload		: 'Puja',
		advanced	: 'Avançat',
		type		: 'Tipus d\'enllaç',
		toUrl		: 'URL',
		toAnchor	: 'Àncora en aquesta pàgina',
		toEmail		: 'Correu electrònic',
		targetFrame		: '<marc>',
		targetPopup		: '<finestra emergent>',
		targetFrameName	: 'Nom del marc de destí',
		targetPopupName	: 'Nom finestra popup',
		popupFeatures	: 'Característiques finestra popup',
		popupResizable	: 'Redimensionable',
		popupStatusBar	: 'Barra d\'estat',
		popupLocationBar: 'Barra d\'adreça',
		popupToolbar	: 'Barra d\'eines',
		popupMenuBar	: 'Barra de menú',
		popupFullScreen	: 'Pantalla completa (IE)',
		popupScrollBars	: 'Barres d\'scroll',
		popupDependent	: 'Depenent (Netscape)',
		popupLeft		: 'Posició esquerra',
		popupTop		: 'Posició dalt',
		id				: 'Id',
		langDir			: 'Direcció de l\'idioma',
		langDirLTR		: 'D\'esquerra a dreta (LTR)',
		langDirRTL		: 'De dreta a esquerra (RTL)',
		acccessKey		: 'Clau d\'accés',
		name			: 'Nom',
		langCode			: 'Direcció de l\'idioma',
		tabIndex			: 'Index de Tab',
		advisoryTitle		: 'Títol consultiu',
		advisoryContentType	: 'Tipus de contingut consultiu',
		cssClasses		: 'Classes del full d\'estil',
		charset			: 'Conjunt de caràcters font enllaçat',
		styles			: 'Estil',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Selecciona una àncora',
		anchorName		: 'Per nom d\'àncora',
		anchorId			: 'Per Id d\'element',
		emailAddress		: 'Adreça de correu electrònic',
		emailSubject		: 'Assumpte del missatge',
		emailBody		: 'Cos del missatge',
		noAnchors		: '(No hi ha àncores disponibles en aquest document)',
		noUrl			: 'Si us plau, escrigui l\'enllaç URL',
		noEmail			: 'Si us plau, escrigui l\'adreça correu electrònic'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Insereix/Edita àncora',
		menu		: 'Propietats de l\'àncora',
		title		: 'Propietats de l\'àncora',
		name		: 'Nom de l\'àncora',
		errorName	: 'Si us plau, escriviu el nom de l\'ancora'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Numbered List Properties',
		bulletedTitle		: 'Bulleted List Properties',
		type				: 'Type',
		start				: 'Start',
		validateStartNumber				:'List start number must be a whole number.',
		circle				: 'Circle',
		disc				: 'Disc',
		square				: 'Square',
		none				: 'None',
		notset				: '<not set>',
		armenian			: 'Armenian numbering',
		georgian			: 'Georgian numbering (an, ban, gan, etc.)',
		lowerRoman			: 'Lower Roman (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Upper Roman (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Lower Alpha (a, b, c, d, e, etc.)',
		upperAlpha			: 'Upper Alpha (A, B, C, D, E, etc.)',
		lowerGreek			: 'Lower Greek (alpha, beta, gamma, etc.)',
		decimal				: 'Decimal (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Decimal leading zero (01, 02, 03, etc.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Cerca i reemplaça',
		find				: 'Cerca',
		replace				: 'Reemplaça',
		findWhat			: 'Cerca:',
		replaceWith			: 'Remplaça amb:',
		notFoundMsg			: 'El text especificat no s\'ha trobat.',
		matchCase			: 'Distingeix majúscules/minúscules',
		matchWord			: 'Només paraules completes',
		matchCyclic			: 'Match cyclic',
		replaceAll			: 'Reemplaça-ho tot',
		replaceSuccessMsg	: '%1 ocurrència/es reemplaçada/es.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Taula',
		title		: 'Propietats de la taula',
		menu		: 'Propietats de la taula',
		deleteTable	: 'Suprimeix la taula',
		rows		: 'Files',
		columns		: 'Columnes',
		border		: 'Mida vora',
		widthPx		: 'píxels',
		widthPc		: 'percentatge',
		widthUnit	: 'unitat d\'amplada',
		cellSpace	: 'Espaiat de cel·les',
		cellPad		: 'Encoixinament de cel·les',
		caption		: 'Títol',
		summary		: 'Resum',
		headers		: 'Capçaleres',
		headersNone		: 'Cap',
		headersColumn	: 'Primera columna',
		headersRow		: 'Primera fila',
		headersBoth		: 'Ambdues',
		invalidRows		: 'El nombre de files ha de ser un nombre major que 0.',
		invalidCols		: 'El nombre de columnes ha de ser un nombre major que 0.',
		invalidBorder	: 'El gruix de la vora ha de ser un nombre.',
		invalidWidth	: 'L\'amplada de la taula  ha de ser un nombre.',
		invalidHeight	: 'L\'alçada de la taula  ha de ser un nombre.',
		invalidCellSpacing	: 'L\'espaiat de cel·la  ha de ser un nombre.',
		invalidCellPadding	: 'L\'encoixinament de cel·la  ha de ser un nombre.',

		cell :
		{
			menu			: 'Cel·la',
			insertBefore	: 'Insereix abans',
			insertAfter		: 'Insereix després',
			deleteCell		: 'Suprimeix',
			merge			: 'Fusiona',
			mergeRight		: 'Fusiona a la dreta',
			mergeDown		: 'Fusiona avall',
			splitHorizontal	: 'Divideix horitzontalment',
			splitVertical	: 'Divideix verticalment',
			title			: 'Propietats de la cel·la',
			cellType		: 'Tipus de cel·la',
			rowSpan			: 'Expansió de files',
			colSpan			: 'Expansió de columnes',
			wordWrap		: 'Ajustar al contingut',
			hAlign			: 'Alineació Horizontal',
			vAlign			: 'Alineació Vertical',
			alignBaseline	: 'A la línia base',
			bgColor			: 'Color de fons',
			borderColor		: 'Color de la vora',
			data			: 'Dades',
			header			: 'Capçalera',
			yes				: 'Sí',
			no				: 'No',
			invalidWidth	: 'L\'amplada de cel·la ha de ser un nombre.',
			invalidHeight	: 'L\'alçada de cel·la ha de ser un nombre.',
			invalidRowSpan	: 'L\'expansió de files ha de ser un nombre enter.',
			invalidColSpan	: 'L\'expansió de columnes ha de ser un nombre enter.',
			chooseColor		: 'Trieu'
		},

		row :
		{
			menu			: 'Fila',
			insertBefore	: 'Insereix fila abans de',
			insertAfter		: 'Insereix fila darrera',
			deleteRow		: 'Suprimeix una fila'
		},

		column :
		{
			menu			: 'Columna',
			insertBefore	: 'Insereix columna abans de',
			insertAfter		: 'Insereix columna darrera',
			deleteColumn	: 'Suprimeix una columna'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Propietats del botó',
		text		: 'Text (Valor)',
		type		: 'Tipus',
		typeBtn		: 'Botó',
		typeSbm		: 'Transmet formulari',
		typeRst		: 'Reinicia formulari'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Propietats de la casella de verificació',
		radioTitle	: 'Propietats del botó d\'opció',
		value		: 'Valor',
		selected	: 'Seleccionat'
	},

	// Form Dialog.
	form :
	{
		title		: 'Propietats del formulari',
		menu		: 'Propietats del formulari',
		action		: 'Acció',
		method		: 'Mètode',
		encoding	: 'Codificació'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Propietats del camp de selecció',
		selectInfo	: 'Info',
		opAvail		: 'Opcions disponibles',
		value		: 'Valor',
		size		: 'Mida',
		lines		: 'Línies',
		chkMulti	: 'Permet múltiples seleccions',
		opText		: 'Text',
		opValue		: 'Valor',
		btnAdd		: 'Afegeix',
		btnModify	: 'Modifica',
		btnUp		: 'Amunt',
		btnDown		: 'Avall',
		btnSetValue : 'Selecciona per defecte',
		btnDelete	: 'Elimina'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Propietats de l\'àrea de text',
		cols		: 'Columnes',
		rows		: 'Files'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Propietats del camp de text',
		name		: 'Nom',
		value		: 'Valor',
		charWidth	: 'Amplada',
		maxChars	: 'Nombre màxim de caràcters',
		type		: 'Tipus',
		typeText	: 'Text',
		typePass	: 'Contrasenya'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Propietats del camp ocult',
		name	: 'Nom',
		value	: 'Valor'
	},

	// Image Dialog.
	image :
	{
		title		: 'Propietats de la imatge',
		titleButton	: 'Propietats del botó d\'imatge',
		menu		: 'Propietats de la imatge',
		infoTab		: 'Informació de la imatge',
		btnUpload	: 'Envia-la al servidor',
		upload		: 'Puja',
		alt			: 'Text alternatiu',
		lockRatio	: 'Bloqueja les proporcions',
		unlockRatio	: 'Desbloqueja el ràtio',
		resetSize	: 'Restaura la mida',
		border		: 'Vora',
		hSpace		: 'Espaiat horit.',
		vSpace		: 'Espaiat vert.',
		alertUrl	: 'Si us plau, escriviu la URL de la imatge',
		linkTab		: 'Enllaç',
		button2Img	: 'Voleu transformar el botó d\'imatge seleccionat en una simple imatge?',
		img2Button	: 'Voleu transformar la imatge seleccionada en un botó d\'imatge?',
		urlMissing	: 'Falta la URL de la imatge.',
		validateBorder	: 'La vora ha de ser un nombre enter.',
		validateHSpace	: 'HSpace ha de ser un nombre enter.',
		validateVSpace	: 'VSpace ha de ser un nombre enter.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Propietats del Flash',
		propertiesTab	: 'Propietats',
		title			: 'Propietats del Flash',
		chkPlay			: 'Reprodució automàtica',
		chkLoop			: 'Bucle',
		chkMenu			: 'Habilita menú Flash',
		chkFull			: 'Permetre la pantalla completa',
 		scale			: 'Escala',
		scaleAll		: 'Mostra-ho tot',
		scaleNoBorder	: 'Sense vores',
		scaleFit		: 'Mida exacta',
		access			: 'Accés a scripts',
		accessAlways	: 'Sempre',
		accessSameDomain: 'El mateix domini',
		accessNever		: 'Mai',
		alignAbsBottom	: 'Abs Bottom',
		alignAbsMiddle	: 'Abs Middle',
		alignBaseline	: 'Baseline',
		alignTextTop	: 'Text Top',
		quality			: 'Qualitat',
		qualityBest		: 'La millor',
		qualityHigh		: 'Alta',
		qualityAutoHigh	: 'Alta automàtica',
		qualityMedium	: 'Mitjana',
		qualityAutoLow	: 'Baixa automàtica',
		qualityLow		: 'Baixa',
		windowModeWindow: 'Finestra',
		windowModeOpaque: 'Opaca',
		windowModeTransparent : 'Transparent',
		windowMode		: 'Mode de la finestra',
		flashvars		: 'Variables de Flash',
		bgcolor			: 'Color de Fons',
		hSpace			: 'Espaiat horit.',
		vSpace			: 'Espaiat vert.',
		validateSrc		: 'Si us plau, escrigui l\'enllaç URL',
		validateHSpace	: 'L\'espaiat horitzonatal ha de ser un nombre.',
		validateVSpace	: 'L\'espaiat vertical ha de ser un nombre.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Revisa l\'ortografia',
		title			: 'Comprova l\'ortografia',
		notAvailable	: 'El servei no es troba disponible ara.',
		errorLoading	: 'Error carregant el servidor: %s.',
		notInDic		: 'No és al diccionari',
		changeTo		: 'Reemplaça amb',
		btnIgnore		: 'Ignora',
		btnIgnoreAll	: 'Ignora-les totes',
		btnReplace		: 'Canvia',
		btnReplaceAll	: 'Canvia-les totes',
		btnUndo			: 'Desfés',
		noSuggestions	: 'Cap suggeriment',
		progress		: 'Verificació ortogràfica en curs...',
		noMispell		: 'Verificació ortogràfica acabada: no hi ha cap paraula mal escrita',
		noChanges		: 'Verificació ortogràfica: no s\'ha canviat cap paraula',
		oneChange		: 'Verificació ortogràfica: s\'ha canviat una paraula',
		manyChanges		: 'Verificació ortogràfica: s\'han canviat %1 paraules',
		ieSpellDownload	: 'Verificació ortogràfica no instal·lada. Voleu descarregar-ho ara?'
	},

	smiley :
	{
		toolbar	: 'Icona',
		title	: 'Insereix una icona',
		options : 'Opcions d\'emoticones'
	},

	elementsPath :
	{
		eleLabel : 'Elements path',
		eleTitle : '%1 element'
	},

	numberedlist	: 'Llista numerada',
	bulletedlist	: 'Llista de pics',
	indent			: 'Augmenta el sagnat',
	outdent			: 'Redueix el sagnat',

	justify :
	{
		left	: 'Alinea a l\'esquerra',
		center	: 'Centrat',
		right	: 'Alinea a la dreta',
		block	: 'Justificat'
	},

	blockquote : 'Bloc de cita',

	clipboard :
	{
		title		: 'Enganxa',
		cutError	: 'La seguretat del vostre navegador no permet executar automàticament les operacions de retallar. Si us plau, utilitzeu el teclat (Ctrl+X).',
		copyError	: 'La seguretat del vostre navegador no permet executar automàticament les operacions de copiar. Si us plau, utilitzeu el teclat (Ctrl+C).',
		pasteMsg	: 'Si us plau, enganxeu dins del següent camp utilitzant el teclat (<STRONG>Ctrl+V</STRONG>) i premeu <STRONG>OK</STRONG>.',
		securityMsg	: 'A causa de la configuració de seguretat del vostre navegador, l\'editor no pot accedir al porta-retalls directament. Enganxeu-ho un altre cop en aquesta finestra.',
		pasteArea	: 'Àrea d\'enganxat'
	},

	pastefromword :
	{
		confirmCleanup	: 'El text que voleu enganxar sembla provenir de Word. Voleu netejar aquest text abans que sigui enganxat?',
		toolbar			: 'Enganxa des del Word',
		title			: 'Enganxa des del Word',
		error			: 'No ha estat possible netejar les dades enganxades degut a un error intern'
	},

	pasteText :
	{
		button	: 'Enganxa com a text no formatat',
		title	: 'Enganxa com a text no formatat'
	},

	templates :
	{
		button			: 'Plantilles',
		title			: 'Plantilles de contingut',
		options : 'Opcions de plantilla',
		insertOption	: 'Reemplaça el contingut actual',
		selectPromptMsg	: 'Seleccioneu una plantilla per usar a l\'editor<br>(per defecte s\'elimina el contingut actual):',
		emptyListMsg	: '(No hi ha plantilles definides)'
	},

	showBlocks : 'Mostra els blocs',

	stylesCombo :
	{
		label		: 'Estil',
		panelTitle	: 'Estils de format',
		panelTitle1	: 'Estils de bloc',
		panelTitle2	: 'Estils incrustats',
		panelTitle3	: 'Estils d\'objecte'
	},

	format :
	{
		label		: 'Format',
		panelTitle	: 'Format',

		tag_p		: 'Normal',
		tag_pre		: 'Formatejat',
		tag_address	: 'Adreça',
		tag_h1		: 'Encapçalament 1',
		tag_h2		: 'Encapçalament 2',
		tag_h3		: 'Encapçalament 3',
		tag_h4		: 'Encapçalament 4',
		tag_h5		: 'Encapçalament 5',
		tag_h6		: 'Encapçalament 6',
		tag_div		: 'Normal (DIV)'
	},

	div :
	{
		title				: 'Crea un contenidor Div',
		toolbar				: 'Crea un contenidor Div',
		cssClassInputLabel	: 'Classes de la fulla d\'estils',
		styleSelectLabel	: 'Estil',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Codi d\'idioma',
		inlineStyleInputLabel	: 'Estil en línia',
		advisoryTitleInputLabel	: 'Títol de guia',
		langDirLabel		: 'Direcció de l\'idioma',
		langDirLTRLabel		: 'D\'esquerra a dreta (LTR)',
		langDirRTLLabel		: 'De dreta a esquerra (RTL)',
		edit				: 'Edita Div',
		remove				: 'Elimina Div'
  	},

	iframe :
	{
		title		: 'Propietats IFrame',
		toolbar		: 'IFrame',
		noUrl		: 'Si us plau, introduïu la URL de l\'iframe URL',
		scrolling	: 'Activa les barrres de desplaçament',
		border		: 'Mostra la vora del marc'
	},

	font :
	{
		label		: 'Tipus de lletra',
		voiceLabel	: 'Tipus de lletra',
		panelTitle	: 'Tipus de lletra'
	},

	fontSize :
	{
		label		: 'Mida',
		voiceLabel	: 'Mida de la lletra',
		panelTitle	: 'Mida'
	},

	colorButton :
	{
		textColorTitle	: 'Color de Text',
		bgColorTitle	: 'Color de Fons',
		panelTitle		: 'Colors',
		auto			: 'Automàtic',
		more			: 'Més colors...'
	},

	colors :
	{
		'000' : 'Negre',
		'800000' : 'Granat',
		'8B4513' : 'Marró sella',
		'2F4F4F' : 'Gris pissarra fosca',
		'008080' : 'Blau xarxet',
		'000080' : 'Blau marí',
		'4B0082' : 'Indi',
		'696969' : 'Gris intens',
		'B22222' : 'Maó',
		'A52A2A' : 'Marró (web)',
		'DAA520' : 'Solidago',
		'006400' : 'Verd fosc',
		'40E0D0' : 'Turquesa',
		'0000CD' : 'Atzur',
		'800080' : 'Lila',
		'808080' : 'Gris',
		'F00' : 'Vermell',
		'FF8C00' : 'Taronja fosc',
		'FFD700' : 'Or',
		'008000' : 'Verd',
		'0FF' : 'Cian',
		'00F' : 'Blau',
		'EE82EE' : 'Lavanda rosat',
		'A9A9A9' : 'Gris clar',
		'FFA07A' : 'Salmó clar',
		'FFA500' : 'Taronja',
		'FFFF00' : 'Groc',
		'00FF00' : 'Verd llima',
		'AFEEEE' : 'Blau pàlid',
		'ADD8E6' : 'Blau clar',
		'DDA0DD' : 'Pruna',
		'D3D3D3' : 'Gris clar',
		'FFF0F5' : 'Lavanda rosat',
		'FAEBD7' : 'Blanc antic',
		'FFFFE0' : 'Groc clar',
		'F0FFF0' : 'Verd pàlid',
		'F0FFFF' : 'Blau cel pàlid',
		'F0F8FF' : 'Cian pàlid',
		'E6E6FA' : 'Lavanda',
		'FFF' : 'Blanc'
	},

	scayt :
	{
		title			: 'Spell Check As You Type',
		opera_title		: 'No és compatible amb l\'Opera',
		enable			: 'Habilitat l\'SCAYT',
		disable			: 'Deshabilita SCAYT',
		about			: 'Quant a l\'SCAYT',
		toggle			: 'Commuta l\'SCAYT',
		options			: 'Opcions',
		langs			: 'Idiomes',
		moreSuggestions	: 'Més suggerències',
		ignore			: 'Ignora',
		ignoreAll		: 'Ignora\'ls tots',
		addWord			: 'Afegeix una paraula',
		emptyDic		: 'El nom del diccionari no hauria d\'estar buit.',

		optionsTab		: 'Opcions',
		allCaps			: 'Ignora paraules en majúscules',
		ignoreDomainNames : 'Ignora els noms de domini',
		mixedCase		: 'Ignora paraules amb majúscules i minúscules',
		mixedWithDigits	: 'Ignora paraules amb números ',

		languagesTab	: 'Idiomes',

		dictionariesTab	: 'Diccionaris',
		dic_field_name	: 'Nom del diccionari',
		dic_create		: 'Crea',
		dic_restore		: 'Restaura',
		dic_delete		: 'Elimina',
		dic_rename		: 'Canvia el nom',
		dic_info		: 'Inicialment el diccionari d\'usuari s\'emmagatzema en una galeta. De totes maneres, les galetes tenen la mida limitada. Quan el diccionari creix massa, llavors el diccionari es pot emmagatzemar al nostre servidor. Per desar el vostre diccionari personal al nostre servidor heu d.\'especificar un nom pel diccionari. Si ja heu desat un diccionari, teclegeu si us plau el seu nom i cliqueu el botó de restauració.',

		aboutTab		: 'Quant a'
	},

	about :
	{
		title		: 'Quant al CKEditor',
		dlgTitle	: 'Quant al CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Per informació sobre llicències visiteu el web:',
		copy		: 'Copyright &copy; $1. Tots els drets reservats.'
	},

	maximize : 'Maximitza',
	minimize : 'Minimitza',

	fakeobjects :
	{
		anchor		: 'Àncora',
		flash		: 'Animació Flash',
		iframe		: 'IFrame',
		hiddenfield	: 'Camp ocult',
		unknown		: 'Objecte desconegut'
	},

	resize : 'Arrossegueu per redimensionar',

	colordialog :
	{
		title		: 'Selecciona el color',
		options	:	'Opcions del color',
		highlight	: 'Destacat',
		selected	: 'Seleccionat',
		clear		: 'Neteja'
	},

	toolbarCollapse	: 'Redueix la barra d\'eines',
	toolbarExpand	: 'Amplia la barra d\'eines',

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
		ltr : 'Direcció del text d\'esquerra a dreta',
		rtl : 'Direcció del text de dreta a esquerra'
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
