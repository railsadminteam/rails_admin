/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * A lightweight representation of an HTML element.
 * @param {String} name The element name.
 * @param {Object} attributes And object holding all attributes defined for
 *		this element.
 * @constructor
 * @example
 */
CKEDITOR.htmlParser.element = function( name, attributes )
{
	/**
	 * The element name.
	 * @type String
	 * @example
	 */
	this.name = name;

	/**
	 * Holds the attributes defined for this element.
	 * @type Object
	 * @example
	 */
	this.attributes = attributes || ( attributes = {} );

	/**
	 * The nodes that are direct children of this element.
	 * @type Array
	 * @example
	 */
	this.children = [];

	var tagName = attributes[ 'data-cke-real-element-type' ] || name || '';

	// Reveal the real semantic of our internal custom tag name (#6639).
	var internalTag = tagName.match( /^cke:(.*)/ );
  	internalTag && ( tagName = internalTag[ 1 ] );

	var dtd			= CKEDITOR.dtd,
		isBlockLike	= !!( dtd.$nonBodyContent[ tagName ]
				|| dtd.$block[ tagName ]
				|| dtd.$listItem[ tagName ]
				|| dtd.$tableContent[ tagName ]
				|| dtd.$nonEditable[ tagName ]
				|| tagName == 'br' ),
		isEmpty = !!dtd.$empty[ name ];

	this.isEmpty	= isEmpty;
	this.isUnknown	= !dtd[ name ];

	/** @private */
	this._ =
	{
		isBlockLike : isBlockLike,
		hasInlineStarted : isEmpty || !isBlockLike
	};
};

(function()
{
	// Used to sort attribute entries in an array, where the first element of
	// each object is the attribute name.
	var sortAttribs = function( a, b )
	{
		a = a[0];
		b = b[0];
		return a < b ? -1 : a > b ? 1 : 0;
	};

	CKEDITOR.htmlParser.element.prototype =
	{
		/**
		 * The node type. This is a constant value set to {@link CKEDITOR.NODE_ELEMENT}.
		 * @type Number
		 * @example
		 */
		type : CKEDITOR.NODE_ELEMENT,

		/**
		 * Adds a node to the element children list.
		 * @param {Object} node The node to be added. It can be any of of the
		 *		following types: {@link CKEDITOR.htmlParser.element},
		 *		{@link CKEDITOR.htmlParser.text} and
		 *		{@link CKEDITOR.htmlParser.comment}.
		 * @function
		 * @example
		 */
		add : CKEDITOR.htmlParser.fragment.prototype.add,

		/**
		 * Clone this element.
		 * @returns {CKEDITOR.htmlParser.element} The element clone.
		 * @example
		 */
		clone : function()
		{
			return new CKEDITOR.htmlParser.element( this.name, this.attributes );
		},

		/**
		 * Writes the element HTML to a CKEDITOR.htmlWriter.
		 * @param {CKEDITOR.htmlWriter} writer The writer to which write the HTML.
		 * @example
		 */
		writeHtml : function( writer, filter )
		{
			var attributes = this.attributes;

			// Ignore cke: prefixes when writing HTML.
			var element = this,
				writeName = element.name,
				a, newAttrName, value;

			var isChildrenFiltered;

			/**
			 * Providing an option for bottom-up filtering order ( element
			 * children to be pre-filtered before the element itself ).
			 */
			element.filterChildren = function()
			{
				if ( !isChildrenFiltered )
				{
					var writer = new CKEDITOR.htmlParser.basicWriter();
					CKEDITOR.htmlParser.fragment.prototype.writeChildrenHtml.call( element, writer, filter );
					element.children = new CKEDITOR.htmlParser.fragment.fromHtml( writer.getHtml(), 0, element.clone() ).children;
					isChildrenFiltered = 1;
				}
			};

			if ( filter )
			{
				while ( true )
				{
					if ( !( writeName = filter.onElementName( writeName ) ) )
						return;

					element.name = writeName;

					if ( !( element = filter.onElement( element ) ) )
						return;

					element.parent = this.parent;

					if ( element.name == writeName )
						break;

					// If the element has been replaced with something of a
					// different type, then make the replacement write itself.
					if ( element.type != CKEDITOR.NODE_ELEMENT )
					{
						element.writeHtml( writer, filter );
						return;
					}

					writeName = element.name;

					// This indicate that the element has been dropped by
					// filter but not the children.
					if ( !writeName )
					{
						this.writeChildrenHtml.call( element, writer, isChildrenFiltered ? null : filter );
						return;
					}
				}

				// The element may have been changed, so update the local
				// references.
				attributes = element.attributes;
			}

			// Open element tag.
			writer.openTag( writeName, attributes );

			// Copy all attributes to an array.
			var attribsArray = [];
			// Iterate over the attributes twice since filters may alter
			// other attributes.
			for ( var i = 0 ; i < 2; i++ )
			{
				for ( a in attributes )
				{
					newAttrName = a;
					value = attributes[ a ];
					if ( i == 1 )
						attribsArray.push( [ a, value ] );
					else if ( filter )
					{
						while ( true )
						{
							if ( !( newAttrName = filter.onAttributeName( a ) ) )
							{
								delete attributes[ a ];
								break;
							}
							else if ( newAttrName != a )
							{
								delete attributes[ a ];
								a = newAttrName;
								continue;
							}
							else
								break;
						}
						if ( newAttrName )
						{
							if ( ( value = filter.onAttribute( element, newAttrName, value ) ) === false )
								delete attributes[ newAttrName ];
							else
								attributes [ newAttrName ] = value;
						}
					}
				}
			}
			// Sort the attributes by name.
			if ( writer.sortAttributes )
				attribsArray.sort( sortAttribs );

			// Send the attributes.
			var len = attribsArray.length;
			for ( i = 0 ; i < len ; i++ )
			{
				var attrib = attribsArray[ i ];
				writer.attribute( attrib[0], attrib[1] );
			}

			// Close the tag.
			writer.openTagClose( writeName, element.isEmpty );

			if ( !element.isEmpty )
			{
				this.writeChildrenHtml.call( element, writer, isChildrenFiltered ? null : filter );
				// Close the element.
				writer.closeTag( writeName );
			}
		},

		writeChildrenHtml : function( writer, filter )
		{
			// Send children.
			CKEDITOR.htmlParser.fragment.prototype.writeChildrenHtml.apply( this, arguments );

		}
	};
})();
