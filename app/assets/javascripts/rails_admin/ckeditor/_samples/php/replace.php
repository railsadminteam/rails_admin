<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Replace Selected Textarea Elements &mdash; CKEditor Sample</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<link href="../sample.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 class="samples">
		CKEditor Sample &mdash;  Replace Selected Textarea Elements Using PHP Code
	</h1>
	<div class="description">
	<p>
		This sample shows how to replace a selected <code>&lt;textarea&gt;</code> element
		with a CKEditor instance by using PHP code.
	</p>
	<p>
		To replace a <code>&lt;textarea&gt;</code> element, place the following call at any point
		after the <code>&lt;textarea&gt;</code> element:
	</p>
	<pre class="samples">
&lt;?php
// Include the CKEditor class.
include_once "ckeditor/ckeditor.php";

// Create a class instance.
$CKEditor = new CKEditor();

// Path to the CKEditor directory.
$CKEditor->basePath = '/ckeditor/';

// Replace a textarea element with an id (or name) of "textarea_id".
$CKEditor->replace("textarea_id");
?&gt;</pre>
	<p>
		Note that <code><em>textarea_id</em></code> in the code above is the <code>id</code> attribute of
		the <code>&lt;textarea&gt;</code> element to be replaced.
	</p>
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
		<p>
			<label for="editor1">
				Editor 1:</label>
			<textarea cols="80" id="editor1" name="editor1" rows="10">&lt;p&gt;This is some &lt;strong&gt;sample text&lt;/strong&gt;. You are using &lt;a href="http://ckeditor.com/"&gt;CKEditor&lt;/a&gt;.&lt;/p&gt;</textarea>
		</p>
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
	<?php
	// Include the CKEditor class.
	include_once "../../ckeditor.php";
	// Create a class instance.
	$CKEditor = new CKEditor();
	// Path to the CKEditor directory, ideally use an absolute path instead of a relative dir.
	//   $CKEditor->basePath = '/ckeditor/'
	// If not set, CKEditor will try to detect the correct path.
	$CKEditor->basePath = '../../';
	// Replace a textarea element with an id (or name) of "editor1".
	$CKEditor->replace("editor1");
	?>
</body>
</html>
