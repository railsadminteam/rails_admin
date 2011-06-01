﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.lang} object, for the
 * Spanish language.
 */

/**#@+
   @type String
   @example
*/

/**
 * Constains the dictionary of language entries.
 * @namespace
 */
CKEDITOR.lang['es'] =
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
	editorTitle : 'Editor de texto, %1, pulse ALT 0 para ayuda.',

	// ARIA descriptions.
	toolbars	: 'Barras de herramientas del editor',
	editor		: 'Editor de texto enriquecido',

	// Toolbar buttons without dialogs.
	source			: 'Fuente HTML',
	newPage			: 'Nueva Página',
	save			: 'Guardar',
	preview			: 'Vista Previa',
	cut				: 'Cortar',
	copy			: 'Copiar',
	paste			: 'Pegar',
	print			: 'Imprimir',
	underline		: 'Subrayado',
	bold			: 'Negrita',
	italic			: 'Cursiva',
	selectAll		: 'Seleccionar Todo',
	removeFormat	: 'Eliminar Formato',
	strike			: 'Tachado',
	subscript		: 'Subíndice',
	superscript		: 'Superíndice',
	horizontalrule	: 'Insertar Línea Horizontal',
	pagebreak		: 'Insertar Salto de Página',
	pagebreakAlt		: 'Salto de página',
	unlink			: 'Eliminar Vínculo',
	undo			: 'Deshacer',
	redo			: 'Rehacer',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Ver Servidor',
		url				: 'URL',
		protocol		: 'Protocolo',
		upload			: 'Cargar',
		uploadSubmit	: 'Enviar al Servidor',
		image			: 'Imagen',
		flash			: 'Flash',
		form			: 'Formulario',
		checkbox		: 'Casilla de Verificación',
		radio			: 'Botones de Radio',
		textField		: 'Campo de Texto',
		textarea		: 'Area de Texto',
		hiddenField		: 'Campo Oculto',
		button			: 'Botón',
		select			: 'Campo de Selección',
		imageButton		: 'Botón Imagen',
		notSet			: '<No definido>',
		id				: 'Id',
		name			: 'Nombre',
		langDir			: 'Orientación',
		langDirLtr		: 'Izquierda a Derecha (LTR)',
		langDirRtl		: 'Derecha a Izquierda (RTL)',
		langCode		: 'Cód. de idioma',
		longDescr		: 'Descripción larga URL',
		cssClass		: 'Clases de hojas de estilo',
		advisoryTitle	: 'Título',
		cssStyle		: 'Estilo',
		ok				: 'Aceptar',
		cancel			: 'Cancelar',
		close			: 'Cerrar',
		preview			: 'Previsualización',
		generalTab		: 'General',
		advancedTab		: 'Avanzado',
		validateNumberFailed : 'El valor no es un número.',
		confirmNewPage	: 'Cualquier cambio que no se haya guardado se perderá.\r\n¿Está seguro de querer crear una nueva página?',
		confirmCancel	: 'Algunas de las opciones se han cambiado.\r\n¿Está seguro de querer cerrar el diálogo?',
		options			: 'Opciones',
		target			: 'Destino',
		targetNew		: 'Nueva ventana (_blank)',
		targetTop		: 'Ventana principal (_top)',
		targetSelf		: 'Misma ventana (_self)',
		targetParent	: 'Ventana padre (_parent)',
		langDirLTR		: 'Izquierda a derecha (LTR)',
		langDirRTL		: 'Derecha a izquierda (RTL)',
		styles			: 'Estilos',
		cssClasses		: 'Clase de la hoja de estilos',
		width			: 'Anchura',
		height			: 'Altura',
		align			: 'Alineación',
		alignLeft		: 'Izquierda',
		alignRight		: 'Derecha',
		alignCenter		: 'Centrado',
		alignTop		: 'Tope',
		alignMiddle		: 'Centro',
		alignBottom		: 'Pie',
		invalidHeight	: 'Altura debe ser un número.',
		invalidWidth	: 'Anchura debe ser un número.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, no disponible</span>'
	},

	contextmenu :
	{
		options : 'Opciones del menú contextual'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Insertar Caracter Especial',
		title		: 'Seleccione un caracter especial',
		options : 'Opciones de caracteres especiales'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Insertar/Editar Vínculo',
		other 		: '<otro>',
		menu		: 'Editar Vínculo',
		title		: 'Vínculo',
		info		: 'Información de Vínculo',
		target		: 'Destino',
		upload		: 'Cargar',
		advanced	: 'Avanzado',
		type		: 'Tipo de vínculo',
		toUrl		: 'URL',
		toAnchor	: 'Referencia en esta página',
		toEmail		: 'E-Mail',
		targetFrame		: '<marco>',
		targetPopup		: '<ventana emergente>',
		targetFrameName	: 'Nombre del Marco Destino',
		targetPopupName	: 'Nombre de Ventana Emergente',
		popupFeatures	: 'Características de Ventana Emergente',
		popupResizable	: 'Redimensionable',
		popupStatusBar	: 'Barra de Estado',
		popupLocationBar: 'Barra de ubicación',
		popupToolbar	: 'Barra de Herramientas',
		popupMenuBar	: 'Barra de Menú',
		popupFullScreen	: 'Pantalla Completa (IE)',
		popupScrollBars	: 'Barras de desplazamiento',
		popupDependent	: 'Dependiente (Netscape)',
		popupLeft		: 'Posición Izquierda',
		popupTop		: 'Posición Derecha',
		id				: 'Id',
		langDir			: 'Orientación',
		langDirLTR		: 'Izquierda a Derecha (LTR)',
		langDirRTL		: 'Derecha a Izquierda (RTL)',
		acccessKey		: 'Tecla de Acceso',
		name			: 'Nombre',
		langCode			: 'Código idioma',
		tabIndex			: 'Indice de tabulación',
		advisoryTitle		: 'Título',
		advisoryContentType	: 'Tipo de Contenido',
		cssClasses		: 'Clases de hojas de estilo',
		charset			: 'Fuente de caracteres vinculado',
		styles			: 'Estilo',
		rel			: 'Relación',
		selectAnchor		: 'Seleccionar una referencia',
		anchorName		: 'Por Nombre de Referencia',
		anchorId			: 'Por ID de elemento',
		emailAddress		: 'Dirección de E-Mail',
		emailSubject		: 'Título del Mensaje',
		emailBody		: 'Cuerpo del Mensaje',
		noAnchors		: '(No hay referencias disponibles en el documento)',
		noUrl			: 'Por favor escriba el vínculo URL',
		noEmail			: 'Por favor escriba la dirección de e-mail'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Referencia',
		menu		: 'Propiedades de Referencia',
		title		: 'Propiedades de Referencia',
		name		: 'Nombre de la Referencia',
		errorName	: 'Por favor, complete el nombre de la Referencia'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Propiedades de lista numerada',
		bulletedTitle		: 'Propiedades de viñetas',
		type				: 'Tipo',
		start				: 'Inicio',
		validateStartNumber				:'El Inicio debe ser un número entero.',
		circle				: 'Círculo',
		disc				: 'Disco',
		square				: 'Cuadrado',
		none				: 'Ninguno',
		notset				: '<sin establecer>',
		armenian			: 'Numeración armenia',
		georgian			: 'Numeración georgiana (an, ban, gan, etc.)',
		lowerRoman			: 'Números romanos en minúsculas (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Números romanos en mayúsculas (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Alfabeto en minúsculas (a, b, c, d, e, etc.)',
		upperAlpha			: 'Alfabeto en mayúsculas  (A, B, C, D, E, etc.)',
		lowerGreek			: 'Letras griegas (alpha, beta, gamma, etc.)',
		decimal				: 'Decimal (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Decimal con cero inicial (01, 02, 03, etc.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Buscar y Reemplazar',
		find				: 'Buscar',
		replace				: 'Reemplazar',
		findWhat			: 'Texto a buscar:',
		replaceWith			: 'Reemplazar con:',
		notFoundMsg			: 'El texto especificado no ha sido encontrado.',
		matchCase			: 'Coincidir may/min',
		matchWord			: 'Coincidir toda la palabra',
		matchCyclic			: 'Buscar en todo el contenido',
		replaceAll			: 'Reemplazar Todo',
		replaceSuccessMsg	: 'La expresión buscada ha sido reemplazada %1 veces.'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabla',
		title		: 'Propiedades de Tabla',
		menu		: 'Propiedades de Tabla',
		deleteTable	: 'Eliminar Tabla',
		rows		: 'Filas',
		columns		: 'Columnas',
		border		: 'Tamaño de Borde',
		widthPx		: 'pixeles',
		widthPc		: 'porcentaje',
		widthUnit	: 'unidad de la anchura',
		cellSpace	: 'Esp. e/celdas',
		cellPad		: 'Esp. interior',
		caption		: 'Título',
		summary		: 'Síntesis',
		headers		: 'Encabezados',
		headersNone		: 'Ninguno',
		headersColumn	: 'Primera columna',
		headersRow		: 'Primera fila',
		headersBoth		: 'Ambas',
		invalidRows		: 'El número de filas debe ser un número mayor que 0.',
		invalidCols		: 'El número de columnas debe ser un número mayor que 0.',
		invalidBorder	: 'El tamaño del borde debe ser un número.',
		invalidWidth	: 'La anchura de tabla debe ser un número.',
		invalidHeight	: 'La altura de tabla debe ser un número.',
		invalidCellSpacing	: 'El espaciado entre celdas debe ser un número.',
		invalidCellPadding	: 'El espaciado interior debe ser un número.',

		cell :
		{
			menu			: 'Celda',
			insertBefore	: 'Insertar celda a la izquierda',
			insertAfter		: 'Insertar celda a la derecha',
			deleteCell		: 'Eliminar Celdas',
			merge			: 'Combinar Celdas',
			mergeRight		: 'Combinar a la derecha',
			mergeDown		: 'Combinar hacia abajo',
			splitHorizontal	: 'Dividir la celda horizontalmente',
			splitVertical	: 'Dividir la celda verticalmente',
			title			: 'Propiedades de celda',
			cellType		: 'Tipo de Celda',
			rowSpan			: 'Expandir filas',
			colSpan			: 'Expandir columnas',
			wordWrap		: 'Ajustar al contenido',
			hAlign			: 'Alineación Horizontal',
			vAlign			: 'Alineación Vertical',
			alignBaseline	: 'Linea de base',
			bgColor			: 'Color de fondo',
			borderColor		: 'Color de borde',
			data			: 'Datos',
			header			: 'Encabezado',
			yes				: 'Sí',
			no				: 'No',
			invalidWidth	: 'La anchura de celda debe ser un número.',
			invalidHeight	: 'La altura de celda debe ser un número.',
			invalidRowSpan	: 'La expansión de filas debe ser un número entero.',
			invalidColSpan	: 'La expansión de columnas debe ser un número entero.',
			chooseColor		: 'Elegir'
		},

		row :
		{
			menu			: 'Fila',
			insertBefore	: 'Insertar fila en la parte superior',
			insertAfter		: 'Insertar fila en la parte inferior',
			deleteRow		: 'Eliminar Filas'
		},

		column :
		{
			menu			: 'Columna',
			insertBefore	: 'Insertar columna a la izquierda',
			insertAfter		: 'Insertar columna a la derecha',
			deleteColumn	: 'Eliminar Columnas'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Propiedades de Botón',
		text		: 'Texto (Valor)',
		type		: 'Tipo',
		typeBtn		: 'Boton',
		typeSbm		: 'Enviar',
		typeRst		: 'Reestablecer'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Propiedades de Casilla',
		radioTitle	: 'Propiedades de Botón de Radio',
		value		: 'Valor',
		selected	: 'Seleccionado'
	},

	// Form Dialog.
	form :
	{
		title		: 'Propiedades de Formulario',
		menu		: 'Propiedades de Formulario',
		action		: 'Acción',
		method		: 'Método',
		encoding	: 'Codificación'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Propiedades de Campo de Selección',
		selectInfo	: 'Información',
		opAvail		: 'Opciones disponibles',
		value		: 'Valor',
		size		: 'Tamaño',
		lines		: 'Lineas',
		chkMulti	: 'Permitir múltiple selección',
		opText		: 'Texto',
		opValue		: 'Valor',
		btnAdd		: 'Agregar',
		btnModify	: 'Modificar',
		btnUp		: 'Subir',
		btnDown		: 'Bajar',
		btnSetValue : 'Establecer como predeterminado',
		btnDelete	: 'Eliminar'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Propiedades de Area de Texto',
		cols		: 'Columnas',
		rows		: 'Filas'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Propiedades de Campo de Texto',
		name		: 'Nombre',
		value		: 'Valor',
		charWidth	: 'Caracteres de ancho',
		maxChars	: 'Máximo caracteres',
		type		: 'Tipo',
		typeText	: 'Texto',
		typePass	: 'Contraseña'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Propiedades de Campo Oculto',
		name	: 'Nombre',
		value	: 'Valor'
	},

	// Image Dialog.
	image :
	{
		title		: 'Propiedades de Imagen',
		titleButton	: 'Propiedades de Botón de Imagen',
		menu		: 'Propiedades de Imagen',
		infoTab		: 'Información de Imagen',
		btnUpload	: 'Enviar al Servidor',
		upload		: 'Cargar',
		alt			: 'Texto Alternativo',
		lockRatio	: 'Proporcional',
		unlockRatio	: 'Desbloquear el proporcional',
		resetSize	: 'Tamaño Original',
		border		: 'Borde',
		hSpace		: 'Esp.Horiz',
		vSpace		: 'Esp.Vert',
		alertUrl	: 'Por favor escriba la URL de la imagen',
		linkTab		: 'Vínculo',
		button2Img	: '¿Desea convertir el botón de imagen en una simple imagen?',
		img2Button	: '¿Desea convertir la imagen en un botón de imagen?',
		urlMissing	: 'Debe indicar la URL de la imagen.',
		validateBorder	: 'El borde debe ser un número.',
		validateHSpace	: 'El espaciado horizontal debe ser un número.',
		validateVSpace	: 'El espaciado vertical debe ser un número.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Propiedades de Flash',
		propertiesTab	: 'Propiedades',
		title			: 'Propiedades de Flash',
		chkPlay			: 'Autoejecución',
		chkLoop			: 'Repetir',
		chkMenu			: 'Activar Menú Flash',
		chkFull			: 'Permitir pantalla completa',
 		scale			: 'Escala',
		scaleAll		: 'Mostrar todo',
		scaleNoBorder	: 'Sin Borde',
		scaleFit		: 'Ajustado',
		access			: 'Acceso de scripts',
		accessAlways	: 'Siempre',
		accessSameDomain: 'Mismo dominio',
		accessNever		: 'Nunca',
		alignAbsBottom	: 'Abs inferior',
		alignAbsMiddle	: 'Abs centro',
		alignBaseline	: 'Línea de base',
		alignTextTop	: 'Tope del texto',
		quality			: 'Calidad',
		qualityBest		: 'La mejor',
		qualityHigh		: 'Alta',
		qualityAutoHigh	: 'Auto Alta',
		qualityMedium	: 'Media',
		qualityAutoLow	: 'Auto Baja',
		qualityLow		: 'Baja',
		windowModeWindow: 'Ventana',
		windowModeOpaque: 'Opaco',
		windowModeTransparent : 'Transparente',
		windowMode		: 'WindowMode',
		flashvars		: 'Opciones',
		bgcolor			: 'Color de Fondo',
		hSpace			: 'Esp.Horiz',
		vSpace			: 'Esp.Vert',
		validateSrc		: 'Por favor escriba el vínculo URL',
		validateHSpace	: 'Esp.Horiz debe ser un número.',
		validateVSpace	: 'Esp.Vert debe ser un número.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Ortografía',
		title			: 'Comprobar ortografía',
		notAvailable	: 'Lo sentimos pero el servicio no está disponible.',
		errorLoading	: 'Error cargando la aplicación del servidor: %s.',
		notInDic		: 'No se encuentra en el Diccionario',
		changeTo		: 'Cambiar a',
		btnIgnore		: 'Ignorar',
		btnIgnoreAll	: 'Ignorar Todo',
		btnReplace		: 'Reemplazar',
		btnReplaceAll	: 'Reemplazar Todo',
		btnUndo			: 'Deshacer',
		noSuggestions	: '- No hay sugerencias -',
		progress		: 'Control de Ortografía en progreso...',
		noMispell		: 'Control finalizado: no se encontraron errores',
		noChanges		: 'Control finalizado: no se ha cambiado ninguna palabra',
		oneChange		: 'Control finalizado: se ha cambiado una palabra',
		manyChanges		: 'Control finalizado: se ha cambiado %1 palabras',
		ieSpellDownload	: 'Módulo de Control de Ortografía no instalado.\r\n¿Desea descargarlo ahora?'
	},

	smiley :
	{
		toolbar	: 'Emoticonos',
		title	: 'Insertar un Emoticon',
		options : 'Opciones de emoticonos'
	},

	elementsPath :
	{
		eleLabel : 'Ruta de los elementos',
		eleTitle : '%1 elemento'
	},

	numberedlist	: 'Numeración',
	bulletedlist	: 'Viñetas',
	indent			: 'Aumentar Sangría',
	outdent			: 'Disminuir Sangría',

	justify :
	{
		left	: 'Alinear a Izquierda',
		center	: 'Centrar',
		right	: 'Alinear a Derecha',
		block	: 'Justificado'
	},

	blockquote : 'Cita',

	clipboard :
	{
		title		: 'Pegar',
		cutError	: 'La configuración de seguridad de este navegador no permite la ejecución automática de operaciones de cortado.\r\nPor favor use el teclado (Ctrl/Cmd+X).',
		copyError	: 'La configuración de seguridad de este navegador no permite la ejecución automática de operaciones de copiado.\r\nPor favor use el teclado (Ctrl/Cmd+C).',
		pasteMsg	: 'Por favor pegue dentro del cuadro utilizando el teclado (<STRONG>Ctrl/Cmd+V</STRONG>);\r\nluego presione <STRONG>Aceptar</STRONG>.',
		securityMsg	: 'Debido a la configuración de seguridad de su navegador, el editor no tiene acceso al portapapeles.\r\nEs necesario que lo pegue de nuevo en esta ventana.',
		pasteArea	: 'Zona de pegado'
	},

	pastefromword :
	{
		confirmCleanup	: 'El texto que desea parece provenir de Word.\r\n¿Desea depurarlo antes de pegarlo?',
		toolbar			: 'Pegar desde Word',
		title			: 'Pegar desde Word',
		error			: 'No ha sido posible limpiar los datos debido a un error interno'
	},

	pasteText :
	{
		button	: 'Pegar como Texto Plano',
		title	: 'Pegar como Texto Plano'
	},

	templates :
	{
		button			: 'Plantillas',
		title			: 'Contenido de Plantillas',
		options : 'Opciones de plantillas',
		insertOption	: 'Reemplazar el contenido actual',
		selectPromptMsg	: 'Por favor selecciona la plantilla a abrir en el editor<br>(el contenido actual se perderá):',
		emptyListMsg	: '(No hay plantillas definidas)'
	},

	showBlocks : 'Mostrar bloques',

	stylesCombo :
	{
		label		: 'Estilo',
		panelTitle	: 'Estilos para formatear',
		panelTitle1	: 'Estilos de párrafo',
		panelTitle2	: 'Estilos de carácter',
		panelTitle3	: 'Estilos de objeto'
	},

	format :
	{
		label		: 'Formato',
		panelTitle	: 'Formato',

		tag_p		: 'Normal',
		tag_pre		: 'Con formato',
		tag_address	: 'Dirección',
		tag_h1		: 'Encabezado 1',
		tag_h2		: 'Encabezado 2',
		tag_h3		: 'Encabezado 3',
		tag_h4		: 'Encabezado 4',
		tag_h5		: 'Encabezado 5',
		tag_h6		: 'Encabezado 6',
		tag_div		: 'Normal (DIV)'
	},

	div :
	{
		title				: 'Crear contenedor DIV',
		toolbar				: 'Crear contenedor DIV',
		cssClassInputLabel	: 'Clase de hoja de estilos',
		styleSelectLabel	: 'Estilo',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: ' Codigo de idioma',
		inlineStyleInputLabel	: 'Estilo',
		advisoryTitleInputLabel	: 'Título',
		langDirLabel		: 'Orientación',
		langDirLTRLabel		: 'Izquierda a Derecha (LTR)',
		langDirRTLLabel		: 'Derecha a Izquierda (RTL)',
		edit				: 'Editar Div',
		remove				: 'Quitar Div'
  	},

	iframe :
	{
		title		: 'Propiedades de iframe',
		toolbar		: 'IFrame',
		noUrl		: 'Por favor, escriba la dirección del iframe',
		scrolling	: 'Activar barras de desplazamiento',
		border		: 'Mostrar borde del marco'
	},

	font :
	{
		label		: 'Fuente',
		voiceLabel	: 'Fuente',
		panelTitle	: 'Fuente'
	},

	fontSize :
	{
		label		: 'Tamaño',
		voiceLabel	: 'Tamaño de fuente',
		panelTitle	: 'Tamaño'
	},

	colorButton :
	{
		textColorTitle	: 'Color de Texto',
		bgColorTitle	: 'Color de Fondo',
		panelTitle		: 'Colores',
		auto			: 'Automático',
		more			: 'Más Colores...'
	},

	colors :
	{
		'000' : 'Negro',
		'800000' : 'Marrón oscuro',
		'8B4513' : 'Marrón tierra',
		'2F4F4F' : 'Pizarra Oscuro',
		'008080' : 'Azul verdoso',
		'000080' : 'Azul marino',
		'4B0082' : 'Añil',
		'696969' : 'Gris oscuro',
		'B22222' : 'Ladrillo',
		'A52A2A' : 'Marrón',
		'DAA520' : 'Oro oscuro',
		'006400' : 'Verde oscuro',
		'40E0D0' : 'Turquesa',
		'0000CD' : 'Azul medio-oscuro',
		'800080' : 'Púrpura',
		'808080' : 'Gris',
		'F00' : 'Rojo',
		'FF8C00' : 'Naranja oscuro',
		'FFD700' : 'Oro',
		'008000' : 'Verde',
		'0FF' : 'Cian',
		'00F' : 'Azul',
		'EE82EE' : 'Violeta',
		'A9A9A9' : 'Gris medio',
		'FFA07A' : 'Salmón claro',
		'FFA500' : 'Naranja',
		'FFFF00' : 'Amarillo',
		'00FF00' : 'Lima',
		'AFEEEE' : 'Turquesa claro',
		'ADD8E6' : 'Azul claro',
		'DDA0DD' : 'Violeta claro',
		'D3D3D3' : 'Gris claro',
		'FFF0F5' : 'Lavanda rojizo',
		'FAEBD7' : 'Blanco antiguo',
		'FFFFE0' : 'Amarillo claro',
		'F0FFF0' : 'Miel',
		'F0FFFF' : 'Azul celeste',
		'F0F8FF' : 'Azul pálido',
		'E6E6FA' : 'Lavanda',
		'FFF' : 'Blanco'
	},

	scayt :
	{
		title			: 'Comprobar Ortografía Mientras Escribe',
		opera_title		: 'No soportado en Opera',
		enable			: 'Activar Corrector',
		disable			: 'Desactivar Corrector',
		about			: 'Acerca de Corrector',
		toggle			: 'Cambiar Corrector',
		options			: 'Opciones',
		langs			: 'Idiomas',
		moreSuggestions	: 'Más sugerencias',
		ignore			: 'Ignorar',
		ignoreAll		: 'Ignorar Todas',
		addWord			: 'Añadir palabra',
		emptyDic		: 'El nombre del diccionario no puede estar en blanco.',

		optionsTab		: 'Opciones',
		allCaps			: 'Omitir palabras en MAYÚSCULAS',
		ignoreDomainNames : 'Omitir nombres de dominio',
		mixedCase		: 'Ignorar palabras con combinación de mayúsculas y minúsculas',
		mixedWithDigits	: 'Omitir palabras con números',

		languagesTab	: 'Idiomas',

		dictionariesTab	: 'Diccionarios',
		dic_field_name	: 'Nombre del diccionario',
		dic_create		: 'Crear',
		dic_restore		: 'Recuperar',
		dic_delete		: 'Borrar',
		dic_rename		: 'Renombrar',
		dic_info		: 'Inicialmente el Diccionario de usuario se guarda en una Cookie. Sin embargo, las cookies están limitadas en tamaño. Cuando el diccionario crece a un punto en el que no se puede guardar en una Cookie, el diccionario puede ser almacenado en nuestro servidor. Para almacenar su diccionario personalizado en nuestro servidor debe especificar un nombre para su diccionario. Si ya ha guardado un diccionaro, por favor, escriba su nombre y pulse el botón Recuperar',

		aboutTab		: 'Acerca de'
	},

	about :
	{
		title		: 'Acerca de CKEditor',
		dlgTitle	: 'Acerca de CKEditor',
		help	: 'Lea la  $1 para resolver sus dudas.',
		userGuide : 'Guía de usuario de CKEditor',
		moreInfo	: 'Para información de licencia, por favor visite nuestro sitio web:',
		copy		: 'Copyright &copy; $1. Todos los derechos reservados.'
	},

	maximize : 'Maximizar',
	minimize : 'Minimizar',

	fakeobjects :
	{
		anchor		: 'Ancla',
		flash		: 'Animación flash',
		iframe		: 'IFrame',
		hiddenfield	: 'Campo oculto',
		unknown		: 'Objeto desconocido'
	},

	resize : 'Arrastre para redimensionar',

	colordialog :
	{
		title		: 'Elegir color',
		options	:	'Opciones de colores',
		highlight	: 'Muestra',
		selected	: 'Elegido',
		clear		: 'Borrar'
	},

	toolbarCollapse	: 'Contraer barra de herramientas',
	toolbarExpand	: 'Expandir barra de herramientas',

	toolbarGroups :
	{
		document : 'Documento',
		clipboard : 'Portapapeles/Deshacer',
		editing : 'Edición',
		forms : 'Formularios',
		basicstyles : 'Estilos básicos',
		paragraph : 'Párrafo',
		links : 'Enlaces',
		insert : 'Insertar',
		styles : 'Estilos',
		colors : 'Colores',
		tools : 'Herramientas'
	},

	bidi :
	{
		ltr : 'Dirección del texto de izquierda a derecha',
		rtl : 'Dirección del texto de derecha a izquierda'
	},

	docprops :
	{
		label : 'Propiedades del documento',
		title : 'Propiedades del documento',
		design : 'Diseño',
		meta : 'Meta Tags',
		chooseColor : 'Elegir',
		other : 'Otro...',
		docTitle :	'Título de página',
		charset : 	'Codificación de caracteres',
		charsetOther : 'Otra codificación de caracteres',
		charsetASCII : 'ASCII',
		charsetCE : 'Centro Europeo',
		charsetCT : 'Chino Tradicional (Big5)',
		charsetCR : 'Ruso',
		charsetGR : 'Griego',
		charsetJP : 'Japonés',
		charsetKR : 'Koreano',
		charsetTR : 'Turco',
		charsetUN : 'Unicode (UTF-8)',
		charsetWE : 'Europeo occidental',
		docType : 'Tipo de documento',
		docTypeOther : 'Otro tipo de documento',
		xhtmlDec : 'Incluir declaración XHTML',
		bgColor : 'Color de fondo',
		bgImage : 'Imagen de fondo',
		bgFixed : 'Fondo fijo (no se desplaza)',
		txtColor : 'Color del texto',
		margin : 'Márgenes',
		marginTop : 'Superior',
		marginLeft : 'Izquierdo',
		marginRight : 'Derecho',
		marginBottom : 'Inferior',
		metaKeywords : 'Palabras claves del documento separadas por coma (meta keywords)',
		metaDescription : 'Descripción del documento',
		metaAuthor : 'Autor',
		metaCopyright : 'Copyright',
		previewHtml : '<p>Este es un <strong>texto de ejemplo</strong>. Usted está usando <a href="javascript:void(0)">CKEditor</a>.</p>'
	}
};
