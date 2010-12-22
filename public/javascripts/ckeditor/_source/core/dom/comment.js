/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @fileOverview Defines the {@link CKEDITOR.dom.comment} class, which represents
 *		a DOM comment node.
 */

CKEDITOR.dom.comment = CKEDITOR.tools.createClass(
{
	base : CKEDITOR.dom.node,

	$ : function( text, ownerDocument )
	{
		if ( typeof text == 'string' )
			text = ( ownerDocument ? ownerDocument.$ : document ).createComment( text );

		this.base( text );
	},

	proto :
	{
		type : CKEDITOR.NODE_COMMENT,

		getOuterHtml : function()
		{
			return '<!--' + this.$.nodeValue + '-->';
		}
	}
});
