// :external asset_source entry for the dummy app. Built into app/assets/builds/rails_admin.js.
// base already bundles @rails/activestorage, @rails/actiontext and all flatpickr locales;
// the dummy adds Trix on top so the rich-text editor is served statically instead of
// from the CDN.
import "rails_admin/src/rails_admin/base";
import "trix";
