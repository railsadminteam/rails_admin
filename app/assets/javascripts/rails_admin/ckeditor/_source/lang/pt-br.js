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
CKEDITOR.lang['pt-br'] =
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
	editorTitle : 'Editor de Texto, %1, pressione ALT 0 para obter ajuda.',

	// ARIA descriptions.
	toolbars	: 'Editor toolbars', // MISSING
	editor		: 'Editor de Texto',

	// Toolbar buttons without dialogs.
	source			: 'Código-Fonte',
	newPage			: 'Novo',
	save			: 'Salvar',
	preview			: 'Visualizar',
	cut				: 'Recortar',
	copy			: 'Copiar',
	paste			: 'Colar',
	print			: 'Imprimir',
	underline		: 'Sublinhado',
	bold			: 'Negrito',
	italic			: 'Itálico',
	selectAll		: 'Selecionar Tudo',
	removeFormat	: 'Remover Formatação',
	strike			: 'Tachado',
	subscript		: 'Subscrito',
	superscript		: 'Sobrescrito',
	horizontalrule	: 'Inserir Linha Horizontal',
	pagebreak		: 'Inserir Quebra de Página',
	pagebreakAlt		: 'Page Break', // MISSING
	unlink			: 'Remover Link',
	undo			: 'Desfazer',
	redo			: 'Refazer',

	// Common messages and labels.
	common :
	{
		browseServer	: 'Localizar no Servidor',
		url				: 'URL',
		protocol		: 'Protocolo',
		upload			: 'Enviar ao Servidor',
		uploadSubmit	: 'Enviar para o Servidor',
		image			: 'Imagem',
		flash			: 'Flash',
		form			: 'Formulário',
		checkbox		: 'Caixa de Seleção',
		radio			: 'Botão de Opção',
		textField		: 'Caixa de Texto',
		textarea		: 'Área de Texto',
		hiddenField		: 'Campo Oculto',
		button			: 'Botão',
		select			: 'Caixa de Listagem',
		imageButton		: 'Botão de Imagem',
		notSet			: '<não ajustado>',
		id				: 'Id',
		name			: 'Nome',
		langDir			: 'Direção do idioma',
		langDirLtr		: 'Esquerda para Direita (LTR)',
		langDirRtl		: 'Direita para Esquerda (RTL)',
		langCode		: 'Idioma',
		longDescr		: 'Descrição da URL',
		cssClass		: 'Classe de CSS',
		advisoryTitle	: 'Título',
		cssStyle		: 'Estilos',
		ok				: 'OK',
		cancel			: 'Cancelar',
		close			: 'Fechar',
		preview			: 'Visualizar',
		generalTab		: 'Geral',
		advancedTab		: 'Avançado',
		validateNumberFailed : 'Este valor não é um número.',
		confirmNewPage	: 'Todas as mudanças não salvas serão perdidas. Tem certeza de que quer abrir uma nova página?',
		confirmCancel	: 'Algumas opções foram alteradas. Tem certeza de que quer fechar a caixa de diálogo?',
		options			: 'Opções',
		target			: 'Destino',
		targetNew		: 'Nova Janela (_blank)',
		targetTop		: 'Janela de Cima (_top)',
		targetSelf		: 'Mesma Janela (_self)',
		targetParent	: 'Janela Pai (_parent)',
		langDirLTR		: 'Left to Right (LTR)', // MISSING
		langDirRTL		: 'Right to Left (RTL)', // MISSING
		styles			: 'Style', // MISSING
		cssClasses		: 'Stylesheet Classes', // MISSING
		width			: 'Largura',
		height			: 'Altura',
		align			: 'Alinhamento',
		alignLeft		: 'Esquerda',
		alignRight		: 'Direita',
		alignCenter		: 'Centralizado',
		alignTop		: 'Superior',
		alignMiddle		: 'Centralizado',
		alignBottom		: 'Inferior',
		invalidHeight	: 'A altura tem que ser um número',
		invalidWidth	: 'A largura tem que ser um número.',

		// Put the voice-only part of the label in the span.
		unavailable		: '%1<span class="cke_accessibility">, indisponível</span>'
	},

	contextmenu :
	{
		options : 'Opções Menu de Contexto'
	},

	// Special char dialog.
	specialChar		:
	{
		toolbar		: 'Inserir Caractere Especial',
		title		: 'Selecione um Caractere Especial',
		options : 'Opções de Caractere Especial'
	},

	// Link dialog.
	link :
	{
		toolbar		: 'Inserir/Editar Link',
		other 		: '<outro>',
		menu		: 'Editar Link',
		title		: 'Editar Link',
		info		: 'Informações',
		target		: 'Destino',
		upload		: 'Enviar ao Servidor',
		advanced	: 'Avançado',
		type		: 'Tipo de hiperlink',
		toUrl		: 'URL',
		toAnchor	: 'Âncora nesta página',
		toEmail		: 'E-Mail',
		targetFrame		: '<frame>',
		targetPopup		: '<janela popup>',
		targetFrameName	: 'Nome do Frame de Destino',
		targetPopupName	: 'Nome da Janela Pop-up',
		popupFeatures	: 'Propriedades da Janela Pop-up',
		popupResizable	: 'Redimensionável',
		popupStatusBar	: 'Barra de Status',
		popupLocationBar: 'Barra de Endereços',
		popupToolbar	: 'Barra de Ferramentas',
		popupMenuBar	: 'Barra de Menus',
		popupFullScreen	: 'Modo Tela Cheia (IE)',
		popupScrollBars	: 'Barras de Rolagem',
		popupDependent	: 'Dependente (Netscape)',
		popupLeft		: 'Esquerda',
		popupTop		: 'Topo',
		id				: 'Id',
		langDir			: 'Direção do idioma',
		langDirLTR		: 'Esquerda para Direita (LTR)',
		langDirRTL		: 'Direita para Esquerda (RTL)',
		acccessKey		: 'Chave de Acesso',
		name			: 'Nome',
		langCode			: 'Direção do idioma',
		tabIndex			: 'Índice de Tabulação',
		advisoryTitle		: 'Título',
		advisoryContentType	: 'Tipo de Conteúdo',
		cssClasses		: 'Classe de CSS',
		charset			: 'Charset do Link',
		styles			: 'Estilos',
		rel			: 'Relationship', // MISSING
		selectAnchor		: 'Selecione uma âncora',
		anchorName		: 'Nome da âncora',
		anchorId			: 'Id da âncora',
		emailAddress		: 'Endereço E-Mail',
		emailSubject		: 'Assunto da Mensagem',
		emailBody		: 'Corpo da Mensagem',
		noAnchors		: '(Não há âncoras no documento)',
		noUrl			: 'Por favor, digite o endereço do Link',
		noEmail			: 'Por favor, digite o endereço de e-mail'
	},

	// Anchor dialog
	anchor :
	{
		toolbar		: 'Inserir/Editar Âncora',
		menu		: 'Formatar Âncora',
		title		: 'Formatar Âncora',
		name		: 'Nome da Âncora',
		errorName	: 'Por favor, digite o nome da âncora'
	},

	// List style dialog
	list:
	{
		numberedTitle		: 'Propriedades da Lista Numerada',
		bulletedTitle		: 'Propriedades da Lista sem Numeros',
		type				: 'Tipo',
		start				: 'Início',
		validateStartNumber				:'List start number must be a whole number.', // MISSING
		circle				: 'Círculo',
		disc				: 'Disco',
		square				: 'Quadrado',
		none				: 'Nenhum',
		notset				: '<não definido>',
		armenian			: 'Numeração Armêna',
		georgian			: 'Numeração da Geórgia (an, ban, gan, etc.)',
		lowerRoman			: 'Numeração Romana minúscula (i, ii, iii, iv, v, etc.)',
		upperRoman			: 'Numeração Romana maiúscula (I, II, III, IV, V, etc.)',
		lowerAlpha			: 'Numeração Alfabética minúscula (a, b, c, d, e, etc.)',
		upperAlpha			: 'Numeração Alfabética Maiúscula (A, B, C, D, E, etc.)',
		lowerGreek			: 'Numeração Grega minúscula (alpha, beta, gamma, etc.)',
		decimal				: 'Numeração Decimal (1, 2, 3, etc.)',
		decimalLeadingZero	: 'Numeração Decimal com zeros (01, 02, 03, etc.)'
	},

	// Find And Replace Dialog
	findAndReplace :
	{
		title				: 'Localizar e Substituir',
		find				: 'Localizar',
		replace				: 'Substituir',
		findWhat			: 'Procurar por:',
		replaceWith			: 'Substituir por:',
		notFoundMsg			: 'O texto especificado não foi encontrado.',
		matchCase			: 'Coincidir Maiúsculas/Minúsculas',
		matchWord			: 'Coincidir a palavra inteira',
		matchCyclic			: 'Coincidir cíclico',
		replaceAll			: 'Substituir Tudo',
		replaceSuccessMsg	: '%1 ocorrência(s) substituída(s).'
	},

	// Table Dialog
	table :
	{
		toolbar		: 'Tabela',
		title		: 'Formatar Tabela',
		menu		: 'Formatar Tabela',
		deleteTable	: 'Apagar Tabela',
		rows		: 'Linhas',
		columns		: 'Colunas',
		border		: 'Borda',
		widthPx		: 'pixels',
		widthPc		: '%',
		widthUnit	: 'unidade largura',
		cellSpace	: 'Espaçamento',
		cellPad		: 'Margem interna',
		caption		: 'Legenda',
		summary		: 'Resumo',
		headers		: 'Cabeçalho',
		headersNone		: 'Nenhum',
		headersColumn	: 'Primeira coluna',
		headersRow		: 'Primeira linha',
		headersBoth		: 'Ambos',
		invalidRows		: 'O número de linhas tem que ser um número maior que 0.',
		invalidCols		: 'O número de colunas tem que ser um número maior que 0.',
		invalidBorder	: 'O tamanho da borda tem que ser um número.',
		invalidWidth	: 'A largura da tabela tem que ser um número.',
		invalidHeight	: 'A altura da tabela tem que ser um número.',
		invalidCellSpacing	: 'O espaçamento das células tem que ser um número.',
		invalidCellPadding	: 'A margem interna das células tem que ser um número.',

		cell :
		{
			menu			: 'Célula',
			insertBefore	: 'Inserir célula a esquerda',
			insertAfter		: 'Inserir célula a direita',
			deleteCell		: 'Remover Células',
			merge			: 'Mesclar Células',
			mergeRight		: 'Mesclar com célula a direita',
			mergeDown		: 'Mesclar com célula abaixo',
			splitHorizontal	: 'Dividir célula horizontalmente',
			splitVertical	: 'Dividir célula verticalmente',
			title			: 'Propriedades da célula',
			cellType		: 'Tipo de célula',
			rowSpan			: 'Linhas cobertas',
			colSpan			: 'Colunas cobertas',
			wordWrap		: 'Quebra de palavra',
			hAlign			: 'Alinhamento horizontal',
			vAlign			: 'Alinhamento vertical',
			alignBaseline	: 'Patamar de alinhamento',
			bgColor			: 'Cor de fundo',
			borderColor		: 'Cor das bordas',
			data			: 'Dados',
			header			: 'Cabeçalho',
			yes				: 'Sim',
			no				: 'Não',
			invalidWidth	: 'A largura da célula tem que ser um número.',
			invalidHeight	: 'A altura da célula tem que ser um número.',
			invalidRowSpan	: 'Linhas cobertas tem que ser um número inteiro.',
			invalidColSpan	: 'Colunas cobertas tem que ser um número inteiro.',
			chooseColor		: 'Escolher'
		},

		row :
		{
			menu			: 'Linha',
			insertBefore	: 'Inserir linha acima',
			insertAfter		: 'Inserir linha abaixo',
			deleteRow		: 'Remover Linhas'
		},

		column :
		{
			menu			: 'Coluna',
			insertBefore	: 'Inserir coluna a esquerda',
			insertAfter		: 'Inserir coluna a direita',
			deleteColumn	: 'Remover Colunas'
		}
	},

	// Button Dialog.
	button :
	{
		title		: 'Formatar Botão',
		text		: 'Texto (Valor)',
		type		: 'Tipo',
		typeBtn		: 'Botão',
		typeSbm		: 'Enviar',
		typeRst		: 'Limpar'
	},

	// Checkbox and Radio Button Dialogs.
	checkboxAndRadio :
	{
		checkboxTitle : 'Formatar Caixa de Seleção',
		radioTitle	: 'Formatar Botão de Opção',
		value		: 'Valor',
		selected	: 'Selecionado'
	},

	// Form Dialog.
	form :
	{
		title		: 'Formatar Formulário',
		menu		: 'Formatar Formulário',
		action		: 'Ação',
		method		: 'Método',
		encoding	: 'Codificação'
	},

	// Select Field Dialog.
	select :
	{
		title		: 'Formatar Caixa de Listagem',
		selectInfo	: 'Informações',
		opAvail		: 'Opções disponíveis',
		value		: 'Valor',
		size		: 'Tamanho',
		lines		: 'linhas',
		chkMulti	: 'Permitir múltiplas seleções',
		opText		: 'Texto',
		opValue		: 'Valor',
		btnAdd		: 'Adicionar',
		btnModify	: 'Modificar',
		btnUp		: 'Para cima',
		btnDown		: 'Para baixo',
		btnSetValue : 'Definir como selecionado',
		btnDelete	: 'Remover'
	},

	// Textarea Dialog.
	textarea :
	{
		title		: 'Formatar Área de Texto',
		cols		: 'Colunas',
		rows		: 'Linhas'
	},

	// Text Field Dialog.
	textfield :
	{
		title		: 'Formatar Caixa de Texto',
		name		: 'Nome',
		value		: 'Valor',
		charWidth	: 'Comprimento (em caracteres)',
		maxChars	: 'Número Máximo de Caracteres',
		type		: 'Tipo',
		typeText	: 'Texto',
		typePass	: 'Senha'
	},

	// Hidden Field Dialog.
	hidden :
	{
		title	: 'Formatar Campo Oculto',
		name	: 'Nome',
		value	: 'Valor'
	},

	// Image Dialog.
	image :
	{
		title		: 'Formatar Imagem',
		titleButton	: 'Formatar Botão de Imagem',
		menu		: 'Formatar Imagem',
		infoTab		: 'Informações da Imagem',
		btnUpload	: 'Enviar para o Servidor',
		upload		: 'Enviar',
		alt			: 'Texto Alternativo',
		lockRatio	: 'Travar Proporções',
		unlockRatio	: 'Destravar Proporções',
		resetSize	: 'Redefinir para o Tamanho Original',
		border		: 'Borda',
		hSpace		: 'HSpace',
		vSpace		: 'VSpace',
		alertUrl	: 'Por favor, digite a URL da imagem.',
		linkTab		: 'Link',
		button2Img	: 'Deseja transformar o botão de imagem em uma imagem comum?',
		img2Button	: 'Deseja transformar a imagem em um botão de imagem?',
		urlMissing	: 'URL da imagem está faltando.',
		validateBorder	: 'A borda deve ser um número inteiro.',
		validateHSpace	: 'O HSpace deve ser um número inteiro.',
		validateVSpace	: 'O VSpace deve ser um número inteiro.'
	},

	// Flash Dialog
	flash :
	{
		properties		: 'Propriedades do Flash',
		propertiesTab	: 'Propriedades',
		title			: 'Propriedades do Flash',
		chkPlay			: 'Tocar Automaticamente',
		chkLoop			: 'Tocar Infinitamente',
		chkMenu			: 'Habilita Menu Flash',
		chkFull			: 'Permitir tela cheia',
 		scale			: 'Escala',
		scaleAll		: 'Mostrar tudo',
		scaleNoBorder	: 'Sem Borda',
		scaleFit		: 'Escala Exata',
		access			: 'Acesso ao script',
		accessAlways	: 'Sempre',
		accessSameDomain: 'Acessar Mesmo Domínio',
		accessNever		: 'Nunca',
		alignAbsBottom	: 'Inferior Absoluto',
		alignAbsMiddle	: 'Centralizado Absoluto',
		alignBaseline	: 'Baseline',
		alignTextTop	: 'Superior Absoluto',
		quality			: 'Qualidade',
		qualityBest		: 'Qualidade Melhor',
		qualityHigh		: 'Qualidade Alta',
		qualityAutoHigh	: 'Qualidade Alta Automática',
		qualityMedium	: 'Qualidade Média',
		qualityAutoLow	: 'Qualidade Baixa Automática',
		qualityLow		: 'Qualidade Baixa',
		windowModeWindow: 'Janela',
		windowModeOpaque: 'Opaca',
		windowModeTransparent : 'Transparente',
		windowMode		: 'Modo da janela',
		flashvars		: 'Variáveis do Flash',
		bgcolor			: 'Cor do Plano de Fundo',
		hSpace			: 'HSpace',
		vSpace			: 'VSpace',
		validateSrc		: 'Por favor, digite o endereço do link',
		validateHSpace	: 'O HSpace tem que ser um número',
		validateVSpace	: 'O VSpace tem que ser um número.'
	},

	// Speller Pages Dialog
	spellCheck :
	{
		toolbar			: 'Verificar Ortografia',
		title			: 'Corretor Ortográfico',
		notAvailable	: 'Desculpe, o serviço não está disponível no momento.',
		errorLoading	: 'Erro carregando servidor de aplicação: %s.',
		notInDic		: 'Não encontrada',
		changeTo		: 'Alterar para',
		btnIgnore		: 'Ignorar uma vez',
		btnIgnoreAll	: 'Ignorar Todas',
		btnReplace		: 'Alterar',
		btnReplaceAll	: 'Alterar Todas',
		btnUndo			: 'Desfazer',
		noSuggestions	: '-sem sugestões de ortografia-',
		progress		: 'Verificação ortográfica em andamento...',
		noMispell		: 'Verificação encerrada: Não foram encontrados erros de ortografia',
		noChanges		: 'Verificação ortográfica encerrada: Não houve alterações',
		oneChange		: 'Verificação ortográfica encerrada: Uma palavra foi alterada',
		manyChanges		: 'Verificação ortográfica encerrada: %1 palavras foram alteradas',
		ieSpellDownload	: 'A verificação ortográfica não foi instalada. Você gostaria de realizar o download agora?'
	},

	smiley :
	{
		toolbar	: 'Emoticon',
		title	: 'Inserir Emoticon',
		options : 'Opções de Emoticons'
	},

	elementsPath :
	{
		eleLabel : 'Caminho dos Elementos',
		eleTitle : 'Elemento %1'
	},

	numberedlist	: 'Lista numerada',
	bulletedlist	: 'Lista sem números',
	indent			: 'Aumentar Recuo',
	outdent			: 'Diminuir Recuo',

	justify :
	{
		left	: 'Alinhar Esquerda',
		center	: 'Centralizar',
		right	: 'Alinhar Direita',
		block	: 'Justificado'
	},

	blockquote : 'Citação',

	clipboard :
	{
		title		: 'Colar',
		cutError	: 'As configurações de segurança do seu navegador não permitem que o editor execute operações de recortar automaticamente. Por favor, utilize o teclado para recortar (Ctrl/Cmd+X).',
		copyError	: 'As configurações de segurança do seu navegador não permitem que o editor execute operações de copiar automaticamente. Por favor, utilize o teclado para copiar (Ctrl/Cmd+C).',
		pasteMsg	: 'Transfira o link usado na caixa usando o teclado com (<STRONG>Ctrl/Cmd+V</STRONG>) e <STRONG>OK</STRONG>.',
		securityMsg	: 'As configurações de segurança do seu navegador não permitem que o editor acesse os dados da área de transferência diretamente. Por favor cole o conteúdo manualmente nesta janela.',
		pasteArea	: 'Área para Colar'
	},

	pastefromword :
	{
		confirmCleanup	: 'O texto que você deseja colar parece ter sido copiado do Word. Você gostaria de remover a formatação antes de colar?',
		toolbar			: 'Colar do Word',
		title			: 'Colar do Word',
		error			: 'Não foi possível limpar os dados colados devido a um erro interno'
	},

	pasteText :
	{
		button	: 'Colar como Texto sem Formatação',
		title	: 'Colar como Texto sem Formatação'
	},

	templates :
	{
		button			: 'Modelos de layout',
		title			: 'Modelo de layout de conteúdo',
		options : 'Opções de Template',
		insertOption	: 'Substituir o conteúdo atual',
		selectPromptMsg	: 'Selecione um modelo de layout para ser aberto no editor<br>(o conteúdo atual será perdido):',
		emptyListMsg	: '(Não foram definidos modelos de layout)'
	},

	showBlocks : 'Mostrar blocos de código',

	stylesCombo :
	{
		label		: 'Estilo',
		panelTitle	: 'Estilos de Formatação',
		panelTitle1	: 'Estilos de bloco',
		panelTitle2	: 'Estilos de texto corrido',
		panelTitle3	: 'Estilos de objeto'
	},

	format :
	{
		label		: 'Formatação',
		panelTitle	: 'Formatação',

		tag_p		: 'Normal',
		tag_pre		: 'Formatado',
		tag_address	: 'Endereço',
		tag_h1		: 'Título 1',
		tag_h2		: 'Título 2',
		tag_h3		: 'Título 3',
		tag_h4		: 'Título 4',
		tag_h5		: 'Título 5',
		tag_h6		: 'Título 6',
		tag_div		: 'Normal (DIV)'
	},

	div :
	{
		title				: 'Criar Container de DIV',
		toolbar				: 'Criar Container de DIV',
		cssClassInputLabel	: 'Classes de CSS',
		styleSelectLabel	: 'Estilo',
		IdInputLabel		: 'Id',
		languageCodeInputLabel	: 'Código de Idioma',
		inlineStyleInputLabel	: 'Estilo Inline',
		advisoryTitleInputLabel	: 'Título Consulta',
		langDirLabel		: 'Direção da Escrita',
		langDirLTRLabel		: 'Esquerda para Direita (LTR)',
		langDirRTLLabel		: 'Direita para Esquerda (RTL)',
		edit				: 'Editar Div',
		remove				: 'Remover Div'
  	},

	iframe :
	{
		title		: 'IFrame Properties', // MISSING
		toolbar		: 'IFrame', // MISSING
		noUrl		: 'Please type the iframe URL', // MISSING
		scrolling	: 'Enable scrollbars', // MISSING
		border		: 'Show frame border' // MISSING
	},

	font :
	{
		label		: 'Fonte',
		voiceLabel	: 'Fonte',
		panelTitle	: 'Fonte'
	},

	fontSize :
	{
		label		: 'Tamanho',
		voiceLabel	: 'Tamanho da fonte',
		panelTitle	: 'Tamanho'
	},

	colorButton :
	{
		textColorTitle	: 'Cor do Texto',
		bgColorTitle	: 'Cor do Plano de Fundo',
		panelTitle		: 'Cores',
		auto			: 'Automático',
		more			: 'Mais Cores...'
	},

	colors :
	{
		'000' : 'Preto',
		'800000' : 'Foquete',
		'8B4513' : 'Marrom 1',
		'2F4F4F' : 'Cinza 1',
		'008080' : 'Cerceta',
		'000080' : 'Azul Marinho',
		'4B0082' : 'Índigo',
		'696969' : 'Cinza 2',
		'B22222' : 'Tijolo de Fogo',
		'A52A2A' : 'Marrom 2',
		'DAA520' : 'Vara Dourada',
		'006400' : 'Verde Escuro',
		'40E0D0' : 'Turquesa',
		'0000CD' : 'Azul Médio',
		'800080' : 'Roxo',
		'808080' : 'Cinza 3',
		'F00' : 'Vermelho',
		'FF8C00' : 'Laranja Escuro',
		'FFD700' : 'Dourado',
		'008000' : 'Verde',
		'0FF' : 'Ciano',
		'00F' : 'Azul',
		'EE82EE' : 'Violeta',
		'A9A9A9' : 'Cinza Escuro',
		'FFA07A' : 'Salmão Claro',
		'FFA500' : 'Laranja',
		'FFFF00' : 'Amarelo',
		'00FF00' : 'Lima',
		'AFEEEE' : 'Turquesa Pálido',
		'ADD8E6' : 'Azul Claro',
		'DDA0DD' : 'Ameixa',
		'D3D3D3' : 'Cinza Claro',
		'FFF0F5' : 'Lavanda 1',
		'FAEBD7' : 'Branco Antiguidade',
		'FFFFE0' : 'Amarelo Claro',
		'F0FFF0' : 'Orvalho',
		'F0FFFF' : 'Azure',
		'F0F8FF' : 'Azul Alice',
		'E6E6FA' : 'Lavanda 2',
		'FFF' : 'Branco'
	},

	scayt :
	{
		title			: 'Correção ortográfica durante a digitação',
		opera_title		: 'Não suportado no Opera',
		enable			: 'Habilitar correção ortográfica durante a digitação',
		disable			: 'Desabilitar correção ortográfica durante a digitação',
		about			: 'Sobre a correção ortográfica durante a digitação',
		toggle			: 'Ativar/desativar correção ortográfica durante a digitação',
		options			: 'Opções',
		langs			: 'Idiomas',
		moreSuggestions	: 'Mais sugestões',
		ignore			: 'Ignorar',
		ignoreAll		: 'Ignorar todas',
		addWord			: 'Adicionar palavra',
		emptyDic		: 'O nome do dicionário não deveria estar vazio.',

		optionsTab		: 'Opções',
		allCaps			: 'Ignorar palavras maiúsculas',
		ignoreDomainNames : 'Ignorar nomes de domínio',
		mixedCase		: 'Ignorar palavras com maiúsculas e minúsculas misturadas',
		mixedWithDigits	: 'Ignorar palavras com números',

		languagesTab	: 'Idiomas',

		dictionariesTab	: 'Dicionários',
		dic_field_name	: 'Nome do Dicionário',
		dic_create		: 'Criar',
		dic_restore		: 'Restaurar',
		dic_delete		: 'Excluir',
		dic_rename		: 'Renomear',
		dic_info		: 'Inicialmente, o dicionário do usuário fica armazenado em um Cookie. Porém, Cookies tem tamanho limitado, portanto quand o dicionário do usuário atingir o tamanho limite poderá ser armazenado no nosso servidor. Para armazenar seu dicionário pessoal no nosso servidor deverá especificar um nome para ele. Se já tiver um dicionário armazenado por favor especifique o seu nome e clique em Restaurar.',

		aboutTab		: 'Sobre'
	},

	about :
	{
		title		: 'Sobre o CKEditor',
		dlgTitle	: 'Sobre o CKEditor',
		help	: 'Check $1 for help.', // MISSING
		userGuide : 'CKEditor User\'s Guide', // MISSING
		moreInfo	: 'Para informações sobre a licença por favor visite o nosso site:',
		copy		: 'Copyright &copy; $1. Todos os direitos reservados.'
	},

	maximize : 'Maximizar',
	minimize : 'Minimize',

	fakeobjects :
	{
		anchor		: 'Âncora',
		flash		: 'Animação em Flash',
		iframe		: 'IFrame', // MISSING
		hiddenfield	: 'Hidden Field', // MISSING
		unknown		: 'Objeto desconhecido'
	},

	resize : 'Arraste para redimensionar',

	colordialog :
	{
		title		: 'Selecione uma cor',
		options	:	'Opções de Cor',
		highlight	: 'Grifar',
		selected	: 'Cor Selecionada',
		clear		: 'Limpar'
	},

	toolbarCollapse	: 'Diminuir Barra de Ferramentas',
	toolbarExpand	: 'Aumentar Barra de Ferramentas',

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
		ltr : 'Text direction from left to right', // MISSING
		rtl : 'Text direction from right to left' // MISSING
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
