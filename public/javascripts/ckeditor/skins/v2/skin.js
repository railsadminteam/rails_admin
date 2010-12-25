/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.skins.add('v2',(function(){return{editor:{css:['editor.css']},dialog:{css:['dialog.css']},templates:{css:['templates.css']},margins:[0,14,18,14]};})());(function(){CKEDITOR.dialog?a():CKEDITOR.on('dialogPluginReady',a);function a(){CKEDITOR.dialog.on('resize',function(b){var c=b.data,d=c.width,e=c.height,f=c.dialog,g=f.parts.contents;if(c.skin!='v2')return;g.setStyles({width:d+'px',height:e+'px'});if(!CKEDITOR.env.ie)return;setTimeout(function(){var h=f.parts.dialog.getChild([0,0,0]),i=h.getChild(0),j=h.getChild(2);j.setStyle('width',i.$.offsetWidth+'px');j=h.getChild(7);j.setStyle('width',i.$.offsetWidth-28+'px');j=h.getChild(4);j.setStyle('height',e+i.getChild(0).$.offsetHeight+'px');j=h.getChild(5);j.setStyle('height',e+i.getChild(0).$.offsetHeight+'px');},100);});};})();
