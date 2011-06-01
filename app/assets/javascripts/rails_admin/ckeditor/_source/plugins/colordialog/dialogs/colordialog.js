/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.dialog.add( 'colordialog', function( editor )
	{
		// Define some shorthands.
		var $el = CKEDITOR.dom.element,
			$doc = CKEDITOR.document,
			$tools = CKEDITOR.tools,
			lang = editor.lang.colordialog;

		// Reference the dialog.
		var dialog;

		var spacer =
		{
			type : 'html',
			html : '&nbsp;'
		};

		function clearSelected()
		{
			$doc.getById( selHiColorId ).removeStyle( 'background-color' );
			dialog.getContentElement( 'picker', 'selectedColor' ).setValue( '' );
		}

		function updateSelected( evt )
		{
			if ( ! ( evt instanceof CKEDITOR.dom.event ) )
				evt = new CKEDITOR.dom.event( evt );

			var target = evt.getTarget(),
				color;

			if ( target.getName() == 'a' && ( color = target.getChild( 0 ).getHtml() ) )
				dialog.getContentElement( 'picker', 'selectedColor' ).setValue( color );
		}

		function updateHighlight( event )
		{
			if ( ! ( event instanceof CKEDITOR.dom.event ) )
				event = event.data;

			var target = event.getTarget(),
					color;

			if ( target.getName() == 'a' && ( color = target.getChild( 0 ).getHtml() ) )
			{
				$doc.getById( hicolorId ).setStyle( 'background-color', color );
				$doc.getById( hicolorTextId ).setHtml( color );
			}
		}

		function clearHighlight()
		{
			$doc.getById( hicolorId ).removeStyle( 'background-color' );
			$doc.getById( hicolorTextId ).setHtml( '&nbsp;' );
		}

		var onMouseout = $tools.addFunction( clearHighlight ),
			onClick = updateSelected,
			onClickHandler = CKEDITOR.tools.addFunction( onClick ),
			onFocus = updateHighlight,
			onBlur = clearHighlight;

		var onKeydownHandler = CKEDITOR.tools.addFunction( function( ev )
		{
			ev = new CKEDITOR.dom.event( ev );
			var element = ev.getTarget();
			var relative, nodeToMove;
			var keystroke = ev.getKeystroke(),
				rtl = editor.lang.dir == 'rtl';

			switch ( keystroke )
			{
				// UP-ARROW
				case 38 :
					// relative is TR
					if ( ( relative = element.getParent().getParent().getPrevious() ) )
					{
						nodeToMove = relative.getChild( [element.getParent().getIndex(), 0] );
						nodeToMove.focus();
						onBlur( ev, element );
						onFocus( ev, nodeToMove );
					}
					ev.preventDefault();
					break;
				// DOWN-ARROW
				case 40 :
					// relative is TR
					if ( ( relative = element.getParent().getParent().getNext() ) )
					{
						nodeToMove = relative.getChild( [ element.getParent().getIndex(), 0 ] );
						if ( nodeToMove && nodeToMove.type == 1 )
						{
							nodeToMove.focus();
							onBlur( ev, element );
							onFocus( ev, nodeToMove );
						}
					}
					ev.preventDefault();
					break;
				// SPACE
				// ENTER is already handled as onClick
				case 32 :
					onClick( ev );
					ev.preventDefault();
					break;

				// RIGHT-ARROW
				case rtl ? 37 : 39 :
					// relative is TD
					if ( ( relative = element.getParent().getNext() ) )
					{
						nodeToMove = relative.getChild( 0 );
						if ( nodeToMove.type == 1 )
						{
							nodeToMove.focus();
							onBlur( ev, element );
							onFocus( ev, nodeToMove );
							ev.preventDefault( true );
						}
						else
							onBlur( null, element );
					}
					// relative is TR
					else if ( ( relative = element.getParent().getParent().getNext() ) )
					{
						nodeToMove = relative.getChild( [ 0, 0 ] );
						if ( nodeToMove && nodeToMove.type == 1 )
						{
							nodeToMove.focus();
							onBlur( ev, element );
							onFocus( ev, nodeToMove );
							ev.preventDefault( true );
						}
						else
							onBlur( null, element );
					}
					break;

				// LEFT-ARROW
				case rtl ? 39 : 37 :
					// relative is TD
					if ( ( relative = element.getParent().getPrevious() ) )
					{
						nodeToMove = relative.getChild( 0 );
						nodeToMove.focus();
						onBlur( ev, element );
						onFocus( ev, nodeToMove );
						ev.preventDefault( true );
					}
					// relative is TR
					else if ( ( relative = element.getParent().getParent().getPrevious() ) )
					{
						nodeToMove = relative.getLast().getChild( 0 );
						nodeToMove.focus();
						onBlur( ev, element );
						onFocus( ev, nodeToMove );
						ev.preventDefault( true );
					}
					else
						onBlur( null, element );
					break;
				default :
					// Do not stop not handled events.
					return;
			}
		});

		function createColorTable()
		{
			// Create the base colors array.
			var aColors = [ '00', '33', '66', '99', 'cc', 'ff' ];

			// This function combines two ranges of three values from the color array into a row.
			function appendColorRow( rangeA, rangeB )
			{
				for ( var i = rangeA ; i < rangeA + 3 ; i++ )
				{
					var row = table.$.insertRow( -1 );

					for ( var j = rangeB ; j < rangeB + 3 ; j++ )
					{
						for ( var n = 0 ; n < 6 ; n++ )
						{
							appendColorCell( row, '#' + aColors[j] + aColors[n] + aColors[i] );
						}
					}
				}
			}

			// This function create a single color cell in the color table.
			function appendColorCell( targetRow, color )
			{
				var cell = new $el( targetRow.insertCell( -1 ) );
				cell.setAttribute( 'class', 'ColorCell' );
				cell.setStyle( 'background-color', color );

				cell.setStyle( 'width', '15px' );
				cell.setStyle( 'height', '15px' );

				var index = cell.$.cellIndex + 1 + 18 * targetRow.rowIndex;
				cell.append( CKEDITOR.dom.element.createFromHtml(
						'<a href="javascript: void(0);" role="option"' +
						' aria-posinset="' + index + '"' +
						' aria-setsize="' + 13 * 18 + '"' +
						' style="cursor: pointer;display:block;width:100%;height:100% " title="'+ CKEDITOR.tools.htmlEncode( color )+ '"' +
						' onkeydown="CKEDITOR.tools.callFunction( ' + onKeydownHandler + ', event, this )"' +
						' onclick="CKEDITOR.tools.callFunction(' + onClickHandler + ', event, this ); return false;"' +
						' tabindex="-1"><span class="cke_voice_label">' + color + '</span>&nbsp;</a>', CKEDITOR.document ) );
			}

			appendColorRow( 0, 0 );
			appendColorRow( 3, 0 );
			appendColorRow( 0, 3 );
			appendColorRow( 3, 3 );

			// Create the last row.
			var oRow = table.$.insertRow(-1) ;

			// Create the gray scale colors cells.
			for ( var n = 0 ; n < 6 ; n++ )
			{
				appendColorCell( oRow, '#' + aColors[n] + aColors[n] + aColors[n] ) ;
			}

			// Fill the row with black cells.
			for ( var i = 0 ; i < 12 ; i++ )
			{
				appendColorCell( oRow, '#000000' ) ;
			}
		}

		var table = new $el( 'table' );
		createColorTable();
		var html = table.getHtml();

		var numbering = function( id )
			{
				return CKEDITOR.tools.getNextId() + '_' + id;
			},
			hicolorId = numbering( 'hicolor' ),
			hicolorTextId = numbering( 'hicolortext' ),
			selHiColorId = numbering( 'selhicolor' ),
			tableLabelId = numbering( 'color_table_label' );

		return {
			title : lang.title,
			minWidth : 360,
			minHeight : 220,
			onLoad : function()
			{
				// Update reference.
				dialog = this;
			},
			contents : [
				{
					id : 'picker',
					label : lang.title,
					accessKey : 'I',
					elements :
					[
						{
							type : 'hbox',
							padding : 0,
							widths : [ '70%', '10%', '30%' ],
							children :
							[
								{
									type : 'html',
									html :	'<table role="listbox" aria-labelledby="' + tableLabelId + '" onmouseout="CKEDITOR.tools.callFunction( ' + onMouseout + ' );">' +
											( !CKEDITOR.env.webkit ? html : '' ) +
										'</table><span id="' + tableLabelId + '" class="cke_voice_label">' + lang.options +'</span>',
									onLoad : function()
									{
										var table = CKEDITOR.document.getById( this.domId );
										table.on( 'mouseover', updateHighlight );
										// In WebKit, the table content must be inserted after this event call (#6150)
										CKEDITOR.env.webkit && table.setHtml( html );
									},
									focus: function()
									{
										var firstColor = this.getElement().getElementsByTag( 'a' ).getItem( 0 );
										firstColor.focus();
									}
								},
								spacer,
								{
									type : 'vbox',
									padding : 0,
									widths : [ '70%', '5%', '25%' ],
									children :
									[
										{
											type : 'html',
											html : '<span>' + lang.highlight +'</span>\
												<div id="' + hicolorId + '" style="border: 1px solid; height: 74px; width: 74px;"></div>\
												<div id="' + hicolorTextId + '">&nbsp;</div><span>' + lang.selected + '</span>\
												<div id="' + selHiColorId + '" style="border: 1px solid; height: 20px; width: 74px;"></div>'
										},
										{
											type : 'text',
											label : lang.selected,
											labelStyle: 'display:none',
											id : 'selectedColor',
											style : 'width: 74px',
											onChange : function()
											{
												// Try to update color preview with new value. If fails, then set it no none.
												try
												{
													$doc.getById( selHiColorId ).setStyle( 'background-color', this.getValue() );
												}
												catch ( e )
												{
													clearSelected();
												}
											}
										},
										spacer,
										{
											type : 'button',
											id : 'clear',
											style : 'margin-top: 5px',
											label : lang.clear,
											onClick : clearSelected
										}
									]
								}
							]
						}
					]
				}
			]
		};
	}
	);
