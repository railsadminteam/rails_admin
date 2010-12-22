/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.skins.add( 'office2003', (function()
{
	return {
		editor		: { css : [ 'editor.css' ] },
		dialog		: { css : [ 'dialog.css' ] },
		templates	: { css : [ 'templates.css' ] },
		margins		: [ 0, 14, 18, 14 ]
	};
})() );

(function()
{
	CKEDITOR.dialog ? dialogSetup() : CKEDITOR.on( 'dialogPluginReady', dialogSetup );

	function dialogSetup()
	{
		CKEDITOR.dialog.on( 'resize', function( evt )
			{
				var data = evt.data,
					width = data.width,
					height = data.height,
					dialog = data.dialog,
					contents = dialog.parts.contents;

				if ( data.skin != 'office2003' )
					return;

				contents.setStyles(
					{
						width : width + 'px',
						height : height + 'px'
					});

				if ( !CKEDITOR.env.ie )
					return;

				// Fix the size of the elements which have flexible lengths.
				var fixSize = function()
					{
						var innerDialog = dialog.parts.dialog.getChild( [ 0, 0, 0 ] ),
							body = innerDialog.getChild( 0 );

						// tc
						var el = innerDialog.getChild( 2 );
						el.setStyle( 'width', ( body.$.offsetWidth ) + 'px' );

						// bc
						el = innerDialog.getChild( 7 );
						el.setStyle( 'width', ( body.$.offsetWidth - 28 ) + 'px' );

						// ml
						el = innerDialog.getChild( 4 );
						el.setStyle( 'height', ( height + body.getChild(0).$.offsetHeight ) + 'px' );

						// mr
						el = innerDialog.getChild( 5 );
						el.setStyle( 'height', ( height + body.getChild(0).$.offsetHeight ) + 'px' );
					};
				setTimeout( fixSize, 100 );

				// Ensure size is correct for RTL mode. (#4003)
				if ( evt.editor.lang.dir == 'rtl' )
					setTimeout( fixSize, 1000 );
			});
	}
})();
