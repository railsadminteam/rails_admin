﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @stylesheetParser plugin.
 */

(function()
{
	// We want to extract only the elements with classes defined in the stylesheets:
	function parseClasses( aRules, skipSelectors, validSelectors )
	{
		// aRules are just the different rules in the style sheets
		// We want to merge them and them split them by commas, so we end up with only
		// the selectors
		var s = aRules.join(' ');
		// Remove selectors splitting the elements, leave only the class selector (.)
		s = s.replace( /(,|>|\+|~)/g, ' ' );
		// Remove attribute selectors: table[border="0"]
		s = s.replace( /\[[^\]]*/g, '' );
		// Remove Ids: div#main
		s = s.replace( /#[^\s]*/g, '' );
		// Remove pseudo-selectors and pseudo-elements: :hover :nth-child(2n+1) ::before
		s = s.replace( /\:{1,2}[^\s]*/g, '' );

		s = s.replace( /\s+/g, ' ' );

		var aSelectors = s.split( ' ' ),
			aClasses = [];

		for ( var i = 0; i < aSelectors.length ; i++ )
		{
			var selector = aSelectors[ i ];

			if ( validSelectors.test( selector ) && !skipSelectors.test( selector ) )
			{
				// If we still don't know about this one, add it
				if ( CKEDITOR.tools.indexOf( aClasses, selector ) == -1 )
					aClasses.push( selector );
			}
		}

		return aClasses;
	}

	function LoadStylesCSS( theDoc, skipSelectors, validSelectors )
	{
		var styles = [],
			// It will hold all the rules of the applied stylesheets (except those internal to CKEditor)
			aRules = [],
			i;

		for ( i = 0; i < theDoc.styleSheets.length; i++ )
		{
			var sheet = theDoc.styleSheets[ i ],
				node = sheet.ownerNode || sheet.owningElement;

			// Skip the internal stylesheets
			if ( node.getAttribute( 'data-cke-temp' ) )
				continue;

			// Exclude stylesheets injected by extensions
			if ( sheet.href && sheet.href.substr(0, 9) == 'chrome://' )
				continue;

			var sheetRules = sheet.cssRules || sheet.rules;
			for ( var j = 0; j < sheetRules.length; j++ )
				aRules.push( sheetRules[ j ].selectorText );
		}

		var aClasses = parseClasses( aRules, skipSelectors, validSelectors );

		// Add each style to our "Styles" collection.
		for ( i = 0; i < aClasses.length; i++ )
		{
			var oElement = aClasses[ i ].split( '.' ),
				element = oElement[ 0 ].toLowerCase(),
				sClassName = oElement[ 1 ];

			styles.push( {
				name : element + '.' + sClassName,
				element : element,
				attributes : {'class' : sClassName}
			});
		}

		return styles;
	}

	// Register a plugin named "stylesheetparser".
	CKEDITOR.plugins.add( 'stylesheetparser',
	{
		requires: [ 'styles' ],
		onLoad : function()
		{
			var obj = CKEDITOR.editor.prototype;
			obj.getStylesSet = CKEDITOR.tools.override( obj.getStylesSet,  function( org )
			{
				return function( callback )
				{
					var self = this;
					org.call( this, function( definitions )
					{
						// Rules that must be skipped
						var skipSelectors = self.config.stylesheetParser_skipSelectors || ( /(^body\.|^\.)/i ),
							// Rules that are valid
							validSelectors = self.config.stylesheetParser_validSelectors || ( /\w+\.\w+/ );

						callback( ( self._.stylesDefinitions = definitions.concat( LoadStylesCSS( self.document.$, skipSelectors, validSelectors ) ) ) );
					});
				};
			});

		}
	});
})();


/**
 * Regular Expression to check if a css rule must be skipped by
 * the stylesheet parser plugin (so it's ignored and not available)
 * @name CKEDITOR.config.stylesheetParser_skipSelectors
 * @type RegExp
 * @default /(^body\.|^\.)/i
 * @since 3.6
 * @example
 * // Ignore rules for body, caption, only a class or classes starting with "high".
 * config.stylesheetParser_skipSelectors = /(^body\.|^caption\.|\.high|^\.)/i;
 */

 /**
 * Regular Expression to check if a css rule must be allowed by
 * the stylesheet parser plugin
 * @name CKEDITOR.config.stylesheetParser_validSelectors
 * @type RegExp
 * @default /\w+\.\w+/
 * @since 3.6
 * @example
 * // Add only rules for p and span elements.
 * config.stylesheetParser_validSelectors = /\^(p|span)\.\w+/;
 */
