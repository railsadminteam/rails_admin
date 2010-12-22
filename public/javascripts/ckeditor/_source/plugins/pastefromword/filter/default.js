/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	var fragmentPrototype = CKEDITOR.htmlParser.fragment.prototype,
		elementPrototype = CKEDITOR.htmlParser.element.prototype;

	fragmentPrototype.onlyChild = elementPrototype.onlyChild = function()
	{
		var children = this.children,
			count = children.length,
			firstChild = ( count == 1 ) && children[ 0 ];
		return firstChild || null;
	};

	elementPrototype.removeAnyChildWithName = function( tagName )
	{
		var children = this.children,
			childs = [],
			child;

		for ( var i = 0; i < children.length; i++ )
		{
			child = children[ i ];
			if ( !child.name )
				continue;

			if ( child.name == tagName )
			{
				childs.push( child );
				children.splice( i--, 1 );
			}
			childs = childs.concat( child.removeAnyChildWithName( tagName ) );
		}
		return childs;
	};

	elementPrototype.getAncestor = function( tagNameRegex )
	{
		var parent = this.parent;
		while ( parent && !( parent.name && parent.name.match( tagNameRegex ) ) )
			parent = parent.parent;
		return parent;
	};

	fragmentPrototype.firstChild = elementPrototype.firstChild = function( evaluator )
	{
		var child;

		for ( var i = 0 ; i < this.children.length ; i++ )
		{
			child = this.children[ i ];
			if ( evaluator( child ) )
				return child;
			else if ( child.name )
			{
				child = child.firstChild( evaluator );
				if ( child )
					return child;
			}
		}

		return null;
	};

	// Adding a (set) of styles to the element's 'style' attributes.
	elementPrototype.addStyle = function( name, value, isPrepend )
	{
		var styleText, addingStyleText = '';
		// name/value pair.
		if ( typeof value == 'string' )
			addingStyleText += name + ':' + value + ';';
		else
		{
			// style literal.
			if ( typeof name == 'object' )
			{
				for ( var style in name )
				{
					if ( name.hasOwnProperty( style ) )
						addingStyleText += style + ':' + name[ style ] + ';';
				}
			}
			// raw style text form.
			else
				addingStyleText += name;

			isPrepend = value;
		}

		if ( !this.attributes )
			this.attributes = {};

		styleText = this.attributes.style || '';

		styleText = ( isPrepend ?
		              [ addingStyleText, styleText ]
					  : [ styleText, addingStyleText ] ).join( ';' );

		this.attributes.style = styleText.replace( /^;|;(?=;)/, '' );
	};

	/**
	 * Return the DTD-valid parent tag names of the specified one.
	 * @param tagName
	 */
	CKEDITOR.dtd.parentOf = function( tagName )
	{
		var result = {};
		for ( var tag in this )
		{
			if ( tag.indexOf( '$' ) == -1 && this[ tag ][ tagName ] )
				result[ tag ] = 1;
		}
		return result;
	};

	var cssLengthRelativeUnit = /^([.\d]*)+(em|ex|px|gd|rem|vw|vh|vm|ch|mm|cm|in|pt|pc|deg|rad|ms|s|hz|khz){1}?/i;
	var emptyMarginRegex = /^(?:\b0[^\s]*\s*){1,4}$/;		// e.g. 0px 0pt 0px
	var romanLiternalPattern = '^m{0,4}(cm|cd|d?c{0,3})(xc|xl|l?x{0,3})(ix|iv|v?i{0,3})$',
		lowerRomanLiteralRegex = new RegExp( romanLiternalPattern ),
		upperRomanLiteralRegex = new RegExp( romanLiternalPattern.toUpperCase() );

	var listBaseIndent = 0,
		 previousListItemMargin;

	CKEDITOR.plugins.pastefromword =
	{
		utils :
		{
			// Create a <cke:listbullet> which indicate an list item type.
			createListBulletMarker : function ( bulletStyle, bulletText )
			{
				var marker = new CKEDITOR.htmlParser.element( 'cke:listbullet' ),
					listType;

				// TODO: Support more list style type from MS-Word.
				if ( !bulletStyle )
				{
					bulletStyle = 'decimal';
					listType = 'ol';
				}
				else if ( bulletStyle[ 2 ] )
				{
					if ( !isNaN( bulletStyle[ 1 ] ) )
						bulletStyle = 'decimal';
					else if ( lowerRomanLiteralRegex.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'lower-roman';
					else if ( upperRomanLiteralRegex.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'upper-roman';
					else if ( /^[a-z]+$/.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'lower-alpha';
					else if ( /^[A-Z]+$/.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'upper-alpha';
					// Simply use decimal for the rest forms of unrepresentable
					// numerals, e.g. Chinese...
					else
						bulletStyle = 'decimal';

					listType = 'ol';
				}
				else
				{
					if ( /[l\u00B7\u2002]/.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'disc';
					else if ( /[\u006F\u00D8]/.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'circle';
					else if ( /[\u006E\u25C6]/.test( bulletStyle[ 1 ] ) )
						bulletStyle = 'square';
					else
						bulletStyle = 'disc';

					listType = 'ul';
				}

				// Represent list type as CSS style.
				marker.attributes =
				{
					'cke:listtype' : listType,
					'style' : 'list-style-type:' + bulletStyle + ';'
				};
				marker.add( new CKEDITOR.htmlParser.text( bulletText ) );
				return marker;
			},

			isListBulletIndicator : function( element )
			{
				var styleText = element.attributes && element.attributes.style;
				if ( /mso-list\s*:\s*Ignore/i.test( styleText ) )
					return true;
			},

			isContainingOnlySpaces : function( element )
			{
				var text;
				return ( ( text = element.onlyChild() )
					    && ( /^(:?\s|&nbsp;)+$/ ).test( text.value ) );
			},

			resolveList : function( element )
			{
				// <cke:listbullet> indicate a list item.
				var attrs = element.attributes,
					listMarker;

				if ( ( listMarker = element.removeAnyChildWithName( 'cke:listbullet' ) )
					  && listMarker.length
					  && ( listMarker = listMarker[ 0 ] ) )
				{
					element.name = 'cke:li';

					if ( attrs.style )
					{
						attrs.style = CKEDITOR.plugins.pastefromword.filters.stylesFilter(
								[
									// Text-indent is not representing list item level any more.
									[ 'text-indent' ],
									[ 'line-height' ],
									// Resolve indent level from 'margin-left' value.
									[ ( /^margin(:?-left)?$/ ), null, function( margin )
									{
										// Be able to deal with component/short-hand form style.
										var values = margin.split( ' ' );
										margin = CKEDITOR.plugins.pastefromword.utils.convertToPx( values[ 3 ] || values[ 1 ] || values [ 0 ] );
										margin = parseInt( margin, 10 );

										// Figure out the indent unit by looking at the first increament.
										if ( !listBaseIndent && previousListItemMargin && margin > previousListItemMargin )
											listBaseIndent = margin - previousListItemMargin;

										attrs[ 'cke:margin' ] = previousListItemMargin = margin;
									} ]
							] )( attrs.style, element ) || '' ;
					}

					// Inherit list-type-style from bullet.
					var listBulletAttrs = listMarker.attributes,
						listBulletStyle = listBulletAttrs.style;

					element.addStyle( listBulletStyle );
					CKEDITOR.tools.extend( attrs, listBulletAttrs );
					return true;
				}

				return false;
			},

			// Convert various length units to 'px' in ignorance of DPI.
			convertToPx : ( function ()
			{
				var calculator = CKEDITOR.dom.element.createFromHtml(
								'<div style="position:absolute;left:-9999px;' +
								'top:-9999px;margin:0px;padding:0px;border:0px;"' +
								'></div>', CKEDITOR.document );
				CKEDITOR.document.getBody().append( calculator );

				return function( cssLength )
				{
					if ( cssLengthRelativeUnit.test( cssLength ) )
					{
						calculator.setStyle( 'width', cssLength );
						return calculator.$.clientWidth + 'px';
					}

					return cssLength;
				};
			} )(),

			// Providing a shorthand style then retrieve one or more style component values.
			getStyleComponents : ( function()
			{
				var calculator = CKEDITOR.dom.element.createFromHtml(
								'<div style="position:absolute;left:-9999px;top:-9999px;"></div>',
								CKEDITOR.document );
				CKEDITOR.document.getBody().append( calculator );

				return function( name, styleValue, fetchList )
				{
					calculator.setStyle( name, styleValue );
					var styles = {},
						count = fetchList.length;
					for ( var i = 0; i < count; i++ )
						styles[ fetchList[ i ] ]  = calculator.getStyle( fetchList[ i ] );

					return styles;
				};
			} )(),

			listDtdParents : CKEDITOR.dtd.parentOf( 'ol' )
		},

		filters :
		{
				// Transform a normal list into flat list items only presentation.
				// E.g. <ul><li>level1<ol><li>level2</li></ol></li> =>
				// <cke:li cke:listtype="ul" cke:indent="1">level1</cke:li>
				// <cke:li cke:listtype="ol" cke:indent="2">level2</cke:li>
				flattenList : function( element )
				{
					var	attrs = element.attributes,
						parent = element.parent;

					var listStyleType,
						indentLevel = 1;

					// Resolve how many level nested.
					while ( parent )
					{
						parent.attributes && parent.attributes[ 'cke:list'] && indentLevel++;
						parent = parent.parent;
					}

					// All list items are of the same type.
					switch ( attrs.type )
					{
						case 'a' :
							listStyleType = 'lower-alpha';
							break;
						// TODO: Support more list style type from MS-Word.
					}

					var children = element.children,
						child;

					for ( var i = 0; i < children.length; i++ )
					{
						child = children[ i ];
						var attributes = child.attributes;

						if ( child.name in CKEDITOR.dtd.$listItem )
						{
							var listItemChildren = child.children,
								count = listItemChildren.length,
								last = listItemChildren[ count - 1 ];

							// Move out nested list.
							if ( last.name in CKEDITOR.dtd.$list )
							{
								children.splice( i + 1, 0, last );
								last.parent = element;

								// Remove the parent list item if it's just a holder.
								if ( !--listItemChildren.length )
									children.splice( i, 1 );
							}

							child.name = 'cke:li';
							attributes[ 'cke:indent' ] = indentLevel;
							previousListItemMargin = 0;
							attributes[ 'cke:listtype' ] = element.name;
							listStyleType && child.addStyle( 'list-style-type', listStyleType, true );
						}
					}

					delete element.name;

					// We're loosing tag name here, signalize this element as a list.
					attrs[ 'cke:list' ] = 1;
				},

				/**
				 *  Try to collect all list items among the children and establish one
				 *  or more HTML list structures for them.
				 * @param element
				 */
				assembleList : function( element )
				{
					var children = element.children, child,
							listItem,   // The current processing cke:li element.
							listItemAttrs,
							listType,   // Determine the root type of the list.
							listItemIndent, // Indent level of current list item.
							lastListItem, // The previous one just been added to the list.
							list, parentList, // Current staging list and it's parent list if any.
							indent;

					for ( var i = 0; i < children.length; i++ )
					{
						child = children[ i ];

						if ( 'cke:li' == child.name )
						{
							child.name = 'li';
							listItem = child;
							listItemAttrs = listItem.attributes;
							listType = listItem.attributes[ 'cke:listtype' ];

							// List item indent level might come from a real list indentation or
							// been resolved from a pseudo list item's margin value, even get
							// no indentation at all.
							listItemIndent = parseInt( listItemAttrs[ 'cke:indent' ], 10 )
													|| listBaseIndent && ( Math.ceil( listItemAttrs[ 'cke:margin' ] / listBaseIndent ) )
													|| 1;

							// Ignore the 'list-style-type' attribute if it's matched with
							// the list root element's default style type.
							listItemAttrs.style && ( listItemAttrs.style =
							        CKEDITOR.plugins.pastefromword.filters.stylesFilter(
									[
										[ 'list-style-type', listType == 'ol' ? 'decimal' : 'disc' ]
									] )( listItemAttrs.style )
									|| '' );

							if ( !list )
							{
								list = new CKEDITOR.htmlParser.element( listType );
								list.add( listItem );
								children[ i ] = list;
							}
							else
							{
								if ( listItemIndent > indent )
								{
									list = new CKEDITOR.htmlParser.element( listType );
									list.add( listItem );
									lastListItem.add( list );
								}
								else if ( listItemIndent < indent )
								{
									// There might be a negative gap between two list levels. (#4944)
									var diff = indent - listItemIndent,
										parent;
									while ( diff-- && ( parent = list.parent ) )
										list = parent.parent;

									list.add( listItem );
								}
								else
									list.add( listItem );

								children.splice( i--, 1 );
							}

							lastListItem = listItem;
							indent = listItemIndent;
						}
						else
							list = null;
					}

					listBaseIndent = 0;
				},

				/**
				 * A simple filter which always rejecting.
				 */
				falsyFilter : function( value )
				{
					return false;
				},

				/**
				 * A filter dedicated on the 'style' attribute filtering, e.g. dropping/replacing style properties.
				 * @param styles {Array} in form of [ styleNameRegexp, styleValueRegexp,
				 *  newStyleValue/newStyleGenerator, newStyleName ] where only the first
				 *  parameter is mandatory.
				 * @param whitelist {Boolean} Whether the {@param styles} will be considered as a white-list.
				 */
				stylesFilter : function( styles, whitelist )
				{
					return function( styleText, element )
					{
						 var rules = [];
						// html-encoded quote might be introduced by 'font-family'
						// from MS-Word which confused the following regexp. e.g.
						//'font-family: &quot;Lucida, Console&quot;'
						 styleText
							.replace( /&quot;/g, '"' )
							.replace( /\s*([^ :;]+)\s*:\s*([^;]+)\s*(?=;|$)/g,
								 function( match, name, value )
								 {
									 name = name.toLowerCase();
									 name == 'font-family' && ( value = value.replace( /["']/g, '' ) );

									 var namePattern,
										 valuePattern,
										 newValue,
										 newName;
									 for ( var i = 0 ; i < styles.length; i++ )
									 {
										if ( styles[ i ] )
										{
											namePattern = styles[ i ][ 0 ];
											valuePattern = styles[ i ][ 1 ];
											newValue = styles[ i ][ 2 ];
											newName = styles[ i ][ 3 ];

											if ( name.match( namePattern )
												 && ( !valuePattern || value.match( valuePattern ) ) )
											{
												name = newName || name;
												whitelist && ( newValue = newValue || value );

												if ( typeof newValue == 'function' )
													newValue = newValue( value, element, name );

												// Return an couple indicate both name and value
												// changed.
												if ( newValue && newValue.push )
													name = newValue[ 0 ], newValue = newValue[ 1 ];

												if ( typeof newValue == 'string' )
													rules.push( [ name, newValue ] );
												return;
											}
										}
									 }

									 !whitelist && rules.push( [ name, value ] );

								 });

						for ( var i = 0 ; i < rules.length ; i++ )
							 rules[ i ] = rules[ i ].join( ':' );
						return rules.length ?
						         ( rules.join( ';' ) + ';' ) : false;
					 };
				},

				/**
				 * Migrate the element by decorate styles on it.
				 * @param styleDefiniton
				 * @param variables
				 */
				elementMigrateFilter : function ( styleDefiniton, variables )
				{
					return function( element )
						{
							var styleDef =
									variables ?
										new CKEDITOR.style( styleDefiniton, variables )._.definition
										: styleDefiniton;
							element.name = styleDef.element;
							CKEDITOR.tools.extend( element.attributes, CKEDITOR.tools.clone( styleDef.attributes ) );
							element.addStyle( CKEDITOR.style.getStyleText( styleDef ) );
						};
				},

				/**
				 * Migrate styles by creating a new nested stylish element.
				 * @param styleDefinition
				 */
				styleMigrateFilter : function( styleDefinition, variableName )
				{

					var elementMigrateFilter = this.elementMigrateFilter;
					return function( value, element )
					{
						// Build an stylish element first.
						var styleElement = new CKEDITOR.htmlParser.element( null ),
							variables = {};

						variables[ variableName ] = value;
						elementMigrateFilter( styleDefinition, variables )( styleElement );
						// Place the new element inside the existing span.
						styleElement.children = element.children;
						element.children = [ styleElement ];
					};
				},

				/**
				 * A filter which remove cke-namespaced-attribute on
				 * all none-cke-namespaced elements.
				 * @param value
				 * @param element
				 */
				bogusAttrFilter : function( value, element )
				{
					if ( element.name.indexOf( 'cke:' ) == -1 )
						return false;
				},

				/**
				 * A filter which will be used to apply inline css style according the stylesheet
				 * definition rules, is generated lazily when filtering.
				 */
				applyStyleFilter : null

			},

		getRules : function( editor )
		{
			var dtd = CKEDITOR.dtd,
				blockLike = CKEDITOR.tools.extend( {}, dtd.$block, dtd.$listItem, dtd.$tableContent ),
				config = editor.config,
				filters = this.filters,
				falsyFilter = filters.falsyFilter,
				stylesFilter = filters.stylesFilter,
				elementMigrateFilter = filters.elementMigrateFilter,
				styleMigrateFilter = CKEDITOR.tools.bind( this.filters.styleMigrateFilter, this.filters ),
				createListBulletMarker = this.utils.createListBulletMarker,
				flattenList = filters.flattenList,
				assembleList = filters.assembleList,
				isListBulletIndicator = this.utils.isListBulletIndicator,
				containsNothingButSpaces = this.utils.isContainingOnlySpaces,
				resolveListItem = this.utils.resolveList,
				convertToPx = this.utils.convertToPx,
				getStyleComponents = this.utils.getStyleComponents,
				listDtdParents = this.utils.listDtdParents,
				removeFontStyles = config.pasteFromWordRemoveFontStyles !== false,
				removeStyles = config.pasteFromWordRemoveStyles !== false;

			return {

				elementNames :
				[
					// Remove script, meta and link elements.
					[ ( /meta|link|script/ ), '' ]
				],

				root : function( element )
				{
					element.filterChildren();
					assembleList( element );
				},

				elements :
				{
					'^' : function( element )
					{
						// Transform CSS style declaration to inline style.
						var applyStyleFilter;
						if ( CKEDITOR.env.gecko && ( applyStyleFilter = filters.applyStyleFilter ) )
							applyStyleFilter( element );
					},

					$ : function( element )
					{
						var tagName = element.name || '',
							attrs = element.attributes;

						// Convert length unit of width/height on blocks to
						// a more editor-friendly way (px).
						if ( tagName in blockLike
							&& attrs.style )
						{
							attrs.style = stylesFilter(
										[ [ ( /^(:?width|height)$/ ), null, convertToPx ] ] )( attrs.style ) || '';
						}

						// Processing headings.
						if ( tagName.match( /h\d/ ) )
						{
							element.filterChildren();
							// Is the heading actually a list item?
							if ( resolveListItem( element ) )
								return;

							// Adapt heading styles to editor's convention.
							elementMigrateFilter( config[ 'format_' + tagName ] )( element );
						}
						// Remove inline elements which contain only empty spaces.
						else if ( tagName in dtd.$inline )
						{
							element.filterChildren();
							if ( containsNothingButSpaces( element ) )
								delete element.name;
						}
						// Remove element with ms-office namespace,
						// with it's content preserved, e.g. 'o:p'.
						else if ( tagName.indexOf( ':' ) != -1
								 && tagName.indexOf( 'cke' ) == -1 )
						{
							element.filterChildren();

							// Restore image real link from vml.
							if ( tagName == 'v:imagedata' )
							{
								var href = element.attributes[ 'o:href' ];
								if ( href )
									element.attributes.src = href;
								element.name = 'img';
								return;
							}
							delete element.name;
						}

						// Assembling list items into a whole list.
						if ( tagName in listDtdParents )
						{
							element.filterChildren();
							assembleList( element );
						}
					},

					// We'll drop any style sheet, but Firefox conclude
					// certain styles in a single style element, which are
					// required to be changed into inline ones.
					'style' : function( element )
					{
						if ( CKEDITOR.env.gecko )
						{
							// Grab only the style definition section.
							var styleDefSection = element.onlyChild().value.match( /\/\* Style Definitions \*\/([\s\S]*?)\/\*/ ),
								styleDefText = styleDefSection && styleDefSection[ 1 ],
								rules = {}; // Storing the parsed result.

							if ( styleDefText )
							{
								styleDefText
									// Remove line-breaks.
									.replace(/[\n\r]/g,'')
									// Extract selectors and style properties.
									.replace( /(.+?)\{(.+?)\}/g,
										function( rule, selectors, styleBlock )
										{
											selectors = selectors.split( ',' );
											var length = selectors.length, selector;
											for ( var i = 0; i < length; i++ )
											{
												// Assume MS-Word mostly generate only simple
												// selector( [Type selector][Class selector]).
												CKEDITOR.tools.trim( selectors[ i ] )
															  .replace( /^(\w+)(\.[\w-]+)?$/g,
												function( match, tagName, className )
												{
													tagName = tagName || '*';
													className = className.substring( 1, className.length );

													// Reject MS-Word Normal styles.
													if ( className.match( /MsoNormal/ ) )
														return;

													if ( !rules[ tagName ] )
														rules[ tagName ] = {};
													if ( className )
														rules[ tagName ][ className ] = styleBlock;
													else
														rules[ tagName ] = styleBlock;
												} );
											}
										});

								filters.applyStyleFilter = function( element )
								{
									var name = rules[ '*' ] ? '*' : element.name,
										className = element.attributes && element.attributes[ 'class' ],
										style;
									if ( name in rules )
									{
										style = rules[ name ];
										if ( typeof style == 'object' )
											style = style[ className ];
										// Maintain style rules priorities.
										style && element.addStyle( style, true );
									}
								};
							}
						}
						return false;
					},

					'p' : function( element )
					{
						element.filterChildren();

						// Is the paragraph actually a list item?
						if ( resolveListItem( element ) )
							return;

						// Adapt paragraph formatting to editor's convention
						// according to enter-mode.
						if ( config.enterMode == CKEDITOR.ENTER_BR )
						{
							// We suffer from attribute/style lost in this situation.
							delete element.name;
							element.add( new CKEDITOR.htmlParser.element( 'br' ) );
						}
						else
							elementMigrateFilter( config[ 'format_' + ( config.enterMode == CKEDITOR.ENTER_P ? 'p' : 'div' ) ] )( element );
					},

					'div' : function( element )
					{
						// Aligned table with no text surrounded is represented by a wrapper div, from which
						// table cells inherit as text-align styles, which is wrong.
						// Instead we use a clear-float div after the table to properly achieve the same layout.
						var singleChild = element.onlyChild();
						if ( singleChild && singleChild.name == 'table' )
						{
							var attrs = element.attributes;
							singleChild.attributes = CKEDITOR.tools.extend( singleChild.attributes, attrs );
							attrs.style && singleChild.addStyle( attrs.style );

							var clearFloatDiv = new CKEDITOR.htmlParser.element( 'div' );
							clearFloatDiv.addStyle( 'clear' ,'both' );
							element.add( clearFloatDiv );
							delete element.name;
						}
					},

					'td' : function ( element )
					{
						// 'td' in 'thead' is actually <th>.
						if ( element.getAncestor( 'thead') )
							element.name = 'th';
					},

					// MS-Word sometimes present list as a mixing of normal list
					// and pseudo-list, normalize the previous ones into pseudo form.
					'ol' : flattenList,
					'ul' : flattenList,
					'dl' : flattenList,

					'font' : function( element )
					{
						// IE/Safari: drop the font tag if it comes from list bullet text.
						if ( !CKEDITOR.env.gecko && isListBulletIndicator( element.parent ) )
						{
							delete element.name;
							return;
						}

						element.filterChildren();

						var attrs = element.attributes,
							styleText = attrs.style,
							parent = element.parent;

						if ( 'font' == parent.name )     // Merge nested <font> tags.
						{
							CKEDITOR.tools.extend( parent.attributes,
									element.attributes );
							styleText && parent.addStyle( styleText );
							delete element.name;
						}
						// Convert the merged into a span with all attributes preserved.
						else
						{
							styleText = styleText || '';
							// IE's having those deprecated attributes, normalize them.
							if ( attrs.color )
							{
								attrs.color != '#000000' && ( styleText += 'color:' + attrs.color + ';' );
								delete attrs.color;
							}
							if ( attrs.face )
							{
								styleText += 'font-family:' + attrs.face + ';';
								delete attrs.face;
							}
							// TODO: Mapping size in ranges of xx-small,
							// x-small, small, medium, large, x-large, xx-large.
							if ( attrs.size )
							{
								styleText += 'font-size:' +
								             ( attrs.size > 3 ? 'large'
										             : ( attrs.size < 3 ? 'small' : 'medium' ) ) + ';';
								delete attrs.size;
							}

							element.name = 'span';
							element.addStyle( styleText );
						}
					},

					'span' : function( element )
					{
						// IE/Safari: remove the span if it comes from list bullet text.
						if ( !CKEDITOR.env.gecko && isListBulletIndicator( element.parent ) )
							return false;

						element.filterChildren();
						if ( containsNothingButSpaces( element ) )
						{
							delete element.name;
							return null;
						}

						// For IE/Safari: List item bullet type is supposed to be indicated by
						// the text of a span with style 'mso-list : Ignore' or an image.
						if ( !CKEDITOR.env.gecko && isListBulletIndicator( element ) )
						{
							var listSymbolNode = element.firstChild( function( node )
							{
								return node.value || node.name == 'img';
							});

							var listSymbol =  listSymbolNode && ( listSymbolNode.value || 'l.' ),
								listType = listSymbol.match( /^([^\s]+?)([.)]?)$/ );
							return createListBulletMarker( listType, listSymbol );
						}

						// Update the src attribute of image element with href.
						var children = element.children,
							attrs = element.attributes,
							styleText = attrs && attrs.style,
							firstChild = children && children[ 0 ];

						// Assume MS-Word mostly carry font related styles on <span>,
						// adapting them to editor's convention.
						if ( styleText )
						{
							attrs.style = stylesFilter(
									[
										// Drop 'inline-height' style which make lines overlapping.
										[ 'line-height' ],
										[ ( /^font-family$/ ), null, !removeFontStyles ? styleMigrateFilter( config[ 'font_style' ], 'family' ) : null ] ,
										[ ( /^font-size$/ ), null, !removeFontStyles ? styleMigrateFilter( config[ 'fontSize_style' ], 'size' ) : null ] ,
										[ ( /^color$/ ), null, !removeFontStyles ? styleMigrateFilter( config[ 'colorButton_foreStyle' ], 'color' ) : null ] ,
										[ ( /^background-color$/ ), null, !removeFontStyles ? styleMigrateFilter( config[ 'colorButton_backStyle' ], 'color' ) : null ]
									] )( styleText, element ) || '';
						}

						return null;
					},

					// Migrate basic style formats to editor configured ones.
					'b' : elementMigrateFilter( config[ 'coreStyles_bold' ] ),
					'i' : elementMigrateFilter( config[ 'coreStyles_italic' ] ),
					'u' : elementMigrateFilter( config[ 'coreStyles_underline' ] ),
					's' : elementMigrateFilter( config[ 'coreStyles_strike' ] ),
					'sup' : elementMigrateFilter( config[ 'coreStyles_superscript' ] ),
					'sub' : elementMigrateFilter( config[ 'coreStyles_subscript' ] ),
					// Editor doesn't support anchor with content currently (#3582),
					// drop such anchors with content preserved.
					'a' : function( element )
					{
						var attrs = element.attributes;
						if ( attrs && !attrs.href && attrs.name )
							delete element.name;
					},
					'cke:listbullet' : function( element )
					{
						if ( element.getAncestor( /h\d/ ) && !config.pasteFromWordNumberedHeadingToList )
							delete element.name;
						}
				},

				attributeNames :
				[
					// Remove onmouseover and onmouseout events (from MS Word comments effect)
					[ ( /^onmouse(:?out|over)/ ), '' ],
					// Onload on image element.
					[ ( /^onload$/ ), '' ],
					// Remove office and vml attribute from elements.
					[ ( /(?:v|o):\w+/ ), '' ],
					// Remove lang/language attributes.
					[ ( /^lang/ ), '' ]
				],

				attributes :
				{
					'style' : stylesFilter(
					removeStyles ?
					// Provide a white-list of styles that we preserve, those should
					// be the ones that could later be altered with editor tools.
					[
						// Preserve margin-left/right which used as default indent style in the editor.
						[ ( /^margin$|^margin-(?!bottom|top)/ ), null, function( value, element, name )
							{
								if ( element.name in { p : 1, div : 1 } )
								{
									var indentStyleName = config.contentsLangDirection == 'ltr' ?
											'margin-left' : 'margin-right';

									// Extract component value from 'margin' shorthand.
									if ( name == 'margin' )
									{
										value = getStyleComponents( name, value,
												[ indentStyleName ] )[ indentStyleName ];
									}
									else if ( name != indentStyleName )
										return null;

									if ( value && !emptyMarginRegex.test( value ) )
										return [ indentStyleName, value ];
								}

								return null;
							} ],

						// Preserve clear float style.
						[ ( /^clear$/ ) ],

						[ ( /^border.*|margin.*|vertical-align|float$/ ), null,
							function( value, element )
							{
								if ( element.name == 'img' )
									return value;
							} ],

						[ (/^width|height$/ ), null,
							function( value, element )
							{
								if ( element.name in { table : 1, td : 1, th : 1, img : 1 } )
									return value;
							} ]
					] :
					// Otherwise provide a black-list of styles that we remove.
					[
						[ ( /^mso-/ ) ],
						// Fixing color values.
						[ ( /-color$/ ), null, function( value )
						{
							if ( value == 'transparent' )
								return false;
							if ( CKEDITOR.env.gecko )
								return value.replace( /-moz-use-text-color/g, 'transparent' );
						} ],
						// Remove empty margin values, e.g. 0.00001pt 0em 0pt
						[ ( /^margin$/ ), emptyMarginRegex ],
						[ 'text-indent', '0cm' ],
						[ 'page-break-before' ],
						[ 'tab-stops' ],
						[ 'display', 'none' ],
						removeFontStyles ? [ ( /font-?/ ) ] : null
					], removeStyles ),

					// Prefer width styles over 'width' attributes.
					'width' : function( value, element )
					{
						if ( element.name in dtd.$tableContent )
							return false;
					},
					// Prefer border styles over table 'border' attributes.
					'border' : function( value, element )
					{
						if ( element.name in dtd.$tableContent )
							return false;
					},

					// Only Firefox carry style sheet from MS-Word, which
					// will be applied by us manually. For other browsers
					// the css className is useless.
					'class' : falsyFilter,

					// MS-Word always generate 'background-color' along with 'bgcolor',
					// simply drop the deprecated attributes.
					'bgcolor' : falsyFilter,

					// Deprecate 'valign' attribute in favor of 'vertical-align'.
					'valign' : removeStyles ? falsyFilter : function( value, element )
					{
						element.addStyle( 'vertical-align', value );
						return false;
					}
				},

				// Fore none-IE, some useful data might be buried under these IE-conditional
				// comments where RegExp were the right approach to dig them out where usual approach
				// is transform it into a fake element node which hold the desired data.
				comment :
					!CKEDITOR.env.ie ?
						function( value, node )
						{
							var imageInfo = value.match( /<img.*?>/ ),
								listInfo = value.match( /^\[if !supportLists\]([\s\S]*?)\[endif\]$/ );

							// Seek for list bullet indicator.
							if ( listInfo )
							{
								// Bullet symbol could be either text or an image.
								var listSymbol = listInfo[ 1 ] || ( imageInfo && 'l.' ),
									listType = listSymbol && listSymbol.match( />([^\s]+?)([.)]?)</ );
								return createListBulletMarker( listType, listSymbol );
							}

							// Reveal the <img> element in conditional comments for Firefox.
							if ( CKEDITOR.env.gecko && imageInfo )
							{
								var img = CKEDITOR.htmlParser.fragment.fromHtml( imageInfo[ 0 ] ).children[ 0 ],
									previousComment = node.previous,
									// Try to dig the real image link from vml markup from previous comment text.
									imgSrcInfo = previousComment && previousComment.value.match( /<v:imagedata[^>]*o:href=['"](.*?)['"]/ ),
									imgSrc = imgSrcInfo && imgSrcInfo[ 1 ];

								// Is there a real 'src' url to be used?
								imgSrc && ( img.attributes.src = imgSrc );
								return img;
							}

							return false;
						}
					: falsyFilter
			};
		}
	};

	// The paste processor here is just a reduced copy of html data processor.
	var pasteProcessor = function()
	{
		this.dataFilter = new CKEDITOR.htmlParser.filter();
	};

	pasteProcessor.prototype =
	{
		toHtml : function( data )
		{
			var fragment = CKEDITOR.htmlParser.fragment.fromHtml( data, false ),
				writer = new CKEDITOR.htmlParser.basicWriter();

			fragment.writeHtml( writer, this.dataFilter );
			return writer.getHtml( true );
		}
	};

	CKEDITOR.cleanWord = function( data, editor )
	{
		// Firefox will be confused by those downlevel-revealed IE conditional
		// comments, fixing them first( convert it to upperlevel-revealed one ).
		// e.g. <![if !vml]>...<![endif]>
		if ( CKEDITOR.env.gecko )
			data = data.replace( /(<!--\[if[^<]*?\])-->([\S\s]*?)<!--(\[endif\]-->)/gi, '$1$2$3' );

		var dataProcessor = new pasteProcessor(),
			dataFilter = dataProcessor.dataFilter;

		// These rules will have higher priorities than default ones.
		dataFilter.addRules( CKEDITOR.plugins.pastefromword.getRules( editor ) );

		// Allow extending data filter rules.
		editor.fire( 'beforeCleanWord', { filter : dataFilter } );

		try
		{
			data = dataProcessor.toHtml( data, false );
		}
		catch ( e )
		{
			alert( editor.lang.pastefromword.error );
		}

		/* Below post processing those things that are unable to delivered by filter rules. */

		// Remove 'cke' namespaced attribute used in filter rules as marker.
		data = data.replace( /cke:.*?".*?"/g, '' );

		// Remove empty style attribute.
		data = data.replace( /style=""/g, '' );

		// Remove the dummy spans ( having no inline style ).
		data = data.replace( /<span>/g, '' );

		return data;
	};
})();

/**
 * Whether to ignore all font related formatting styles, including:
 * <ul>	<li>font size;</li>
 *		<li>font family;</li>
 *		<li>font foreground/background color.</li></ul>
 * @name CKEDITOR.config.pasteFromWordRemoveFontStyles
 * @since 3.1
 * @type Boolean
 * @default true
 * @example
 * config.pasteFromWordRemoveFontStyles = false;
 */

/**
 * Whether to transform MS Word outline numbered headings into lists.
 * @name CKEDITOR.config.pasteFromWordNumberedHeadingToList
 * @since 3.1
 * @type Boolean
 * @default false
 * @example
 * config.pasteFromWordNumberedHeadingToList = true;
 */

/**
 * Whether to remove element styles that can't be managed with the editor. Note
 * that this doesn't handle the font specific styles, which depends on the
 * {@link CKEDITOR.config.pasteFromWordRemoveFontStyles} setting instead.
 * @name CKEDITOR.config.pasteFromWordRemoveStyles
 * @since 3.1
 * @type Boolean
 * @default true
 * @example
 * config.pasteFromWordRemoveStyles = false;
 */
