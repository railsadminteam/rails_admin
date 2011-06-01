﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	/**
	 * Represents a list os CKEDITOR.dom.range objects, which can be easily
	 * iterated sequentially.
	 * @constructor
	 * @param {CKEDITOR.dom.range|Array} [ranges] The ranges contained on this list.
	 *		Note that, if an array of ranges is specified, the range sequence
	 *		should match its DOM order. This class will not help to sort them.
	 */
	CKEDITOR.dom.rangeList = function( ranges )
	{
		if ( ranges instanceof CKEDITOR.dom.rangeList )
			return ranges;

		if ( !ranges )
			ranges = [];
		else if ( ranges instanceof CKEDITOR.dom.range )
			ranges = [ ranges ];

		return CKEDITOR.tools.extend( ranges, mixins );
	};

	var mixins =
	/** @lends CKEDITOR.dom.rangeList.prototype */
	{
			/**
			 * Creates an instance of the rangeList iterator, it should be used
			 * only when the ranges processing could be DOM intrusive, which
			 * means it may pollute and break other ranges in this list.
			 * Otherwise, it's enough to just iterate over this array in a for loop.
			 * @returns {CKEDITOR.dom.rangeListIterator}
			 */
			createIterator : function()
			{
				var rangeList = this,
					bookmark = CKEDITOR.dom.walker.bookmark(),
					guard = function( node ) { return ! ( node.is && node.is( 'tr' ) ); },
						bookmarks = [],
					current;

				/**
				 * @lends CKEDITOR.dom.rangeListIterator.prototype
				 */
				return {

					/**
					 * Retrieves the next range in the list.
					 * @param {Boolean} mergeConsequent Whether join two adjacent ranges into single, e.g. consequent table cells.
					 */
					getNextRange : function( mergeConsequent )
					{
						current = current == undefined ? 0 : current + 1;

						var range = rangeList[ current ];

						// Multiple ranges might be mangled by each other.
						if ( range && rangeList.length > 1 )
						{
							// Bookmarking all other ranges on the first iteration,
							// the range correctness after it doesn't matter since we'll
							// restore them before the next iteration.
							if ( !current )
							{
								// Make sure bookmark correctness by reverse processing.
								for ( var i = rangeList.length - 1; i >= 0; i-- )
									bookmarks.unshift( rangeList[ i ].createBookmark( true ) );
							}

							if ( mergeConsequent )
							{
								// Figure out how many ranges should be merged.
								var mergeCount = 0;
								while ( rangeList[ current + mergeCount + 1 ] )
								{
									var doc = range.document,
										found = 0,
										left =  doc.getById( bookmarks[ mergeCount ].endNode ),
										right = doc.getById( bookmarks[ mergeCount + 1 ].startNode ),
										next;

									// Check subsequent range.
									while ( 1 )
									{
										next = left.getNextSourceNode( false );
										if ( !right.equals( next ) )
										{
											// This could be yet another bookmark or
											// walking across block boundaries.
											if ( bookmark( next ) || ( next.type == CKEDITOR.NODE_ELEMENT && next.isBlockBoundary() ) )
											{
												left = next;
												continue;
											}
										}
										else
											found = 1;

										break;
									}

									if ( !found )
										break;

									mergeCount++;
								}
							}

							range.moveToBookmark( bookmarks.shift() );

							// Merge ranges finally after moving to bookmarks.
							while( mergeCount-- )
							{
								next = rangeList[ ++current ];
								next.moveToBookmark( bookmarks.shift() );
								range.setEnd( next.endContainer, next.endOffset );
							}
						}

						return range;
					}
				};
			},

			createBookmarks : function( serializable )
			{
				var retval = [], bookmark;
				for ( var i = 0; i < this.length ; i++ )
				{
					retval.push( bookmark = this[ i ].createBookmark( serializable, true) );

					// Updating the container & offset values for ranges
					// that have been touched.
					for ( var j = i + 1; j < this.length; j++ )
					{
						this[ j ] = updateDirtyRange( bookmark, this[ j ] );
						this[ j ] = updateDirtyRange( bookmark, this[ j ], true );
					}
				}
				return retval;
			},

			createBookmarks2 : function( normalized )
			{
				var bookmarks = [];

				for ( var i = 0 ; i < this.length ; i++ )
					bookmarks.push( this[ i ].createBookmark2( normalized ) );

				return bookmarks;
			},

			/**
			 * Move each range in the list to the position specified by a list of bookmarks.
			 * @param {Array} bookmarks The list of bookmarks, each one matching a range in the list.
			 */
			moveToBookmarks :  function( bookmarks )
			{
				for ( var i = 0 ; i < this.length ; i++ )
					this[ i ].moveToBookmark( bookmarks[ i ] );
			}
	};

	// Update the specified range which has been mangled by previous insertion of
	// range bookmark nodes.(#3256)
	function updateDirtyRange( bookmark, dirtyRange, checkEnd )
	{
		var serializable = bookmark.serializable,
			container = dirtyRange[ checkEnd ? 'endContainer' : 'startContainer' ],
			offset = checkEnd ? 'endOffset' : 'startOffset';

		var bookmarkStart = serializable ?
				dirtyRange.document.getById( bookmark.startNode )
				: bookmark.startNode;

		var bookmarkEnd = serializable ?
				dirtyRange.document.getById( bookmark.endNode )
				: bookmark.endNode;

		if ( container.equals( bookmarkStart.getPrevious() ) )
		{
			dirtyRange.startOffset = dirtyRange.startOffset
					- container.getLength()
					- bookmarkEnd.getPrevious().getLength();
			container = bookmarkEnd.getNext();
		}
		else if ( container.equals( bookmarkEnd.getPrevious() ) )
		{
			dirtyRange.startOffset = dirtyRange.startOffset - container.getLength();
			container = bookmarkEnd.getNext();
		}

		container.equals( bookmarkStart.getParent() ) && dirtyRange[ offset ]++;
		container.equals( bookmarkEnd.getParent() ) && dirtyRange[ offset ]++;

		// Update and return this range.
		dirtyRange[ checkEnd ? 'endContainer' : 'startContainer' ] = container;
		return dirtyRange;
	}
})();

/**
 * (Virtual Class) Do not call this constructor. This class is not really part
 *	of the API. It just describes the return type of {@link CKEDITOR.dom.rangeList#createIterator}.
 * @name CKEDITOR.dom.rangeListIterator
 * @constructor
 * @example
 */
