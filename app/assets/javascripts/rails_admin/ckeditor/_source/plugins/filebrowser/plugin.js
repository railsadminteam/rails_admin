/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview The "filebrowser" plugin, it adds support for file uploads and
 *               browsing.
 *
 * When file is selected inside of the file browser or uploaded, its url is
 * inserted automatically to a field, which is described in the 'filebrowser'
 * attribute. To specify field that should be updated, pass the tab id and
 * element id, separated with a colon.
 *
 * Example 1: (Browse)
 *
 * <pre>
 * {
 * 	type : 'button',
 * 	id : 'browse',
 * 	filebrowser : 'tabId:elementId',
 * 	label : editor.lang.common.browseServer
 * }
 * </pre>
 *
 * If you set the 'filebrowser' attribute on any element other than
 * 'fileButton', the 'Browse' action will be triggered.
 *
 * Example 2: (Quick Upload)
 *
 * <pre>
 * {
 * 	type : 'fileButton',
 * 	id : 'uploadButton',
 * 	filebrowser : 'tabId:elementId',
 * 	label : editor.lang.common.uploadSubmit,
 * 	'for' : [ 'upload', 'upload' ]
 * }
 * </pre>
 *
 * If you set the 'filebrowser' attribute on a fileButton element, the
 * 'QuickUpload' action will be executed.
 *
 * Filebrowser plugin also supports more advanced configuration (through
 * javascript object).
 *
 * The following settings are supported:
 *
 * <pre>
 *  [action] - Browse or QuickUpload
 *  [target] - field to update, tabId:elementId
 *  [params] - additional arguments to be passed to the server connector (optional)
 *  [onSelect] - function to execute when file is selected/uploaded (optional)
 *  [url] - the URL to be called (optional)
 * </pre>
 *
 * Example 3: (Quick Upload)
 *
 * <pre>
 * {
 * 	type : 'fileButton',
 * 	label : editor.lang.common.uploadSubmit,
 * 	id : 'buttonId',
 * 	filebrowser :
 * 	{
 * 		action : 'QuickUpload', //required
 * 		target : 'tab1:elementId', //required
 * 		params : //optional
 * 		{
 * 			type : 'Files',
 * 			currentFolder : '/folder/'
 * 		},
 * 		onSelect : function( fileUrl, errorMessage ) //optional
 * 		{
 * 			// Do not call the built-in selectFuntion
 * 			// return false;
 * 		}
 * 	},
 * 	'for' : [ 'tab1', 'myFile' ]
 * }
 * </pre>
 *
 * Suppose we have a file element with id 'myFile', text field with id
 * 'elementId' and a fileButton. If filebowser.url is not specified explicitly,
 * form action will be set to 'filebrowser[DialogName]UploadUrl' or, if not
 * specified, to 'filebrowserUploadUrl'. Additional parameters from 'params'
 * object will be added to the query string. It is possible to create your own
 * uploadHandler and cancel the built-in updateTargetElement command.
 *
 * Example 4: (Browse)
 *
 * <pre>
 * {
 * 	type : 'button',
 * 	id : 'buttonId',
 * 	label : editor.lang.common.browseServer,
 * 	filebrowser :
 * 	{
 * 		action : 'Browse',
 * 		url : '/ckfinder/ckfinder.html&amp;type=Images',
 * 		target : 'tab1:elementId'
 * 	}
 * }
 * </pre>
 *
 * In this example, after pressing a button, file browser will be opened in a
 * popup. If we don't specify filebrowser.url attribute,
 * 'filebrowser[DialogName]BrowseUrl' or 'filebrowserBrowseUrl' will be used.
 * After selecting a file in a file browser, an element with id 'elementId' will
 * be updated. Just like in the third example, a custom 'onSelect' function may be
 * defined.
 */
( function()
{
	/*
	 * Adds (additional) arguments to given url.
	 *
	 * @param {String}
	 *            url The url.
	 * @param {Object}
	 *            params Additional parameters.
	 */
	function addQueryString( url, params )
	{
		var queryString = [];

		if ( !params )
			return url;
		else
		{
			for ( var i in params )
				queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
		}

		return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
	}

	/*
	 * Make a string's first character uppercase.
	 *
	 * @param {String}
	 *            str String.
	 */
	function ucFirst( str )
	{
		str += '';
		var f = str.charAt( 0 ).toUpperCase();
		return f + str.substr( 1 );
	}

	/*
	 * The onlick function assigned to the 'Browse Server' button. Opens the
	 * file browser and updates target field when file is selected.
	 *
	 * @param {CKEDITOR.event}
	 *            evt The event object.
	 */
	function browseServer( evt )
	{
		var dialog = this.getDialog();
		var editor = dialog.getParentEditor();

		editor._.filebrowserSe = this;

		var width = editor.config[ 'filebrowser' + ucFirst( dialog.getName() ) + 'WindowWidth' ]
				|| editor.config.filebrowserWindowWidth || '80%';
		var height = editor.config[ 'filebrowser' + ucFirst( dialog.getName() ) + 'WindowHeight' ]
				|| editor.config.filebrowserWindowHeight || '70%';

		var params = this.filebrowser.params || {};
		params.CKEditor = editor.name;
		params.CKEditorFuncNum = editor._.filebrowserFn;
		if ( !params.langCode )
			params.langCode = editor.langCode;

		var url = addQueryString( this.filebrowser.url, params );
		editor.popup( url, width, height, editor.config.fileBrowserWindowFeatures );
	}

	/*
	 * The onlick function assigned to the 'Upload' button. Makes the final
	 * decision whether form is really submitted and updates target field when
	 * file is uploaded.
	 *
	 * @param {CKEDITOR.event}
	 *            evt The event object.
	 */
	function uploadFile( evt )
	{
		var dialog = this.getDialog();
		var editor = dialog.getParentEditor();

		editor._.filebrowserSe = this;

		// If user didn't select the file, stop the upload.
		if ( !dialog.getContentElement( this[ 'for' ][ 0 ], this[ 'for' ][ 1 ] ).getInputElement().$.value )
			return false;

		if ( !dialog.getContentElement( this[ 'for' ][ 0 ], this[ 'for' ][ 1 ] ).getAction() )
			return false;

		return true;
	}

	/*
	 * Setups the file element.
	 *
	 * @param {CKEDITOR.ui.dialog.file}
	 *            fileInput The file element used during file upload.
	 * @param {Object}
	 *            filebrowser Object containing filebrowser settings assigned to
	 *            the fileButton associated with this file element.
	 */
	function setupFileElement( editor, fileInput, filebrowser )
	{
		var params = filebrowser.params || {};
		params.CKEditor = editor.name;
		params.CKEditorFuncNum = editor._.filebrowserFn;
		if ( !params.langCode )
			params.langCode = editor.langCode;

		fileInput.action = addQueryString( filebrowser.url, params );
		fileInput.filebrowser = filebrowser;
	}

	/*
	 * Traverse through the content definition and attach filebrowser to
	 * elements with 'filebrowser' attribute.
	 *
	 * @param String
	 *            dialogName Dialog name.
	 * @param {CKEDITOR.dialog.definitionObject}
	 *            definition Dialog definition.
	 * @param {Array}
	 *            elements Array of {@link CKEDITOR.dialog.definition.content}
	 *            objects.
	 */
	function attachFileBrowser( editor, dialogName, definition, elements )
	{
		var element, fileInput;

		for ( var i in elements )
		{
			element = elements[ i ];

			if ( element.type == 'hbox' || element.type == 'vbox' )
				attachFileBrowser( editor, dialogName, definition, element.children );

			if ( !element.filebrowser )
				continue;

			if ( typeof element.filebrowser == 'string' )
			{
				var fb =
				{
					action : ( element.type == 'fileButton' ) ? 'QuickUpload' : 'Browse',
					target : element.filebrowser
				};
				element.filebrowser = fb;
			}

			if ( element.filebrowser.action == 'Browse' )
			{
				var url = element.filebrowser.url;
				if ( url === undefined )
				{
					url = editor.config[ 'filebrowser' + ucFirst( dialogName ) + 'BrowseUrl' ];
					if ( url === undefined )
						url = editor.config.filebrowserBrowseUrl;
				}

				if ( url )
				{
					element.onClick = browseServer;
					element.filebrowser.url = url;
					element.hidden = false;
				}
			}
			else if ( element.filebrowser.action == 'QuickUpload' && element[ 'for' ] )
			{
				url = element.filebrowser.url;
				if ( url === undefined )
				{
					url = editor.config[ 'filebrowser' + ucFirst( dialogName ) + 'UploadUrl' ];
					if ( url === undefined )
						url = editor.config.filebrowserUploadUrl;
				}

				if ( url )
				{
					var onClick = element.onClick;
					element.onClick = function( evt )
					{
						// "element" here means the definition object, so we need to find the correct
						// button to scope the event call
						var sender = evt.sender;
						if ( onClick && onClick.call( sender, evt ) === false )
							return false;

						return uploadFile.call( sender, evt );
					};

					element.filebrowser.url = url;
					element.hidden = false;
					setupFileElement( editor, definition.getContents( element[ 'for' ][ 0 ] ).get( element[ 'for' ][ 1 ] ), element.filebrowser );
				}
			}
		}
	}

	/*
	 * Updates the target element with the url of uploaded/selected file.
	 *
	 * @param {String}
	 *            url The url of a file.
	 */
	function updateTargetElement( url, sourceElement )
	{
		var dialog = sourceElement.getDialog();
		var targetElement = sourceElement.filebrowser.target || null;
		url = url.replace( /#/g, '%23' );

		// If there is a reference to targetElement, update it.
		if ( targetElement )
		{
			var target = targetElement.split( ':' );
			var element = dialog.getContentElement( target[ 0 ], target[ 1 ] );
			if ( element )
			{
				element.setValue( url );
				dialog.selectPage( target[ 0 ] );
			}
		}
	}

	/*
	 * Returns true if filebrowser is configured in one of the elements.
	 *
	 * @param {CKEDITOR.dialog.definitionObject}
	 *            definition Dialog definition.
	 * @param String
	 *            tabId The tab id where element(s) can be found.
	 * @param String
	 *            elementId The element id (or ids, separated with a semicolon) to check.
	 */
	function isConfigured( definition, tabId, elementId )
	{
		if ( elementId.indexOf( ";" ) !== -1 )
		{
			var ids = elementId.split( ";" );
			for ( var i = 0 ; i < ids.length ; i++ )
			{
				if ( isConfigured( definition, tabId, ids[i] ) )
					return true;
			}
			return false;
		}

		var elementFileBrowser = definition.getContents( tabId ).get( elementId ).filebrowser;
		return ( elementFileBrowser && elementFileBrowser.url );
	}

	function setUrl( fileUrl, data )
	{
		var dialog = this._.filebrowserSe.getDialog(),
			targetInput = this._.filebrowserSe[ 'for' ],
			onSelect = this._.filebrowserSe.filebrowser.onSelect;

		if ( targetInput )
			dialog.getContentElement( targetInput[ 0 ], targetInput[ 1 ] ).reset();

		if ( typeof data == 'function' && data.call( this._.filebrowserSe ) === false )
			return;

		if ( onSelect && onSelect.call( this._.filebrowserSe, fileUrl, data ) === false )
			return;

		// The "data" argument may be used to pass the error message to the editor.
		if ( typeof data == 'string' && data )
			alert( data );

		if ( fileUrl )
			updateTargetElement( fileUrl, this._.filebrowserSe );
	}

	CKEDITOR.plugins.add( 'filebrowser',
	{
		init : function( editor, pluginPath )
		{
			editor._.filebrowserFn = CKEDITOR.tools.addFunction( setUrl, editor );
			editor.on( 'destroy', function () { CKEDITOR.tools.removeFunction( this._.filebrowserFn ); } );
		}
	} );

	CKEDITOR.on( 'dialogDefinition', function( evt )
	{
		var definition = evt.data.definition,
			element;
		// Associate filebrowser to elements with 'filebrowser' attribute.
		for ( var i in definition.contents )
		{
			if ( ( element = definition.contents[ i ] ) )
			{
				attachFileBrowser( evt.editor, evt.data.name, definition, element.elements );
				if ( element.hidden && element.filebrowser )
				{
					element.hidden = !isConfigured( definition, element[ 'id' ], element.filebrowser );
				}
			}
		}
	} );

} )();

/**
 * The location of an external file browser, that should be launched when "Browse Server" button is pressed.
 * If configured, the "Browse Server" button will appear in Link, Image and Flash dialogs.
 * @see The <a href="http://docs.cksource.com/CKEditor_3.x/Developers_Guide/File_Browser_(Uploader)">File Browser/Uploader</a> documentation.
 * @name CKEDITOR.config.filebrowserBrowseUrl
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserBrowseUrl = '/browser/browse.php';
 */

/**
 * The location of a script that handles file uploads.
 * If set, the "Upload" tab will appear in "Link", "Image" and "Flash" dialogs.
 * @name CKEDITOR.config.filebrowserUploadUrl
 * @see The <a href="http://docs.cksource.com/CKEditor_3.x/Developers_Guide/File_Browser_(Uploader)">File Browser/Uploader</a> documentation.
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserUploadUrl = '/uploader/upload.php';
 */

/**
 * The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
 * If not set, CKEditor will use {@link CKEDITOR.config.filebrowserBrowseUrl}.
 * @name CKEDITOR.config.filebrowserImageBrowseUrl
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserImageBrowseUrl = '/browser/browse.php?type=Images';
 */

/**
 * The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
 * If not set, CKEditor will use {@link CKEDITOR.config.filebrowserBrowseUrl}.
 * @name CKEDITOR.config.filebrowserFlashBrowseUrl
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserFlashBrowseUrl = '/browser/browse.php?type=Flash';
 */

/**
 * The location of a script that handles file uploads in the Image dialog.
 * If not set, CKEditor will use {@link CKEDITOR.config.filebrowserUploadUrl}.
 * @name CKEDITOR.config.filebrowserImageUploadUrl
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserImageUploadUrl = '/uploader/upload.php?type=Images';
 */

/**
 * The location of a script that handles file uploads in the Flash dialog.
 * If not set, CKEditor will use {@link CKEDITOR.config.filebrowserUploadUrl}.
 * @name CKEDITOR.config.filebrowserFlashUploadUrl
 * @since 3.0
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserFlashUploadUrl = '/uploader/upload.php?type=Flash';
 */

/**
 * The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
 * If not set, CKEditor will use {@link CKEDITOR.config.filebrowserBrowseUrl}.
 * @name CKEDITOR.config.filebrowserImageBrowseLinkUrl
 * @since 3.2
 * @type String
 * @default '' (empty string = disabled)
 * @example
 * config.filebrowserImageBrowseLinkUrl = '/browser/browse.php';
 */

/**
 * The "features" to use in the file browser popup window.
 * @name CKEDITOR.config.filebrowserWindowFeatures
 * @since 3.4.1
 * @type String
 * @default 'location=no,menubar=no,toolbar=no,dependent=yes,minimizable=no,modal=yes,alwaysRaised=yes,resizable=yes,scrollbars=yes'
 * @example
 * config.filebrowserWindowFeatures = 'resizable=yes,scrollbars=no';
 */

/**
 * The width of the file browser popup window. It can be a number or a percent string.
 * @name CKEDITOR.config.filebrowserWindowWidth
 * @type Number|String
 * @default '80%'
 * @example
 * config.filebrowserWindowWidth = 750;
 * @example
 * config.filebrowserWindowWidth = '50%';
 */

/**
 * The height of the file browser popup window. It can be a number or a percent string.
 * @name CKEDITOR.config.filebrowserWindowHeight
 * @type Number|String
 * @default '70%'
 * @example
 * config.filebrowserWindowHeight = 580;
 * @example
 * config.filebrowserWindowHeight = '50%';
 */
