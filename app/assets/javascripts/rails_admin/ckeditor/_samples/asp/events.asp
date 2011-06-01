<%@  codepage="65001" language="VBScript" %>
<% Option Explicit %>
<!-- #INCLUDE file="../../ckeditor.asp" -->
<%

	' You must set "Enable Parent Paths" on your web site
	' in order for the above relative include to work.
	' Or you can use #INCLUDE VIRTUAL="/full path/ckeditor.asp"

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Sample - CKEditor</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<link href="../sample.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 class="samples">
		CKEditor Sample
	</h1>
	<!-- This <div> holds alert messages to be display in the sample page. -->
	<div id="alerts">
		<noscript>
			<p>
				<strong>CKEditor requires JavaScript to run</strong>. In a browser with no JavaScript
				support, like yours, you should still see the contents (HTML data) and you should
				be able to edit it normally, without a rich editor interface.
			</p>
		</noscript>
	</div>
	<!-- This <fieldset> holds the HTML that you will usually find in your pages. -->
	<fieldset title="Output">
		<legend>Output</legend>
		<form action="sample_posteddata.asp" method="post">
			<p>
				<label>Editor 1:</label><br/>
			</p>
<%

''
 ' Adds global event, will hide "Target" tab in Link dialog in all instances.
 '
function CKEditorHideLinkTargetTab(editor)
	dim functionCode
	functionCode = "function (ev) {" & vbcrlf & _
		"// Take the dialog name and its definition from the event data" & vbcrlf & _
		"var dialogName = ev.data.name;" & vbcrlf & _
		"var dialogDefinition = ev.data.definition;" & vbcrlf & _
		"" & vbcrlf & _
		"// Check if the definition is from the Link dialog." & vbcrlf & _
		"if ( dialogName == 'link' )" & vbcrlf & _
		"	dialogDefinition.removeContents('target')" & vbcrlf & _
	"}" & vbcrlf

	editor.addGlobalEventHandler "dialogDefinition", functionCode
end function

''
 ' Adds global event, will notify about opened dialog.
 '
function CKEditorNotifyAboutOpenedDialog(editor)
	dim functionCode
	functionCode = "function (evt) {" & vbcrlf & _
		"alert('Loading dialog: ' + evt.data.name);" & vbcrlf & _
	"}"

	editor.addGlobalEventHandler "dialogDefinition", functionCode
end function


dim editor, initialValue

' Create class instance.
set editor = new CKEditor

' Set configuration option for all editors.
editor.config("width") = 750

' Path to CKEditor directory, ideally instead of relative dir, use an absolute path:
'   editor.basePath = "/ckeditor/"
' If not set, CKEditor will default to /ckeditor/
editor.basePath = "../../"

' The initial value to be displayed in the editor.
initialValue = "<p>This is some <strong>sample text</strong>. You are using <a href=""http://ckeditor.com/"">CKEditor</a>.</p>"

' Event that will be handled only by the first editor.
editor.addEventHandler "instanceReady", "function (evt) {	alert('Loaded editor: ' + evt.editor.name );}"

' Create first instance.
editor.editor "editor1", initialValue

' Clear event handlers, instances that will be created later will not have
' the 'instanceReady' listener defined a couple of lines above.
editor.clearEventHandlers empty
%>
			<p>
				<label>Editor 2:</label><br/>
			</p>
<%
' Configuration that will be used only by the second editor.
editor.instanceConfig("width") = 600
editor.instanceConfig("toolbar") = "Basic"

' Add some global event handlers (for all editors).
CKEditorHideLinkTargetTab(editor)
CKEditorNotifyAboutOpenedDialog(editor)

' Event that will be handled only by the second editor.
editor.addInstanceEventHandler "instanceReady", "function (evt) { alert('Loaded second editor: ' + evt.editor.name );}"

' Create second instance.
editor.editor "editor2", initialValue
%>
			<p>
				<input type="submit" value="Submit"/>
			</p>
		</form>
	</fieldset>
	<div id="footer">
		<hr />
		<p>
			CKEditor - The text editor for Internet - <a class="samples" href="http://ckeditor.com/">http://ckeditor.com</a>
		</p>
		<p id="copy">
			Copyright &copy; 2003-2011, <a class="samples" href="http://cksource.com/">CKSource</a> - Frederico
			Knabben. All rights reserved.
		</p>
	</div>
</body>
</html>
