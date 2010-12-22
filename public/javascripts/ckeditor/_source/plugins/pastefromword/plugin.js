/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
(function()
{
	CKEDITOR.plugins.add( 'pastefromword',
	{
		init : function( editor )
		{

			// Flag indicate this command is actually been asked instead of a generic
			// pasting.
			var forceFromWord = 0;
			var resetFromWord = function()
				{
					setTimeout( function() { forceFromWord = 0; }, 0 );
				};

			// Features bring by this command beside the normal process:
			// 1. No more bothering of user about the clean-up.
			// 2. Perform the clean-up even if content is not from MS-Word.
			// (e.g. from a MS-Word similar application.)
			editor.addCommand( 'pastefromword',
			{
				canUndo : false,
				exec : function()
				{
					forceFromWord = 1;
					if ( editor.execCommand( 'paste' ) === false )
					{
						editor.on( 'dialogHide', function ( evt )
							{
								evt.removeListener();
								resetFromWord();
							});
					}
					else
						resetFromWord();
				}
			});

			// Register the toolbar button.
			editor.ui.addButton( 'PasteFromWord',
				{
					label : editor.lang.pastefromword.toolbar,
					command : 'pastefromword'
				});

			editor.on( 'paste', function( evt )
			{
				var data = evt.data,
					mswordHtml;

				// MS-WORD format sniffing.
				if ( ( mswordHtml = data[ 'html' ] )
					 && ( forceFromWord || ( /(class=\"?Mso|style=\"[^\"]*\bmso\-|w:WordDocument)/ ).test( mswordHtml ) ) )
				{
					var isLazyLoad = this.loadFilterRules( function()
						{
							// Event continuation with the original data.
							if ( isLazyLoad )
								editor.fire( 'paste', data );
							else if ( !editor.config.pasteFromWordPromptCleanup
							  || ( forceFromWord || confirm( editor.lang.pastefromword.confirmCleanup ) ) )
							 {
								data[ 'html' ] = CKEDITOR.cleanWord( mswordHtml, editor );
							}
						});

					// The cleanup rules are to be loaded, we should just cancel
					// this event.
					isLazyLoad && evt.cancel();
				}
			}, this );
		},

		loadFilterRules : function( callback )
		{

			var isLoaded = CKEDITOR.cleanWord;

			if ( isLoaded )
				callback();
			else
			{
				var filterFilePath = CKEDITOR.getUrl(
						CKEDITOR.config.pasteFromWordCleanupFile
						|| ( this.path + 'filter/default.js' ) );

				// Load with busy indicator.
				CKEDITOR.scriptLoader.load( filterFilePath, callback, null, false, true );
			}

			return !isLoaded;
		}
	});
})();

/**
 * Whether to prompt the user about the clean up of content being pasted from
 * MS Word.
 * @name CKEDITOR.config.pasteFromWordPromptCleanup
 * @since 3.1
 * @type Boolean
 * @default undefined
 * @example
 * config.pasteFromWordPromptCleanup = true;
 */

/**
 * The file that provides the MS Word cleanup function for pasting operations.
 * Note: This is a global configuration shared by all editor instances present
 * in the page.
 * @name CKEDITOR.config.pasteFromWordCleanupFile
 * @since 3.1
 * @type String
 * @default 'default'
 * @example
 * // Load from 'pastefromword' plugin 'filter' sub folder (custom.js file).
 * CKEDITOR.config.pasteFromWordCleanupFile = 'custom';
 */
