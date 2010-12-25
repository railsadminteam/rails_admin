/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	function createFakeElement( editor, realElement )
	{
		var fakeElement = editor.createFakeParserElement( realElement, 'cke_iframe', 'iframe', true ),
			fakeStyle = fakeElement.attributes.style || '';

		var width = realElement.attributes.width,
			height = realElement.attributes.height;

		if ( typeof width != 'undefined' )
			fakeStyle += 'width:' + CKEDITOR.tools.cssLength( width ) + ';';

		if ( typeof height != 'undefined' )
			fakeStyle += 'height:' + CKEDITOR.tools.cssLength( height ) + ';';

		fakeElement.attributes.style = fakeStyle;

		return fakeElement;
	}

	CKEDITOR.plugins.add( 'iframe',
	{
		requires : [ 'dialog', 'fakeobjects' ],
		init : function( editor )
		{
			var pluginName = 'iframe',
				lang = editor.lang.iframe;

			CKEDITOR.dialog.add( pluginName, this.path + 'dialogs/iframe.js' );
			editor.addCommand( pluginName, new CKEDITOR.dialogCommand( pluginName ) );

			editor.addCss(
				'img.cke_iframe' +
				'{' +
					'background-image: url(' + CKEDITOR.getUrl( this.path + 'images/placeholder.png' ) + ');' +
					'background-position: center center;' +
					'background-repeat: no-repeat;' +
					'border: 1px solid #a9a9a9;' +
					'width: 80px;' +
					'height: 80px;' +
				'}'
			);

			editor.ui.addButton( 'Iframe',
				{
					label : lang.toolbar,
					command : pluginName
				});

			editor.on( 'doubleclick', function( evt )
				{
					var element = evt.data.element;
					if ( element.is( 'img' ) && element.data( 'cke-real-element-type' ) == 'iframe' )
						evt.data.dialog = 'iframe';
				});

			if ( editor.addMenuItems )
			{
				editor.addMenuItems(
				{
					iframe :
					{
						label : lang.title,
						command : 'iframe',
						group : 'image'
					}
				});
			}

			// If the "contextmenu" plugin is loaded, register the listeners.
			if ( editor.contextMenu )
			{
				editor.contextMenu.addListener( function( element, selection )
					{
						if ( element && element.is( 'img' ) && element.data( 'cke-real-element-type' ) == 'iframe' )
							return { iframe : CKEDITOR.TRISTATE_OFF };
					});
			}
		},
		afterInit : function( editor )
		{
			var dataProcessor = editor.dataProcessor,
				dataFilter = dataProcessor && dataProcessor.dataFilter;

			if ( dataFilter )
			{
				dataFilter.addRules(
				{
					elements :
					{
						iframe : function( element )
						{
							return createFakeElement( editor, element );
						}
					}
				});
			}
		}
	});
})();
