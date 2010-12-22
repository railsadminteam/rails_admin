/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.skins.add('office2003',(function(){return{editor:{css:['editor.css']},dialog:{css:['dialog.css']},templates:{css:['templates.css']},margins:[0,14,18,14]};})());(function(){CKEDITOR.dialog?a():CKEDITOR.on('dialogPluginReady',a);function a(){CKEDITOR.dialog.on('resize',function(b){var c=b.data,d=c.width,e=c.height,f=c.dialog,g=f.parts.contents;if(c.skin!='office2003')return;g.setStyles({width:d+'px',height:e+'px'});if(!CKEDITOR.env.ie)return;var h=function(){var i=f.parts.dialog.getChild([0,0,0]),j=i.getChild(0),k=i.getChild(2);k.setStyle('width',j.$.offsetWidth+'px');k=i.getChild(7);k.setStyle('width',j.$.offsetWidth-28+'px');k=i.getChild(4);k.setStyle('height',e+j.getChild(0).$.offsetHeight+'px');k=i.getChild(5);k.setStyle('height',e+j.getChild(0).$.offsetHeight+'px');};setTimeout(h,100);if(b.editor.lang.dir=='rtl')setTimeout(h,1000);});};})();
