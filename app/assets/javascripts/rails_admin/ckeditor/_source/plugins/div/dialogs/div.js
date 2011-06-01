﻿/*
 * Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.html or http://ckeditor.com/license
 */

(function()
{

	/**
	 * Add to collection with DUP examination.
	 * @param {Object} collection
	 * @param {Object} element
	 * @param {Object} database
	 */
	function addSafely( collection, element, database )
	{
		// 1. IE doesn't support customData on text nodes;
		// 2. Text nodes never get chance to appear twice;
		if ( !element.is || !element.getCustomData( 'block_processed' ) )
		{
			element.is && CKEDITOR.dom.element.setMarker( database, element, 'block_processed', true );
			collection.push( element );
		}
	}

	function getNonEmptyChildren( element )
	{
		var retval = [];
		var children = element.getChildren();
		for ( var i = 0 ; i < children.count() ; i++ )
		{
			var child = children.getItem( i );
			if ( ! ( child.type === CKEDITOR.NODE_TEXT
				&& ( /^[ \t\n\r]+$/ ).test( child.getText() ) ) )
				retval.push( child );
		}
		return retval;
	}


	/**
	 * Dialog reused by both 'creatediv' and 'editdiv' commands.
	 * @param {Object} editor
	 * @param {String} command	The command name which indicate what the current command is.
	 */
	function divDialog( editor, command )
	{
		// Definition of elements at which div operation should stopped.
		var divLimitDefinition = ( function(){

			// Customzie from specialize blockLimit elements
			var definition = CKEDITOR.tools.extend( {}, CKEDITOR.dtd.$blockLimit );

			// Exclude 'div' itself.
			delete definition.div;

			// Exclude 'td' and 'th' when 'wrapping table'
			if ( editor.config.div_wrapTable )
			{
				delete definition.td;
				delete definition.th;
			}
			return definition;
		})();

		// DTD of 'div' element
		var dtd = CKEDITOR.dtd.div;

		/**
		 * Get the first div limit element on the element's path.
		 * @param {Object} element
		 */
		function getDivLimitElement( element )
		{
			var pathElements = new CKEDITOR.dom.elementPath( element ).elements;
			var divLimit;
			for ( var i = 0; i < pathElements.length ; i++ )
			{
				if ( pathElements[ i ].getName() in divLimitDefinition )
				{
					divLimit = pathElements[ i ];
					break;
				}
			}
			return divLimit;
		}

		/**
		 * Init all fields' setup/commit function.
		 * @memberof divDialog
		 */
		function setupFields()
		{
			this.foreach( function( field )
			{
				// Exclude layout container elements
				if ( /^(?!vbox|hbox)/.test( field.type ) )
				{
					if ( !field.setup )
					{
						// Read the dialog fields values from the specified
						// element attributes.
						field.setup = function( element )
						{
							field.setValue( element.getAttribute( field.id ) || '' );
						};
					}
					if ( !field.commit )
					{
						// Set element attributes assigned by the dialog
						// fields.
						field.commit = function( element )
						{
							var fieldValue = this.getValue();
							// ignore default element attribute values
							if ( 'dir' == field.id && element.getComputedStyle( 'direction' ) == fieldValue )
								return;

							if ( fieldValue )
								element.setAttribute( field.id, fieldValue );
							else
								element.removeAttribute( field.id );
						};
					}
				}
			} );
		}

		/**
		 * Wrapping 'div' element around appropriate blocks among the selected ranges.
		 * @param {Object} editor
		 */
		function createDiv( editor )
		{
			// new adding containers OR detected pre-existed containers.
			var containers = [];
			// node markers store.
			var database = {};
			// All block level elements which contained by the ranges.
			var containedBlocks = [], block;

			// Get all ranges from the selection.
			var selection = editor.document.getSelection(),
				ranges = selection.getRanges();
			var bookmarks = selection.createBookmarks();
			var i, iterator;

			// Calcualte a default block tag if we need to create blocks.
			var blockTag = editor.config.enterMode == CKEDITOR.ENTER_DIV ? 'div' : 'p';

			// collect all included elements from dom-iterator
			for ( i = 0 ; i < ranges.length ; i++ )
			{
				iterator = ranges[ i ].createIterator();
				while ( ( block = iterator.getNextParagraph() ) )
				{
					// include contents of blockLimit elements.
					if ( block.getName() in divLimitDefinition )
					{
						var j, childNodes = block.getChildren();
						for ( j = 0 ; j < childNodes.count() ; j++ )
							addSafely( containedBlocks, childNodes.getItem( j ) , database );
					}
					else
					{
						// Bypass dtd disallowed elements.
						while ( !dtd[ block.getName() ] && block.getName() != 'body' )
							block = block.getParent();
						addSafely( containedBlocks, block, database );
					}
				}
			}

			CKEDITOR.dom.element.clearAllMarkers( database );

			var blockGroups = groupByDivLimit( containedBlocks );
			var ancestor, blockEl, divElement;

			for ( i = 0 ; i < blockGroups.length ; i++ )
			{
				var currentNode = blockGroups[ i ][ 0 ];

				// Calculate the common parent node of all contained elements.
				ancestor = currentNode.getParent();
				for ( j = 1 ; j < blockGroups[ i ].length; j++ )
					ancestor = ancestor.getCommonAncestor( blockGroups[ i ][ j ] );

				divElement = new CKEDITOR.dom.element( 'div', editor.document );

				// Normalize the blocks in each group to a common parent.
				for ( j = 0; j < blockGroups[ i ].length ; j++ )
				{
					currentNode = blockGroups[ i ][ j ];

					while ( !currentNode.getParent().equals( ancestor ) )
						currentNode = currentNode.getParent();

					// This could introduce some duplicated elements in array.
					blockGroups[ i ][ j ] = currentNode;
				}

				// Wrapped blocks counting
				var fixedBlock = null;
				for ( j = 0 ; j < blockGroups[ i ].length ; j++ )
				{
					currentNode = blockGroups[ i ][ j ];

					// Avoid DUP elements introduced by grouping.
					if ( !( currentNode.getCustomData && currentNode.getCustomData( 'block_processed' ) ) )
					{
						currentNode.is && CKEDITOR.dom.element.setMarker( database, currentNode, 'block_processed', true );

						// Establish new container, wrapping all elements in this group.
						if ( !j )
							divElement.insertBefore( currentNode );

						divElement.append( currentNode );
					}
				}

				CKEDITOR.dom.element.clearAllMarkers( database );
				containers.push( divElement );
			}

			selection.selectBookmarks( bookmarks );
			return containers;
		}

		function getDiv( editor )
		{
			var path = new CKEDITOR.dom.elementPath( editor.getSelection().getStartElement() ),
				blockLimit = path.blockLimit,
				div = blockLimit && blockLimit.getAscendant( 'div', true );
			return div;
		}
		/**
		 * Divide a set of nodes to different groups by their path's blocklimit element.
		 * Note: the specified nodes should be in source order naturally, which mean they are supposed to producea by following class:
		 *  * CKEDITOR.dom.range.Iterator
		 *  * CKEDITOR.dom.domWalker
		 *  @return {Array []} the grouped nodes
		 */
		function groupByDivLimit( nodes )
		{
			var groups = [],
				lastDivLimit = null,
				path, block;
			for ( var i = 0 ; i < nodes.length ; i++ )
			{
				block = nodes[i];
				var limit = getDivLimitElement( block );
				if ( !limit.equals( lastDivLimit ) )
				{
					lastDivLimit = limit ;
					groups.push( [] ) ;
				}
				groups[ groups.length - 1 ].push( block ) ;
			}
			return groups;
		}

		// Synchronous field values to other impacted fields is required, e.g. div styles
		// change should also alter inline-style text.
		function commitInternally( targetFields )
		{
			var dialog = this.getDialog(),
				 element = dialog._element && dialog._element.clone()
						 || new CKEDITOR.dom.element( 'div', editor.document );

			// Commit this field and broadcast to target fields.
			this.commit( element, true );

			targetFields = [].concat( targetFields );
			var length = targetFields.length, field;
			for ( var i = 0; i < length; i++ )
			{
				field = dialog.getContentElement.apply( dialog, targetFields[ i ].split( ':' ) );
				field && field.setup && field.setup( element, true );
			}
		}


		// Registered 'CKEDITOR.style' instances.
		var styles = {} ;
		/**
		 * Hold a collection of created block container elements.
		 */
		var containers = [];
		/**
		 * @type divDialog
		 */
		return {
			title : editor.lang.div.title,
			minWidth : 400,
			minHeight : 165,
			contents :
			[
			{
				id :'info',
				label :editor.lang.common.generalTab,
				title :editor.lang.common.generalTab,
				elements :
				[
					{
						type :'hbox',
						widths : [ '50%', '50%' ],
						children :
						[
							{
								id :'elementStyle',
								type :'select',
								style :'width: 100%;',
								label :editor.lang.div.styleSelectLabel,
								'default' : '',
								// Options are loaded dynamically.
								items :
								[
									[ editor.lang.common.notSet , '' ]
								],
								onChange : function()
								{
									commitInternally.call( this, [ 'info:class', 'advanced:dir', 'advanced:style' ] );
								},
								setup : function( element )
								{
									for ( var name in styles )
										styles[ name ].checkElementRemovable( element, true ) && this.setValue( name );
								},
								commit: function( element )
								{
									var styleName;
									if ( ( styleName = this.getValue() ) )
									{
										var style = styles[ styleName ];
										var customData = element.getCustomData( 'elementStyle' ) || '';

										style.applyToObject( element );
										element.setCustomData( 'elementStyle', customData + style._.definition.attributes.style );
									}
								}
							},
							{
								id :'class',
								type :'text',
								label :editor.lang.common.cssClass,
								'default' : ''
							}
						]
					}
				]
			},
			{
					id :'advanced',
					label :editor.lang.common.advancedTab,
					title :editor.lang.common.advancedTab,
					elements :
					[
					{
						type :'vbox',
						padding :1,
						children :
						[
							{
								type :'hbox',
								widths : [ '50%', '50%' ],
								children :
								[
									{
										type :'text',
										id :'id',
										label :editor.lang.common.id,
										'default' : ''
									},
									{
										type :'text',
										id :'lang',
										label :editor.lang.link.langCode,
										'default' : ''
									}
								]
							},
							{
								type :'hbox',
								children :
								[
										{
											type :'text',
											id :'style',
											style :'width: 100%;',
											label :editor.lang.common.cssStyle,
											'default' : '',
											commit : function( element )
											{
												// Merge with 'elementStyle', which is of higher priority.
												var merged = this.getValue() + ( element.getCustomData( 'elementStyle' ) || '' );
												element.setAttribute( 'style', merged );
											}
										}
								]
							},
							{
								type :'hbox',
								children :
								[
										{
											type :'text',
											id :'title',
											style :'width: 100%;',
											label :editor.lang.common.advisoryTitle,
											'default' : ''
										}
								]
							},
							{
								type :'select',
								id :'dir',
								style :'width: 100%;',
								label :editor.lang.common.langDir,
								'default' : '',
								items :
								[
									[ editor.lang.common.notSet , '' ],
									[
										editor.lang.common.langDirLtr,
										'ltr'
									],
									[
										editor.lang.common.langDirRtl,
										'rtl'
									]
								]
							}
						]
					}
					]
				}
			],
			onLoad : function()
			{
				setupFields.call( this );

				// Preparing for the 'elementStyle' field.
				var dialog = this,
					 stylesField = this.getContentElement( 'info', 'elementStyle' );

				 // Reuse the 'stylescombo' plugin's styles definition.
				editor.getStylesSet( function( stylesDefinitions )
				{
					var styleName;

					if ( stylesDefinitions )
					{
						// Digg only those styles that apply to 'div'.
						for ( var i = 0 ; i < stylesDefinitions.length ; i++ )
						{
							var styleDefinition = stylesDefinitions[ i ];
							if ( styleDefinition.element && styleDefinition.element == 'div' )
							{
								styleName = styleDefinition.name;
								styles[ styleName ] = new CKEDITOR.style( styleDefinition );

								// Populate the styles field options with style name.
								stylesField.items.push( [ styleName, styleName ] );
								stylesField.add( styleName, styleName );
							}
						}
					}

					// We should disable the content element
					// it if no options are available at all.
					stylesField[ stylesField.items.length > 1 ? 'enable' : 'disable' ]();

					// Now setup the field value manually.
					setTimeout( function() { stylesField.setup( dialog._element ); }, 0 );
				} );
			},
			onShow : function()
			{
				// Whether always create new container regardless of existed
				// ones.
				if ( command == 'editdiv' )
				{
					// Try to discover the containers that already existed in
					// ranges
					var div = getDiv( editor );
					// update dialog field values
					div && this.setupContent( this._element = div );
				}
			},
			onOk : function()
			{
				if ( command == 'editdiv' )
					containers = [ this._element ];
				else
					containers = createDiv( editor, true );

				// Update elements attributes
				var size = containers.length;
				for ( var i = 0; i < size; i++ )
				{
					this.commitContent( containers[ i ] );

					// Remove empty 'style' attribute.
					!containers[ i ].getAttribute( 'style' ) && containers[ i ].removeAttribute( 'style' );
				}

				this.hide();
			},
			onHide : function()
			{
				// Remove style only when editing existing DIV. (#6315)
				if ( command == 'editdiv' )
					this._element.removeCustomData( 'elementStyle' );
				delete this._element;
			}
		};
	}

	CKEDITOR.dialog.add( 'creatediv', function( editor )
		{
			return divDialog( editor, 'creatediv' );
		} );
	CKEDITOR.dialog.add( 'editdiv', function( editor )
		{
			return divDialog( editor, 'editdiv' );
		} );
} )();

/*
 * @name CKEDITOR.config.div_wrapTable
 * Whether to wrap the whole table instead of indivisual cells when created 'div' in table cell.
 * @type Boolean
 * @default false
 * @example config.div_wrapTable = true;
 */
