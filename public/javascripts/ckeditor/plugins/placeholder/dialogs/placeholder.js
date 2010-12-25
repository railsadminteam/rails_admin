/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

(function(){function a(b,c){var d=b.lang.placeholder,e=b.lang.common.generalTab;return{title:d.title,minWidth:300,minHeight:80,contents:[{id:'info',label:e,title:e,elements:[{id:'text',type:'text',style:'width: 100%;',label:d.text,'default':'',required:true,validate:CKEDITOR.dialog.validate.notEmpty(d.textMissing),setup:function(f){if(c)this.setValue(f.getText().slice(2,-2));},commit:function(f){var g='[['+this.getValue()+']]';CKEDITOR.plugins.placeholder.createPlaceholder(b,f,g);}}]}],onShow:function(){if(c){var f=b.getSelection().getRanges()[0];f.shrink(CKEDITOR.SHRINK_TEXT);var g=f.startContainer;while(g&&!(g.type==CKEDITOR.NODE_ELEMENT&&g.data('cke-placeholder')))g=g.getParent();this._element=g;}this.setupContent(this._element);},onOk:function(){this.commitContent(this._element);delete this._element;}};};CKEDITOR.dialog.add('createplaceholder',function(b){return a(b);});CKEDITOR.dialog.add('editplaceholder',function(b){return a(b,1);});})();
