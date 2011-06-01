/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function()
{
	// Base HTML entities.
	var htmlbase = 'nbsp,gt,lt,amp';

	var entities =
		// Latin-1 Entities
		'quot,iexcl,cent,pound,curren,yen,brvbar,sect,uml,copy,ordf,laquo,' +
		'not,shy,reg,macr,deg,plusmn,sup2,sup3,acute,micro,para,middot,' +
		'cedil,sup1,ordm,raquo,frac14,frac12,frac34,iquest,times,divide,' +

		// Symbols
		'fnof,bull,hellip,prime,Prime,oline,frasl,weierp,image,real,trade,' +
		'alefsym,larr,uarr,rarr,darr,harr,crarr,lArr,uArr,rArr,dArr,hArr,' +
		'forall,part,exist,empty,nabla,isin,notin,ni,prod,sum,minus,lowast,' +
		'radic,prop,infin,ang,and,or,cap,cup,int,there4,sim,cong,asymp,ne,' +
		'equiv,le,ge,sub,sup,nsub,sube,supe,oplus,otimes,perp,sdot,lceil,' +
		'rceil,lfloor,rfloor,lang,rang,loz,spades,clubs,hearts,diams,' +

		// Other Special Characters
		'circ,tilde,ensp,emsp,thinsp,zwnj,zwj,lrm,rlm,ndash,mdash,lsquo,' +
		'rsquo,sbquo,ldquo,rdquo,bdquo,dagger,Dagger,permil,lsaquo,rsaquo,' +
		'euro';

	// Latin Letters Entities
	var latin =
		'Agrave,Aacute,Acirc,Atilde,Auml,Aring,AElig,Ccedil,Egrave,Eacute,' +
		'Ecirc,Euml,Igrave,Iacute,Icirc,Iuml,ETH,Ntilde,Ograve,Oacute,Ocirc,' +
		'Otilde,Ouml,Oslash,Ugrave,Uacute,Ucirc,Uuml,Yacute,THORN,szlig,' +
		'agrave,aacute,acirc,atilde,auml,aring,aelig,ccedil,egrave,eacute,' +
		'ecirc,euml,igrave,iacute,icirc,iuml,eth,ntilde,ograve,oacute,ocirc,' +
		'otilde,ouml,oslash,ugrave,uacute,ucirc,uuml,yacute,thorn,yuml,' +
		'OElig,oelig,Scaron,scaron,Yuml';

	// Greek Letters Entities.
	var greek =
		'Alpha,Beta,Gamma,Delta,Epsilon,Zeta,Eta,Theta,Iota,Kappa,Lambda,Mu,' +
		'Nu,Xi,Omicron,Pi,Rho,Sigma,Tau,Upsilon,Phi,Chi,Psi,Omega,alpha,' +
		'beta,gamma,delta,epsilon,zeta,eta,theta,iota,kappa,lambda,mu,nu,xi,' +
		'omicron,pi,rho,sigmaf,sigma,tau,upsilon,phi,chi,psi,omega,thetasym,' +
		'upsih,piv';

	/**
	 * Create a mapping table between one character and it's entity form from a list of entity names.
	 * @param reverse {Boolean} Whether create a reverse map from the entity string form to actual character.
	 */
	function buildTable( entities, reverse )
	{
		var table = {},
			regex = [];

		// Entities that the browsers DOM don't transform to the final char
		// automatically.
		var specialTable =
			{
				nbsp	: '\u00A0',		// IE | FF
				shy		: '\u00AD',		// IE
				gt		: '\u003E',		// IE | FF |   --   | Opera
				lt		: '\u003C',		// IE | FF | Safari | Opera
				amp : '\u0026'		// ALL
			};

		entities = entities.replace( /\b(nbsp|shy|gt|lt|amp)(?:,|$)/g, function( match, entity )
			{
				var org = reverse ? '&' + entity + ';' : specialTable[ entity ],
					result = reverse ? specialTable[ entity ] : '&' + entity + ';';

				table[ org ] = result;
				regex.push( org );
				return '';
			});

		if ( !reverse && entities )
		{
			// Transforms the entities string into an array.
			entities = entities.split( ',' );

			// Put all entities inside a DOM element, transforming them to their
			// final chars.
			var div = document.createElement( 'div' ),
				chars;
			div.innerHTML = '&' + entities.join( ';&' ) + ';';
			chars = div.innerHTML;
			div = null;

			// Add all chars to the table.
			for ( var i = 0 ; i < chars.length ; i++ )
			{
				var charAt = chars.charAt( i );
				table[ charAt ] = '&' + entities[ i ] + ';';
				regex.push( charAt );
			}
		}

		table.regex = regex.join( reverse ? '|' : '' );

		return table;
	}

	CKEDITOR.plugins.add( 'entities',
	{
		afterInit : function( editor )
		{
			var config = editor.config;

			var dataProcessor = editor.dataProcessor,
				htmlFilter = dataProcessor && dataProcessor.htmlFilter;

			if ( htmlFilter )
			{
				// Mandatory HTML base entities.
				var selectedEntities = '';

				if ( config.basicEntities !== false )
					selectedEntities += htmlbase;

				if ( config.entities )
				{
					selectedEntities += ',' + entities;
					if ( config.entities_latin )
						selectedEntities += ',' + latin;

					if ( config.entities_greek )
						selectedEntities += ',' + greek;

					if ( config.entities_additional )
						selectedEntities += ',' + config.entities_additional;
				}

				var entitiesTable = buildTable( selectedEntities );

				// Create the Regex used to find entities in the text, leave it matches nothing if entities are empty.
				var entitiesRegex = entitiesTable.regex ? '[' + entitiesTable.regex + ']' : 'a^';
				delete entitiesTable.regex;

				if ( config.entities && config.entities_processNumerical )
					entitiesRegex = '[^ -~]|' + entitiesRegex ;

				entitiesRegex = new RegExp( entitiesRegex, 'g' );

				function getEntity( character )
				{
					return config.entities_processNumerical == 'force' || !entitiesTable[ character ] ?
						   '&#' + character.charCodeAt(0) + ';'
							: entitiesTable[ character ];
				}

				// Decode entities that the browsers has transformed
				// at first place.
				var baseEntitiesTable = buildTable( [ htmlbase, 'shy' ].join( ',' ) , true ),
					baseEntitiesRegex = new RegExp( baseEntitiesTable.regex, 'g' );

				function getChar( character )
				{
					return baseEntitiesTable[ character ];
				}

				htmlFilter.addRules(
					{
						text : function( text )
						{
							return text.replace( baseEntitiesRegex, getChar )
									.replace( entitiesRegex, getEntity );
						}
					});
			}
		}
	});
})();

/**
 * Whether to escape HTML preserved entities in text, including:
 * <ul>
 * <li>nbsp</li>
 * <li>gt</li>
 * <li>lt</li>
 * <li>amp</li>
 * </ul>
 * <strong>Note:</strong> It should not be subjected to change unless you're outputting non-HTML data format like BBCode.
 * @type Boolean
 * @default true
 * @example
 * config.basicEntities = false;
 */
CKEDITOR.config.basicEntities = true;

/**
 * Whether to use HTML entities in the output.
 * @name CKEDITOR.config.entities
 * @type Boolean
 * @default true
 * @example
 * config.entities = false;
 */
CKEDITOR.config.entities = true;

/**
 * Whether to convert some Latin characters (Latin alphabet No&#46; 1, ISO 8859-1)
 * to HTML entities. The list of entities can be found at the
 * <a href="http://www.w3.org/TR/html4/sgml/entities.html#h-24.2.1">W3C HTML 4.01 Specification, section 24.2.1</a>.
 * @name CKEDITOR.config.entities_latin
 * @type Boolean
 * @default true
 * @example
 * config.entities_latin = false;
 */
CKEDITOR.config.entities_latin = true;

/**
 * Whether to convert some symbols, mathematical symbols, and Greek letters to
 * HTML entities. This may be more relevant for users typing text written in Greek.
 * The list of entities can be found at the
 * <a href="http://www.w3.org/TR/html4/sgml/entities.html#h-24.3.1">W3C HTML 4.01 Specification, section 24.3.1</a>.
 * @name CKEDITOR.config.entities_greek
 * @type Boolean
 * @default true
 * @example
 * config.entities_greek = false;
 */
CKEDITOR.config.entities_greek = true;

/**
 * Whether to convert all remaining characters, not comprised in the ASCII
 * character table, to their relative decimal numeric representation of HTML entity.
 * When specified as the value 'force', it will simply convert all entities into the above form.
 * For example, the phrase "This is Chinese: &#27721;&#35821;." is outputted
 * as "This is Chinese: &amp;#27721;&amp;#35821;."
 * @name CKEDITOR.config.entities_processNumerical
 * @type Boolean|String
 * @default false
 * @example
 * config.entities_processNumerical = true;
 * config.entities_processNumerical = 'force';		//Convert from "&nbsp;" into "&#160;";
 */

/**
 * An additional list of entities to be used. It's a string containing each
 * entry separated by a comma. Entities names or number must be used, exclusing
 * the "&amp;" preffix and the ";" termination.
 * @name CKEDITOR.config.entities_additional
 * @default '#39'  // The single quote (') character.
 * @type String
 * @example
 */
CKEDITOR.config.entities_additional = '#39';
