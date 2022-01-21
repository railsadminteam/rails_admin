import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import jQuery from "jquery";
import "./vendor/jquery_nested_form";
import "bootstrap";
import "flatpickr/dist/flatpickr";

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
