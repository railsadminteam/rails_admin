﻿/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

/** @fileoverview The "dialogui" plugin. */

CKEDITOR.plugins.add( 'dialogui' );

(function()
{
	var initPrivateObject = function( elementDefinition )
	{
		this._ || ( this._ = {} );
		this._['default'] = this._.initValue = elementDefinition['default'] || '';
		this._.required = elementDefinition[ 'required' ] || false;
		var args = [ this._ ];
		for ( var i = 1 ; i < arguments.length ; i++ )
			args.push( arguments[i] );
		args.push( true );
		CKEDITOR.tools.extend.apply( CKEDITOR.tools, args );
		return this._;
	},
	textBuilder =
	{
		build : function( dialog, elementDefinition, output )
		{
			return new CKEDITOR.ui.dialog.textInput( dialog, elementDefinition, output );
		}
	},
	commonBuilder =
	{
		build : function( dialog, elementDefinition, output )
		{
			return new CKEDITOR.ui.dialog[elementDefinition.type]( dialog, elementDefinition, output );
		}
	},
	containerBuilder =
	{
		build : function( dialog, elementDefinition, output )
		{
			var children = elementDefinition.children,
				child,
				childHtmlList = [],
				childObjList = [];
			for ( var i = 0 ; ( i < children.length && ( child = children[i] ) ) ; i++ )
			{
				var childHtml = [];
				childHtmlList.push( childHtml );
				childObjList.push( CKEDITOR.dialog._.uiElementBuilders[ child.type ].build( dialog, child, childHtml ) );
			}
			return new CKEDITOR.ui.dialog[ elementDefinition.type ]( dialog, childObjList, childHtmlList, output, elementDefinition );
		}
	},
	commonPrototype =
	{
		isChanged : function()
		{
			return this.getValue() != this.getInitValue();
		},

		reset : function( noChangeEvent )
		{
			this.setValue( this.getInitValue(), noChangeEvent );
		},

		setInitValue : function()
		{
			this._.initValue = this.getValue();
		},

		resetInitValue : function()
		{
			this._.initValue = this._['default'];
		},

		getInitValue : function()
		{
			return this._.initValue;
		}
	},
	commonEventProcessors = CKEDITOR.tools.extend( {}, CKEDITOR.ui.dialog.uiElement.prototype.eventProcessors,
		{
			onChange : function( dialog, func )
			{
				if ( !this._.domOnChangeRegistered )
				{
					dialog.on( 'load', function()
						{
							this.getInputElement().on( 'change', function()
							{
								// Make sure 'onchange' doesn't get fired after dialog closed. (#5719)
								if ( !dialog.parts.dialog.isVisible() )
									return;

								this.fire( 'change', { value : this.getValue() } );
							}, this );
						}, this );
					this._.domOnChangeRegistered = true;
				}

				this.on( 'change', func );
			}
		}, true ),
	eventRegex = /^on([A-Z]\w+)/,
	cleanInnerDefinition = function( def )
	{
		// An inner UI element should not have the parent's type, title or events.
		for ( var i in def )
		{
			if ( eventRegex.test( i ) || i == 'title' || i == 'type' )
				delete def[i];
		}
		return def;
	};

	CKEDITOR.tools.extend( CKEDITOR.ui.dialog,
		/** @lends CKEDITOR.ui.dialog */
		{
			/**
			 * Base class for all dialog elements with a textual label on the left.
			 * @constructor
			 * @example
			 * @extends CKEDITOR.ui.dialog.uiElement
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>label</strong> (Required) The label string.</li>
			 * 	<li><strong>labelLayout</strong> (Optional) Put 'horizontal' here if the
			 * 	label element is to be layed out horizontally. Otherwise a vertical
			 * 	layout will be used.</li>
			 * 	<li><strong>widths</strong> (Optional) This applies only for horizontal
			 * 	layouts - an 2-element array of lengths to specify the widths of the
			 * 	label and the content element.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 * @param {Function} contentHtml
			 * A function returning the HTML code string to be added inside the content
			 * cell.
			 */
			labeledElement : function( dialog, elementDefinition, htmlList, contentHtml )
			{
				if ( arguments.length < 4 )
					return;

				var _ = initPrivateObject.call( this, elementDefinition );
				_.labelId = CKEDITOR.tools.getNextId() + '_label';
				var children = this._.children = [];
				/** @ignore */
				var innerHTML = function()
				{
					var html = [],
						requiredClass = elementDefinition.required ? ' cke_required' : '' ;
					if ( elementDefinition.labelLayout != 'horizontal' )
						html.push( '<label class="cke_dialog_ui_labeled_label' + requiredClass + '" ',
								' id="'+  _.labelId + '"',
								' for="' + _.inputId + '"',
								' style="' + elementDefinition.labelStyle + '">',
								elementDefinition.label,
								'</label>',
								'<div class="cke_dialog_ui_labeled_content" role="presentation">',
								contentHtml.call( this, dialog, elementDefinition ),
								'</div>' );
					else
					{
						var hboxDefinition = {
							type : 'hbox',
							widths : elementDefinition.widths,
							padding : 0,
							children :
							[
								{
									type : 'html',
									html : '<label class="cke_dialog_ui_labeled_label' + requiredClass + '"' +
										' id="' + _.labelId + '"' +
										' for="' + _.inputId + '"' +
										' style="' + elementDefinition.labelStyle + '">' +
										   CKEDITOR.tools.htmlEncode( elementDefinition.label ) +
										'</span>'
								},
								{
									type : 'html',
									html : '<span class="cke_dialog_ui_labeled_content">' +
										contentHtml.call( this, dialog, elementDefinition ) +
										'</span>'
								}
							]
						};
						CKEDITOR.dialog._.uiElementBuilders.hbox.build( dialog, hboxDefinition, html );
					}
					return html.join( '' );
				};
				CKEDITOR.ui.dialog.uiElement.call( this, dialog, elementDefinition, htmlList, 'div', null, { role : 'presentation' }, innerHTML );
			},

			/**
			 * A text input with a label. This UI element class represents both the
			 * single-line text inputs and password inputs in dialog boxes.
			 * @constructor
			 * @example
			 * @extends CKEDITOR.ui.dialog.labeledElement
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>default</strong> (Optional) The default value.</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function. </li>
			 * 	<li><strong>maxLength</strong> (Optional) The maximum length of text box
			 * 	contents.</li>
			 * 	<li><strong>size</strong> (Optional) The size of the text box. This is
			 * 	usually overridden by the size defined by the skin, however.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			textInput : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				initPrivateObject.call( this, elementDefinition );
				var domId = this._.inputId = CKEDITOR.tools.getNextId() + '_textInput',
					attributes = { 'class' : 'cke_dialog_ui_input_' + elementDefinition.type, id : domId, type : 'text' },
					i;

				// Set the validator, if any.
				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				// Set the max length and size.
				if ( elementDefinition.maxLength )
					attributes.maxlength = elementDefinition.maxLength;
				if ( elementDefinition.size )
					attributes.size = elementDefinition.size;

				if ( elementDefinition.controlStyle )
					attributes.style = elementDefinition.controlStyle;

				// If user presses Enter in a text box, it implies clicking OK for the dialog.
				var me = this, keyPressedOnMe = false;
				dialog.on( 'load', function()
					{
						me.getInputElement().on( 'keydown', function( evt )
							{
								if ( evt.data.getKeystroke() == 13 )
									keyPressedOnMe = true;
							} );

						// Lower the priority this 'keyup' since 'ok' will close the dialog.(#3749)
						me.getInputElement().on( 'keyup', function( evt )
							{
								if ( evt.data.getKeystroke() == 13 && keyPressedOnMe )
								{
									dialog.getButton( 'ok' ) && setTimeout( function ()
									{
										dialog.getButton( 'ok' ).click();
									}, 0 );
									keyPressedOnMe = false;
								}
							}, null, null, 1000 );
					} );

				/** @ignore */
				var innerHTML = function()
				{
					// IE BUG: Text input fields in IE at 100% would exceed a <td> or inline
					// container's width, so need to wrap it inside a <div>.
					var html = [ '<div class="cke_dialog_ui_input_', elementDefinition.type, '" role="presentation"' ];

					if ( elementDefinition.width )
						html.push( 'style="width:'+ elementDefinition.width +'" ' );

					html.push( '><input ' );

					attributes[ 'aria-labelledby' ] = this._.labelId;
					this._.required && ( attributes[ 'aria-required' ] = this._.required );
					for ( var i in attributes )
						html.push( i + '="' + attributes[i] + '" ' );
					html.push( ' /></div>' );
					return html.join( '' );
				};
				CKEDITOR.ui.dialog.labeledElement.call( this, dialog, elementDefinition, htmlList, innerHTML );
			},

			/**
			 * A text area with a label on the top or left.
			 * @constructor
			 * @extends CKEDITOR.ui.dialog.labeledElement
			 * @example
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>rows</strong> (Optional) The number of rows displayed.
			 * 	Defaults to 5 if not defined.</li>
			 * 	<li><strong>cols</strong> (Optional) The number of cols displayed.
			 * 	Defaults to 20 if not defined. Usually overridden by skins.</li>
			 * 	<li><strong>default</strong> (Optional) The default value.</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function. </li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			textarea : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				initPrivateObject.call( this, elementDefinition );
				var me = this,
					domId = this._.inputId = CKEDITOR.tools.getNextId() + '_textarea',
					attributes = {};

				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				// Generates the essential attributes for the textarea tag.
				attributes.rows = elementDefinition.rows || 5;
				attributes.cols = elementDefinition.cols || 20;

				/** @ignore */
				var innerHTML = function()
				{
					attributes[ 'aria-labelledby' ] = this._.labelId;
					this._.required && ( attributes[ 'aria-required' ] = this._.required );
					var html = [ '<div class="cke_dialog_ui_input_textarea" role="presentation"><textarea class="cke_dialog_ui_input_textarea" id="', domId, '" ' ];
					for ( var i in attributes )
						html.push( i + '="' + CKEDITOR.tools.htmlEncode( attributes[i] ) + '" ' );
					html.push( '>', CKEDITOR.tools.htmlEncode( me._['default'] ), '</textarea></div>' );
					return html.join( '' );
				};
				CKEDITOR.ui.dialog.labeledElement.call( this, dialog, elementDefinition, htmlList, innerHTML );
			},

			/**
			 * A single checkbox with a label on the right.
			 * @constructor
			 * @extends CKEDITOR.ui.dialog.uiElement
			 * @example
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>checked</strong> (Optional) Whether the checkbox is checked
			 * 	on instantiation. Defaults to false.</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function.</li>
			 * 	<li><strong>label</strong> (Optional) The checkbox label.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			checkbox : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				var _ = initPrivateObject.call( this, elementDefinition, { 'default' : !!elementDefinition[ 'default' ] } );

				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				/** @ignore */
				var innerHTML = function()
				{
					var myDefinition = CKEDITOR.tools.extend( {}, elementDefinition,
							{
								id : elementDefinition.id ? elementDefinition.id + '_checkbox' : CKEDITOR.tools.getNextId() + '_checkbox'
							}, true ),
						html = [];

					var labelId = CKEDITOR.tools.getNextId() + '_label';
					var attributes = { 'class' : 'cke_dialog_ui_checkbox_input', type : 'checkbox', 'aria-labelledby' : labelId };
					cleanInnerDefinition( myDefinition );
					if ( elementDefinition[ 'default' ] )
						attributes.checked = 'checked';

					if ( typeof myDefinition.controlStyle != 'undefined' )
						myDefinition.style = myDefinition.controlStyle;

					_.checkbox = new CKEDITOR.ui.dialog.uiElement( dialog, myDefinition, html, 'input', null, attributes );
					html.push( ' <label id="', labelId, '" for="', attributes.id, '">',
							CKEDITOR.tools.htmlEncode( elementDefinition.label ),
							'</label>' );
					return html.join( '' );
				};

				CKEDITOR.ui.dialog.uiElement.call( this, dialog, elementDefinition, htmlList, 'span', null, null, innerHTML );
			},

			/**
			 * A group of radio buttons.
			 * @constructor
			 * @example
			 * @extends CKEDITOR.ui.dialog.labeledElement
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>default</strong> (Required) The default value.</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function.</li>
			 * 	<li><strong>items</strong> (Required) An array of options. Each option
			 * 	is a 1- or 2-item array of format [ 'Description', 'Value' ]. If 'Value'
			 * 	is missing, then the value would be assumed to be the same as the
			 * 	description.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			radio : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3)
					return;

				initPrivateObject.call( this, elementDefinition );
				if ( !this._['default'] )
					this._['default'] = this._.initValue = elementDefinition.items[0][1];
				if ( elementDefinition.validate )
					this.validate = elementDefinition.valdiate;
				var children = [], me = this;

				/** @ignore */
				var innerHTML = function()
				{
					var inputHtmlList = [], html = [],
						commonAttributes = { 'class' : 'cke_dialog_ui_radio_item', 'aria-labelledby' : this._.labelId },
						commonName = elementDefinition.id ? elementDefinition.id + '_radio' : CKEDITOR.tools.getNextId() + '_radio';
					for ( var i = 0 ; i < elementDefinition.items.length ; i++ )
					{
						var item = elementDefinition.items[i],
							title = item[2] !== undefined ? item[2] : item[0],
							value = item[1] !== undefined ? item[1] : item[0],
							inputId = CKEDITOR.tools.getNextId() + '_radio_input',
							labelId = inputId + '_label',
							inputDefinition = CKEDITOR.tools.extend( {}, elementDefinition,
									{
										id : inputId,
										title : null,
										type : null
									}, true ),
							labelDefinition = CKEDITOR.tools.extend( {}, inputDefinition,
									{
										title : title
									}, true ),
							inputAttributes =
							{
								type : 'radio',
								'class' : 'cke_dialog_ui_radio_input',
								name : commonName,
								value : value,
								'aria-labelledby' : labelId
							},
							inputHtml = [];
						if ( me._['default'] == value )
							inputAttributes.checked = 'checked';
						cleanInnerDefinition( inputDefinition );
						cleanInnerDefinition( labelDefinition );

						if ( typeof inputDefinition.controlStyle != 'undefined' )
							inputDefinition.style = inputDefinition.controlStyle;

						children.push( new CKEDITOR.ui.dialog.uiElement( dialog, inputDefinition, inputHtml, 'input', null, inputAttributes ) );
						inputHtml.push( ' ' );
						new CKEDITOR.ui.dialog.uiElement( dialog, labelDefinition, inputHtml, 'label', null, { id : labelId, 'for' : inputAttributes.id },
							   item[0] );
						inputHtmlList.push( inputHtml.join( '' ) );
					}
					new CKEDITOR.ui.dialog.hbox( dialog, [], inputHtmlList, html );
					return html.join( '' );
				};

				CKEDITOR.ui.dialog.labeledElement.call( this, dialog, elementDefinition, htmlList, innerHTML );
				this._.children = children;
			},

			/**
			 * A button with a label inside.
			 * @constructor
			 * @example
			 * @extends CKEDITOR.ui.dialog.uiElement
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>label</strong> (Required) The button label.</li>
			 * 	<li><strong>disabled</strong> (Optional) Set to true if you want the
			 * 	button to appear in disabled state.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			button : function( dialog, elementDefinition, htmlList )
			{
				if ( !arguments.length )
					return;

				if ( typeof elementDefinition == 'function' )
					elementDefinition = elementDefinition( dialog.getParentEditor() );

				initPrivateObject.call( this, elementDefinition, { disabled : elementDefinition.disabled || false } );

				// Add OnClick event to this input.
				CKEDITOR.event.implementOn( this );

				var me = this;

				// Register an event handler for processing button clicks.
				dialog.on( 'load', function( eventInfo )
					{
						var element = this.getElement();

						(function()
						{
							element.on( 'click', function( evt )
								{
									me.fire( 'click', { dialog : me.getDialog() } );
									evt.data.preventDefault();
								} );

							element.on( 'keydown', function( evt )
								{
									if ( evt.data.getKeystroke() in { 32:1 } )
									{
										me.click();
										evt.data.preventDefault();
									}
								} );
						})();

						element.unselectable();
					}, this );

				var outerDefinition = CKEDITOR.tools.extend( {}, elementDefinition );
				delete outerDefinition.style;

				var labelId = CKEDITOR.tools.getNextId() + '_label';
				CKEDITOR.ui.dialog.uiElement.call(
					this,
					dialog,
					outerDefinition,
					htmlList,
					'a',
					null,
					{
						style : elementDefinition.style,
						href : 'javascript:void(0)',
						title : elementDefinition.label,
						hidefocus : 'true',
						'class' : elementDefinition['class'],
						role : 'button',
						'aria-labelledby' : labelId
					},
					'<span id="' + labelId + '" class="cke_dialog_ui_button">' +
						CKEDITOR.tools.htmlEncode( elementDefinition.label ) +
					'</span>' );
			},

			/**
			 * A select box.
			 * @extends CKEDITOR.ui.dialog.uiElement
			 * @example
			 * @constructor
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>default</strong> (Required) The default value.</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function.</li>
			 * 	<li><strong>items</strong> (Required) An array of options. Each option
			 * 	is a 1- or 2-item array of format [ 'Description', 'Value' ]. If 'Value'
			 * 	is missing, then the value would be assumed to be the same as the
			 * 	description.</li>
			 * 	<li><strong>multiple</strong> (Optional) Set this to true if you'd like
			 * 	to have a multiple-choice select box.</li>
			 * 	<li><strong>size</strong> (Optional) The number of items to display in
			 * 	the select box.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			select : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				var _ = initPrivateObject.call( this, elementDefinition );

				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				_.inputId = CKEDITOR.tools.getNextId() + '_select';
				/** @ignore */
				var innerHTML = function()
				{
					var myDefinition = CKEDITOR.tools.extend( {}, elementDefinition,
							{
								id : elementDefinition.id ? elementDefinition.id + '_select' : CKEDITOR.tools.getNextId() + '_select'
							}, true ),
						html = [],
						innerHTML = [],
						attributes = { 'id' : _.inputId, 'class' : 'cke_dialog_ui_input_select', 'aria-labelledby' : this._.labelId };

					// Add multiple and size attributes from element definition.
					if ( elementDefinition.size != undefined )
						attributes.size = elementDefinition.size;
					if ( elementDefinition.multiple != undefined )
						attributes.multiple = elementDefinition.multiple;

					cleanInnerDefinition( myDefinition );
					for ( var i = 0, item ; i < elementDefinition.items.length && ( item = elementDefinition.items[i] ) ; i++ )
					{
						innerHTML.push( '<option value="',
							CKEDITOR.tools.htmlEncode( item[1] !== undefined ? item[1] : item[0] ).replace( /"/g, '&quot;' ), '" /> ',
							CKEDITOR.tools.htmlEncode( item[0] ) );
					}

					if ( typeof myDefinition.controlStyle != 'undefined' )
						myDefinition.style = myDefinition.controlStyle;

					_.select = new CKEDITOR.ui.dialog.uiElement( dialog, myDefinition, html, 'select', null, attributes, innerHTML.join( '' ) );
					return html.join( '' );
				};

				CKEDITOR.ui.dialog.labeledElement.call( this, dialog, elementDefinition, htmlList, innerHTML );
			},

			/**
			 * A file upload input.
			 * @extends CKEDITOR.ui.dialog.labeledElement
			 * @example
			 * @constructor
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>validate</strong> (Optional) The validation function.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			file : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				if ( elementDefinition['default'] === undefined )
					elementDefinition['default'] = '';

				var _ = CKEDITOR.tools.extend( initPrivateObject.call( this, elementDefinition ), { definition : elementDefinition, buttons : [] } );

				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				/** @ignore */
				var innerHTML = function()
				{
					_.frameId = CKEDITOR.tools.getNextId() + '_fileInput';

					// Support for custom document.domain in IE.
					var isCustomDomain = CKEDITOR.env.isCustomDomain();

					var html = [
						'<iframe' +
							' frameborder="0"' +
							' allowtransparency="0"' +
							' class="cke_dialog_ui_input_file"' +
							' id="', _.frameId, '"' +
							' title="', elementDefinition.label, '"' +
							' src="javascript:void(' ];

					html.push(
							isCustomDomain ?
								'(function(){' +
									'document.open();' +
									'document.domain=\'' + document.domain + '\';' +
									'document.close();' +
								'})()'
							:
								'0' );

					html.push(
							')">' +
						'</iframe>' );

					return html.join( '' );
				};

				// IE BUG: Parent container does not resize to contain the iframe automatically.
				dialog.on( 'load', function()
					{
						var iframe = CKEDITOR.document.getById( _.frameId ),
							contentDiv = iframe.getParent();
						contentDiv.addClass( 'cke_dialog_ui_input_file' );
					} );

				CKEDITOR.ui.dialog.labeledElement.call( this, dialog, elementDefinition, htmlList, innerHTML );
			},

			/**
			 * A button for submitting the file in a file upload input.
			 * @extends CKEDITOR.ui.dialog.button
			 * @example
			 * @constructor
			 * @param {CKEDITOR.dialog} dialog
			 * Parent dialog object.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>for</strong> (Required) The file input's page and element Id
			 * 	to associate to, in a 2-item array format: [ 'page_id', 'element_id' ].
			 * 	</li>
			 * 	<li><strong>validate</strong> (Optional) The validation function.</li>
			 * </ul>
			 * @param {Array} htmlList
			 * List of HTML code to output to.
			 */
			fileButton : function( dialog, elementDefinition, htmlList )
			{
				if ( arguments.length < 3 )
					return;

				var _ = initPrivateObject.call( this, elementDefinition ),
					me = this;

				if ( elementDefinition.validate )
					this.validate = elementDefinition.validate;

				var myDefinition = CKEDITOR.tools.extend( {}, elementDefinition );
				var onClick = myDefinition.onClick;
				myDefinition.className = ( myDefinition.className ? myDefinition.className + ' ' : '' ) + 'cke_dialog_ui_button';
				myDefinition.onClick = function( evt )
				{
					var target = elementDefinition[ 'for' ];		// [ pageId, elementId ]
					if ( !onClick || onClick.call( this, evt ) !== false )
					{
						dialog.getContentElement( target[0], target[1] ).submit();
						this.disable();
					}
				};

				dialog.on( 'load', function()
						{
							dialog.getContentElement( elementDefinition[ 'for' ][0], elementDefinition[ 'for' ][1] )._.buttons.push( me );
						} );

				CKEDITOR.ui.dialog.button.call( this, dialog, myDefinition, htmlList );
			},

			html : (function()
			{
				var myHtmlRe = /^\s*<[\w:]+\s+([^>]*)?>/,
					theirHtmlRe = /^(\s*<[\w:]+(?:\s+[^>]*)?)((?:.|\r|\n)+)$/,
					emptyTagRe = /\/$/;
				/**
				 * A dialog element made from raw HTML code.
				 * @extends CKEDITOR.ui.dialog.uiElement
				 * @name CKEDITOR.ui.dialog.html
				 * @param {CKEDITOR.dialog} dialog Parent dialog object.
				 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition Element definition.
				 * Accepted fields:
				 * <ul>
				 * 	<li><strong>html</strong> (Required) HTML code of this element.</li>
				 * </ul>
				 * @param {Array} htmlList List of HTML code to be added to the dialog's content area.
				 * @example
				 * @constructor
				 */
				return function( dialog, elementDefinition, htmlList )
				{
					if ( arguments.length < 3 )
						return;

					var myHtmlList = [],
						myHtml,
						theirHtml = elementDefinition.html,
						myMatch, theirMatch;

					// If the HTML input doesn't contain any tags at the beginning, add a <span> tag around it.
					if ( theirHtml.charAt( 0 ) != '<' )
						theirHtml = '<span>' + theirHtml + '</span>';

					// Look for focus function in definition.
					var focus = elementDefinition.focus;
					if ( focus )
					{
						var oldFocus = this.focus;
						this.focus = function()
						{
							oldFocus.call( this );
							typeof focus == 'function' && focus.call( this );
							this.fire( 'focus' );
						};
						if ( elementDefinition.isFocusable )
						{
							var oldIsFocusable = this.isFocusable;
							this.isFocusable = oldIsFocusable;
						}
						this.keyboardFocusable = true;
					}

					CKEDITOR.ui.dialog.uiElement.call( this, dialog, elementDefinition, myHtmlList, 'span', null, null, '' );

					// Append the attributes created by the uiElement call to the real HTML.
					myHtml = myHtmlList.join( '' );
					myMatch = myHtml.match( myHtmlRe );
					theirMatch = theirHtml.match( theirHtmlRe ) || [ '', '', '' ];

					if ( emptyTagRe.test( theirMatch[1] ) )
					{
						theirMatch[1] = theirMatch[1].slice( 0, -1 );
						theirMatch[2] = '/' + theirMatch[2];
					}

					htmlList.push( [ theirMatch[1], ' ', myMatch[1] || '', theirMatch[2] ].join( '' ) );
				};
			})(),

			/**
			 * Form fieldset for grouping dialog UI elements.
			 * @constructor
			 * @extends CKEDITOR.ui.dialog.uiElement
			 * @param {CKEDITOR.dialog} dialog Parent dialog object.
			 * @param {Array} childObjList
			 * Array of {@link CKEDITOR.ui.dialog.uiElement} objects inside this
			 * container.
			 * @param {Array} childHtmlList
			 * Array of HTML code that correspond to the HTML output of all the
			 * objects in childObjList.
			 * @param {Array} htmlList
			 * Array of HTML code that this element will output to.
			 * @param {CKEDITOR.dialog.definition.uiElement} elementDefinition
			 * The element definition. Accepted fields:
			 * <ul>
			 * 	<li><strong>label</strong> (Optional) The legend of the this fieldset.</li>
			 * 	<li><strong>children</strong> (Required) An array of dialog field definitions which will be grouped inside this fieldset. </li>
			 * </ul>
			 */
			fieldset : function( dialog, childObjList, childHtmlList, htmlList, elementDefinition )
			{
				var legendLabel = elementDefinition.label;
				/** @ignore */
				var innerHTML = function()
				{
					var html = [];
					legendLabel && html.push( '<legend>' + legendLabel + '</legend>' );
					for ( var i = 0; i < childHtmlList.length; i++ )
						html.push( childHtmlList[ i ] );
					return html.join( '' );
				};

				this._ = { children : childObjList };
				CKEDITOR.ui.dialog.uiElement.call( this, dialog, elementDefinition, htmlList, 'fieldset', null, null, innerHTML );
			}

		}, true );

	CKEDITOR.ui.dialog.html.prototype = new CKEDITOR.ui.dialog.uiElement;

	CKEDITOR.ui.dialog.labeledElement.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.uiElement,
			/** @lends CKEDITOR.ui.dialog.labeledElement.prototype */
			{
				/**
				 * Sets the label text of the element.
				 * @param {String} label The new label text.
				 * @returns {CKEDITOR.ui.dialog.labeledElement} The current labeled element.
				 * @example
				 */
				setLabel : function( label )
				{
					var node = CKEDITOR.document.getById( this._.labelId );
					if ( node.getChildCount() < 1 )
						( new CKEDITOR.dom.text( label, CKEDITOR.document ) ).appendTo( node );
					else
						node.getChild( 0 ).$.nodeValue = label;
					return this;
				},

				/**
				 * Retrieves the current label text of the elment.
				 * @returns {String} The current label text.
				 * @example
				 */
				getLabel : function()
				{
					var node = CKEDITOR.document.getById( this._.labelId );
					if ( !node || node.getChildCount() < 1 )
						return '';
					else
						return node.getChild( 0 ).getText();
				},

				/**
				 * Defines the onChange event for UI element definitions.
				 * @field
				 * @type Object
				 * @example
				 */
				eventProcessors : commonEventProcessors
			}, true );

	CKEDITOR.ui.dialog.button.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.uiElement,
			/** @lends CKEDITOR.ui.dialog.button.prototype */
			{
				/**
				 * Simulates a click to the button.
				 * @example
				 * @returns {Object} Return value of the 'click' event.
				 */
				click : function()
				{
					if ( !this._.disabled )
						return this.fire( 'click', { dialog : this._.dialog } );
					this.getElement().$.blur();
					return false;
				},

				/**
				 * Enables the button.
				 * @example
				 */
				enable : function()
				{
					this._.disabled = false;
					var element = this.getElement();
					element && element.removeClass( 'cke_disabled' );
				},

				/**
				 * Disables the button.
				 * @example
				 */
				disable : function()
				{
					this._.disabled = true;
					this.getElement().addClass( 'cke_disabled' );
				},

				isVisible : function()
				{
					return this.getElement().getFirst().isVisible();
				},

				isEnabled : function()
				{
					return !this._.disabled;
				},

				/**
				 * Defines the onChange event and onClick for button element definitions.
				 * @field
				 * @type Object
				 * @example
				 */
				eventProcessors : CKEDITOR.tools.extend( {}, CKEDITOR.ui.dialog.uiElement.prototype.eventProcessors,
					{
						/** @ignore */
						onClick : function( dialog, func )
						{
							this.on( 'click', func );
						}
					}, true ),

				/**
				 * Handler for the element's access key up event. Simulates a click to
				 * the button.
				 * @example
				 */
				accessKeyUp : function()
				{
					this.click();
				},

				/**
				 * Handler for the element's access key down event. Simulates a mouse
				 * down to the button.
				 * @example
				 */
				accessKeyDown : function()
				{
					this.focus();
				},

				keyboardFocusable : true
			}, true );

	CKEDITOR.ui.dialog.textInput.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.labeledElement,
			/** @lends CKEDITOR.ui.dialog.textInput.prototype */
			{
				/**
				 * Gets the text input DOM element under this UI object.
				 * @example
				 * @returns {CKEDITOR.dom.element} The DOM element of the text input.
				 */
				getInputElement : function()
				{
					return CKEDITOR.document.getById( this._.inputId );
				},

				/**
				 * Puts focus into the text input.
				 * @example
				 */
				focus : function()
				{
					var me = this.selectParentTab();

					// GECKO BUG: setTimeout() is needed to workaround invisible selections.
					setTimeout( function()
						{
							var element = me.getInputElement();
							element && element.$.focus();
						}, 0 );
				},

				/**
				 * Selects all the text in the text input.
				 * @example
				 */
				select : function()
				{
					var me = this.selectParentTab();

					// GECKO BUG: setTimeout() is needed to workaround invisible selections.
					setTimeout( function()
						{
							var e = me.getInputElement();
							if ( e )
							{
								e.$.focus();
								e.$.select();
							}
						}, 0 );
				},

				/**
				 * Handler for the text input's access key up event. Makes a select()
				 * call to the text input.
				 * @example
				 */
				accessKeyUp : function()
				{
					this.select();
				},

				/**
				 * Sets the value of this text input object.
				 * @param {Object} value The new value.
				 * @returns {CKEDITOR.ui.dialog.textInput} The current UI element.
				 * @example
				 * uiElement.setValue( 'Blamo' );
				 */
				setValue : function( value )
				{
					!value && ( value = '' );
					return CKEDITOR.ui.dialog.uiElement.prototype.setValue.apply( this, arguments );
				},

				keyboardFocusable : true
			}, commonPrototype, true );

	CKEDITOR.ui.dialog.textarea.prototype = new CKEDITOR.ui.dialog.textInput();

	CKEDITOR.ui.dialog.select.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.labeledElement,
			/** @lends CKEDITOR.ui.dialog.select.prototype */
			{
				/**
				 * Gets the DOM element of the select box.
				 * @returns {CKEDITOR.dom.element} The &lt;select&gt; element of this UI
				 * element.
				 * @example
				 */
				getInputElement : function()
				{
					return this._.select.getElement();
				},

				/**
				 * Adds an option to the select box.
				 * @param {String} label Option label.
				 * @param {String} value (Optional) Option value, if not defined it'll be
				 * assumed to be the same as the label.
				 * @param {Number} index (Optional) Position of the option to be inserted
				 * to. If not defined the new option will be inserted to the end of list.
				 * @example
				 * @returns {CKEDITOR.ui.dialog.select} The current select UI element.
				 */
				add : function( label, value, index )
				{
					var option = new CKEDITOR.dom.element( 'option', this.getDialog().getParentEditor().document ),
						selectElement = this.getInputElement().$;
					option.$.text = label;
					option.$.value = ( value === undefined || value === null ) ? label : value;
					if ( index === undefined || index === null )
					{
						if ( CKEDITOR.env.ie )
							selectElement.add( option.$ );
						else
							selectElement.add( option.$, null );
					}
					else
						selectElement.add( option.$, index );
					return this;
				},

				/**
				 * Removes an option from the selection list.
				 * @param {Number} index Index of the option to be removed.
				 * @example
				 * @returns {CKEDITOR.ui.dialog.select} The current select UI element.
				 */
				remove : function( index )
				{
					var selectElement = this.getInputElement().$;
					selectElement.remove( index );
					return this;
				},

				/**
				 * Clears all options out of the selection list.
				 * @returns {CKEDITOR.ui.dialog.select} The current select UI element.
				 */
				clear : function()
				{
					var selectElement = this.getInputElement().$;
					while ( selectElement.length > 0 )
						selectElement.remove( 0 );
					return this;
				},

				keyboardFocusable : true
			}, commonPrototype, true );

	CKEDITOR.ui.dialog.checkbox.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.uiElement,
			/** @lends CKEDITOR.ui.dialog.checkbox.prototype */
			{
				/**
				 * Gets the checkbox DOM element.
				 * @example
				 * @returns {CKEDITOR.dom.element} The DOM element of the checkbox.
				 */
				getInputElement : function()
				{
					return this._.checkbox.getElement();
				},

				/**
				 * Sets the state of the checkbox.
				 * @example
				 * @param {Boolean} true to tick the checkbox, false to untick it.
				 * @param {Boolean} noChangeEvent Internal commit, to supress 'change' event on this element.
				 */
				setValue : function( checked, noChangeEvent )
				{
					this.getInputElement().$.checked = checked;
					!noChangeEvent && this.fire( 'change', { value : checked } );
				},

				/**
				 * Gets the state of the checkbox.
				 * @example
				 * @returns {Boolean} true means the checkbox is ticked, false means it's not ticked.
				 */
				getValue : function()
				{
					return this.getInputElement().$.checked;
				},

				/**
				 * Handler for the access key up event. Toggles the checkbox.
				 * @example
				 */
				accessKeyUp : function()
				{
					this.setValue( !this.getValue() );
				},

				/**
				 * Defines the onChange event for UI element definitions.
				 * @field
				 * @type Object
				 * @example
				 */
				eventProcessors :
				{
					onChange : function( dialog, func )
					{
						if ( !CKEDITOR.env.ie )
							return commonEventProcessors.onChange.apply( this, arguments );
						else
						{
							dialog.on( 'load', function()
								{
									var element = this._.checkbox.getElement();
									element.on( 'propertychange', function( evt )
										{
											evt = evt.data.$;
											if ( evt.propertyName == 'checked' )
												this.fire( 'change', { value : element.$.checked } );
										}, this );
								}, this );
							this.on( 'change', func );
						}
						return null;
					}
				},

				keyboardFocusable : true
			}, commonPrototype, true );

	CKEDITOR.ui.dialog.radio.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.uiElement,
			/** @lends CKEDITOR.ui.dialog.radio.prototype */
			{
				/**
				 * Checks one of the radio buttons in this button group.
				 * @example
				 * @param {String} value The value of the button to be chcked.
				 * @param {Boolean} noChangeEvent Internal commit, to supress 'change' event on this element.
				 */
				setValue : function( value, noChangeEvent )
				{
					var children = this._.children,
						item;
					for ( var i = 0 ; ( i < children.length ) && ( item = children[i] ) ; i++ )
						item.getElement().$.checked = ( item.getValue() == value );
					!noChangeEvent && this.fire( 'change', { value : value } );
				},

				/**
				 * Gets the value of the currently checked radio button.
				 * @example
				 * @returns {String} The currently checked button's value.
				 */
				getValue : function()
				{
					var children = this._.children;
					for ( var i = 0 ; i < children.length ; i++ )
					{
						if ( children[i].getElement().$.checked )
							return children[i].getValue();
					}
					return null;
				},

				/**
				 * Handler for the access key up event. Focuses the currently
				 * selected radio button, or the first radio button if none is
				 * selected.
				 * @example
				 */
				accessKeyUp : function()
				{
					var children = this._.children, i;
					for ( i = 0 ; i < children.length ; i++ )
					{
						if ( children[i].getElement().$.checked )
						{
							children[i].getElement().focus();
							return;
						}
					}
					children[0].getElement().focus();
				},

				/**
				 * Defines the onChange event for UI element definitions.
				 * @field
				 * @type Object
				 * @example
				 */
				eventProcessors :
				{
					onChange : function( dialog, func )
					{
						if ( !CKEDITOR.env.ie )
							return commonEventProcessors.onChange.apply( this, arguments );
						else
						{
							dialog.on( 'load', function()
								{
									var children = this._.children, me = this;
									for ( var i = 0 ; i < children.length ; i++ )
									{
										var element = children[i].getElement();
										element.on( 'propertychange', function( evt )
											{
												evt = evt.data.$;
												if ( evt.propertyName == 'checked' && this.$.checked )
													me.fire( 'change', { value : this.getAttribute( 'value' ) } );
											} );
									}
								}, this );
							this.on( 'change', func );
						}
						return null;
					}
				},

				keyboardFocusable : true
			}, commonPrototype, true );

	CKEDITOR.ui.dialog.file.prototype = CKEDITOR.tools.extend( new CKEDITOR.ui.dialog.labeledElement,
			commonPrototype,
			/** @lends CKEDITOR.ui.dialog.file.prototype */
			{
				/**
				 * Gets the &lt;input&gt; element of this file input.
				 * @returns {CKEDITOR.dom.element} The file input element.
				 * @example
				 */
				getInputElement : function()
				{
					var frameDocument = CKEDITOR.document.getById( this._.frameId ).getFrameDocument();
					return frameDocument.$.forms.length > 0 ?
						new CKEDITOR.dom.element( frameDocument.$.forms[0].elements[0] ) :
						this.getElement();
				},

				/**
				 * Uploads the file in the file input.
				 * @returns {CKEDITOR.ui.dialog.file} This object.
				 * @example
				 */
				submit : function()
				{
					this.getInputElement().getParent().$.submit();
					return this;
				},

				/**
				 * Get the action assigned to the form.
				 * @returns {String} The value of the action.
				 * @example
				 */
				getAction : function()
				{
					return this.getInputElement().getParent().$.action;
				},

				/**
				 * The events must be applied on the inner input element, and
				 * that must be done when the iframe & form has been loaded
				 */
				registerEvents : function( definition )
				{
					var regex = /^on([A-Z]\w+)/,
						match;

					var registerDomEvent = function( uiElement, dialog, eventName, func )
					{
						uiElement.on( 'formLoaded', function()
						{
							uiElement.getInputElement().on( eventName, func, uiElement );
						});
					};

					for ( var i in definition )
					{
						if ( !( match = i.match( regex ) ) )
							continue;

						if ( this.eventProcessors[i] )
							this.eventProcessors[i].call( this, this._.dialog, definition[i] );
						else
							registerDomEvent( this, this._.dialog, match[1].toLowerCase(), definition[i] );
					}

					return this;
				},

				/**
				 * Redraws the file input and resets the file path in the file input.
				 * The redraw logic is necessary because non-IE browsers tend to clear
				 * the &lt;iframe&gt; containing the file input after closing the dialog.
				 * @example
				 */
				reset : function()
				{
					var _ = this._,
						frameElement = CKEDITOR.document.getById( _.frameId ),
						frameDocument = frameElement.getFrameDocument(),
						elementDefinition = _.definition,
						buttons = _.buttons,
						callNumber = this.formLoadedNumber,
						unloadNumber = this.formUnloadNumber,
						langDir = _.dialog._.editor.lang.dir,
						langCode = _.dialog._.editor.langCode;

					// The callback function for the iframe, but we must call tools.addFunction only once
					// so we store the function number in this.formLoadedNumber
					if ( !callNumber )
					{
						callNumber = this.formLoadedNumber = CKEDITOR.tools.addFunction(
							function()
							{
								// Now we can apply the events to the input type=file
								this.fire( 'formLoaded' ) ;
							}, this ) ;

						// Remove listeners attached to the content of the iframe (the file input)
						unloadNumber = this.formUnloadNumber = CKEDITOR.tools.addFunction(
							function()
							{
								this.getInputElement().clearCustomData();
							}, this ) ;

						this.getDialog()._.editor.on( 'destroy', function()
								{
									CKEDITOR.tools.removeFunction( callNumber );
									CKEDITOR.tools.removeFunction( unloadNumber );
								} );
					}

					function generateFormField()
					{
						frameDocument.$.open();

						// Support for custom document.domain in IE.
						if ( CKEDITOR.env.isCustomDomain() )
							frameDocument.$.domain = document.domain;

						var size = '';
						if ( elementDefinition.size )
							size = elementDefinition.size - ( CKEDITOR.env.ie  ? 7 : 0 );	// "Browse" button is bigger in IE.

						frameDocument.$.write( [ '<html dir="' + langDir + '" lang="' + langCode + '"><head><title></title></head><body style="margin: 0; overflow: hidden; background: transparent;">',
								'<form enctype="multipart/form-data" method="POST" dir="' + langDir + '" lang="' + langCode + '" action="',
								CKEDITOR.tools.htmlEncode( elementDefinition.action ),
								'">',
								'<input type="file" name="',
								CKEDITOR.tools.htmlEncode( elementDefinition.id || 'cke_upload' ),
								'" size="',
								CKEDITOR.tools.htmlEncode( size > 0 ? size : "" ),
								'" />',
								'</form>',
								'</body></html>',
								'<script>window.parent.CKEDITOR.tools.callFunction(' + callNumber + ');',
								'window.onbeforeunload = function() {window.parent.CKEDITOR.tools.callFunction(' + unloadNumber + ')}</script>' ].join( '' ) );

						frameDocument.$.close();

						for ( var i = 0 ; i < buttons.length ; i++ )
							buttons[i].enable();
					}

					// #3465: Wait for the browser to finish rendering the dialog first.
					if ( CKEDITOR.env.gecko )
						setTimeout( generateFormField, 500 );
					else
						generateFormField();
				},

				getValue : function()
				{
					return this.getInputElement().$.value || '';
				},

				/***
				 * The default value of input type="file" is an empty string, but during initialization
				 * of this UI element, the iframe still isn't ready so it can't be read from that object
				 * Setting it manually prevents later issues about the current value ("") being different
				 * of the initial value (undefined as it asked for .value of a div)
				 */
				setInitValue : function()
				{
					this._.initValue = '';
				},

				/**
				 * Defines the onChange event for UI element definitions.
				 * @field
				 * @type Object
				 * @example
				 */
				eventProcessors :
				{
					onChange : function( dialog, func )
					{
						// If this method is called several times (I'm not sure about how this can happen but the default
						// onChange processor includes this protection)
						// In order to reapply to the new element, the property is deleted at the beggining of the registerEvents method
						if ( !this._.domOnChangeRegistered )
						{
							// By listening for the formLoaded event, this handler will get reapplied when a new
							// form is created
							this.on( 'formLoaded', function()
							{
								this.getInputElement().on( 'change', function(){ this.fire( 'change', { value : this.getValue() } ); }, this );
							}, this );
							this._.domOnChangeRegistered = true;
						}

						this.on( 'change', func );
					}
				},

				keyboardFocusable : true
			}, true );

	CKEDITOR.ui.dialog.fileButton.prototype = new CKEDITOR.ui.dialog.button;

	CKEDITOR.ui.dialog.fieldset.prototype = CKEDITOR.tools.clone( CKEDITOR.ui.dialog.hbox.prototype );

	CKEDITOR.dialog.addUIElement( 'text', textBuilder );
	CKEDITOR.dialog.addUIElement( 'password', textBuilder );
	CKEDITOR.dialog.addUIElement( 'textarea', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'checkbox', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'radio', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'button', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'select', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'file', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'fileButton', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'html', commonBuilder );
	CKEDITOR.dialog.addUIElement( 'fieldset', containerBuilder );
})();

/**
 * Fired when the value of the uiElement is changed
 * @name CKEDITOR.ui.dialog.uiElement#change
 * @event
 */

/**
 * Fired when the inner frame created by the element is ready.
 * Each time the button is used or the dialog is loaded a new
 * form might be created.
 * @name CKEDITOR.ui.dialog.fileButton#formLoaded
 * @event
 */
