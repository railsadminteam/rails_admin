/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	var widthPattern = /^(\d+(?:\.\d+)?)(px|%)$/,
		heightPattern = /^(\d+(?:\.\d+)?)px$/;

	var commitValue = function( data )
	{
		var id = this.id;
		if ( !data.info )
			data.info = {};
		data.info[id] = this.getValue();
	};

	function tableDialog( editor, command )
	{
		var makeElement = function( name )
			{
				return new CKEDITOR.dom.element( name, editor.document );
			};

		var dialogadvtab = editor.plugins.dialogadvtab;

		return {
			title : editor.lang.table.title,
			minWidth : 310,
			minHeight : CKEDITOR.env.ie ? 310 : 280,

			onLoad : function()
			{
				var dialog = this;

				var styles = dialog.getContentElement( 'advanced', 'advStyles' );

				if ( styles )
				{
					styles.on( 'change', function( evt )
						{
							// Synchronize width value.
							var width = this.getStyle( 'width', '' ),
								txtWidth = dialog.getContentElement( 'info', 'txtWidth' ),
								cmbWidthType = dialog.getContentElement( 'info', 'cmbWidthType' ),
								isPx = 1;

							if ( width )
							{
								isPx = ( width.length < 3 || width.substr( width.length - 1 ) != '%' );
								width = parseInt( width, 10 );
							}

							txtWidth && txtWidth.setValue( width, true );
							cmbWidthType && cmbWidthType.setValue( isPx ? 'pixels' : 'percents', true );

							// Synchronize height value.
							var height = this.getStyle( 'height', '' ),
								txtHeight = dialog.getContentElement( 'info', 'txtHeight' );

							height && ( height = parseInt( height, 10 ) );
							txtHeight && txtHeight.setValue( height, true );
						});
				}
			},

			onShow : function()
			{
				// Detect if there's a selected table.
				var selection = editor.getSelection(),
					ranges = selection.getRanges(),
					selectedTable = null;

				var rowsInput = this.getContentElement( 'info', 'txtRows' ),
					colsInput = this.getContentElement( 'info', 'txtCols' ),
					widthInput = this.getContentElement( 'info', 'txtWidth' ),
					heightInput = this.getContentElement( 'info', 'txtHeight' );

				if ( command == 'tableProperties' )
				{
					if ( ( selectedTable = selection.getSelectedElement() ) )
						selectedTable = selectedTable.getAscendant( 'table', true );
					else if ( ranges.length > 0 )
					{
						// Webkit could report the following range on cell selection (#4948):
						// <table><tr><td>[&nbsp;</td></tr></table>]
						if ( CKEDITOR.env.webkit )
							ranges[ 0 ].shrink( CKEDITOR.NODE_ELEMENT );

						var rangeRoot = ranges[0].getCommonAncestor( true );
						selectedTable = rangeRoot.getAscendant( 'table', true );
					}

					// Save a reference to the selected table, and push a new set of default values.
					this._.selectedElement = selectedTable;
				}

				// Enable or disable the row, cols, width fields.
				if ( selectedTable )
				{
					this.setupContent( selectedTable );
					rowsInput && rowsInput.disable();
					colsInput && colsInput.disable();
				}
				else
				{
					rowsInput && rowsInput.enable();
					colsInput && colsInput.enable();
				}

				// Call the onChange method for the widht and height fields so
				// they get reflected into the Advanced tab.
				widthInput && widthInput.onChange();
				heightInput && heightInput.onChange();
			},
			onOk : function()
			{
				if ( this._.selectedElement )
				{
					var selection = editor.getSelection(),
						bms = selection.createBookmarks();
				}

				var table = this._.selectedElement || makeElement( 'table' ),
					me = this,
					data = {};

				this.commitContent( data, table );

				if ( data.info )
				{
					var info = data.info;

					// Generate the rows and cols.
					if ( !this._.selectedElement )
					{
						var tbody = table.append( makeElement( 'tbody' ) ),
							rows = parseInt( info.txtRows, 10 ) || 0,
							cols = parseInt( info.txtCols, 10 ) || 0;

						for ( var i = 0 ; i < rows ; i++ )
						{
							var row = tbody.append( makeElement( 'tr' ) );
							for ( var j = 0 ; j < cols ; j++ )
							{
								var cell = row.append( makeElement( 'td' ) );
								if ( !CKEDITOR.env.ie )
									cell.append( makeElement( 'br' ) );
							}
						}
					}

					// Modify the table headers. Depends on having rows and cols generated
					// correctly so it can't be done in commit functions.

					// Should we make a <thead>?
					var headers = info.selHeaders;
					if ( !table.$.tHead && ( headers == 'row' || headers == 'both' ) )
					{
						var thead = new CKEDITOR.dom.element( table.$.createTHead() );
						tbody = table.getElementsByTag( 'tbody' ).getItem( 0 );
						var theRow = tbody.getElementsByTag( 'tr' ).getItem( 0 );

						// Change TD to TH:
						for ( i = 0 ; i < theRow.getChildCount() ; i++ )
						{
							var th = theRow.getChild( i );
							// Skip bookmark nodes. (#6155)
							if ( th.type == CKEDITOR.NODE_ELEMENT && !th.data( 'cke-bookmark' ) )
							{
								th.renameNode( 'th' );
								th.setAttribute( 'scope', 'col' );
							}
						}
						thead.append( theRow.remove() );
					}

					if ( table.$.tHead !== null && !( headers == 'row' || headers == 'both' ) )
					{
						// Move the row out of the THead and put it in the TBody:
						thead = new CKEDITOR.dom.element( table.$.tHead );
						tbody = table.getElementsByTag( 'tbody' ).getItem( 0 );

						var previousFirstRow = tbody.getFirst();
						while ( thead.getChildCount() > 0 )
						{
							theRow = thead.getFirst();
							for ( i = 0; i < theRow.getChildCount() ; i++ )
							{
								var newCell = theRow.getChild( i );
								if ( newCell.type == CKEDITOR.NODE_ELEMENT )
								{
									newCell.renameNode( 'td' );
									newCell.removeAttribute( 'scope' );
								}
							}
							theRow.insertBefore( previousFirstRow );
						}
						thead.remove();
					}

					// Should we make all first cells in a row TH?
					if ( !this.hasColumnHeaders && ( headers == 'col' || headers == 'both' ) )
					{
						for ( row = 0 ; row < table.$.rows.length ; row++ )
						{
							newCell = new CKEDITOR.dom.element( table.$.rows[ row ].cells[ 0 ] );
							newCell.renameNode( 'th' );
							newCell.setAttribute( 'scope', 'row' );
						}
					}

					// Should we make all first TH-cells in a row make TD? If 'yes' we do it the other way round :-)
					if ( ( this.hasColumnHeaders ) && !( headers == 'col' || headers == 'both' ) )
					{
						for ( i = 0 ; i < table.$.rows.length ; i++ )
						{
							row = new CKEDITOR.dom.element( table.$.rows[i] );
							if ( row.getParent().getName() == 'tbody' )
							{
								newCell = new CKEDITOR.dom.element( row.$.cells[0] );
								newCell.renameNode( 'td' );
								newCell.removeAttribute( 'scope' );
							}
						}
					}

					// Set the width and height.
					var styles = [];
					if ( info.txtHeight )
						table.setStyle( 'height', CKEDITOR.tools.cssLength( info.txtHeight ) );
					else
						table.removeStyle( 'height' );

					if ( info.txtWidth )
					{
						var type = info.cmbWidthType || 'pixels';
						table.setStyle( 'width', info.txtWidth + ( type == 'pixels' ? 'px' : '%' ) );
					}
					else
						table.removeStyle( 'width' );

					if ( !table.getAttribute( 'style' ) )
						table.removeAttribute( 'style' );
				}

				// Insert the table element if we're creating one.
				if ( !this._.selectedElement )
					editor.insertElement( table );
				// Properly restore the selection inside table. (#4822)
				else
					selection.selectBookmarks( bms );

				return true;
			},
			contents : [
				{
					id : 'info',
					label : editor.lang.table.title,
					elements :
					[
						{
							type : 'hbox',
							widths : [ null, null ],
							styles : [ 'vertical-align:top' ],
							children :
							[
								{
									type : 'vbox',
									padding : 0,
									children :
									[
										{
											type : 'text',
											id : 'txtRows',
											'default' : 3,
											label : editor.lang.table.rows,
											required : true,
											style : 'width:5em',
											validate : function()
											{
												var pass = true,
													value = this.getValue();
												pass = pass && CKEDITOR.dialog.validate.integer()( value )
													&& value > 0;
												if ( !pass )
												{
													alert( editor.lang.table.invalidRows );
													this.select();
												}
												return pass;
											},
											setup : function( selectedElement )
											{
												this.setValue( selectedElement.$.rows.length );
											},
											commit : commitValue
										},
										{
											type : 'text',
											id : 'txtCols',
											'default' : 2,
											label : editor.lang.table.columns,
											required : true,
											style : 'width:5em',
											validate : function()
											{
												var pass = true,
													value = this.getValue();
												pass = pass && CKEDITOR.dialog.validate.integer()( value )
													&& value > 0;
												if ( !pass )
												{
													alert( editor.lang.table.invalidCols );
													this.select();
												}
												return pass;
											},
											setup : function( selectedTable )
											{
												this.setValue( selectedTable.$.rows[0].cells.length);
											},
											commit : commitValue
										},
										{
											type : 'html',
											html : '&nbsp;'
										},
										{
											type : 'select',
											id : 'selHeaders',
											'default' : '',
											label : editor.lang.table.headers,
											items :
											[
												[ editor.lang.table.headersNone, '' ],
												[ editor.lang.table.headersRow, 'row' ],
												[ editor.lang.table.headersColumn, 'col' ],
												[ editor.lang.table.headersBoth, 'both' ]
											],
											setup : function( selectedTable )
											{
												// Fill in the headers field.
												var dialog = this.getDialog();
												dialog.hasColumnHeaders = true;

												// Check if all the first cells in every row are TH
												for ( var row = 0 ; row < selectedTable.$.rows.length ; row++ )
												{
													// If just one cell isn't a TH then it isn't a header column
													if ( selectedTable.$.rows[row].cells[0].nodeName.toLowerCase() != 'th' )
													{
														dialog.hasColumnHeaders = false;
														break;
													}
												}

												// Check if the table contains <thead>.
												if ( ( selectedTable.$.tHead !== null) )
													this.setValue( dialog.hasColumnHeaders ? 'both' : 'row' );
												else
													this.setValue( dialog.hasColumnHeaders ? 'col' : '' );
											},
											commit : commitValue
										},
										{
											type : 'text',
											id : 'txtBorder',
											'default' : 1,
											label : editor.lang.table.border,
											style : 'width:3em',
											validate : CKEDITOR.dialog.validate['number']( editor.lang.table.invalidBorder ),
											setup : function( selectedTable )
											{
												this.setValue( selectedTable.getAttribute( 'border' ) || '' );
											},
											commit : function( data, selectedTable )
											{
												if ( this.getValue() )
													selectedTable.setAttribute( 'border', this.getValue() );
												else
													selectedTable.removeAttribute( 'border' );
											}
										},
										{
											id : 'cmbAlign',
											type : 'select',
											'default' : '',
											label : editor.lang.common.align,
											items :
											[
												[ editor.lang.common.notSet , ''],
												[ editor.lang.common.alignLeft , 'left'],
												[ editor.lang.common.alignCenter , 'center'],
												[ editor.lang.common.alignRight , 'right']
											],
											setup : function( selectedTable )
											{
												this.setValue( selectedTable.getAttribute( 'align' ) || '' );
											},
											commit : function( data, selectedTable )
											{
												if ( this.getValue() )
													selectedTable.setAttribute( 'align', this.getValue() );
												else
													selectedTable.removeAttribute( 'align' );
											}
										}
									]
								},
								{
									type : 'vbox',
									padding : 0,
									children :
									[
										{
											type : 'hbox',
											widths : [ '5em' ],
											children :
											[
												{
													type : 'text',
													id : 'txtWidth',
													style : 'width:5em',
													label : editor.lang.common.width,
													'default' : 500,
													validate : CKEDITOR.dialog.validate['number']( editor.lang.table.invalidWidth ),

													// Extra labelling of width unit type.
													onLoad : function()
													{
														var widthType = this.getDialog().getContentElement( 'info', 'cmbWidthType' ),
															labelElement = widthType.getElement(),
															inputElement = this.getInputElement(),
															ariaLabelledByAttr = inputElement.getAttribute( 'aria-labelledby' );

														inputElement.setAttribute( 'aria-labelledby', [ ariaLabelledByAttr, labelElement.$.id ].join( ' ' ) );
													},

													onChange : function()
													{
														var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );

														if ( styles )
														{
															var value = this.getValue();

															if ( value )
																value += this.getDialog().getContentElement( 'info', 'cmbWidthType' ).getValue() == 'percents' ? '%' : 'px';

															styles.updateStyle( 'width', value );
														}
													},

													setup : function( selectedTable )
													{
														var widthMatch = widthPattern.exec( selectedTable.$.style.width );
														if ( widthMatch )
															this.setValue( widthMatch[1] );
														else
															this.setValue( '' );
													},
													commit : commitValue
												},
												{
													id : 'cmbWidthType',
													type : 'select',
													label : editor.lang.table.widthUnit,
													labelStyle: 'visibility:hidden',
													'default' : 'pixels',
													items :
													[
														[ editor.lang.table.widthPx , 'pixels'],
														[ editor.lang.table.widthPc , 'percents']
													],
													setup : function( selectedTable )
													{
														var widthMatch = widthPattern.exec( selectedTable.$.style.width );
														if ( widthMatch )
															this.setValue( widthMatch[2] == 'px' ? 'pixels' : 'percents' );
													},
													onChange : function()
													{
														this.getDialog().getContentElement( 'info', 'txtWidth' ).onChange();
													},
													commit : commitValue
												}
											]
										},
										{
											type : 'hbox',
											widths : [ '5em' ],
											children :
											[
												{
													type : 'text',
													id : 'txtHeight',
													style : 'width:5em',
													label : editor.lang.common.height,
													'default' : '',
													validate : CKEDITOR.dialog.validate['number']( editor.lang.table.invalidHeight ),

													// Extra labelling of height unit type.
													onLoad : function()
													{
														var heightType = this.getDialog().getContentElement( 'info', 'htmlHeightType' ),
															labelElement = heightType.getElement(),
															inputElement = this.getInputElement(),
															ariaLabelledByAttr = inputElement.getAttribute( 'aria-labelledby' );

														inputElement.setAttribute( 'aria-labelledby', [ ariaLabelledByAttr, labelElement.$.id ].join( ' ' ) );
													},

													onChange : function()
													{
														var styles = this.getDialog().getContentElement( 'advanced', 'advStyles' );

														if ( styles )
														{
															var value = this.getValue();
															styles.updateStyle( 'height', value && ( value + 'px' ) );
														}
													},

													setup : function( selectedTable )
													{
														var heightMatch = heightPattern.exec( selectedTable.$.style.height );
														if ( heightMatch )
															this.setValue( heightMatch[1] );
													},
													commit : commitValue
												},
												{
													id : 'htmlHeightType',
													type : 'html',
													html : '<div><br />' + editor.lang.table.widthPx + '</div>'
												}
											]
										},
										{
											type : 'html',
											html : '&nbsp;'
										},
										{
											type : 'text',
											id : 'txtCellSpace',
											style : 'width:3em',
											label : editor.lang.table.cellSpace,
											'default' : 1,
											validate : CKEDITOR.dialog.validate['number']( editor.lang.table.invalidCellSpacing ),
											setup : function( selectedTable )
											{
												this.setValue( selectedTable.getAttribute( 'cellSpacing' ) || '' );
											},
											commit : function( data, selectedTable )
											{
												if ( this.getValue() )
													selectedTable.setAttribute( 'cellSpacing', this.getValue() );
												else
													selectedTable.removeAttribute( 'cellSpacing' );
											}
										},
										{
											type : 'text',
											id : 'txtCellPad',
											style : 'width:3em',
											label : editor.lang.table.cellPad,
											'default' : 1,
											validate : CKEDITOR.dialog.validate['number']( editor.lang.table.invalidCellPadding ),
											setup : function( selectedTable )
											{
												this.setValue( selectedTable.getAttribute( 'cellPadding' ) || '' );
											},
											commit : function( data, selectedTable )
											{
												if ( this.getValue() )
													selectedTable.setAttribute( 'cellPadding', this.getValue() );
												else
													selectedTable.removeAttribute( 'cellPadding' );
											}
										}
									]
								}
							]
						},
						{
							type : 'html',
							align : 'right',
							html : ''
						},
						{
							type : 'vbox',
							padding : 0,
							children :
							[
								{
									type : 'text',
									id : 'txtCaption',
									label : editor.lang.table.caption,
									setup : function( selectedTable )
									{
										var nodeList = selectedTable.getElementsByTag( 'caption' );
										if ( nodeList.count() > 0 )
										{
											var caption = nodeList.getItem( 0 );
											caption = CKEDITOR.tools.trim( caption.getText() );
											this.setValue( caption );
										}
									},
									commit : function( data, table )
									{
										var caption = this.getValue(),
											captionElement = table.getElementsByTag( 'caption' );
										if ( caption )
										{
											if ( captionElement.count() > 0 )
											{
												captionElement = captionElement.getItem( 0 );
												captionElement.setHtml( '' );
											}
											else
											{
												captionElement = new CKEDITOR.dom.element( 'caption', editor.document );
												if ( table.getChildCount() )
													captionElement.insertBefore( table.getFirst() );
												else
													captionElement.appendTo( table );
											}
											captionElement.append( new CKEDITOR.dom.text( caption, editor.document ) );
										}
										else if ( captionElement.count() > 0 )
										{
											for ( var i = captionElement.count() - 1 ; i >= 0 ; i-- )
												captionElement.getItem( i ).remove();
										}
									}
								},
								{
									type : 'text',
									id : 'txtSummary',
									label : editor.lang.table.summary,
									setup : function( selectedTable )
									{
										this.setValue( selectedTable.getAttribute( 'summary' ) || '' );
									},
									commit : function( data, selectedTable )
									{
										if ( this.getValue() )
											selectedTable.setAttribute( 'summary', this.getValue() );
										else
											selectedTable.removeAttribute( 'summary' );
									}
								}
							]
						}
					]
				},
				dialogadvtab && dialogadvtab.createAdvancedTab( editor )
			]
		};
	}

	CKEDITOR.dialog.add( 'table', function( editor )
		{
			return tableDialog( editor, 'table' );
		} );
	CKEDITOR.dialog.add( 'tableProperties', function( editor )
		{
			return tableDialog( editor, 'tableProperties' );
		} );
})();
