<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>Creating CKEditor Instances &mdash; CKEditor Sample</title>
	<meta content="text/html; charset=utf-8" http-equiv="content-type"/>
	<link href="../sample.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<h1 class="samples">
		CKEditor Sample &mdash; Creating CKEditor Instances
	</h1>
	<div class="description">
	<p>
		This sample shows how to create a CKEditor instance with PHP.
	</p>
	<pre class="samples">
&lt;?php
include_once "ckeditor/ckeditor.php";

// Create a class instance.
$CKEditor = new CKEditor();

// Path to the CKEditor directory.
$CKEditor->basePath = '/ckeditor/';

// Create a textarea element and attach CKEditor to it.
$CKEditor->editor("textarea_id", "This is some sample text");
?&gt;</pre>
	<p>
		Note that <code><em>textarea_id</em></code> in the code above is the <code>id</code> and <code>name</code> attribute of
		the <code>&lt;textarea&gt;</code> element that will be created.
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
	<!-- This <fieldset> holds the HTML code that you will usually find in your pages. -->
	<form action="../sample_posteddata.php" method="post">
		<p>
			<label for="editor1">
				Editor 1:</label>
		</p>
		<p>
		<?php
			// Include the CKEditor class.
			include_once "../../ckeditor.php";
			// The initial value to be displayed in the editor.
			$initialValue = '<p>This is some <strong>sample text</strong>.</p>';
			// Create a class instance.
			$CKEditor = new CKEditor();
			// Path to the CKEditor directory, ideally use an absolute path instead of a relative dir.
			//   $CKEditor->basePath = '/ckeditor/'
			// If not set, CKEditor will try to detect the correct path.
			$CKEditor->basePath = '../../';
			// Create a textarea element and attach CKEditor to it.
			$CKEditor->editor("editor1", $initialValue);
		?>
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
