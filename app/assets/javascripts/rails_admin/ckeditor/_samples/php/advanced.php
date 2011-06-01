<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Setting Configuration Options &mdash; CKEditor Sample</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<link href="../sample.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 class="samples">
		CKEditor Sample &mdash; Setting Configuration Options
	</h1>
	<p>
		This sample shows how to insert a CKEditor instance with custom configuration options.
	</p>
	<p>
		To set configuration options, use the <a class="samples" href="http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html"><code>config</code></a> property. To set the attributes of a <code>&lt;textarea&gt;</code> element (which is displayed instead of CKEditor in unsupported browsers), use the <code>textareaAttributes</code> property.
	</p>
	<pre class="samples">
&lt;?php
// Include the CKEditor class.
include_once "ckeditor/ckeditor.php";

// Create a class instance.
$CKEditor = new CKEditor();

// Path to the CKEditor directory.
$CKEditor->basePath = '/ckeditor/';

// Set global configuration (used by every instance of CKEditor).
$CKEditor-><strong>config['width']</strong> = 600;

// Change default textarea attributes.
$CKEditor-><strong>textareaAttributes</strong> = array("cols" => 80, "rows" => 10);

// The initial value to be displayed in the editor.
$initialValue = 'This is some sample text.';

// Create the first instance.
$CKEditor->editor("textarea_id", $initialValue);
?&gt;</pre>
	<p>
		Note that <code><em>textarea_id</em></code> in the code above is the <code>name</code> attribute of
		the <code>&lt;textarea&gt;</code> element to be created.
	</p>

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
// Include the CKEditor class.
include("../../ckeditor.php");

// Create a class instance.
$CKEditor = new CKEditor();

// Do not print the code directly to the browser, return it instead.
$CKEditor->returnOutput = true;

// Path to the CKEditor directory, ideally use an absolute path instead of a relative dir.
//   $CKEditor->basePath = '/ckeditor/'
// If not set, CKEditor will try to detect the correct path.
$CKEditor->basePath = '../../';

// Set global configuration (will be used by all instances of CKEditor).
$CKEditor->config['width'] = 600;

// Change default textarea attributes.
$CKEditor->textareaAttributes = array("cols" => 80, "rows" => 10);

// The initial value to be displayed in the editor.
$initialValue = '<p>This is some <strong>sample text</strong>. You are using <a href="http://ckeditor.com/">CKEditor</a>.</p>';

// Create the first instance.
$code = $CKEditor->editor("editor1", $initialValue);

echo $code;
?>
				<br />
				<label>Editor 2:</label>
<?php
// Configuration that will only be used by the second editor.
$config['toolbar'] = array(
	array( 'Source', '-', 'Bold', 'Italic', 'Underline', 'Strike' ),
	array( 'Image', 'Link', 'Unlink', 'Anchor' )
);

$config['skin'] = 'v2';

// Create the second instance.
echo $CKEditor->editor("editor2", $initialValue, $config);
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
