import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import jQuery from "jquery";
import "./vendor/jquery_nested_form";
import "bootstrap";

// These jQuery-UI indirect dependencies need to be preloaded to be used within Import maps
import "jquery-ui/ui/version.js";
import "jquery-ui/ui/keycode.js";
import "jquery-ui/ui/position.js";
import "jquery-ui/ui/safe-active-element.js";
import "jquery-ui/ui/data.js";
import "jquery-ui/ui/ie.js";
import "jquery-ui/ui/scroll-parent.js";
import "jquery-ui/ui/unique-id.js";
import "jquery-ui/ui/widget.js";
import "jquery-ui/ui/widgets/menu.js";
import "jquery-ui/ui/widgets/mouse.js";

import "./filter-box";
import "./filtering-multiselect";
import "./filtering-select";
import "./nested-form-hooks";
import "./remote-form";
import "./sidescroll";
import "./ui";
import "./widgets";

Rails.start();
window.$ = window.jQuery = jQuery;
