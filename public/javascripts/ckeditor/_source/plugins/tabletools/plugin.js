/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	function removeRawAttribute( $node, attr )
	{
		if ( CKEDITOR.env.ie )
			$node.removeAttribute( attr );
		else
			delete $node[ attr ];
	}

	var cellNodeRegex = /^(?:td|th)$/;

	function getSelectedCells( selection )
	{
		// Walker will try to split text nodes, which will make the current selection
		// invalid. So save bookmarks before doing anything.
		var bookmarks = selection.createBookmarks();

		var ranges = selection.getRanges();
		var retval = [];
		var database = {};

		function moveOutOfCellGuard( node )
		{
			// Apply to the first cell only.
			if ( retval.length > 0 )
				return;

			// If we are exiting from the first </td>, then the td should definitely be
			// included.
			if ( node.type == CKEDITOR.NODE_ELEMENT && cellNodeRegex.test( node.getName() )
					&& !node.getCustomData( 'selected_cell' ) )
			{
				CKEDITOR.dom.element.setMarker( database, node, 'selected_cell', true );
				retval.push( node );
			}
		}

		for ( var i = 0 ; i < ranges.length ; i++ )
		{
			var range = ranges[ i ];

			if ( range.collapsed )
			{
				// Walker does not handle collapsed ranges yet - fall back to old API.
				var startNode = range.getCommonAncestor();
				var nearestCell = startNode.getAscendant( 'td', true ) || startNode.getAscendant( 'th', true );
				if ( nearestCell )
					retval.push( nearestCell );
			}
			else
			{
				var walker = new CKEDITOR.dom.walker( range );
				var node;
				walker.guard = moveOutOfCellGuard;

				while ( ( node = walker.next() ) )
				{
					// If may be possible for us to have a range like this:
					// <td>^1</td><td>^2</td>
					// The 2nd td shouldn't be included.
					//
					// So we have to take care to include a td we've entered only when we've
					// walked into its children.

					var parent = node.getParent();
					if ( parent && cellNodeRegex.test( parent.getName() ) && !parent.getCustomData( 'selected_cell' ) )
					{
						CKEDITOR.dom.element.setMarker( database, parent, 'selected_cell', true );
						retval.push( parent );
					}
				}
			}
		}

		CKEDITOR.dom.element.clearAllMarkers( database );

		// Restore selection position.
		selection.selectBookmarks( bookmarks );

		return retval;
	}

	function getFocusElementAfterDelCells( cellsToDelete ) {
		var i = 0,
			last = cellsToDelete.length - 1,
			database = {},
			cell,focusedCell,
			tr;

		while ( ( cell = cellsToDelete[ i++ ] ) )
			CKEDITOR.dom.element.setMarker( database, cell, 'delete_cell', true );

		// 1.first we check left or right side focusable cell row by row;
		i = 0;
		while ( ( cell = cellsToDelete[ i++ ] ) )
		{
			if ( ( focusedCell = cell.getPrevious() ) && !focusedCell.getCustomData( 'delete_cell' )
			  || ( focusedCell = cell.getNext()     ) && !focusedCell.getCustomData( 'delete_cell' ) )
			{
				CKEDITOR.dom.element.clearAllMarkers( database );
				return focusedCell;
			}
		}

		CKEDITOR.dom.element.clearAllMarkers( database );

		// 2. then we check the toppest row (outside the selection area square) focusable cell
		tr = cellsToDelete[ 0 ].getParent();
		if ( ( tr = tr.getPrevious() ) )
			return tr.getLast();

		// 3. last we check the lowerest  row focusable cell
		tr = cellsToDelete[ last ].getParent();
		if ( ( tr = tr.getNext() ) )
			return tr.getChild( 0 );

		return null;
	}

	function clearRow( $tr )
	{
		// Get the array of row's cells.
		var $cells = $tr.cells;

		// Empty all cells.
		for ( var i = 0 ; i < $cells.length ; i++ )
		{
			$cells[ i ].innerHTML = '';

			if ( !CKEDITOR.env.ie )
				( new CKEDITOR.dom.element( $cells[ i ] ) ).appendBogus();
		}
	}

	function insertRow( selection, insertBefore )
	{
		// Get the row where the selection is placed in.
		var row = selection.getStartElement().getAscendant( 'tr' );
		if ( !row )
			return;

		// Create a clone of the row.
		var newRow = row.clone( 1 );

		insertBefore ?
			newRow.insertBefore( row ) :
			newRow.insertAfter( row );

		// Clean the new row.
		clearRow( newRow.$ );
	}

	function deleteRows( selectionOrRow )
	{
		if ( selectionOrRow instanceof CKEDITOR.dom.selection )
		{
			var cells = getSelectedCells( selectionOrRow ),
				cellsCount = cells.length,
				rowsToDelete = [],
				cursorPosition,
				previousRowIndex,
				nextRowIndex;

			// Queue up the rows - it's possible and likely that we have duplicates.
			for ( var i = 0 ; i < cellsCount ; i++ )
			{
				var row = cells[ i ].getParent(),
						rowIndex = row.$.rowIndex;

				!i && ( previousRowIndex = rowIndex - 1 );
				rowsToDelete[ rowIndex ] = row;
				i == cellsCount - 1 && ( nextRowIndex = rowIndex + 1 );
			}

			var table = row.getAscendant( 'table' ),
					rows =  table.$.rows,
					rowCount = rows.length;

			// Where to put the cursor after rows been deleted?
			// 1. Into next sibling row if any;
			// 2. Into previous sibling row if any;
			// 3. Into table's parent element if it's the very last row.
			cursorPosition = new CKEDITOR.dom.element(
				nextRowIndex < rowCount && table.$.rows[ nextRowIndex ] ||
				previousRowIndex > 0 && table.$.rows[ previousRowIndex ] ||
				table.$.parentNode );

			for ( i = rowsToDelete.length ; i >= 0 ; i-- )
			{
				if ( rowsToDelete[ i ] )
					deleteRows( rowsToDelete[ i ] );
			}

			return cursorPosition;
		}
		else if ( selectionOrRow instanceof CKEDITOR.dom.element )
		{
			table = selectionOrRow.getAscendant( 'table' );

			if ( table.$.rows.length == 1 )
				table.remove();
			else
				selectionOrRow.remove();
		}

		return 0;
	}

	function insertColumn( selection, insertBefore )
	{
		// Get the cell where the selection is placed in.
		var startElement = selection.getStartElement();
		var cell = startElement.getAscendant( 'td', 1 ) || startElement.getAscendant( 'th', 1 );

		if ( !cell )
			return;

		// Get the cell's table.
		var table = cell.getAscendant( 'table' );
		var cellIndex = cell.$.cellIndex;

		// Loop through all rows available in the table.
		for ( var i = 0 ; i < table.$.rows.length ; i++ )
		{
			var $row = table.$.rows[ i ];

			// If the row doesn't have enough cells, ignore it.
			if ( $row.cells.length < ( cellIndex + 1 ) )
				continue;

			cell = ( new CKEDITOR.dom.element( $row.cells[ cellIndex ] ) ).clone( 0 );

			if ( !CKEDITOR.env.ie )
				cell.appendBogus();

			// Get back the currently selected cell.
			var baseCell = new CKEDITOR.dom.element( $row.cells[ cellIndex ] );
			if ( insertBefore )
				cell.insertBefore( baseCell );
			else
				cell.insertAfter( baseCell );
		}
	}

	function getFocusElementAfterDelCols( cells )
	{
		var cellIndexList = [],
			table = cells[ 0 ] && cells[ 0 ].getAscendant( 'table' ),
			i, length,
			targetIndex, targetCell;

		// get the cellIndex list of delete cells
		for ( i = 0, length = cells.length; i < length; i++ )
			cellIndexList.push( cells[i].$.cellIndex );

		// get the focusable column index
		cellIndexList.sort();
		for ( i = 1, length = cellIndexList.length; i < length; i++ )
		{
			if ( cellIndexList[ i ] - cellIndexList[ i - 1 ] > 1 )
			{
				targetIndex = cellIndexList[ i - 1 ] + 1;
				break;
			}
		}

		if ( !targetIndex )
			targetIndex = cellIndexList[ 0 ] > 0 ? ( cellIndexList[ 0 ] - 1 )
							: ( cellIndexList[ cellIndexList.length - 1 ] + 1 );

		// scan row by row to get the target cell
		var rows = table.$.rows;
		for ( i = 0, length = rows.length; i < length ; i++ )
		{
			targetCell = rows[ i ].cells[ targetIndex ];
			if ( targetCell )
				break;
		}

		return targetCell ?  new CKEDITOR.dom.element( targetCell ) :  table.getPrevious();
	}

	function deleteColumns( selectionOrCell )
	{
		if ( selectionOrCell instanceof CKEDITOR.dom.selection )
		{
			var colsToDelete = getSelectedCells( selectionOrCell ),
				elementToFocus = getFocusElementAfterDelCols( colsToDelete );

			for ( var i = colsToDelete.length - 1 ; i >= 0 ; i-- )
			{
				if ( colsToDelete[ i ] )
					deleteColumns( colsToDelete[ i ] );
			}

			return elementToFocus;
		}
		else if ( selectionOrCell instanceof CKEDITOR.dom.element )
		{
			// Get the cell's table.
			var table = selectionOrCell.getAscendant( 'table' );
			if ( !table )
				return null;

			// Get the cell index.
			var cellIndex = selectionOrCell.$.cellIndex;

			/*
			 * Loop through all rows from down to up, coz it's possible that some rows
			 * will be deleted.
			 */
			for ( i = table.$.rows.length - 1 ; i >= 0 ; i-- )
			{
				// Get the row.
				var row = new CKEDITOR.dom.element( table.$.rows[ i ] );

				// If the cell to be removed is the first one and the row has just one cell.
				if ( !cellIndex && row.$.cells.length == 1 )
				{
					deleteRows( row );
					continue;
				}

				// Else, just delete the cell.
				if ( row.$.cells[ cellIndex ] )
					row.$.removeChild( row.$.cells[ cellIndex ] );
			}
		}

		return null;
	}

	function insertCell( selection, insertBefore )
	{
		var startElement = selection.getStartElement();
		var cell = startElement.getAscendant( 'td', 1 ) || startElement.getAscendant( 'th', 1 );

		if ( !cell )
			return;

		// Create the new cell element to be added.
		var newCell = cell.clone();
		if ( !CKEDITOR.env.ie )
			newCell.appendBogus();

		if ( insertBefore )
			newCell.insertBefore( cell );
		else
			newCell.insertAfter( cell );
	}

	function deleteCells( selectionOrCell )
	{
		if ( selectionOrCell instanceof CKEDITOR.dom.selection )
		{
			var cellsToDelete = getSelectedCells( selectionOrCell );
			var table = cellsToDelete[ 0 ] && cellsToDelete[ 0 ].getAscendant( 'table' );
			var cellToFocus   = getFocusElementAfterDelCells( cellsToDelete );

			for ( var i = cellsToDelete.length - 1 ; i >= 0 ; i-- )
				deleteCells( cellsToDelete[ i ] );

			if ( cellToFocus )
				placeCursorInCell( cellToFocus, true );
			else if ( table )
				table.remove();
		}
		else if ( selectionOrCell instanceof CKEDITOR.dom.element )
		{
			var tr = selectionOrCell.getParent();
			if ( tr.getChildCount() == 1 )
				tr.remove();
			else
				selectionOrCell.remove();
		}
	}

	// Remove filler at end and empty spaces around the cell content.
	function trimCell( cell )
	{
		var bogus = cell.getBogus();
		bogus && bogus.remove();
		cell.trim();
	}

	function placeCursorInCell( cell, placeAtEnd )
	{
		var range = new CKEDITOR.dom.range( cell.getDocument() );
		if ( !range[ 'moveToElementEdit' + ( placeAtEnd ? 'End' : 'Start' ) ]( cell ) )
		{
			range.selectNodeContents( cell );
			range.collapse( placeAtEnd ? false : true );
		}
		range.select( true );
	}

	function cellInRow( tableMap, rowIndex, cell )
	{
		var oRow = tableMap[ rowIndex ];
		if ( typeof cell == 'undefined' )
			return oRow;

		for ( var c = 0 ; oRow && c < oRow.length ; c++ )
		{
			if ( cell.is && oRow[c] == cell.$ )
				return c;
			else if ( c == cell )
				return new CKEDITOR.dom.element( oRow[ c ] );
		}
		return cell.is ? -1 : null;
	}

	function cellInCol( tableMap, colIndex, cell )
	{
		var oCol = [];
		for ( var r = 0; r < tableMap.length; r++ )
		{
			var row = tableMap[ r ];
			if ( typeof cell == 'undefined' )
				oCol.push( row[ colIndex ] );
			else if ( cell.is && row[ colIndex ] == cell.$ )
				return r;
			else if ( r == cell )
				return new CKEDITOR.dom.element( row[ colIndex ] );
		}

		return ( typeof cell == 'undefined' )? oCol : cell.is ? -1 :  null;
	}

	function mergeCells( selection, mergeDirection, isDetect )
	{
		var cells = getSelectedCells( selection );

		// Invalid merge request if:
		// 1. In batch mode despite that less than two selected.
		// 2. In solo mode while not exactly only one selected.
		// 3. Cells distributed in different table groups (e.g. from both thead and tbody).
		var commonAncestor;
		if ( ( mergeDirection ? cells.length != 1 : cells.length < 2 )
				|| ( commonAncestor = selection.getCommonAncestor() )
				&& commonAncestor.type == CKEDITOR.NODE_ELEMENT
				&& commonAncestor.is( 'table' ) )
		{
			return false;
		}

		var	cell,
			firstCell = cells[ 0 ],
			table = firstCell.getAscendant( 'table' ),
			map = CKEDITOR.tools.buildTableMap( table ),
			mapHeight = map.length,
			mapWidth = map[ 0 ].length,
			startRow = firstCell.getParent().$.rowIndex,
			startColumn = cellInRow( map, startRow, firstCell );

		if ( mergeDirection )
		{
			var targetCell;
			try
			{
				targetCell =
					map[ mergeDirection == 'up' ?
							( startRow - 1 ):
							mergeDirection == 'down' ? ( startRow + 1 ) : startRow  ] [
						 mergeDirection == 'left' ?
							( startColumn - 1 ):
						 mergeDirection == 'right' ?  ( startColumn + 1 ) : startColumn ];

			}
			catch( er )
			{
				return false;
			}

			// 1. No cell could be merged.
			// 2. Same cell actually.
			if ( !targetCell || firstCell.$ == targetCell  )
				return false;

			// Sort in map order regardless of the DOM sequence.
			cells[ ( mergeDirection == 'up' || mergeDirection == 'left' ) ?
			         'unshift' : 'push' ]( new CKEDITOR.dom.element( targetCell ) );
		}

		// Start from here are merging way ignorance (merge up/right, batch merge).
		var	doc = firstCell.getDocument(),
			lastRowIndex = startRow,
			totalRowSpan = 0,
			totalColSpan = 0,
			// Use a documentFragment as buffer when appending cell contents.
			frag = !isDetect && new CKEDITOR.dom.documentFragment( doc ),
			dimension = 0;

		for ( var i = 0; i < cells.length; i++ )
		{
			cell = cells[ i ];

			var tr = cell.getParent(),
				cellFirstChild = cell.getFirst(),
				colSpan = cell.$.colSpan,
				rowSpan = cell.$.rowSpan,
				rowIndex = tr.$.rowIndex,
				colIndex = cellInRow( map, rowIndex, cell );

			// Accumulated the actual places taken by all selected cells.
			dimension += colSpan * rowSpan;
			// Accumulated the maximum virtual spans from column and row.
			totalColSpan = Math.max( totalColSpan, colIndex - startColumn + colSpan ) ;
			totalRowSpan = Math.max( totalRowSpan, rowIndex - startRow + rowSpan );

			if ( !isDetect )
			{
				// Trim all cell fillers and check to remove empty cells.
				if ( trimCell( cell ), cell.getChildren().count() )
				{
					// Merge vertically cells as two separated paragraphs.
					if ( rowIndex != lastRowIndex
						&& cellFirstChild
						&& !( cellFirstChild.isBlockBoundary
							  && cellFirstChild.isBlockBoundary( { br : 1 } ) ) )
					{
						var last = frag.getLast( CKEDITOR.dom.walker.whitespaces( true ) );
						if ( last && !( last.is && last.is( 'br' ) ) )
							frag.append( new CKEDITOR.dom.element( 'br' ) );
					}

					cell.moveChildren( frag );
				}
				i ? cell.remove() : cell.setHtml( '' );
			}
			lastRowIndex = rowIndex;
		}

		if ( !isDetect )
		{
			frag.moveChildren( firstCell );

			if ( !CKEDITOR.env.ie )
				firstCell.appendBogus();

			if ( totalColSpan >= mapWidth )
				firstCell.removeAttribute( 'rowSpan' );
			else
				firstCell.$.rowSpan = totalRowSpan;

			if ( totalRowSpan >= mapHeight )
				firstCell.removeAttribute( 'colSpan' );
			else
				firstCell.$.colSpan = totalColSpan;

			// Swip empty <tr> left at the end of table due to the merging.
			var trs = new CKEDITOR.dom.nodeList( table.$.rows ),
				count = trs.count();

			for ( i = count - 1; i >= 0; i-- )
			{
				var tailTr = trs.getItem( i );
				if ( !tailTr.$.cells.length )
				{
					tailTr.remove();
					count++;
					continue;
				}
			}

			return firstCell;
		}
		// Be able to merge cells only if actual dimension of selected
		// cells equals to the caculated rectangle.
		else
			return ( totalRowSpan * totalColSpan ) == dimension;
	}

	function verticalSplitCell ( selection, isDetect )
	{
		var cells = getSelectedCells( selection );
		if ( cells.length > 1 )
			return false;
		else if ( isDetect )
			return true;

		var cell = cells[ 0 ],
			tr = cell.getParent(),
			table = tr.getAscendant( 'table' ),
			map = CKEDITOR.tools.buildTableMap( table ),
			rowIndex = tr.$.rowIndex,
			colIndex = cellInRow( map, rowIndex, cell ),
			rowSpan = cell.$.rowSpan,
			newCell,
			newRowSpan,
			newCellRowSpan,
			newRowIndex;

		if ( rowSpan > 1 )
		{
			newRowSpan = Math.ceil( rowSpan / 2 );
			newCellRowSpan = Math.floor( rowSpan / 2 );
			newRowIndex = rowIndex + newRowSpan;
			var newCellTr = new CKEDITOR.dom.element( table.$.rows[ newRowIndex ] ),
				newCellRow = cellInRow( map, newRowIndex ),
				candidateCell;

			newCell = cell.clone();

			// Figure out where to insert the new cell by checking the vitual row.
			for ( var c = 0; c < newCellRow.length; c++ )
			{
				candidateCell = newCellRow[ c ];
				// Catch first cell actually following the column.
				if ( candidateCell.parentNode == newCellTr.$
					&& c > colIndex )
				{
					newCell.insertBefore( new CKEDITOR.dom.element( candidateCell ) );
					break;
				}
				else
					candidateCell = null;
			}

			// The destination row is empty, append at will.
			if ( !candidateCell )
				newCellTr.append( newCell, true );
		}
		else
		{
			newCellRowSpan = newRowSpan = 1;

			newCellTr = tr.clone();
			newCellTr.insertAfter( tr );
			newCellTr.append( newCell = cell.clone() );

			var cellsInSameRow = cellInRow( map, rowIndex );
			for ( var i = 0; i < cellsInSameRow.length; i++ )
				cellsInSameRow[ i ].rowSpan++;
		}

		if ( !CKEDITOR.env.ie )
			newCell.appendBogus();

		cell.$.rowSpan = newRowSpan;
		newCell.$.rowSpan = newCellRowSpan;
		if ( newRowSpan == 1 )
			cell.removeAttribute( 'rowSpan' );
		if ( newCellRowSpan == 1 )
			newCell.removeAttribute( 'rowSpan' );

		return newCell;
	}

	function horizontalSplitCell( selection, isDetect )
	{
		var cells = getSelectedCells( selection );
		if ( cells.length > 1 )
			return false;
		else if ( isDetect )
			return true;

		var cell = cells[ 0 ],
			tr = cell.getParent(),
			table = tr.getAscendant( 'table' ),
			map = CKEDITOR.tools.buildTableMap( table ),
			rowIndex = tr.$.rowIndex,
			colIndex = cellInRow( map, rowIndex, cell ),
			colSpan = cell.$.colSpan,
			newCell,
			newColSpan,
			newCellColSpan;

		if ( colSpan > 1 )
		{
			newColSpan = Math.ceil( colSpan / 2 );
			newCellColSpan = Math.floor( colSpan / 2 );
		}
		else
		{
			newCellColSpan = newColSpan = 1;
			var cellsInSameCol = cellInCol( map, colIndex );
			for ( var i = 0; i < cellsInSameCol.length; i++ )
				cellsInSameCol[ i ].colSpan++;
		}
		newCell = cell.clone();
		newCell.insertAfter( cell );
		if ( !CKEDITOR.env.ie )
			newCell.appendBogus();

		cell.$.colSpan = newColSpan;
		newCell.$.colSpan = newCellColSpan;
		if ( newColSpan == 1 )
			cell.removeAttribute( 'colSpan' );
		if ( newCellColSpan == 1 )
			newCell.removeAttribute( 'colSpan' );

		return newCell;
	}
	// Context menu on table caption incorrect (#3834)
	var contextMenuTags = { thead : 1, tbody : 1, tfoot : 1, td : 1, tr : 1, th : 1 };

	CKEDITOR.plugins.tabletools =
	{
		init : function( editor )
		{
			var lang = editor.lang.table;

			editor.addCommand( 'cellProperties', new CKEDITOR.dialogCommand( 'cellProperties' ) );
			CKEDITOR.dialog.add( 'cellProperties', this.path + 'dialogs/tableCell.js' );

			editor.addCommand( 'tableDelete',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection(),
							startElement = selection && selection.getStartElement(),
							table = startElement && startElement.getAscendant( 'table', 1 );

						if ( !table )
							return;

						// Maintain the selection point at where the table was deleted.
						selection.selectElement( table );
						var range = selection.getRanges()[0];
						range.collapse();
						selection.selectRanges( [ range ] );

						// If the table's parent has only one child remove it as well (unless it's the body or a table cell) (#5416, #6289)
						var parent = table.getParent();
						if ( parent.getChildCount() == 1 && !parent.is( 'body', 'td', 'th' ) )
							parent.remove();
						else
							table.remove();
					}
				} );

			editor.addCommand( 'rowDelete',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						placeCursorInCell( deleteRows( selection ) );
					}
				} );

			editor.addCommand( 'rowInsertBefore',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertRow( selection, true );
					}
				} );

			editor.addCommand( 'rowInsertAfter',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertRow( selection );
					}
				} );

			editor.addCommand( 'columnDelete',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						var element = deleteColumns( selection );
						element &&  placeCursorInCell( element, true );
					}
				} );

			editor.addCommand( 'columnInsertBefore',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertColumn( selection, true );
					}
				} );

			editor.addCommand( 'columnInsertAfter',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertColumn( selection );
					}
				} );

			editor.addCommand( 'cellDelete',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						deleteCells( selection );
					}
				} );

			editor.addCommand( 'cellMerge',
				{
					exec : function( editor )
					{
						placeCursorInCell( mergeCells( editor.getSelection() ), true );
					}
				} );

			editor.addCommand( 'cellMergeRight',
				{
					exec : function( editor )
					{
						placeCursorInCell( mergeCells( editor.getSelection(), 'right' ), true );
					}
				} );

			editor.addCommand( 'cellMergeDown',
				{
					exec : function( editor )
					{
						placeCursorInCell( mergeCells( editor.getSelection(), 'down' ), true );
					}
				} );

			editor.addCommand( 'cellVerticalSplit',
				{
					exec : function( editor )
					{
						placeCursorInCell( verticalSplitCell( editor.getSelection() ) );
					}
				} );

			editor.addCommand( 'cellHorizontalSplit',
				{
					exec : function( editor )
					{
						placeCursorInCell( horizontalSplitCell( editor.getSelection() ) );
					}
				} );

			editor.addCommand( 'cellInsertBefore',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertCell( selection, true );
					}
				} );

			editor.addCommand( 'cellInsertAfter',
				{
					exec : function( editor )
					{
						var selection = editor.getSelection();
						insertCell( selection );
					}
				} );

			// If the "menu" plugin is loaded, register the menu items.
			if ( editor.addMenuItems )
			{
				editor.addMenuItems(
					{
						tablecell :
						{
							label : lang.cell.menu,
							group : 'tablecell',
							order : 1,
							getItems : function()
							{
								var selection = editor.getSelection(),
									cells = getSelectedCells( selection );
								return {
									tablecell_insertBefore : CKEDITOR.TRISTATE_OFF,
									tablecell_insertAfter : CKEDITOR.TRISTATE_OFF,
									tablecell_delete : CKEDITOR.TRISTATE_OFF,
									tablecell_merge : mergeCells( selection, null, true ) ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
									tablecell_merge_right : mergeCells( selection, 'right', true ) ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
									tablecell_merge_down : mergeCells( selection, 'down', true ) ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
									tablecell_split_vertical : verticalSplitCell( selection, true ) ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
									tablecell_split_horizontal : horizontalSplitCell( selection, true ) ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED,
									tablecell_properties : cells.length > 0 ? CKEDITOR.TRISTATE_OFF : CKEDITOR.TRISTATE_DISABLED
								};
							}
						},

						tablecell_insertBefore :
						{
							label : lang.cell.insertBefore,
							group : 'tablecell',
							command : 'cellInsertBefore',
							order : 5
						},

						tablecell_insertAfter :
						{
							label : lang.cell.insertAfter,
							group : 'tablecell',
							command : 'cellInsertAfter',
							order : 10
						},

						tablecell_delete :
						{
							label : lang.cell.deleteCell,
							group : 'tablecell',
							command : 'cellDelete',
							order : 15
						},

						tablecell_merge :
						{
							label : lang.cell.merge,
							group : 'tablecell',
							command : 'cellMerge',
							order : 16
						},

						tablecell_merge_right :
						{
							label : lang.cell.mergeRight,
							group : 'tablecell',
							command : 'cellMergeRight',
							order : 17
						},

						tablecell_merge_down :
						{
							label : lang.cell.mergeDown,
							group : 'tablecell',
							command : 'cellMergeDown',
							order : 18
						},

						tablecell_split_horizontal :
						{
							label : lang.cell.splitHorizontal,
							group : 'tablecell',
							command : 'cellHorizontalSplit',
							order : 19
						},

						tablecell_split_vertical :
						{
							label : lang.cell.splitVertical,
							group : 'tablecell',
							command : 'cellVerticalSplit',
							order : 20
						},

						tablecell_properties :
						{
							label : lang.cell.title,
							group : 'tablecellproperties',
							command : 'cellProperties',
							order : 21
						},

						tablerow :
						{
							label : lang.row.menu,
							group : 'tablerow',
							order : 1,
							getItems : function()
							{
								return {
									tablerow_insertBefore : CKEDITOR.TRISTATE_OFF,
									tablerow_insertAfter : CKEDITOR.TRISTATE_OFF,
									tablerow_delete : CKEDITOR.TRISTATE_OFF
								};
							}
						},

						tablerow_insertBefore :
						{
							label : lang.row.insertBefore,
							group : 'tablerow',
							command : 'rowInsertBefore',
							order : 5
						},

						tablerow_insertAfter :
						{
							label : lang.row.insertAfter,
							group : 'tablerow',
							command : 'rowInsertAfter',
							order : 10
						},

						tablerow_delete :
						{
							label : lang.row.deleteRow,
							group : 'tablerow',
							command : 'rowDelete',
							order : 15
						},

						tablecolumn :
						{
							label : lang.column.menu,
							group : 'tablecolumn',
							order : 1,
							getItems : function()
							{
								return {
									tablecolumn_insertBefore : CKEDITOR.TRISTATE_OFF,
									tablecolumn_insertAfter : CKEDITOR.TRISTATE_OFF,
									tablecolumn_delete : CKEDITOR.TRISTATE_OFF
								};
							}
						},

						tablecolumn_insertBefore :
						{
							label : lang.column.insertBefore,
							group : 'tablecolumn',
							command : 'columnInsertBefore',
							order : 5
						},

						tablecolumn_insertAfter :
						{
							label : lang.column.insertAfter,
							group : 'tablecolumn',
							command : 'columnInsertAfter',
							order : 10
						},

						tablecolumn_delete :
						{
							label : lang.column.deleteColumn,
							group : 'tablecolumn',
							command : 'columnDelete',
							order : 15
						}
					});
			}

			// If the "contextmenu" plugin is laoded, register the listeners.
			if ( editor.contextMenu )
			{
				editor.contextMenu.addListener( function( element, selection )
					{
						if ( !element || element.isReadOnly() )
							return null;

						while ( element )
						{
							if ( element.getName() in contextMenuTags )
							{
								return {
									tablecell : CKEDITOR.TRISTATE_OFF,
									tablerow : CKEDITOR.TRISTATE_OFF,
									tablecolumn : CKEDITOR.TRISTATE_OFF
								};
							}
							element = element.getParent();
						}

						return null;
					} );
			}
		},

		getSelectedCells : getSelectedCells

	};
	CKEDITOR.plugins.add( 'tabletools', CKEDITOR.plugins.tabletools );
})();

/**
 * Create a two-dimension array that reflects the actual layout of table cells,
 * with cell spans, with mappings to the original td elements.
 * @param table {CKEDITOR.dom.element}
 */
CKEDITOR.tools.buildTableMap = function ( table )
{
	var aRows = table.$.rows ;

	// Row and Column counters.
	var r = -1 ;

	var aMap = [];

	for ( var i = 0 ; i < aRows.length ; i++ )
	{
		r++ ;
		!aMap[r] && ( aMap[r] = [] );

		var c = -1 ;

		for ( var j = 0 ; j < aRows[i].cells.length ; j++ )
		{
			var oCell = aRows[i].cells[j] ;

			c++ ;
			while ( aMap[r][c] )
				c++ ;

			var iColSpan = isNaN( oCell.colSpan ) ? 1 : oCell.colSpan ;
			var iRowSpan = isNaN( oCell.rowSpan ) ? 1 : oCell.rowSpan ;

			for ( var rs = 0 ; rs < iRowSpan ; rs++ )
			{
				if ( !aMap[r + rs] )
					aMap[r + rs] = [];

				for ( var cs = 0 ; cs < iColSpan ; cs++ )
				{
					aMap[r + rs][c + cs] = aRows[i].cells[j] ;
				}
			}

			c += iColSpan - 1 ;
		}
	}
	return aMap ;
};
