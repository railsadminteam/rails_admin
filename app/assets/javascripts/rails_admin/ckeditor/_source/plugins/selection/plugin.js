/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	// #### checkSelectionChange : START

	// The selection change check basically saves the element parent tree of
	// the current node and check it on successive requests. If there is any
	// change on the tree, then the selectionChange event gets fired.
	function checkSelectionChange()
	{
		try
		{
			// In IE, the "selectionchange" event may still get thrown when
			// releasing the WYSIWYG mode, so we need to check it first.
			var sel = this.getSelection();
			if ( !sel || !sel.document.getWindow().$ )
				return;

			var firstElement = sel.getStartElement();
			var currentPath = new CKEDITOR.dom.elementPath( firstElement );

			if ( !currentPath.compare( this._.selectionPreviousPath ) )
			{
				this._.selectionPreviousPath = currentPath;
				this.fire( 'selectionChange', { selection : sel, path : currentPath, element : firstElement } );
			}
		}
		catch (e)
		{}
	}

	var checkSelectionChangeTimer,
		checkSelectionChangeTimeoutPending;

	function checkSelectionChangeTimeout()
	{
		// Firing the "OnSelectionChange" event on every key press started to
		// be too slow. This function guarantees that there will be at least
		// 200ms delay between selection checks.

		checkSelectionChangeTimeoutPending = true;

		if ( checkSelectionChangeTimer )
			return;

		checkSelectionChangeTimeoutExec.call( this );

		checkSelectionChangeTimer = CKEDITOR.tools.setTimeout( checkSelectionChangeTimeoutExec, 200, this );
	}

	function checkSelectionChangeTimeoutExec()
	{
		checkSelectionChangeTimer = null;

		if ( checkSelectionChangeTimeoutPending )
		{
			// Call this with a timeout so the browser properly moves the
			// selection after the mouseup. It happened that the selection was
			// being moved after the mouseup when clicking inside selected text
			// with Firefox.
			CKEDITOR.tools.setTimeout( checkSelectionChange, 0, this );

			checkSelectionChangeTimeoutPending = false;
		}
	}

	// #### checkSelectionChange : END

	function rangeRequiresFix( range )
	{
		function isInlineCt( node )
		{
			return node && node.type == CKEDITOR.NODE_ELEMENT
					&& node.getName() in CKEDITOR.dtd.$removeEmpty;
		}

		var start = range.startContainer,
			offset = range.startOffset;

		if ( start.type == CKEDITOR.NODE_TEXT )
			return false;

		// 1. Empty inline element. <span>^</span>
		// 2. Adjoin to inline element. <p><strong>text</strong>^</p>
		return !CKEDITOR.tools.trim( start.getHtml() ) ? isInlineCt( start ) : isInlineCt( start.getChild( offset - 1 ) ) || isInlineCt( start.getChild( offset ) );
	}

	var selectAllCmd =
	{
		modes : { wysiwyg : 1, source : 1 },
		readOnly : CKEDITOR.env.ie || CKEDITOR.env.webkit,
		exec : function( editor )
		{
			switch ( editor.mode )
			{
				case 'wysiwyg' :
					editor.document.$.execCommand( 'SelectAll', false, null );
					// Force triggering selectionChange (#7008)
					editor.forceNextSelectionCheck();
					editor.selectionChange();
					break;
				case 'source' :
					// Select the contents of the textarea
					var textarea = editor.textarea.$;
					if ( CKEDITOR.env.ie )
						textarea.createTextRange().execCommand( 'SelectAll' );
					else
					{
						textarea.selectionStart = 0;
						textarea.selectionEnd = textarea.value.length;
					}
					textarea.focus();
			}
		},
		canUndo : false
	};

	function createFillingChar( doc )
	{
		removeFillingChar( doc );

		var fillingChar = doc.createText( '\u200B' );
		doc.setCustomData( 'cke-fillingChar', fillingChar );

		return fillingChar;
	}

	function getFillingChar( doc )
	{
		return doc && doc.getCustomData( 'cke-fillingChar' );
	}

	// Checks if a filling char has been used, eventualy removing it (#1272).
	function checkFillingChar( doc )
	{
		var fillingChar = doc && getFillingChar( doc );
		if ( fillingChar )
		{
			// Use this flag to avoid removing the filling char right after
			// creating it.
			if ( fillingChar.getCustomData( 'ready' ) )
				removeFillingChar( doc );
			else
				fillingChar.setCustomData( 'ready', 1 );
		}
	}

	function removeFillingChar( doc )
	{
		var fillingChar = doc && doc.removeCustomData( 'cke-fillingChar' );
		if ( fillingChar )
		{
			// We can't simply remove the filling node because the user
			// will actually enlarge it when typing, so we just remove the
			// invisible char from it.
			fillingChar.setText( fillingChar.getText().replace( /\u200B/g, '' ) );
			fillingChar = 0;
		}
	}

	CKEDITOR.plugins.add( 'selection',
	{
		init : function( editor )
		{
			// On WebKit only, we need a special "filling" char on some situations
			// (#1272). Here we set the events that should invalidate that char.
			if ( CKEDITOR.env.webkit )
			{
				editor.on( 'selectionChange', function() { checkFillingChar( editor.document ); } );
				editor.on( 'beforeSetMode', function() { removeFillingChar( editor.document ); } );
				editor.on( 'key', function( e )
					{
						// Remove the filling char before some keys get
						// executed, so they'll not get blocked by it.
						switch ( e.data.keyCode )
						{
							case 13 :	// ENTER
							case CKEDITOR.SHIFT + 13 :	// SHIFT-ENTER
							case 37 :	// LEFT-ARROW
							case 39 :	// RIGHT-ARROW
							case 8 :	// BACKSPACE
								removeFillingChar( editor.document );
						}
					}, null, null, 10 );

				var fillingCharBefore,
					resetSelection;

				function beforeData()
				{
					var doc = editor.document,
						fillingChar = getFillingChar( doc );

					if ( fillingChar )
					{
						// If cursor is right blinking by side of the filler node, save it for restoring,
						// as the following text substitution will blind it. (#7437)
						var sel = doc.$.defaultView.getSelection();
						if ( sel.type == 'Caret' && sel.anchorNode == fillingChar.$ )
							resetSelection = 1;

						fillingCharBefore = fillingChar.getText();
						fillingChar.setText( fillingCharBefore.replace( /\u200B/g, '' ) );
					}
				}
				function afterData()
				{
					var doc = editor.document,
						fillingChar = getFillingChar( doc );

					if ( fillingChar )
					{
						fillingChar.setText( fillingCharBefore );

						if ( resetSelection )
						{
							doc.$.defaultView.getSelection().setPosition( fillingChar.$,fillingChar.getLength() );
							resetSelection = 0;
						}
					}
				}
				editor.on( 'beforeUndoImage', beforeData );
				editor.on( 'afterUndoImage', afterData );
				editor.on( 'beforeGetData', beforeData, null, null, 0 );
				editor.on( 'getData', afterData );
			}

			editor.on( 'contentDom', function()
				{
					var doc = editor.document,
						body = doc.getBody(),
						html = doc.getDocumentElement();

					if ( CKEDITOR.env.ie )
					{
						// Other browsers don't loose the selection if the
						// editor document loose the focus. In IE, we don't
						// have support for it, so we reproduce it here, other
						// than firing the selection change event.

						var savedRange,
							saveEnabled,
							restoreEnabled = 1;

						// "onfocusin" is fired before "onfocus". It makes it
						// possible to restore the selection before click
						// events get executed.
						body.on( 'focusin', function( evt )
							{
								// If there are elements with layout they fire this event but
								// it must be ignored to allow edit its contents #4682
								if ( evt.data.$.srcElement.nodeName != 'BODY' )
									return;

								// If we have saved a range, restore it at this
								// point.
								if ( savedRange )
								{
									if ( restoreEnabled )
									{
										// Well not break because of this.
										try
										{
											savedRange.select();
										}
										catch (e)
										{}

										// Update locked selection because of the normalized text nodes. (#6083, #6987)
										var lockedSelection = doc.getCustomData( 'cke_locked_selection' );
										if ( lockedSelection )
										{
											lockedSelection.unlock();
											lockedSelection.lock();
										}
									}

									savedRange = null;
								}
							});

						body.on( 'focus', function()
							{
								// Enable selections to be saved.
								saveEnabled = 1;

								saveSelection();
							});

						body.on( 'beforedeactivate', function( evt )
							{
								// Ignore this event if it's caused by focus switch between
								// internal editable control type elements, e.g. layouted paragraph. (#4682)
								if ( evt.data.$.toElement )
									return;

								// Disable selections from being saved.
								saveEnabled = 0;
								restoreEnabled = 1;
							});

						// IE before version 8 will leave cursor blinking inside the document after
						// editor blurred unless we clean up the selection. (#4716)
						if ( CKEDITOR.env.ie && CKEDITOR.env.version < 8 )
						{
							editor.on( 'blur', function( evt )
							{
								// Try/Catch to avoid errors if the editor is hidden. (#6375)
								try
								{
									editor.document && editor.document.$.selection.empty();
								}
								catch (e) {}
							});
						}

						// Listening on document element ensures that
						// scrollbar is included. (#5280)
						html.on( 'mousedown', function()
						{
							// Lock restore selection now, as we have
							// a followed 'click' event which introduce
							// new selection. (#5735)
							restoreEnabled = 0;
						});

						html.on( 'mouseup', function()
						{
							restoreEnabled = 1;
						});

						// In IE6/7 the blinking cursor appears, but contents are
						// not editable. (#5634)
						if ( CKEDITOR.env.ie && ( CKEDITOR.env.ie7Compat || CKEDITOR.env.version < 8 || CKEDITOR.env.quirks ) )
						{
							// The 'click' event is not fired when clicking the
							// scrollbars, so we can use it to check whether
							// the empty space following <body> has been clicked.
							html.on( 'click', function( evt )
							{
								if ( evt.data.getTarget().getName() == 'html' )
									editor.getSelection().getRanges()[ 0 ].select();
							});
						}

						var scroll;
						// IE fires the "selectionchange" event when clicking
						// inside a selection. We don't want to capture that.
						body.on( 'mousedown', function( evt )
						{
							// IE scrolls document to top on right mousedown
							// when editor has no focus, remember this scroll
							// position and revert it before context menu opens. (#5778)
							if ( evt.data.$.button == 2 )
							{
								var sel = editor.document.$.selection;
								if ( sel.type == 'None' )
									scroll = editor.window.getScrollPosition();
							}
							disableSave();
						});

						body.on( 'mouseup',
							function( evt )
							{
								// Restore recorded scroll position when needed on right mouseup.
								if ( evt.data.$.button == 2 && scroll )
								{
									editor.document.$.documentElement.scrollLeft = scroll.x;
									editor.document.$.documentElement.scrollTop = scroll.y;
								}
								scroll = null;

								saveEnabled = 1;
								setTimeout( function()
									{
										saveSelection( true );
									},
									0 );
							});

						body.on( 'keydown', disableSave );
						body.on( 'keyup',
							function()
							{
								saveEnabled = 1;
								saveSelection();
							});


						// IE is the only to provide the "selectionchange"
						// event.
						doc.on( 'selectionchange', saveSelection );

						function disableSave()
						{
							saveEnabled = 0;
						}

						function saveSelection( testIt )
						{
							if ( saveEnabled )
							{
								var doc = editor.document,
									sel = editor.getSelection(),
									nativeSel = sel && sel.getNative();

								// There is a very specific case, when clicking
								// inside a text selection. In that case, the
								// selection collapses at the clicking point,
								// but the selection object remains in an
								// unknown state, making createRange return a
								// range at the very start of the document. In
								// such situation we have to test the range, to
								// be sure it's valid.
								if ( testIt && nativeSel && nativeSel.type == 'None' )
								{
									// The "InsertImage" command can be used to
									// test whether the selection is good or not.
									// If not, it's enough to give some time to
									// IE to put things in order for us.
									if ( !doc.$.queryCommandEnabled( 'InsertImage' ) )
									{
										CKEDITOR.tools.setTimeout( saveSelection, 50, this, true );
										return;
									}
								}

								// Avoid saving selection from within text input. (#5747)
								var parentTag;
								if ( nativeSel && nativeSel.type && nativeSel.type != 'Control'
									&& ( parentTag = nativeSel.createRange() )
									&& ( parentTag = parentTag.parentElement() )
									&& ( parentTag = parentTag.nodeName )
									&& parentTag.toLowerCase() in { input: 1, textarea : 1 } )
								{
									return;
								}

								savedRange = nativeSel && sel.getRanges()[ 0 ];

								checkSelectionChangeTimeout.call( editor );
							}
						}
					}
					else
					{
						// In other browsers, we make the selection change
						// check based on other events, like clicks or keys
						// press.

						doc.on( 'mouseup', checkSelectionChangeTimeout, editor );
						doc.on( 'keyup', checkSelectionChangeTimeout, editor );
					}
				});

			// Clear the cached range path before unload. (#7174)
			editor.on( 'contentDomUnload', editor.forceNextSelectionCheck, editor );

			editor.addCommand( 'selectAll', selectAllCmd );
			editor.ui.addButton( 'SelectAll',
				{
					label : editor.lang.selectAll,
					command : 'selectAll'
				});

			editor.selectionChange = checkSelectionChangeTimeout;
		}
	});

	/**
	 * Gets the current selection from the editing area when in WYSIWYG mode.
	 * @returns {CKEDITOR.dom.selection} A selection object or null if not on
	 *		WYSIWYG mode or no selection is available.
	 * @example
	 * var selection = CKEDITOR.instances.editor1.<b>getSelection()</b>;
	 * alert( selection.getType() );
	 */
	CKEDITOR.editor.prototype.getSelection = function()
	{
		return this.document && this.document.getSelection();
	};

	CKEDITOR.editor.prototype.forceNextSelectionCheck = function()
	{
		delete this._.selectionPreviousPath;
	};

	/**
	 * Gets the current selection from the document.
	 * @returns {CKEDITOR.dom.selection} A selection object.
	 * @example
	 * var selection = CKEDITOR.instances.editor1.document.<b>getSelection()</b>;
	 * alert( selection.getType() );
	 */
	CKEDITOR.dom.document.prototype.getSelection = function()
	{
		var sel = new CKEDITOR.dom.selection( this );
		return ( !sel || sel.isInvalid ) ? null : sel;
	};

	/**
	 * No selection.
	 * @constant
	 * @example
	 * if ( editor.getSelection().getType() == CKEDITOR.SELECTION_NONE )
	 *     alert( 'Nothing is selected' );
	 */
	CKEDITOR.SELECTION_NONE		= 1;

	/**
	 * Text or collapsed selection.
	 * @constant
	 * @example
	 * if ( editor.getSelection().getType() == CKEDITOR.SELECTION_TEXT )
	 *     alert( 'Text is selected' );
	 */
	CKEDITOR.SELECTION_TEXT		= 2;

	/**
	 * Element selection.
	 * @constant
	 * @example
	 * if ( editor.getSelection().getType() == CKEDITOR.SELECTION_ELEMENT )
	 *     alert( 'An element is selected' );
	 */
	CKEDITOR.SELECTION_ELEMENT	= 3;

	/**
	 * Manipulates the selection in a DOM document.
	 * @constructor
	 * @example
	 */
	CKEDITOR.dom.selection = function( document )
	{
		var lockedSelection = document.getCustomData( 'cke_locked_selection' );

		if ( lockedSelection )
			return lockedSelection;

		this.document = document;
		this.isLocked = 0;
		this._ =
		{
			cache : {}
		};

		/**
		 * IE BUG: The selection's document may be a different document than the
		 * editor document. Return null if that's the case.
		 */
		if ( CKEDITOR.env.ie )
		{
			var range = this.getNative().createRange();
			if ( !range
				|| ( range.item && range.item(0).ownerDocument != this.document.$ )
				|| ( range.parentElement && range.parentElement().ownerDocument != this.document.$ ) )
			{
				this.isInvalid = true;
			}
		}

		return this;
	};

	var styleObjectElements =
		{
			img:1,hr:1,li:1,table:1,tr:1,td:1,th:1,embed:1,object:1,ol:1,ul:1,
			a:1,input:1,form:1,select:1,textarea:1,button:1,fieldset:1,thead:1,tfoot:1
		};

	CKEDITOR.dom.selection.prototype =
	{
		/**
		 * Gets the native selection object from the browser.
		 * @function
		 * @returns {Object} The native selection object.
		 * @example
		 * var selection = editor.getSelection().<b>getNative()</b>;
		 */
		getNative :
			CKEDITOR.env.ie ?
				function()
				{
					return this._.cache.nativeSel || ( this._.cache.nativeSel = this.document.$.selection );
				}
			:
				function()
				{
					return this._.cache.nativeSel || ( this._.cache.nativeSel = this.document.getWindow().$.getSelection() );
				},

		/**
		 * Gets the type of the current selection. The following values are
		 * available:
		 * <ul>
		 *		<li>{@link CKEDITOR.SELECTION_NONE} (1): No selection.</li>
		 *		<li>{@link CKEDITOR.SELECTION_TEXT} (2): Text is selected or
		 *			collapsed selection.</li>
		 *		<li>{@link CKEDITOR.SELECTION_ELEMENT} (3): A element
		 *			selection.</li>
		 * </ul>
		 * @function
		 * @returns {Number} One of the following constant values:
		 *		{@link CKEDITOR.SELECTION_NONE}, {@link CKEDITOR.SELECTION_TEXT} or
		 *		{@link CKEDITOR.SELECTION_ELEMENT}.
		 * @example
		 * if ( editor.getSelection().<b>getType()</b> == CKEDITOR.SELECTION_TEXT )
		 *     alert( 'Text is selected' );
		 */
		getType :
			CKEDITOR.env.ie ?
				function()
				{
					var cache = this._.cache;
					if ( cache.type )
						return cache.type;

					var type = CKEDITOR.SELECTION_NONE;

					try
					{
						var sel = this.getNative(),
							ieType = sel.type;

						if ( ieType == 'Text' )
							type = CKEDITOR.SELECTION_TEXT;

						if ( ieType == 'Control' )
							type = CKEDITOR.SELECTION_ELEMENT;

						// It is possible that we can still get a text range
						// object even when type == 'None' is returned by IE.
						// So we'd better check the object returned by
						// createRange() rather than by looking at the type.
						if ( sel.createRange().parentElement )
							type = CKEDITOR.SELECTION_TEXT;
					}
					catch(e) {}

					return ( cache.type = type );
				}
			:
				function()
				{
					var cache = this._.cache;
					if ( cache.type )
						return cache.type;

					var type = CKEDITOR.SELECTION_TEXT;

					var sel = this.getNative();

					if ( !sel )
						type = CKEDITOR.SELECTION_NONE;
					else if ( sel.rangeCount == 1 )
					{
						// Check if the actual selection is a control (IMG,
						// TABLE, HR, etc...).

						var range = sel.getRangeAt(0),
							startContainer = range.startContainer;

						if ( startContainer == range.endContainer
							&& startContainer.nodeType == 1
							&& ( range.endOffset - range.startOffset ) == 1
							&& styleObjectElements[ startContainer.childNodes[ range.startOffset ].nodeName.toLowerCase() ] )
						{
							type = CKEDITOR.SELECTION_ELEMENT;
						}
					}

					return ( cache.type = type );
				},

		/**
		 * Retrieve the {@link CKEDITOR.dom.range} instances that represent the current selection.
		 * Note: Some browsers returns multiple ranges even on a sequent selection, e.g. Firefox returns
		 * one range for each table cell when one or more table row is selected.
		 * @return {Array}
		 * @example
		 * var ranges = selection.getRanges();
		 * alert(ranges.length);
		 */
		getRanges : (function()
		{
			var func = CKEDITOR.env.ie ?
				( function()
				{
					function getNodeIndex( node ) { return new CKEDITOR.dom.node( node ).getIndex(); }

					// Finds the container and offset for a specific boundary
					// of an IE range.
					var getBoundaryInformation = function( range, start )
					{
						// Creates a collapsed range at the requested boundary.
						range = range.duplicate();
						range.collapse( start );

						// Gets the element that encloses the range entirely.
						var parent = range.parentElement(),
							doc = parent.ownerDocument;

						// Empty parent element, e.g. <i>^</i>
						if ( !parent.hasChildNodes() )
							return  { container : parent, offset : 0 };

						var siblings = parent.children,
							child,
							sibling,
							testRange = range.duplicate(),
							startIndex = 0,
							endIndex = siblings.length - 1,
							index = -1,
							position,
							distance;

						// Binary search over all element childs to test the range to see whether
						// range is right on the boundary of one element.
						while ( startIndex <= endIndex )
						{
							index = Math.floor( ( startIndex + endIndex ) / 2 );
							child = siblings[ index ];
							testRange.moveToElementText( child );
							position = testRange.compareEndPoints( 'StartToStart', range );

							if ( position > 0 )
								endIndex = index - 1;
							else if ( position < 0 )
								startIndex = index + 1;
							else
							{
								// IE9 report wrong measurement with compareEndPoints when range anchors between two BRs.
								// e.g. <p>text<br />^<br /></p> (#7433)
								if ( CKEDITOR.env.ie9Compat && child.tagName == 'BR' )
								{
									var bmId = 'cke_range_marker';
									range.execCommand( 'CreateBookmark', false, bmId );
									child = doc.getElementsByName( bmId )[ 0 ];
									var offset = getNodeIndex( child );
									parent.removeChild( child );
									return { container : parent, offset : offset };
								}
								else
									return { container : parent, offset : getNodeIndex( child ) };
							}
						}

						// All childs are text nodes,
						// or to the right hand of test range are all text nodes. (#6992)
						if ( index == -1 || index == siblings.length - 1 && position < 0 )
						{
							// Adapt test range to embrace the entire parent contents.
							testRange.moveToElementText( parent );
							testRange.setEndPoint( 'StartToStart', range );

							// IE report line break as CRLF with range.text but
							// only LF with textnode.nodeValue, normalize them to avoid
							// breaking character counting logic below. (#3949)
							distance = testRange.text.replace( /(\r\n|\r)/g, '\n' ).length;

							siblings = parent.childNodes;

							// Actual range anchor right beside test range at the boundary of text node.
							if ( !distance )
							{
								child = siblings[ siblings.length - 1 ];

								if ( child.nodeType == CKEDITOR.NODE_ELEMENT )
									return { container : parent, offset : siblings.length };
								else
									return { container : child, offset : child.nodeValue.length };
							}

							// Start the measuring until distance overflows, meanwhile count the text nodes.
							var i = siblings.length;
							while ( distance > 0 )
								distance -= siblings[ --i ].nodeValue.length;

							return  { container : siblings[ i ], offset : -distance };
						}
						// Test range was one offset beyond OR behind the anchored text node.
						else
						{
							// Adapt one side of test range to the actual range
							// for measuring the offset between them.
							testRange.collapse( position > 0 ? true : false );
							testRange.setEndPoint( position > 0 ? 'StartToStart' : 'EndToStart', range );

							// IE report line break as CRLF with range.text but
							// only LF with textnode.nodeValue, normalize them to avoid
							// breaking character counting logic below. (#3949)
							distance = testRange.text.replace( /(\r\n|\r)/g, '\n' ).length;

							// Actual range anchor right beside test range at the inner boundary of text node.
							if ( !distance )
								return { container : parent, offset : getNodeIndex( child ) + ( position > 0 ? 0 : 1 ) };

							// Start the measuring until distance overflows, meanwhile count the text nodes.
							while ( distance > 0 )
							{
								try
								{
									sibling = child[ position > 0 ? 'previousSibling' : 'nextSibling' ];
									distance -= sibling.nodeValue.length;
									child = sibling;
								}
								// Measurement in IE could be somtimes wrong because of <select> element. (#4611)
								catch( e )
								{
									return { container : parent, offset : getNodeIndex( child ) };
								}
							}

							return { container : child, offset : position > 0 ? -distance : child.nodeValue.length + distance };
						}
					};

					return function()
					{
						// IE doesn't have range support (in the W3C way), so we
						// need to do some magic to transform selections into
						// CKEDITOR.dom.range instances.

						var sel = this.getNative(),
							nativeRange = sel && sel.createRange(),
							type = this.getType(),
							range;

						if ( !sel )
							return [];

						if ( type == CKEDITOR.SELECTION_TEXT )
						{
							range = new CKEDITOR.dom.range( this.document );

							var boundaryInfo = getBoundaryInformation( nativeRange, true );
							range.setStart( new CKEDITOR.dom.node( boundaryInfo.container ), boundaryInfo.offset );

							boundaryInfo = getBoundaryInformation( nativeRange );
							range.setEnd( new CKEDITOR.dom.node( boundaryInfo.container ), boundaryInfo.offset );

							// Correct an invalid IE range case on empty list item. (#5850)
							if ( range.endContainer.getPosition( range.startContainer ) & CKEDITOR.POSITION_PRECEDING
									&& range.endOffset <= range.startContainer.getIndex() )
							{
								range.collapse();
							}

							return [ range ];
						}
						else if ( type == CKEDITOR.SELECTION_ELEMENT )
						{
							var retval = [];

							for ( var i = 0 ; i < nativeRange.length ; i++ )
							{
								var element = nativeRange.item( i ),
									parentElement = element.parentNode,
									j = 0;

								range = new CKEDITOR.dom.range( this.document );

								for (; j < parentElement.childNodes.length && parentElement.childNodes[j] != element ; j++ )
								{ /*jsl:pass*/ }

								range.setStart( new CKEDITOR.dom.node( parentElement ), j );
								range.setEnd( new CKEDITOR.dom.node( parentElement ), j + 1 );
								retval.push( range );
							}

							return retval;
						}

						return [];
					};
				})()
			:
				function()
				{

					// On browsers implementing the W3C range, we simply
					// tranform the native ranges in CKEDITOR.dom.range
					// instances.

					var ranges = [],
						range,
						doc = this.document,
						sel = this.getNative();

					if ( !sel )
						return ranges;

					// On WebKit, it may happen that we'll have no selection
					// available. We normalize it here by replicating the
					// behavior of other browsers.
					if ( !sel.rangeCount )
					{
						range = new CKEDITOR.dom.range( doc );
						range.moveToElementEditStart( doc.getBody() );
						ranges.push( range );
					}

					for ( var i = 0 ; i < sel.rangeCount ; i++ )
					{
						var nativeRange = sel.getRangeAt( i );

						range = new CKEDITOR.dom.range( doc );

						range.setStart( new CKEDITOR.dom.node( nativeRange.startContainer ), nativeRange.startOffset );
						range.setEnd( new CKEDITOR.dom.node( nativeRange.endContainer ), nativeRange.endOffset );
						ranges.push( range );
					}
					return ranges;
				};

			return function( onlyEditables )
			{
				var cache = this._.cache;
				if ( cache.ranges && !onlyEditables )
					return cache.ranges;
				else if ( !cache.ranges )
					cache.ranges = new CKEDITOR.dom.rangeList( func.call( this ) );

				// Split range into multiple by read-only nodes.
				if ( onlyEditables )
				{
					var ranges = cache.ranges;
					for ( var i = 0; i < ranges.length; i++ )
					{
						var range = ranges[ i ];

						// Drop range spans inside one ready-only node.
						var parent = range.getCommonAncestor();
						if ( parent.isReadOnly() )
							ranges.splice( i, 1 );

						if ( range.collapsed )
							continue;

						var startContainer = range.startContainer,
							endContainer = range.endContainer,
							startOffset = range.startOffset,
							endOffset = range.endOffset,
							walkerRange = range.clone();

						// Range may start inside a non-editable element, restart range
						// by the end of it.
						var readOnly;
						if ( ( readOnly = startContainer.isReadOnly() ) )
							range.setStartAfter( readOnly );

						// Enlarge range start/end with text node to avoid walker
						// being DOM destructive, it doesn't interfere our checking
						// of elements below as well.
						if ( startContainer && startContainer.type == CKEDITOR.NODE_TEXT )
						{
							if ( startOffset >= startContainer.getLength() )
								walkerRange.setStartAfter( startContainer );
							else
								walkerRange.setStartBefore( startContainer );
						}

						if ( endContainer && endContainer.type == CKEDITOR.NODE_TEXT )
						{
							if ( !endOffset )
								walkerRange.setEndBefore( endContainer );
							else
								walkerRange.setEndAfter( endContainer );
						}

						// Looking for non-editable element inside the range.
						var walker = new CKEDITOR.dom.walker( walkerRange );
						walker.evaluator = function( node )
						{
							if ( node.type == CKEDITOR.NODE_ELEMENT
								&& node.isReadOnly() )
							{
								var newRange = range.clone();
								range.setEndBefore( node );

								// Drop collapsed range around read-only elements,
								// it make sure the range list empty when selecting
								// only non-editable elements.
								if ( range.collapsed )
									ranges.splice( i--, 1 );

								// Avoid creating invalid range.
								if ( !( node.getPosition( walkerRange.endContainer ) & CKEDITOR.POSITION_CONTAINS ) )
								{
									newRange.setStartAfter( node );
									if ( !newRange.collapsed )
										ranges.splice( i + 1, 0, newRange );
								}

								return true;
							}

							return false;
						};

						walker.next();
					}
				}

				return cache.ranges;
			};
		})(),

		/**
		 * Gets the DOM element in which the selection starts.
		 * @returns {CKEDITOR.dom.element} The element at the beginning of the
		 *		selection.
		 * @example
		 * var element = editor.getSelection().<b>getStartElement()</b>;
		 * alert( element.getName() );
		 */
		getStartElement : function()
		{
			var cache = this._.cache;
			if ( cache.startElement !== undefined )
				return cache.startElement;

			var node,
				sel = this.getNative();

			switch ( this.getType() )
			{
				case CKEDITOR.SELECTION_ELEMENT :
					return this.getSelectedElement();

				case CKEDITOR.SELECTION_TEXT :

					var range = this.getRanges()[0];

					if ( range )
					{
						if ( !range.collapsed )
						{
							range.optimize();

							// Decrease the range content to exclude particial
							// selected node on the start which doesn't have
							// visual impact. ( #3231 )
							while ( 1 )
							{
								var startContainer = range.startContainer,
									startOffset = range.startOffset;
								// Limit the fix only to non-block elements.(#3950)
								if ( startOffset == ( startContainer.getChildCount ?
									 startContainer.getChildCount() : startContainer.getLength() )
									 && !startContainer.isBlockBoundary() )
									range.setStartAfter( startContainer );
								else break;
							}

							node = range.startContainer;

							if ( node.type != CKEDITOR.NODE_ELEMENT )
								return node.getParent();

							node = node.getChild( range.startOffset );

							if ( !node || node.type != CKEDITOR.NODE_ELEMENT )
								node = range.startContainer;
							else
							{
								var child = node.getFirst();
								while (  child && child.type == CKEDITOR.NODE_ELEMENT )
								{
									node = child;
									child = child.getFirst();
								}
							}
						}
						else
						{
							node = range.startContainer;
							if ( node.type != CKEDITOR.NODE_ELEMENT )
								node = node.getParent();
						}

						node = node.$;
					}
			}

			return cache.startElement = ( node ? new CKEDITOR.dom.element( node ) : null );
		},

		/**
		 * Gets the current selected element.
		 * @returns {CKEDITOR.dom.element} The selected element. Null if no
		 *		selection is available or the selection type is not
		 *		{@link CKEDITOR.SELECTION_ELEMENT}.
		 * @example
		 * var element = editor.getSelection().<b>getSelectedElement()</b>;
		 * alert( element.getName() );
		 */
		getSelectedElement : function()
		{
			var cache = this._.cache;
			if ( cache.selectedElement !== undefined )
				return cache.selectedElement;

			var self = this;

			var node = CKEDITOR.tools.tryThese(
				// Is it native IE control type selection?
				function()
				{
					return self.getNative().createRange().item( 0 );
				},
				// Figure it out by checking if there's a single enclosed
				// node of the range.
				function()
				{
					var range  = self.getRanges()[ 0 ],
						enclosed,
						selected;

					// Check first any enclosed element, e.g. <ul>[<li><a href="#">item</a></li>]</ul>
					for ( var i = 2; i && !( ( enclosed = range.getEnclosedNode() )
						&& ( enclosed.type == CKEDITOR.NODE_ELEMENT )
						&& styleObjectElements[ enclosed.getName() ]
						&& ( selected = enclosed ) ); i-- )
					{
						// Then check any deep wrapped element, e.g. [<b><i><img /></i></b>]
						range.shrink( CKEDITOR.SHRINK_ELEMENT );
					}

					return  selected.$;
				});

			return cache.selectedElement = ( node ? new CKEDITOR.dom.element( node ) : null );
		},

		lock : function()
		{
			// Call all cacheable function.
			this.getRanges();
			this.getStartElement();
			this.getSelectedElement();

			// The native selection is not available when locked.
			this._.cache.nativeSel = {};

			this.isLocked = 1;

			// Save this selection inside the DOM document.
			this.document.setCustomData( 'cke_locked_selection', this );
		},

		unlock : function( restore )
		{
			var doc = this.document,
				lockedSelection = doc.getCustomData( 'cke_locked_selection' );

			if ( lockedSelection )
			{
				doc.setCustomData( 'cke_locked_selection', null );

				if ( restore )
				{
					var selectedElement = lockedSelection.getSelectedElement(),
						ranges = !selectedElement && lockedSelection.getRanges();

					this.isLocked = 0;
					this.reset();

					doc.getBody().focus();

					if ( selectedElement )
						this.selectElement( selectedElement );
					else
						this.selectRanges( ranges );
				}
			}

			if  ( !lockedSelection || !restore )
			{
				this.isLocked = 0;
				this.reset();
			}
		},

		reset : function()
		{
			this._.cache = {};
		},

		/**
		 *  Make the current selection of type {@link CKEDITOR.SELECTION_ELEMENT} by enclosing the specified element.
		 * @param element
		 */
		selectElement : function( element )
		{
			if ( this.isLocked )
			{
				var range = new CKEDITOR.dom.range( this.document );
				range.setStartBefore( element );
				range.setEndAfter( element );

				this._.cache.selectedElement = element;
				this._.cache.startElement = element;
				this._.cache.ranges = new CKEDITOR.dom.rangeList( range );
				this._.cache.type = CKEDITOR.SELECTION_ELEMENT;

				return;
			}

			range = new CKEDITOR.dom.range( element.getDocument() );
			range.setStartBefore( element );
			range.setEndAfter( element );
			range.select();

			this.document.fire( 'selectionchange' );
			this.reset();

		},

		/**
		 *  Adding the specified ranges to document selection preceding
		 * by clearing up the original selection.
		 * @param {CKEDITOR.dom.range} ranges
		 */
		selectRanges : function( ranges )
		{
			if ( this.isLocked )
			{
				this._.cache.selectedElement = null;
				this._.cache.startElement = ranges[ 0 ] && ranges[ 0 ].getTouchedStartNode();
				this._.cache.ranges = new CKEDITOR.dom.rangeList( ranges );
				this._.cache.type = CKEDITOR.SELECTION_TEXT;

				return;
			}

			if ( CKEDITOR.env.ie )
			{
				if ( ranges.length > 1 )
				{
					// IE doesn't accept multiple ranges selection, so we join all into one.
					var last = ranges[ ranges.length -1 ] ;
					ranges[ 0 ].setEnd( last.endContainer, last.endOffset );
					ranges.length = 1;
				}

				if ( ranges[ 0 ] )
					ranges[ 0 ].select();

				this.reset();
			}
			else
			{
				var sel = this.getNative();

				// getNative() returns null if iframe is "display:none" in FF. (#6577)
				if ( !sel )
					return;

				if ( ranges.length )
				{
					sel.removeAllRanges();
					// Remove any existing filling char first.
					CKEDITOR.env.webkit && removeFillingChar( this.document );
				}

				for ( var i = 0 ; i < ranges.length ; i++ )
				{
					// Joining sequential ranges introduced by
					// readonly elements protection.
					if ( i < ranges.length -1 )
					{
						var left = ranges[ i ], right = ranges[ i +1 ],
								between = left.clone();
						between.setStart( left.endContainer, left.endOffset );
						between.setEnd( right.startContainer, right.startOffset );

						// Don't confused by Firefox adjancent multi-ranges
						// introduced by table cells selection.
						if ( !between.collapsed )
						{
							between.shrink( CKEDITOR.NODE_ELEMENT, true );
							var ancestor = between.getCommonAncestor(),
								enclosed = between.getEnclosedNode();

							// The following cases has to be considered:
							// 1. <span contenteditable="false">[placeholder]</span>
							// 2. <input contenteditable="false"  type="radio"/> (#6621)
							if ( ancestor.isReadOnly() || enclosed && enclosed.isReadOnly() )
							{
								right.setStart( left.startContainer, left.startOffset );
								ranges.splice( i--, 1 );
								continue;
							}
						}
					}

					var range = ranges[ i ];
					var nativeRange = this.document.$.createRange();
					var startContainer = range.startContainer;

					// In FF2, if we have a collapsed range, inside an empty
					// element, we must add something to it otherwise the caret
					// will not be visible.
					// In Opera instead, the selection will be moved out of the
					// element. (#4657)
					if ( range.collapsed &&
						( CKEDITOR.env.opera || ( CKEDITOR.env.gecko && CKEDITOR.env.version < 10900 ) ) &&
						startContainer.type == CKEDITOR.NODE_ELEMENT &&
						!startContainer.getChildCount() )
					{
						startContainer.appendText( '' );
					}

					if ( range.collapsed
							&& CKEDITOR.env.webkit
							&& rangeRequiresFix( range ) )
					{
						// Append a zero-width space so WebKit will not try to
						// move the selection by itself (#1272).
						var fillingChar = createFillingChar( this.document );
						range.insertNode( fillingChar ) ;

						var next = fillingChar.getNext();

						// If the filling char is followed by a <br>, whithout
						// having something before it, it'll not blink.
						// Let's remove it in this case.
						if ( next && !fillingChar.getPrevious() && next.type == CKEDITOR.NODE_ELEMENT && next.getName() == 'br' )
						{
							removeFillingChar( this.document );
							range.moveToPosition( next, CKEDITOR.POSITION_BEFORE_START );
						}
						else
							range.moveToPosition( fillingChar, CKEDITOR.POSITION_AFTER_END );
					}

					nativeRange.setStart( range.startContainer.$, range.startOffset );

					try
					{
						nativeRange.setEnd( range.endContainer.$, range.endOffset );
					}
					catch ( e )
					{
						// There is a bug in Firefox implementation (it would be too easy
						// otherwise). The new start can't be after the end (W3C says it can).
						// So, let's create a new range and collapse it to the desired point.
						if ( e.toString().indexOf( 'NS_ERROR_ILLEGAL_VALUE' ) >= 0 )
						{
							range.collapse( 1 );
							nativeRange.setEnd( range.endContainer.$, range.endOffset );
						}
						else
							throw e;
					}

					// Select the range.
					sel.addRange( nativeRange );
				}

				this.reset();
			}
		},

		/**
		 *  Create bookmark for every single of this selection range (from #getRanges)
		 * by calling the {@link CKEDITOR.dom.range.prototype.createBookmark} method,
		 * with extra cares to avoid interferon among those ranges. Same arguments are
		 * received as with the underlay range method.
		 */
		createBookmarks : function( serializable )
		{
			return this.getRanges().createBookmarks( serializable );
		},

		/**
		 *  Create bookmark for every single of this selection range (from #getRanges)
		 * by calling the {@link CKEDITOR.dom.range.prototype.createBookmark2} method,
		 * with extra cares to avoid interferon among those ranges. Same arguments are
		 * received as with the underlay range method.
		 */
		createBookmarks2 : function( normalized )
		{
			return this.getRanges().createBookmarks2( normalized );
		},

		/**
		 * Select the virtual ranges denote by the bookmarks by calling #selectRanges.
		 * @param bookmarks
		 */
		selectBookmarks : function( bookmarks )
		{
			var ranges = [];
			for ( var i = 0 ; i < bookmarks.length ; i++ )
			{
				var range = new CKEDITOR.dom.range( this.document );
				range.moveToBookmark( bookmarks[i] );
				ranges.push( range );
			}
			this.selectRanges( ranges );
			return this;
		},

		/**
		 * Retrieve the common ancestor node of the first range and the last range.
		 */
		getCommonAncestor : function()
		{
			var ranges = this.getRanges(),
				startNode = ranges[ 0 ].startContainer,
				endNode = ranges[ ranges.length - 1 ].endContainer;
			return startNode.getCommonAncestor( endNode );
		},

		/**
		 * Moving scroll bar to the current selection's start position.
		 */
		scrollIntoView : function()
		{
			// If we have split the block, adds a temporary span at the
			// range position and scroll relatively to it.
			var start = this.getStartElement();
			start.scrollIntoView();
		}
	};
})();

( function()
{
	var notWhitespaces = CKEDITOR.dom.walker.whitespaces( true ),
			fillerTextRegex = /\ufeff|\u00a0/,
			nonCells = { table:1,tbody:1,tr:1 };

	CKEDITOR.dom.range.prototype.select =
		CKEDITOR.env.ie ?
			// V2
			function( forceExpand )
			{
				var collapsed = this.collapsed,
					isStartMarkerAlone, dummySpan, ieRange;

				// Try to make a object selection.
				var selected = this.getEnclosedNode();
				if ( selected )
				{
					try
					{
						ieRange = this.document.$.body.createControlRange();
						ieRange.addElement( selected.$ );
						ieRange.select();
						return;
					}
					catch( er ) {}
				}

				// IE doesn't support selecting the entire table row/cell, move the selection into cells, e.g.
				// <table><tbody><tr>[<td>cell</b></td>... => <table><tbody><tr><td>[cell</td>...
				if ( this.startContainer.type == CKEDITOR.NODE_ELEMENT && this.startContainer.getName() in nonCells
					|| this.endContainer.type == CKEDITOR.NODE_ELEMENT && this.endContainer.getName() in nonCells )
				{
					this.shrink( CKEDITOR.NODE_ELEMENT, true );
				}

				var bookmark = this.createBookmark();

				// Create marker tags for the start and end boundaries.
				var startNode = bookmark.startNode;

				var endNode;
				if ( !collapsed )
					endNode = bookmark.endNode;

				// Create the main range which will be used for the selection.
				ieRange = this.document.$.body.createTextRange();

				// Position the range at the start boundary.
				ieRange.moveToElementText( startNode.$ );
				ieRange.moveStart( 'character', 1 );

				if ( endNode )
				{
					// Create a tool range for the end.
					var ieRangeEnd = this.document.$.body.createTextRange();

					// Position the tool range at the end.
					ieRangeEnd.moveToElementText( endNode.$ );

					// Move the end boundary of the main range to match the tool range.
					ieRange.setEndPoint( 'EndToEnd', ieRangeEnd );
					ieRange.moveEnd( 'character', -1 );
				}
				else
				{
					// The isStartMarkerAlone logic comes from V2. It guarantees that the lines
					// will expand and that the cursor will be blinking on the right place.
					// Actually, we are using this flag just to avoid using this hack in all
					// situations, but just on those needed.
					var next = startNode.getNext( notWhitespaces );
					isStartMarkerAlone = ( !( next && next.getText && next.getText().match( fillerTextRegex ) )     // already a filler there?
										  && ( forceExpand || !startNode.hasPrevious() || ( startNode.getPrevious().is && startNode.getPrevious().is( 'br' ) ) ) );

					// Append a temporary <span>&#65279;</span> before the selection.
					// This is needed to avoid IE destroying selections inside empty
					// inline elements, like <b></b> (#253).
					// It is also needed when placing the selection right after an inline
					// element to avoid the selection moving inside of it.
					dummySpan = this.document.createElement( 'span' );
					dummySpan.setHtml( '&#65279;' );	// Zero Width No-Break Space (U+FEFF). See #1359.
					dummySpan.insertBefore( startNode );

					if ( isStartMarkerAlone )
					{
						// To expand empty blocks or line spaces after <br>, we need
						// instead to have any char, which will be later deleted using the
						// selection.
						// \ufeff = Zero Width No-Break Space (U+FEFF). (#1359)
						this.document.createText( '\ufeff' ).insertBefore( startNode );
					}
				}

				// Remove the markers (reset the position, because of the changes in the DOM tree).
				this.setStartBefore( startNode );
				startNode.remove();

				if ( collapsed )
				{
					if ( isStartMarkerAlone )
					{
						// Move the selection start to include the temporary \ufeff.
						ieRange.moveStart( 'character', -1 );

						ieRange.select();

						// Remove our temporary stuff.
						this.document.$.selection.clear();
					}
					else
						ieRange.select();

					this.moveToPosition( dummySpan, CKEDITOR.POSITION_BEFORE_START );
					dummySpan.remove();
				}
				else
				{
					this.setEndBefore( endNode );
					endNode.remove();
					ieRange.select();
				}

				this.document.fire( 'selectionchange' );
			}
		:
			function()
			{
				this.document.getSelection().selectRanges( [ this ] );
			};
} )();
