﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.plugins.add( 'menubutton',
{
	requires : [ 'button', 'menu' ],
	beforeInit : function( editor )
	{
		editor.ui.addHandler( CKEDITOR.UI_MENUBUTTON, CKEDITOR.ui.menuButton.handler );
	}
});

/**
 * Button UI element.
 * @constant
 * @example
 */
CKEDITOR.UI_MENUBUTTON = 'menubutton';

(function()
{
	var clickFn = function( editor )
	{
		var _ = this._;

		// Do nothing if this button is disabled.
		if ( _.state === CKEDITOR.TRISTATE_DISABLED )
			return;

		_.previousState = _.state;

		// Check if we already have a menu for it, otherwise just create it.
		var menu = _.menu;
		if ( !menu )
		{
			menu = _.menu = new CKEDITOR.menu( editor,
			{
				panel:
				{
					className : editor.skinClass + ' cke_contextmenu',
					attributes : { 'aria-label' : editor.lang.common.options }
				}
			});

			menu.onHide = CKEDITOR.tools.bind( function()
				{
					this.setState( this.modes && this.modes[ editor.mode ] ? _.previousState : CKEDITOR.TRISTATE_DISABLED );
				},
				this );

			// Initialize the menu items at this point.
			if ( this.onMenu )
				menu.addListener( this.onMenu );
		}

		if ( _.on )
		{
			menu.hide();
			return;
		}

		this.setState( CKEDITOR.TRISTATE_ON );

		menu.show( CKEDITOR.document.getById( this._.id ), 4 );
	};


	CKEDITOR.ui.menuButton = CKEDITOR.tools.createClass(
	{
		base : CKEDITOR.ui.button,

		$ : function( definition )
		{
			// We don't want the panel definition in this object.
			var panelDefinition = definition.panel;
			delete definition.panel;

			this.base( definition );

			this.hasArrow = true;

			this.click = clickFn;
		},

		statics :
		{
			handler :
			{
				create : function( definition )
				{
					return new CKEDITOR.ui.menuButton( definition );
				}
			}
		}
	});
})();
