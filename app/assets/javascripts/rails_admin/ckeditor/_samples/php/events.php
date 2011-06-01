<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Adding Event Handlers &mdash; CKEditor Sample</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<link href="../sample.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 class="samples">
		CKEditor Sample &mdash; Adding Event Handlers
	</h1>
	<div class="description">
	<p>
		This sample shows how to add event handlers to CKEditor with PHP.
	</p>
	<p>
		A snippet of the configuration code can be seen below; check the source code of this page for
		the full definition:
	</p>
	<pre class="samples">&lt;?php
// Include the CKEditor class.
include("ckeditor/ckeditor.php");

// Create a class instance.
$CKEditor = new CKEditor();

// Path to the CKEditor directory.
$CKEditor->basePath = '/ckeditor/';

// The initial value to be displayed in the editor.
$initialValue = 'This is some sample text.';

// Add event handler, <em>instanceReady</em> is fired when editor is loaded.
$CKEditor-><strong>addEventHandler</strong>('instanceReady', 'function (evt) {
	alert("Loaded editor: " + evt.editor.name);
}');

// Create an editor instance.
$CKEditor->editor("editor1", $initialValue);
</pre>
	</div>
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
	<form action="../sample_posteddata.php" method="post">
		<label>Editor 1:</label>
<?php

/**
 * Adds a global event, will hide the "Target" tab in the "Link" dialog window in all instances.
 */
function CKEditorHideLinkTargetTab(&$CKEditor) {

	$function = 'function (ev) {
		// Take the dialog window name and its definition from the event data.
		var dialogName = ev.data.name;
		var dialogDefinition = ev.data.definition;

		// Check if the definition comes from the "Link" dialog window.
		if ( dialogName == "link" )
			dialogDefinition.removeContents("target")
	}';

	$CKEditor->addGlobalEventHandler('dialogDefinition', $function);
}

/**
 * Adds a global event, will notify about an open dialog window.
 */
function CKEditorNotifyAboutOpenedDialog(&$CKEditor) {
	$function = 'function (evt) {
		alert("Loading a dialog window: " + evt.data.name);
	}';

	$CKEditor->addGlobalEventHandler('dialogDefinition', $function);
}

// Include the CKEditor class.
include("../../ckeditor.php");

// Create a class instance.
$CKEditor = new CKEditor();

// Set a configuration option for all editors.
$CKEditor->config['width'] = 750;

// Path to the CKEditor directory, ideally use an absolute path instead of a relative dir.
//   $CKEditor->basePath = '/ckeditor/'
// If not set, CKEditor will try to detect the correct path.
$CKEditor->basePath = '../../';

// The initial value to be displayed in the editor.
$initialValue = '<p>This is some <strong>sample text</strong>. You are using <a href="http://ckeditor.com/">CKEditor</a>.</p>';

// Event that will be handled only by the first editor.
$CKEditor->addEventHandler('instanceReady', 'function (evt) {
	alert("Loaded editor: " + evt.editor.name);
}');

// Create the first instance.
$CKEditor->editor("editor1", $initialValue);

// Clear event handlers. Instances that will be created later will not have
// the 'instanceReady' listener defined a couple of lines above.
$CKEditor->clearEventHandlers();
?>
		<br />
		<label>Editor 2:</label>
<?php
// Configuration that will only be used by the second editor.
$config['width'] = '600';
$config['toolbar'] = 'Basic';

// Add some global event handlers (for all editors).
CKEditorHideLinkTargetTab($CKEditor);
CKEditorNotifyAboutOpenedDialog($CKEditor);

// Event that will only be handled by the second editor.
// Instead of calling addEventHandler(), events may be passed as an argument.
$events['instanceReady'] = 'function (evt) {
	alert("Loaded second editor: " + evt.editor.name);
}';

// Create the second instance.
$CKEditor->editor("editor2", $initialValue, $config, $events);
?>
		<p>
			<input type="submit" value="Submit"/>
		</p>
	</form>
	<div id="footer">
		<hr />
		<p>
			CKEditor - The text editor for the Internet - <a class="samples" href="http://ckeditor.com/">http://ckeditor.com</a>
		</p>
		<p id="copy">
			Copyright &copy; 2003-2011, <a class="samples" href="http://cksource.com/">CKSource</a> - Frederico
			Knabben. All rights reserved.
		</p>
	</div>
</body>
</html>
