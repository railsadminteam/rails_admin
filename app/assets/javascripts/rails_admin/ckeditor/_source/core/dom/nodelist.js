﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/**
 * @class
 */
CKEDITOR.dom.nodeList = function( nativeList )
{
	this.$ = nativeList;
};

CKEDITOR.dom.nodeList.prototype =
{
	count : function()
	{
		return this.$.length;
	},

	getItem : function( index )
	{
		var $node = this.$[ index ];
		return $node ? new CKEDITOR.dom.node( $node ) : null;
	}
};
