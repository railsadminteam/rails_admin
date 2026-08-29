import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import "./jquery.js";
import "./vendor/jquery_nested_form.js";
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

import "./abstract-select.js";
import "./filter-box.js";
import "./filtering-multiselect.js";
import "./filtering-select.js";
import "./nested-form-hooks.js";
import "./remote-form.js";
import "./sidescroll.js";
import "./ui.js";
import "./widgets.js";

if (!window._rails_loaded) {
  Rails.start();
}
