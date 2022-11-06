# RailsAdmin Changelog

## [Unreleased](https://github.com/railsadminteam/rails_admin/tree/HEAD)

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.1.0...HEAD)

## [3.1.0](https://github.com/railsadminteam/rails_admin/tree/v3.1.0) - 2022-11-06

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.1.0.rc2...v3.1.0)

### Fixed

- Fix to use defer instead of async to ensure script loading order ([2a40976](https://github.com/railsadminteam/rails_admin/commit/2a409764b13a4e23fc848725c604d318e3375484), [#3513](https://github.com/railsadminteam/rails_admin/issues/3513))
- Improve filter method select box appearance ([#3559](https://github.com/railsadminteam/rails_admin/pull/3559))

## [3.1.0.rc2](https://github.com/railsadminteam/rails_admin/tree/v3.1.0.rc2) - 2022-10-02

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.1.0.rc...v3.1.0.rc2)

### Fixed

- Fix sidebar style broken in attempt to support Bootstrap 5.2 ([d7abba4](https://github.com/railsadminteam/rails_admin/commit/d7abba4e8a2e380b4d7f8fb3b37302300af63de5), [#3553](https://github.com/railsadminteam/rails_admin/issues/3553))

## [3.1.0.rc](https://github.com/railsadminteam/rails_admin/tree/v3.1.0.rc) - 2022-09-22

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.1.0.beta...v3.1.0.rc)

### Added

- Add ability to limit filter operators ([be9a75e](https://github.com/railsadminteam/rails_admin/commit/be9a75e504edd9a754157a4ddba590e8a5d14149))
- Support filtering has_one associations ([9657774](https://github.com/railsadminteam/rails_admin/commit/9657774b423912357d8ad8a476b644bb4e36dc30))
- Add ability to set default order of PaperTrail versions ([a1c4c67](https://github.com/railsadminteam/rails_admin/commit/a1c4c673041642ae2a2aa07e3f0555e17be9d940), [#3095](https://github.com/railsadminteam/rails_admin/pull/3095))
- Add block-style DSL support for extension adapters ([951b708](https://github.com/railsadminteam/rails_admin/commit/951b70878cb007d54b4a7aeadd708d4c7668727b))
- Make sidebar navigation collapsible ([e8cb8ed](https://github.com/railsadminteam/rails_admin/commit/e8cb8edd39246bf75ed72295b7832faf5056367c), [#3198](https://github.com/railsadminteam/rails_admin/pull/3198))
- Add ability to show a help text under the search box ([94f16fb](https://github.com/railsadminteam/rails_admin/commit/94f16fb5fdfdaa867173e95820583a68e5a306c5))
- Support for ActiveStorage direct uploads ([e13c7e2](https://github.com/railsadminteam/rails_admin/commit/e13c7e23f789ed2a575eff01b75e52a41cc930b7), [#3296](https://github.com/railsadminteam/rails_admin/issues/3296))

### Changed

- Load ActionText assets statically to enable full-featured setup ([458d0fb](https://github.com/railsadminteam/rails_admin/commit/458d0fb56d79d4fa0a252ad1ca715fd0a3b4b900), [#3251](https://github.com/railsadminteam/rails_admin/issues/3251), [#3386](https://github.com/railsadminteam/rails_admin/issues/3386))
- Change ES Module processing not to affect non-RailsAdmin assets ([f8219bf](https://github.com/railsadminteam/rails_admin/commit/f8219bf3bc508c5e42f5d044cf6355a56726f8b2))
- Change RailsAdmin initialization process to evaluate the config block immediately but load constants lazily ([#3541](https://github.com/railsadminteam/rails_admin/pull/3541), [33e9214](https://github.com/railsadminteam/rails_admin/commit/33e92147214975cddace61737cbbde3117663efe))
- Restore the loading indicator back ([32e6b14](https://github.com/railsadminteam/rails_admin/commit/32e6b1463ecf66b38e6fdc7924426d9753d71eab), [b9ee7f0](https://github.com/railsadminteam/rails_admin/commit/b9ee7f0c202abc7c09726bdaa28536e7ec25127e), [#3500](https://github.com/railsadminteam/rails_admin/issues/3500))

### Fixed

- Fix Bootstrap 5.2 compatibility ([ef76fce](https://github.com/railsadminteam/rails_admin/commit/ef76fcea0b23aed04f6568448cd157ccc9ba30a0))
- Fix filtering select widget options being empty on browser back ([3cffc00](https://github.com/railsadminteam/rails_admin/commit/3cffc0002079bc9d515dc0f3b31513c7166aa2b9))
- Fix RailsAdmin widgets not activated after a validation error ([a604da5](https://github.com/railsadminteam/rails_admin/commit/a604da5670378e57da7b5492afad40e4f4ad083d))
- Fix export action didn't use export section for eager loading ([4cc3f30](https://github.com/railsadminteam/rails_admin/commit/4cc3f304cc0bc4a7dbaf41a6e4e12ecbdbba6e22), [#1954](https://github.com/railsadminteam/rails_admin/issues/1954))
- Fix Dart Sass 2.0 division deprecations ([#3544](https://github.com/railsadminteam/rails_admin/pull/3544), [3a177c2](https://github.com/railsadminteam/rails_admin/commit/3a177c2e8c1b1d782186ee5bbb3c0d44cc4c0060))
- Fix unable to focus elements on modals opened from remote forms ([#3539](https://github.com/railsadminteam/rails_admin/pull/3539), [#3538](https://github.com/railsadminteam/rails_admin/issues/3538))
- Improve pagination appearance on smaller screens ([a2e366e](https://github.com/railsadminteam/rails_admin/commit/a2e366e8839c9046b9f9fde219875a05bc1a66bb), [#3516](https://github.com/railsadminteam/rails_admin/issues/3516))
- Fix the value of submit buttons being lost on submission ([60e1150](https://github.com/railsadminteam/rails_admin/commit/60e115053ea34fa42c3099464106cf6e58dbfa03), [#3513](https://github.com/railsadminteam/rails_admin/issues/3513))
- Fix breaking with a has_and_belongs_to_many association with scope given ([c2bf6db](https://github.com/railsadminteam/rails_admin/commit/c2bf6db41a97b46741bc41b56fd9700c8bdfc9e4), [#2067](https://github.com/railsadminteam/rails_admin/issues/2067))
- Fix nested fields don't toggle properly after pushing 'Add a new ...' button ([d1f1154](https://github.com/railsadminteam/rails_admin/commit/d1f115425c4a8d119fdeb37802fe472ae278918d), [#3528](https://github.com/railsadminteam/rails_admin/issues/3528))

## [3.1.0.beta](https://github.com/railsadminteam/rails_admin/tree/v3.1.0.beta) - 2022-06-20

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0...v3.1.0.beta)

### Added

- Support Importmap and Webpack, via [importmap-rails](https://github.com/rails/importmap-rails) / [jsbundling-rails](https://github.com/rails/jsbundling-rails) and [cssbundling-rails](https://github.com/rails/cssbundling-rails) ([#3488](https://github.com/railsadminteam/rails_admin/pull/3488))
- Support [Composite Primary Keys](https://github.com/composite-primary-keys/composite_primary_keys) gem ([#3527](https://github.com/railsadminteam/rails_admin/pull/3527))
- Allow configuration of Navbar css class ([126f7ac](https://github.com/railsadminteam/rails_admin/commit/126f7ac79b2ce7846cbbed7bbca1cc26dfe46fb6), [#3507](https://github.com/railsadminteam/rails_admin/issues/3507))

### Changed

- Update vendorized jQuery to 3.6.0 ([#3524](https://github.com/railsadminteam/rails_admin/pull/3524))
- Enable frozen string literals across the project ([#3483](https://github.com/railsadminteam/rails_admin/pull/3483))

### Fixed

- Fix edit user link in the top navigation pointing to wrong URL ([#3531](https://github.com/railsadminteam/rails_admin/pull/3531))
- Fix MultipleActiveStorage field deleting previous attachments when updating a record in Rails 7.0 ([974c54a](https://github.com/railsadminteam/rails_admin/commit/974c54a2a3372690ca189f6e7e90ce365bcd4ff5), [#3520](https://github.com/railsadminteam/rails_admin/issues/3520))
- Fix remote form submission breaking when used with HTTP/2 ([#3515](https://github.com/railsadminteam/rails_admin/pull/3515))
- Fix to maintain 2.x hover / active behavior for side navigation links ([#3511](https://github.com/railsadminteam/rails_admin/pull/3511))
- Fix default sort by behavior when `list.sort_by` points to a field with a table reference for `:sortable` ([#3509](https://github.com/railsadminteam/rails_admin/pull/3509), [9959925](https://github.com/railsadminteam/rails_admin/commit/9959925e49812d6fdaf7341ede4b1d66d926e8d8))
- Fix to insert whitespace after sidebar navigation icon to maintain visual consistency ([#3504](https://github.com/railsadminteam/rails_admin/pull/3504))
- Fix orderable multiselect buttons not rendered correctly ([#3506](https://github.com/railsadminteam/rails_admin/pull/3506))
- Fix to use badges instead of labels, which are removed in Bootstrap 5 ([#3503](https://github.com/railsadminteam/rails_admin/pull/3503))

## [3.0.0](https://github.com/railsadminteam/rails_admin/tree/v3.0.0) - 2022-03-21

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.rc4...v3.0.0)

### Fixed

- Fix table sorting not working ([83a0c88](https://github.com/railsadminteam/rails_admin/commit/83a0c889f1de38a0b24c412b0f0f7484add86b29), [#3497](https://github.com/railsadminteam/rails_admin/issues/3497))
- Fix reset button by the query box not working ([4a583e9](https://github.com/railsadminteam/rails_admin/commit/4a583e924c5bef6bfc46d6a49ab751c2323ba23e))

## [3.0.0.rc4](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.rc4) - 2022-03-13

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.rc3...v3.0.0.rc4)

### Added

- Instruct users on potential issues with npm package installation ([2b0594c](https://github.com/railsadminteam/rails_admin/commit/2b0594c6824eb4eed217cbab9477639b61eb99db), [c7a74f1](https://github.com/railsadminteam/rails_admin/commit/c7a74f1ce7a040b8c87b24fe1907ddd9088bf1e5))

### Changed

- Upgrade vendorized Flatpickr to 4.6.11 ([7f8c831](https://github.com/railsadminteam/rails_admin/commit/7f8c831b9aa407987ba89191c21040e2e72e366e))

### Fixed

- Fix not utilizing full browser width after Bootstrap 5 upgrade ([#3493](https://github.com/railsadminteam/rails_admin/pull/3493))
- Fix the style for show views broken on Bootstrap 5 upgrade ([#3491](https://github.com/railsadminteam/rails_admin/pull/3491))
- Fix Pundit 2.2 deprecation for not using Pundit::Authorization ([e38eb46](https://github.com/railsadminteam/rails_admin/commit/e38eb46ffe79cd866c34b837dd4cfbb65361558f))
- Fix JS issues when navigating across the main app and RailsAdmin ([eb4a185](https://github.com/railsadminteam/rails_admin/commit/eb4a18558e9d8c69aeea3fd733f5dc251f3f79f9), [#3484](https://github.com/railsadminteam/rails_admin/pull/3484))

## [3.0.0.rc3](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.rc3) - 2022-02-27

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.rc2...v3.0.0.rc3)

### Fixed

- Fix the style of list scope tabs ([#3477](https://github.com/railsadminteam/rails_admin/pull/3477))
- Fix rake tasks executed twice ([7d56cd6](https://github.com/railsadminteam/rails_admin/commit/7d56cd6af2d468cca44af5211559af0e744f5cb4))
- Fix the style of the header user link when show_gravatar is false ([#3475](https://github.com/railsadminteam/rails_admin/pull/3475))
- Fix 'Cancel' button for delete/bulk_delete action also didn't work ([1fa8486](https://github.com/railsadminteam/rails_admin/commit/1fa8486ead39596e9e0ac62a945fb0aed63929a8), [#3468](https://github.com/railsadminteam/rails_admin/issues/3468))
- Fix failing to export after introducing Turbo Drive ([c749d93](https://github.com/railsadminteam/rails_admin/commit/c749d939e29434937e8558bcb1f3e219fe98c69d), [#3461 (comment)](https://github.com/railsadminteam/rails_admin/pull/3461#issuecomment-1048588801))

## [3.0.0.rc2](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.rc2) - 2022-02-20

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.rc...v3.0.0.rc2)

### Added

- Some improvements to make the upgrade process more friendlier ([#3471](https://github.com/railsadminteam/rails_admin/pull/3471), [3771542](https://github.com/railsadminteam/rails_admin/commit/377154268257d3753093dcd3dd2fd79b7438b9aa), [3b04a96](https://github.com/railsadminteam/rails_admin/commit/3b04a9616169d568b1a6cee26becf9bfea0ee386))

### Fixed

- Fix 'Save and add another', 'Save and edit', 'Cancel' buttons didn't work right ([ac0a563](https://github.com/railsadminteam/rails_admin/commit/ac0a563a0bf91bf33c693e19717148ed77f843fd), [#3468](https://github.com/railsadminteam/rails_admin/issues/3468))
- Fix failing to precompile assets when the database connection is unavailable ([#3470](https://github.com/railsadminteam/rails_admin/pull/3470), [#3469](https://github.com/railsadminteam/rails_admin/issues/3469))
- Fix custom theme overrides not working ([3d7f3b3](https://github.com/railsadminteam/rails_admin/commit/3d7f3b33a1ca6fabbd8606bb178babae930cce25), [#3466](https://github.com/railsadminteam/rails_admin/issues/3466))

## [3.0.0.rc](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.rc) - 2022-02-06

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.beta2...v3.0.0.rc)

### Added

- Support Mongoid's Storage Field Names ([cefa23c](https://github.com/railsadminteam/rails_admin/commit/cefa23c9d23d06dc1134228e142e6f0aa4655c54), [#1745](https://github.com/railsadminteam/rails_admin/issues/1745))
- Allow save/delete oprations to be disabled based on an object's `#read_only?` status ([9cd7541](https://github.com/railsadminteam/rails_admin/commit/9cd7541a2e6af4ae4941b200840a1474baeb2f06), [#1684](https://github.com/railsadminteam/rails_admin/issues/1684))
- Allow customizing model's last created time ([d6d380a](https://github.com/railsadminteam/rails_admin/commit/d6d380a02e955c3b14ff7dc30f1809a2a6cd0f47), [#3010](https://github.com/railsadminteam/rails_admin/issues/3010))
- Add ability to hide the dashboard history section ([#3189](https://github.com/railsadminteam/rails_admin/pull/3189))
- Add model scope configuration option, which enables 'unscoped' mode ([8d905f9](https://github.com/railsadminteam/rails_admin/commit/8d905f9e2f1102e8addf324b496720e3fd47bf1d), [#1348](https://github.com/railsadminteam/rails_admin/issues/1348))

### Changed

- Switch from pjax to Turbo Drive, due to pjax's low maintenance activity ([#3461](https://github.com/railsadminteam/rails_admin/pull/3461), [#3435](https://github.com/railsadminteam/rails_admin/pull/3435))
- Upgrade Bootstrap to 5.1.3 ([#3455](https://github.com/railsadminteam/rails_admin/pull/3455), [#3083](https://github.com/railsadminteam/rails_admin/issues/3083))
- Switch datetime picker library to Flatpickr ([#3455](https://github.com/railsadminteam/rails_admin/pull/3455))

### Removed

- Drop support for Ruby 2.5 ([#3430](https://github.com/railsadminteam/rails_admin/pull/3430))
- Remove Sections::List#sort_reverse because of having very limited usecase ([0c7bc61](https://github.com/railsadminteam/rails_admin/commit/0c7bc6124a189e5307f2bd1f960dd06495932d10), [#1181](https://github.com/railsadminteam/rails_admin/issues/1181))

### Fixed

- Fix failing to detect encoding with JDBC MySQL adapter ([0dfe2e4](https://github.com/railsadminteam/rails_admin/commit/0dfe2e4d1301cc353f972b28ab19554a53cad482))
- Fix unable to start app when using redis-session-store ([#3462](https://github.com/railsadminteam/rails_admin/pull/3462))
- Fix ActiveRecord ObjectExtension has_one setter breaks with custom primary key class ([0e2e0e4](https://github.com/railsadminteam/rails_admin/commit/0e2e0e4e24328a063813a3a5266a15faee7960c8), [#3460](https://github.com/railsadminteam/rails_admin/issues/3460))
- Fix inheritance of parent_controller not updated properly when controllers were eagerly loaded ([#3458](https://github.com/railsadminteam/rails_admin/pull/3458))
- Fix to retrieve actions correctly in the action `#bulk_action` ([#3407](https://github.com/railsadminteam/rails_admin/pull/3407))
- Fix issue when RailsAdmin::MainController needs to dispatch a method call using `#respond_to_missing?` ([da51b91](https://github.com/railsadminteam/rails_admin/commit/da51b91f712b235c0c6e2a120724fcb31ff28168), [#3454](https://github.com/railsadminteam/rails_admin/issues/3454))
- Fix modal foreign keys are not prepopulated unless the association inverse_of is configured ([75504d0](https://github.com/railsadminteam/rails_admin/commit/75504d08ee6197a3a2c72a56ea30f01272b1d28b), [#2585](https://github.com/railsadminteam/rails_admin/issues/2585))

## [3.0.0.beta2](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.beta2) - 2021-12-25

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v3.0.0.beta...v3.0.0.beta2)

### Fixed

- Fix NameError 'uninitialized constant RailsAdmin::Version' on install ([d2ad520](https://github.com/railsadminteam/rails_admin/commit/d2ad5209f98d8678c6317b49f13727b8605048b3), [#3452](https://github.com/railsadminteam/rails_admin/issues/3452))

## [3.0.0.beta](https://github.com/railsadminteam/rails_admin/tree/v3.0.0.beta) - 2021-12-20

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.2.1...v3.0.0.beta)

### Added

- Rails 7.0.0 support ([011b9ae](https://github.com/railsadminteam/rails_admin/commit/011b9aea12d2c3a5e8654786e49071254baacf18), [670d803](https://github.com/railsadminteam/rails_admin/commit/670d803c262429600c6eb7f59f8b36aa145081e5))
- Webpacker support ([#3414](https://github.com/railsadminteam/rails_admin/pull/3414))
- Add #link_target to action configuration ([#3419](https://github.com/railsadminteam/rails_admin/pull/3419))
- Add not like (=does not contain) operator ([#3410](https://github.com/railsadminteam/rails_admin/pull/3410))
- Support for PostgreSQL citext data type ([#3413](https://github.com/railsadminteam/rails_admin/pull/3413), [#2177](https://github.com/railsadminteam/rails_admin/issues/2177))
- Allow #configure to handle multiple fields for a section at once ([#3406](https://github.com/railsadminteam/rails_admin/pull/3406), [#2667](https://github.com/railsadminteam/rails_admin/issues/2667))
- Add has_one id setters/getters, eliminating the need for explicitly defining them ([42f0a5f](https://github.com/railsadminteam/rails_admin/commit/42f0a5f5aac4b7481dcd4950803d12077b598ce5), [#2625](https://github.com/railsadminteam/rails_admin/issues/2625))
- Support for Mongoid's has_and_belongs_to_many custom primary_key ([3f67637](https://github.com/railsadminteam/rails_admin/commit/3f676371ce7fc088220095afa12d3e20c2c6123a), [#3097](https://github.com/railsadminteam/rails_admin/pull/3097))
- Support for eager-loading arbitrary associations ([4404758](https://github.com/railsadminteam/rails_admin/commit/44047580b7d536a84a92c173a3bd00dc9d211399), [#2928](https://github.com/railsadminteam/rails_admin/issues/2928))
- Support for nullable boolean field ([7583369](https://github.com/railsadminteam/rails_admin/commit/7583369a1d1763e542d36930a968726425cacb6c), [#3145](https://github.com/railsadminteam/rails_admin/issues/3145))
- Support for configuration reload in development mode ([e4ae669](https://github.com/railsadminteam/rails_admin/commit/e4ae6698e52e56a1cefdf5c4097b29b8306f21e2), [#2726](https://github.com/railsadminteam/rails_admin/issues/2726), [08f50aa](https://github.com/railsadminteam/rails_admin/commit/08f50aabc1922aeb289ced4ccbe9f983bc1aaa89), [#3420](https://github.com/railsadminteam/rails_admin/issues/3420))
- Add 'No objects found' placeholder in filtering-select as well ([7e3a1a6](https://github.com/railsadminteam/rails_admin/commit/7e3a1a632811a917f2cbd8dbe471861bc0a1ac85), [#3332](https://github.com/railsadminteam/rails_admin/issues/3332))
- Add inline_edit to HasManyAssociation as well ([798ab1b](https://github.com/railsadminteam/rails_admin/commit/798ab1b6ae400f2b853441a9fa48f8e7ad24208d), [#1911](https://github.com/railsadminteam/rails_admin/issues/1911))
- Add hover highlight to the list table for better visibility ([#3221](https://github.com/railsadminteam/rails_admin/pull/3221))
- Add ability to show disabled actions, as well as completely hiding ([6c877ea](https://github.com/railsadminteam/rails_admin/commit/6c877eac1a052881b2d4950a44d41f7fd77b044f), [#1765](https://github.com/railsadminteam/rails_admin/issues/1765))
- Add the message 'no records found' when a list is empty ([#3365](https://github.com/railsadminteam/rails_admin/pull/3365), [a5fe6f8](https://github.com/railsadminteam/rails_admin/commit/a5fe6f806498975a91ae11544ce21310592774a2), [#3329](https://github.com/railsadminteam/rails_admin/issues/3329))
- Add a way to clear belongs_to selection using mouse ([ac3fe35](https://github.com/railsadminteam/rails_admin/commit/ac3fe35b65e858a3b528a523e1b6fbeafe1d359b), [#2090](https://github.com/railsadminteam/rails_admin/issues/2090))
- Add HTML5 validation for float-like field types ([#3378](https://github.com/railsadminteam/rails_admin/pull/3378), [#3289](https://github.com/railsadminteam/rails_admin/issues/3289))

### Changed

- Remove horizontal pagination and always use sidescroll view for list action table ([d51e943](https://github.com/railsadminteam/rails_admin/commit/d51e94314de4b510df0767a695d5953bb7b3fad5))
- Replace image assets with Font Awesome icons ([a0a568b](https://github.com/railsadminteam/rails_admin/commit/a0a568bc866158382b52ec24639699695146794c))
- Switch templates from HAML to ERB ([#3425](https://github.com/railsadminteam/rails_admin/pull/3425), [#3439](https://github.com/railsadminteam/rails_admin/pull/3439), [#3173](https://github.com/railsadminteam/rails_admin/issues/3173))
- Rewrite some JavaScript code not to use jQuery ([#3416](https://github.com/railsadminteam/rails_admin/pull/3416), [#3417](https://github.com/railsadminteam/rails_admin/pull/3417))
- Upgrade FontAwesome to 5.15.4 ([cb1ac73](https://github.com/railsadminteam/rails_admin/commit/cb1ac732c4df85cc082c4e40f2c8a7d144ceb9f2))
- Stop using AbstractObject and use raw model instances with extension ([af88091](https://github.com/railsadminteam/rails_admin/commit/af88091d11590dc95df4866c62fba0c49a7bb9a8), [#2847](https://github.com/railsadminteam/rails_admin/issues/2847))
- Switch from jquery_ujs to rails-ujs ([#3390](https://github.com/railsadminteam/rails_admin/pull/3390), [dea63f4](https://github.com/railsadminteam/rails_admin/commit/dea63f49ee18644ee5e8dee1fb57e0c742d27a97))
- Make colorpicker field use HTML5 native color picker ([#3387](https://github.com/railsadminteam/rails_admin/pull/3387))
- Change to use ISO 8601 time format for browser-server communication, instead of localized value ([01e8d5f](https://github.com/railsadminteam/rails_admin/commit/01e8d5fc8ec94e68af6fdbd80759a751cd83f74a), [#3344](https://github.com/railsadminteam/rails_admin/issues/3344))

### Removed

- Remove dependency for builder and remotipart ([#3427](https://github.com/railsadminteam/rails_admin/pull/3427), [58b76d1](https://github.com/railsadminteam/rails_admin/commit/58b76d1e66ec06b752567da9c118f611105ff39f))
- Remove capitalization helper, letting I18n to perform necessary transformation ([#3396](https://github.com/railsadminteam/rails_admin/pull/3396))
- Remove jQuery Migrate ([#3389](https://github.com/railsadminteam/rails_admin/pull/3389), [b385d4d](https://github.com/railsadminteam/rails_admin/commit/b385d4d50f372de65d8c6c33a4b8256403894483))
- Remove the legacy history adapter([#3374](https://github.com/railsadminteam/rails_admin/issues/3374), [b627580](https://github.com/railsadminteam/rails_admin/commit/b62758039308872e7abe91a51715e1608bfd0915))
- Drop support for Ruby < 2.5 and Rails 5.x([decf428](https://github.com/railsadminteam/rails_admin/commit/decf4280183b8b6a453aa802942fc825524c2f13), [17e20b6](https://github.com/railsadminteam/rails_admin/commit/17e20b6daef1708598ab8cff5678501f8bac4709))

### Fixed

- Reduce object allocations when rendering main navigation menu ([#3412](https://github.com/railsadminteam/rails_admin/pull/3412))
- Fix N+1 queries for ActiveStorage attachments ([e4d5b2f](https://github.com/railsadminteam/rails_admin/commit/e4d5b2f3bece0f5f3e5f588e20e52031ad33e124), [#3282](https://github.com/railsadminteam/rails_admin/issues/3282))
- Fix to convert DateTime format for Moment.js as much as possible ([6d5c049](https://github.com/railsadminteam/rails_admin/commit/6d5c049124d0b390f4612e8e6524f00500afe52e), [#2736](https://github.com/railsadminteam/rails_admin/issues/2736), [#3009](https://github.com/railsadminteam/rails_admin/issues/3009))
- Fix config.parent_controller to work after the class loading ([5bd9805](https://github.com/railsadminteam/rails_admin/commit/5bd980564a565906a6fda87d2ef31590d3e3b0a5), [#2790](https://github.com/railsadminteam/rails_admin/issues/2790))
- Fix NoMethodError when Mongoid's raise_not_found_error is false ([973bd8e](https://github.com/railsadminteam/rails_admin/commit/973bd8e50591a538841575c33b6221706481dae3), [#2623](https://github.com/railsadminteam/rails_admin/issues/2623))
- Fix NoMethodError "undefined method 'has_one_attached'" ([e4ae669](https://github.com/railsadminteam/rails_admin/commit/e4ae6698e52e56a1cefdf5c4097b29b8306f21e2), [#3025](https://github.com/railsadminteam/rails_admin/issues/3025))
- Fix NoMethodError "undefined method `label' for nil:NilClass" on export ([f2104b5](https://github.com/railsadminteam/rails_admin/commit/f2104b595930491a18ede44c9e1a8c881a0316b8), [#1685](https://github.com/railsadminteam/rails_admin/issues/1685))
- Fix Kaminari's custom param_name was not used in history_index and history_show ([#3227](https://github.com/railsadminteam/rails_admin/pull/3227), [#3400](https://github.com/railsadminteam/rails_admin/pull/3400))
- Fix Gravater and email were not shown when the current user is not editable ([bd44929](https://github.com/railsadminteam/rails_admin/commit/bd449292088cb68aad22b282b6344778862187e5), [#3237](https://github.com/railsadminteam/rails_admin/issues/3237))
- Fix RailsAdmin::Config.reset didn't clear the effect of previous included_models/excluded_models ([1190d51](https://github.com/railsadminteam/rails_admin/commit/1190d510ee73949af618bd279e4712f1be4550b6), [#3305](https://github.com/railsadminteam/rails_admin/issues/3305))
- Fix duplication of filtering-multiselect on browser back ([3c10b09](https://github.com/railsadminteam/rails_admin/commit/3c10b0918b65e64624f06ebd5e402181f478cc64), [#3211](https://github.com/railsadminteam/rails_admin/issues/3211))
- Fix no error message is shown on failure with dependent: :restrict_with_error ([bf353cc](https://github.com/railsadminteam/rails_admin/commit/bf353cc76d6e56d511e9c5a87d0ffbd83669e3f2), [#3323](https://github.com/railsadminteam/rails_admin/issues/3223))
- Fix read-only associations are shown empty if it has no value ([7580f33](https://github.com/railsadminteam/rails_admin/commit/7580f3366a6e4a16b439de7fd64860fe26628ad7), [#2681](https://github.com/railsadminteam/rails_admin/issues/2681))
- Fix hidden fields taking up some space ([5aaee51](https://github.com/railsadminteam/rails_admin/commit/5aaee5153441fd82854a998ac02ebbe303b82bf2), [#3380](https://github.com/railsadminteam/rails_admin/issues/3380))
- Fix to show validation errors in modals ([f67defb](https://github.com/railsadminteam/rails_admin/commit/f67defb55ad9d1a1fe8428029c947bcd00b5ce8a), [#1735](https://github.com/railsadminteam/rails_admin/issues/1735))
- Fix image file detection by using Mime::Type ([#3398](https://github.com/railsadminteam/rails_admin/pull/3398), [#3239](https://github.com/railsadminteam/rails_admin/issues/3239))
- Fix 'no objects' message not showing up in filtering-multiselect widget ([aa5545c](https://github.com/railsadminteam/rails_admin/commit/aa5545c928ce0de80142966c19b64be76d88286f))
- Fix 'Delete Image' translation does not work well in some languages ([#3382](https://github.com/railsadminteam/rails_admin/pull/3382), [#3260](https://github.com/railsadminteam/rails_admin/issues/3260))
- Fix polymorphic associations don't work with namespaced classes ([#3377](https://github.com/railsadminteam/rails_admin/pull/3377), [#3376](https://github.com/railsadminteam/rails_admin/issues/3376))
- Fix Boolean pretty_value to include default fallback ([#3379](https://github.com/railsadminteam/rails_admin/pull/3379))
- Fix history#index not supporting models with custom version classes ([ed19f9e](https://github.com/railsadminteam/rails_admin/commit/ed19f9e793b91de1c2bc9133e026b0396e6ec777))
- Fix models stored in eager_load_paths are not picked up by #viable_models ([#3373](https://github.com/railsadminteam/rails_admin/issues/3373), [238f18e](https://github.com/railsadminteam/rails_admin/commit/238f18ee2386f9858670b7995dcb628b8fe6bde9))
- Fix polymorphic associations don't work with namespaced classes([#3376](https://github.com/railsadminteam/rails_admin/issues/3376))

## [2.2.1](https://github.com/railsadminteam/rails_admin/tree/v2.2.0) - 2021-08-08

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.2.0...v2.2.1)

### Fixed

- Fix missing select options for single-select enum filters([#3372](https://github.com/railsadminteam/rails_admin/pull/3372))

## [2.2.0](https://github.com/railsadminteam/rails_admin/tree/v2.2.0) - 2021-07-24

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.1.1...v2.2.0)

### Added

- Support for PaperTrail's alternative versions association name([#3354](https://github.com/railsadminteam/rails_admin/pull/3354))

### Changed

- Update jQuery to 3.x with introducing jQuery.migrate([#3348](https://github.com/railsadminteam/rails_admin/pull/3348), [973dee06](https://github.com/railsadminteam/rails_admin/commit/973dee065938a58d1aef4119a4bc90ac15792421), [#3370](https://github.com/railsadminteam/rails_admin/pull/3370))
- Update Moment.js to 2.29.1([#3348](https://github.com/railsadminteam/rails_admin/pull/3348), [973dee06](https://github.com/railsadminteam/rails_admin/commit/973dee065938a58d1aef4119a4bc90ac15792421), [7962a194](https://github.com/railsadminteam/rails_admin/commit/7962a19469a709c00f481a50a6d1e7ddd1e37cc6))
- Update Bootstrap to 3.4.1([#3348](https://github.com/railsadminteam/rails_admin/pull/3348), [973dee06](https://github.com/railsadminteam/rails_admin/commit/973dee065938a58d1aef4119a4bc90ac15792421))
- Update Bootstrap Datetime Picker to 4.17.49([7962a194](https://github.com/railsadminteam/rails_admin/commit/7962a19469a709c00f481a50a6d1e7ddd1e37cc6))

### Removed

- Remove unnecessary devise patch([#3352](https://github.com/railsadminteam/rails_admin/pull/3352))

### Fixed

- Zeitwerk incompatibility([#3190](https://github.com/railsadminteam/rails_admin/issues/3328), [97ccc289](https://github.com/railsadminteam/rails_admin/commit/97ccc28940d65fee53b30c409c49032fbb0885db))

## [2.1.1](https://github.com/railsadminteam/rails_admin/tree/v2.1.1) - 2021-03-14

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.1.0...v2.1.1)

### Fixed

- Fix AbstractObject's proxying was incompatible with keyword arguments in Ruby 3.0 ([#3342](https://github.com/railsadminteam/rails_admin/issues/3342))

## [2.1.0](https://github.com/railsadminteam/rails_admin/tree/v2.1.0) - 2021-02-28

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.0.2...v2.1.0)

### Added

- Ability to set default filter operator for fields ([#3318](https://github.com/railsadminteam/rails_admin/pull/3318))
- Shrine 3.x support ([#3257](https://github.com/railsadminteam/rails_admin/pull/3257))
- Rails 6.1 compatibility ([f0c46f1e](https://github.com/railsadminteam/rails_admin/commit/f0c46f1e128b5d31d812ff3a80d15db8692c848b))

### Fixed

- Some translation entries of filtering-multiselect weren't localizable ([#3315](https://github.com/railsadminteam/rails_admin/pull/3315))
- Thumbnail generation breaks when used with ActiveStorage 6.x and ruby-vips ([#3255](https://github.com/railsadminteam/rails_admin/pull/3255), [2dba791c](https://github.com/railsadminteam/rails_admin/commit/2dba791c9135b3202d662f90fac443d282869bd6))
- Hide present/blank filter options for required fields ([#3340](https://github.com/railsadminteam/rails_admin/pull/3340))
- Fix to show correct filename for multiple attachments ([#3295](https://github.com/railsadminteam/rails_admin/pull/3295))
- Fix encoding detection was incompatible with DB connection proxies like active_record_host_pool gem ([#3313](https://github.com/railsadminteam/rails_admin/pull/3313))
- Fix hidden fields breaking indentation ([#3278](https://github.com/railsadminteam/rails_admin/pull/3278), [#2487](https://github.com/railsadminteam/rails_admin/issues/2487))

### Removed

- Remove `yell_for_non_accessible_fields` option since it has no effect since 0.5.0 ([#3249](https://github.com/railsadminteam/rails_admin/pull/3249))

## [2.0.2](https://github.com/railsadminteam/rails_admin/tree/v2.0.2) - 2020-03-17

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.0.1...v2.0.2)

### Fixed

- Fix to use I18n to translate the button 'Reset filters'([#3248](https://github.com/railsadminteam/rails_admin/pull/3248))

### Security

- Fix XSS vulnerability in nested forms([d72090ec](https://github.com/railsadminteam/rails_admin/commit/d72090ec6a07c3b9b7b48ab50f3d405f91ff4375))

## [2.0.1](https://github.com/railsadminteam/rails_admin/tree/v2.0.1) - 2019-12-31

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.0.0...v2.0.1)

### Fixed

- Fix Zeitwerk incompatible behavior of autoloading constants during initialization([#3190](https://github.com/railsadminteam/rails_admin/issues/3190), [e275012b](https://github.com/railsadminteam/rails_admin/commit/e275012b630453cb1187e71a938382a3c5d3ef39))
- Fix empty fields being hidden regardless of `compact_show_view`([#3213](https://github.com/railsadminteam/rails_admin/pull/3213))
- Fix `filter_scope` not using `default_search_operator` as default([#3212](https://github.com/railsadminteam/rails_admin/pull/3212))
- Fix PaperTrail integration returning `nil` as username instead of `whodunnit`([#3210](https://github.com/railsadminteam/rails_admin/pull/3210))
- Fix Sprockets 4 incompatibility of vendorized Fontawesome([#3204](https://github.com/railsadminteam/rails_admin/issues/3204), [#3207](https://github.com/railsadminteam/rails_admin/pull/3207))

### Security

- Update moment.js to 2.24.0 to address security vulnerability([#3182](https://github.com/railsadminteam/rails_admin/issues/3182), [#3201](https://github.com/railsadminteam/rails_admin/pull/3201))

## [2.0.0](https://github.com/railsadminteam/rails_admin/tree/v2.0.0) - 2019-08-18

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.0.0.rc...v2.0.0)

### Fixed

- Fix support for belongs_to with custom primary key was broken in 2.0.0.rc([#3184](https://github.com/railsadminteam/rails_admin/issues/3184), [0e92ca43](https://github.com/railsadminteam/rails_admin/commit/0e92ca43fe7782a8d62ae9285a8d3de7857c9853))
- Fix missing translation `en.admin.misc.ago`([#3180](https://github.com/railsadminteam/rails_admin/pull/3180))

## [2.0.0.rc](https://github.com/railsadminteam/rails_admin/tree/v2.0.0.rc) - 2019-08-04

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v2.0.0.beta...v2.0.0.rc)

### Added

- Add Support for CarrierWave 2.0 multiple file upload's keep, append and reorder feature([fb093e04](https://github.com/railsadminteam/rails_admin/commit/fb093e04502e7bff30594f5baf1227abb7199384))
- Add ability to configure way how custom actions show up in root/top/sidebar navigation([#2844](https://github.com/railsadminteam/rails_admin/pull/2844))

### Changed

- [BREAKING CHANGE] Stop authorization adapters assigning attributes on create and update, just check for permission instead([#3120](https://github.com/railsadminteam/rails_admin/pull/3120), [c84d1703](https://github.com/railsadminteam/rails_admin/commit/c84d1703b47b396382d152471dac8fc8dc41aefd))
- [BREAKING CHANGE] Do not show tableless models by default([#3157](https://github.com/railsadminteam/rails_admin/issues/3157), [87b38b33](https://github.com/railsadminteam/rails_admin/commit/87b38b336cc668a74803dec4628215e2e2941248))
- [BREAKING CHANGE] Convert empty string into nil for nullable string-like fields to achieve uniqueness-index friendliness([#2099](https://github.com/railsadminteam/rails_admin/issues/2099), [#3172](https://github.com/railsadminteam/rails_admin/issues/3172), [3f9ab1cc](https://github.com/railsadminteam/rails_admin/commit/3f9ab1cc009caa8b466f34da692c3561da2235e4))
- Extract head from application template for ease of customization([#3114](https://github.com/railsadminteam/rails_admin/pull/3114))
- Rename `delete_key` to `delete_value`, used to identify which file to delete in multiple file upload([8b8c3a44](https://github.com/railsadminteam/rails_admin/commit/8b8c3a44177465823128e9b48b11467ccf7db001))
- Get rid of CoffeeScript, use plain JavaScript instead([#3111](https://github.com/railsadminteam/rails_admin/issues/3111), [#3168](https://github.com/railsadminteam/rails_admin/pull/3168))
- Replace sass-rails with sassc-rails([#3156](https://github.com/railsadminteam/rails_admin/pull/3156))

### Removed

- Drop support for CanCan, please use its successor CanCanCan([6b7495f1](https://github.com/railsadminteam/rails_admin/commit/6b7495f1454e30027a9d77b911206cc7703170a3))
- Drop support for CanCanCan legacy `can :dashboard` style dashboard ability notation([5bebac24](https://github.com/railsadminteam/rails_admin/commit/5bebac2488906f3739717108efadedaa091ccaf5))
- Drop Refile support due to maintenance inactivity([25ae06a9](https://github.com/railsadminteam/rails_admin/commit/25ae06a9a6eb534afa4a5f17e64ca346086bb3b8))

### Fixed

- Fix PaperTrail pagination breaks when Kaminari's `page_method_name` is set([#3170](https://github.com/railsadminteam/rails_admin/issues/3170), [136b943c](https://github.com/railsadminteam/rails_admin/commit/136b943ce842eba6b0a13dc2956ddc9ce20d006c))
- Fix failing to pass config location to CKEditor([#3162](https://github.com/railsadminteam/rails_admin/issues/3162), [c38b76d7](https://github.com/railsadminteam/rails_admin/commit/c38b76d707f198be0ac8baa1ff02dde7bd02344f))
- Fix CarrierWave multiple file uploader breaking when used with Fog([#3070](https://github.com/railsadminteam/rails_admin/issues/3070))
- Fix placeholder being picked up as a selection in filtering-multiselect([#2807](https://github.com/railsadminteam/rails_admin/issues/2807), [15502601](https://github.com/railsadminteam/rails_admin/commit/15502601ccd0bbbaeb364a0ee605f360d65c5cbb))
- Fix breaking with has_many and custom primary key([#1878](https://github.com/railsadminteam/rails_admin/issues/1878), [be7d2f4a](https://github.com/railsadminteam/rails_admin/commit/be7d2f4a3ad1fda788f92a0e0dd4a83b98f141f4))
- Fix to choose right LIKE statement in per-model basis([#1676](https://github.com/railsadminteam/rails_admin/issues/1676), [4ea4575e](https://github.com/railsadminteam/rails_admin/commit/4ea4575e934e26cec4a5b214b9fe68cb96b40247))
- Fix polymorphic associations not using STI base classes for polymorphic type([#2136](https://github.com/railsadminteam/rails_admin/pull/2136))

### Security

- Add `rel="noopener"` to all `target="_blank"` links to prevent Reverse tabnabbing([#2960](https://github.com/railsadminteam/rails_admin/issues/2960), [#3169](https://github.com/railsadminteam/rails_admin/pull/3169))

## [2.0.0.beta](https://github.com/railsadminteam/rails_admin/tree/v2.0.0.beta) - 2019-06-08

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.4.2...v2.0.0.beta)

### Added

- Rails 6 support([#3122](https://github.com/railsadminteam/rails_admin/pull/3122))
- ActionText support([#3144](https://github.com/railsadminteam/rails_admin/issues/3144), [Wiki](https://github.com/railsadminteam/rails_admin/wiki/ActionText))
- sass-rails 6 support([#3129](https://github.com/railsadminteam/rails_admin/issues/3129))
- Sidescroll feature([#3017](https://github.com/railsadminteam/rails_admin/pull/3017), [Wiki](https://github.com/railsadminteam/rails_admin/wiki/Horizontally-scrolling-table-with-frozen-columns-in-list-view))
- Custom search feature([#343](https://github.com/railsadminteam/rails_admin/issues/343), [#3019](https://github.com/railsadminteam/rails_admin/pull/3019), [Wiki](https://github.com/railsadminteam/rails_admin/wiki/Custom-Search))
- Filtering-select feature for polymorphic association([#2886](https://github.com/railsadminteam/rails_admin/pull/2886))
- Shrine support([#3081](https://github.com/railsadminteam/rails_admin/pull/3081))
- Flexibility for localication of _time_ ago([#3135](https://github.com/railsadminteam/rails_admin/pull/3135), [49add741](https://github.com/railsadminteam/rails_admin/commit/49add7413794e2a1423b86399ef476414d22970f))

### Changed

- Vendorize font-awesome to allow using different version in app([#3039](https://github.com/railsadminteam/rails_admin/issues/3039))
- Stop inlining JavaScripts for CSP friendliness([#3087](https://github.com/railsadminteam/rails_admin/issues/3087))
- Richtext editors now uses CDN-hosted assets([#3126](https://github.com/railsadminteam/rails_admin/issues/3126))

### Removed

- Remove deprecated DSL syntax for richtext editors([e0b390d9](https://github.com/railsadminteam/rails_admin/commit/e0b390d99eab64c99f1f3cccae2029649e90e11c))
- Drop support for Ruby 2.1 and Rails 4.x([dd247804](https://github.com/railsadminteam/rails_admin/commit/dd24780445f4dd676ae033c69a5b64347b80c3bc))

### Fixed

- Fix Mongoid query and filter parsing value twice([#2755](https://github.com/railsadminteam/rails_admin/issues/2755))
- Fix thread-safety issues([#2897](https://github.com/railsadminteam/rails_admin/issues/2897), [#2942](https://github.com/railsadminteam/rails_admin/issues/2942), [1d22bc66](https://github.com/railsadminteam/rails_admin/commit/1d22bc66168ac9ea478ea95b4b3b79f41263c0bd))
- Fix compact_show_view not showing Boolean falses([#2416](https://github.com/railsadminteam/rails_admin/issues/2416))
- Fix PaperTrail fail to fetch versions for STI subclasses([#2865](https://github.com/railsadminteam/rails_admin/pull/2865))
- Fix Dragonfly factory breaks if a model not extending Dragonfly::Model is passed([#2720](https://github.com/railsadminteam/rails_admin/pull/2720))
- Fix PaperTrail adapter not using Kaminari's `page_method_name` for pagination([#2712](https://github.com/railsadminteam/rails_admin/pull/2712))
- Fix #bulk_menu was not using passed `abstract_model` ([#2782](https://github.com/railsadminteam/rails_admin/pull/2782))
- Fix wrong styles when using multiple instances of CodeMirror([#3107](https://github.com/railsadminteam/rails_admin/pull/3107))
- Fix password being cleared when used with Devise 4.6([72bc0373](https://github.com/railsadminteam/rails_admin/commit/72bc03736162ffef8e5b99f42ca605d17fe7e7d0))
- ActiveStorage factory caused const missing for Mongoid([#3088](https://github.com/railsadminteam/rails_admin/pull/3088), [db927687](https://github.com/railsadminteam/rails_admin/commit/db9276879c8e8c5e8772261725ef0e0cdadd9cf1))
- Fix exact matches were using LIKE, which was not index-friendly([#3000](https://github.com/railsadminteam/rails_admin/pull/3000))
- Middleware check failed when using RedisStore([#3076](https://github.com/railsadminteam/rails_admin/issues/3076))
- Fix field being reset to default after an error([#3066](https://github.com/railsadminteam/rails_admin/pull/3066))

## [1.4.2](https://github.com/railsadminteam/rails_admin/tree/v1.4.2) - 2018-09-23

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.4.1...v1.4.2)

### Fixed

- Fix `can't modify frozen Array` error on startup([#3060](https://github.com/railsadminteam/rails_admin/issues/3060))
- Fix deprecation warning with PaperTrail.whodunnit([#3059](https://github.com/railsadminteam/rails_admin/pull/3059))

## [1.4.1](https://github.com/railsadminteam/rails_admin/tree/v1.4.1) - 2018-08-19

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.4.0...v1.4.1)

### Fixed

- Export crashes for models with JSON field([#3056](https://github.com/railsadminteam/rails_admin/pull/3056))
- Middlewares being mangled by engine initializer, causing app's session store configuration to be overwritten([#3048](https://github.com/railsadminteam/rails_admin/issues/3048), [59478af9](https://github.com/railsadminteam/rails_admin/commit/59478af9a05c76bdfe35e94e63c60ba89c27a483))

## [1.4.0](https://github.com/railsadminteam/rails_admin/tree/v1.4.0) - 2018-07-22

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.3.0...v1.4.0)

### Added

- Support for ActiveStorage([#2990](https://github.com/railsadminteam/rails_admin/issues/2990), [#3037](https://github.com/railsadminteam/rails_admin/pull/3037))
- Support for multiple file upload for ActiveStorage and CarrierWave ([5bb2d375](https://github.com/railsadminteam/rails_admin/commit/5bb2d375a236268e51c7e8682c2d110d9e52970f))
- Support for Mongoid 7.0([9ef623f6](https://github.com/railsadminteam/rails_admin/commit/9ef623f6cba73adbf86833d9eb07f1be3924a133), [#3013](https://github.com/railsadminteam/rails_admin/issues/3013))
- Support for CanCanCan 2.0([a32d49e4](https://github.com/railsadminteam/rails_admin/commit/a32d49e4b96944905443588a1216b3362ee64c1a), [#2901](https://github.com/railsadminteam/rails_admin/issues/2901))
- Support for Pundit 2.0([bc60c978](https://github.com/railsadminteam/rails_admin/commit/bc60c978adfebe09cdad2c199878d8ff966374f1))
- Support for jquery-ui-rails 6.0([#2951](https://github.com/railsadminteam/rails_admin/issues/2951), [#3003](https://github.com/railsadminteam/rails_admin/issues/3003))

### Fixed

- Make code reloading work([#3041](https://github.com/railsadminteam/rails_admin/pull/3041))
- Improved support for Rails API mode, requiring needed middlewares in engine's initializer([#2919](https://github.com/railsadminteam/rails_admin/issues/2919), [#3006](https://github.com/railsadminteam/rails_admin/pull/3006))
- Make the link text to uploaded file shorter, instead of showing full url([#2983](https://github.com/railsadminteam/rails_admin/pull/2983))
- Fix duplication of filters on browser back([#2998](https://github.com/railsadminteam/rails_admin/pull/2998))
- Fix "can't modify frozen array" exception on code reload([#2999](https://github.com/railsadminteam/rails_admin/pull/2999))
- Fix incorrectly comparing numeric columns with empty string when handling blank operator([#3007](https://github.com/railsadminteam/rails_admin/pull/3007))

## [1.3.0](https://github.com/railsadminteam/rails_admin/tree/v1.3.0) - 2018-02-18

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.2.0...v1.3.0)

### Added

- Configurability for forgery protection setting([#2989](https://github.com/railsadminteam/rails_admin/pull/2989))
- Configurability for the number of audit records displayed into dashboard([#2982](https://github.com/railsadminteam/rails_admin/pull/2982))
- Add limited pagination mode, which doesn't require count query([#2968](https://github.com/railsadminteam/rails_admin/pull/2968))
- Prettier output of JSON field value([#2937](https://github.com/railsadminteam/rails_admin/pull/2937), [#2973](https://github.com/railsadminteam/rails_admin/pull/2973), [#2980](https://github.com/railsadminteam/rails_admin/pull/2980))
- Add markdown field support through SimpleMDE([#2949](https://github.com/railsadminteam/rails_admin/pull/2949))
- Checkboxes for bulk actions in index page can be turned off now([#2917](https://github.com/railsadminteam/rails_admin/pull/2917))

### Fixed

- Parse JS translations as JSON([#2925](https://github.com/railsadminteam/rails_admin/pull/2925))
- Re-selecting an item after unselecting has no effect in filtering-multiselect([#2912](https://github.com/railsadminteam/rails_admin/issues/2912))
- Stop memoization of datetime parser to handle locale changes([#2824](https://github.com/railsadminteam/rails_admin/pull/2824))
- Filters for ActiveRecord Enum field behaved incorrectly for enums whose labels are different from values([#2971](https://github.com/railsadminteam/rails_admin/pull/2971))
- Client-side required validation was not enforced in filtering-select widget([#2905](https://github.com/railsadminteam/rails_admin/pull/2905))
- Filter refresh button was broken([#2890](https://github.com/railsadminteam/rails_admin/pull/2890))

### Security

- Fix XSS vulnerability in filter and multi-select widget([#2985](https://github.com/railsadminteam/rails_admin/issues/2985), [44f09ed7](https://github.com/railsadminteam/rails_admin/commit/44f09ed72b5e0e917a5d61bd89c48d97c494b41c))

## [1.2.0](https://github.com/railsadminteam/rails_admin/tree/v1.2.0) - 2017-05-31

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.1.1...v1.2.0)

### Added

- Add ILIKE support for PostgreSQL/PostGIS adapter, multibyte downcase for other adapters([#2766](https://github.com/railsadminteam/rails_admin/pull/2766))
- Support for UUID query([#2766](https://github.com/railsadminteam/rails_admin/pull/2766))
- Support for Haml 5([#2840](https://github.com/railsadminteam/rails_admin/pull/2840), [#2870](https://github.com/railsadminteam/rails_admin/pull/2870), [#2877](https://github.com/railsadminteam/rails_admin/pull/2877))
- Add instance option to append a CSS class for rows([#2860](https://github.com/railsadminteam/rails_admin/pull/2860))

### Fixed

- Remove usage of alias_method_chain, deprecated in Rails 5.0([#2864](https://github.com/railsadminteam/rails_admin/pull/2864))
- Load models from eager_load, not autoload_paths([#2771](https://github.com/railsadminteam/rails_admin/pull/2771))
- jQuery 3.0 doesn't have size(), use length instead([#2841](https://github.com/railsadminteam/rails_admin/pull/2841))
- Prepopulation of the new form didn't work with namespaced models([#2701](https://github.com/railsadminteam/rails_admin/pull/2701))

## [1.1.1](https://github.com/railsadminteam/rails_admin/tree/v1.1.1) - 2016-12-25

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.1.0...v1.1.1)

### Fixed

- CSV export broke with empty tables([#2796](https://github.com/railsadminteam/rails_admin/issues/2796), [#2797](https://github.com/railsadminteam/rails_admin/pull/2797))
- ActiveRecord adapter's #encoding did not work with Oracle enhanced adapter([#2789](https://github.com/railsadminteam/rails_admin/pull/2789))
- ActiveRecord 5 belongs_to presence validators were unintentionally disabled due to initialization mishandling([#2785](https://github.com/railsadminteam/rails_admin/issues/2785), [#2786](https://github.com/railsadminteam/rails_admin/issues/2786))
- Destroy failure caused subsequent index action to return 404, instead of 200([#2775](https://github.com/railsadminteam/rails_admin/issues/2775), [#2776](https://github.com/railsadminteam/rails_admin/pull/2776))
- CSVConverter#to_csv now accepts string-keyed hashes([#2740](https://github.com/railsadminteam/rails_admin/issues/2740), [#2741](https://github.com/railsadminteam/rails_admin/pull/2741))

### Security

- Fix CSRF vulnerability([b13e879e](https://github.com/railsadminteam/rails_admin/commit/b13e879eb93b661204e9fb5e55f7afa4f397537a))

## [1.1.0](https://github.com/railsadminteam/rails_admin/tree/v1.1.0) - 2016-10-30

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.0.0...v1.1.0)

### Added

- DSL for association eager-loading([#1325](https://github.com/railsadminteam/rails_admin/issues/1325), [#1342](https://github.com/railsadminteam/rails_admin/issues/1342))

### Fixed

- Fix nested has_many form failing to add items([#2737](https://github.com/railsadminteam/rails_admin/pull/2737))

## [1.0.0](https://github.com/railsadminteam/rails_admin/tree/v1.0.0) - 2016-09-19

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v1.0.0.rc...v1.0.0)

### Added

- Introduce setup hook for authorization/auditing adapters([ba2088c6](https://github.com/railsadminteam/rails_admin/commit/ba2088c6ecabd354b4b67c50bb00fccdbd1e6240))
- Add viewport meta tag for mobile layout adjustment([#2664](https://github.com/railsadminteam/rails_admin/pull/2664))
- Support for ActiveRecord::Enum using string columns([#2680](https://github.com/railsadminteam/rails_admin/pull/2680))

### Changed

- Limit children for deletion notice([#2491](https://github.com/railsadminteam/rails_admin/pull/2491))
- [BREAKING CHANGE] Change parent controller to ActionController::Base for out-of-box support of Rails 5 API mode([#2688](https://github.com/railsadminteam/rails_admin/issues/2688))
  - To keep old behavior, add `config.parent_controller = '::ApplicationController'` in your RailsAdmin initializer.

### Fixed

- ActiveRecord Enum fields could not be updated correctly([#2659](https://github.com/railsadminteam/rails_admin/pull/2659), [#2713](https://github.com/railsadminteam/rails_admin/issues/2713))
- Fix performance issue with filtering-multiselect widget([#2715](https://github.com/railsadminteam/rails_admin/pull/2715))
- Restore back rails_admin_controller?([#2268](https://github.com/railsadminteam/rails_admin/issues/2268))
- Duplication of autocomplete fields when using browser back/forward buttons([#2677](https://github.com/railsadminteam/rails_admin/issues/2677), [#2678](https://github.com/railsadminteam/rails_admin/pull/2678))
- Filter refresh button was broken([#2705](https://github.com/railsadminteam/rails_admin/issues/2705), [#2706](https://github.com/railsadminteam/rails_admin/pull/2706))
- Fix presence filtering on boolean columns([#1099](https://github.com/railsadminteam/rails_admin/issues/1099), [#2675](https://github.com/railsadminteam/rails_admin/pull/2675))
- Pundit::AuthorizationNotPerformedError was raised when used with Pundit([#2683](https://github.com/railsadminteam/rails_admin/pull/2683))

## [1.0.0.rc](https://github.com/railsadminteam/rails_admin/tree/v1.0.0.rc) - 2016-07-18

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v0.8.1...v1.0.0.rc)

### Added

- Rails 5 support
- PaperTrail 5 support([9c42783a](https://github.com/railsadminteam/rails_admin/commit/9c42783aa65b704f4a5d467608c49b746c47b81b))
- Support for multiple configuration blocks([#1781](https://github.com/railsadminteam/rails_admin/pull/1781), [#2670](https://github.com/railsadminteam/rails_admin/pull/2670))
- Default association limit is now configurable([#2508](https://github.com/railsadminteam/rails_admin/pull/2058))

### Changed

- Prefix kaminari bootstrap views with `ra-` to avoid name conflict([#2283](https://github.com/railsadminteam/rails_admin/issues/2283), [#2651](https://github.com/railsadminteam/rails_admin/pull/2651))
- Gravatar icon is now optional([#2570](https://github.com/railsadminteam/rails_admin/pull/2570))
- Improve bootstrap-wysihtml5-rails support([#2650](https://github.com/railsadminteam/rails_admin/pull/2650))
- Explicitly call the #t method on I18n([#2564](https://github.com/railsadminteam/rails_admin/pull/2564))
- Improve dashboard performance by querying with id instead of updated_at([#2514](https://github.com/railsadminteam/rails_admin/issues/2514), [#2551](https://github.com/railsadminteam/rails_admin/pull/2551))
- Improve encoding support in CSV converter([#2508](https://github.com/railsadminteam/rails_admin/pull/2508), [dca8911f](https://github.com/railsadminteam/rails_admin/commit/dca8911f240ea11ebb186c33573188aa9e1b031d))
- Add SVG file extension to the image detection method([#2533](https://github.com/railsadminteam/rails_admin/pull/2533))
- Update linear gradient syntax to make autoprefixer happy([#2531](https://github.com/railsadminteam/rails_admin/pull/2531))
- Improve export layout ([#2505](https://github.com/railsadminteam/rails_admin/pull/2505))

### Removed

- Remove safe_yaml dependency([#2397](https://github.com/railsadminteam/rails_admin/pull/2397))
- Drop support for Ruby < 2.1.0

### Fixed

- Pagination did not work when showing all history([#2553](https://github.com/railsadminteam/rails_admin/pull/2553))
- Make filter-box label clickable([#2573](https://github.com/railsadminteam/rails_admin/pull/2573))
- Colorpicker form did not have the default css class `form-control`([#2571](https://github.com/railsadminteam/rails_admin/pull/2571))
- Stop assuming locale en is available([#2155](https://github.com/railsadminteam/rails_admin/issues/2155))
- Fix undefined method error with nested polymorphics([#1338](https://github.com/railsadminteam/rails_admin/issues/1338), [#2110](https://github.com/railsadminteam/rails_admin/pull/2110))
- Fix issue with nav does not check pjax config from an action([#2309](https://github.com/railsadminteam/rails_admin/pull/2309))
- Model label should be pluralized with locale([#1983](https://github.com/railsadminteam/rails_admin/pull/1983))
- Fix delocalize strftime_format for DateTime.strptime to support minus([#2547](https://github.com/railsadminteam/rails_admin/pull/2547))
- Fix Syntax Error in removal of new nested entity([#2539](https://github.com/railsadminteam/rails_admin/pull/2539))
- Fix momentjs translations for '%-d' format day of the month([#2540](https://github.com/railsadminteam/rails_admin/pull/2540))
- Fix Mongoid BSON object field ([#2495](https://github.com/railsadminteam/rails_admin/issues/2495))
- Make browser ignore validaitons of removed nested child models([#2443](https://github.com/railsadminteam/rails_admin/issues/2443), [#2490](https://github.com/railsadminteam/rails_admin/pull/2490))

## [0.8.1](https://github.com/railsadminteam/rails_admin/tree/v0.8.1) - 2015-11-24

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v0.8.0...v0.8.1)

### Fixed

- `vendor/` directory was missing from gemspec([#2481](https://github.com/railsadminteam/rails_admin/issues/2481), [#2482](https://github.com/railsadminteam/rails_admin/pull/2482))

## [0.8.0](https://github.com/railsadminteam/rails_admin/tree/v0.8.0) - 2015-11-23

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v0.7.0...v0.8.0)

### Added

- Feature to deactivate filtering-multiselect widget's remove buttons through `removable?` field option([#2446](https://github.com/railsadminteam/rails_admin/issues/2446))
- Pundit integration([#2399](https://github.com/railsadminteam/rails_admin/pull/2399) by Team CodeBenders, RGSoC'15)
- Refile support([#2385](https://github.com/railsadminteam/rails_admin/pull/2385))

### Changed

- Some UI improvements in export view([#2394](https://github.com/railsadminteam/rails_admin/pull/2394))
- `rails_admin/custom/variables.scss` is now imported first to take advantage of Sass's `default!`([#2404](https://github.com/railsadminteam/rails_admin/pull/2404))
- Proxy classes now inherit from BasicObject([#2434](https://github.com/railsadminteam/rails_admin/issues/2434))
- Show sidebar scrollbar only on demand([#2419](https://github.com/railsadminteam/rails_admin/pull/2419))
- RailsAdmin no longer gets excluded from NewRelic instrumentation by default([#2402](https://github.com/railsadminteam/rails_admin/pull/2402))
- Improve efficiency of filter query in Postgres([#2401](https://github.com/railsadminteam/rails_admin/pull/2401))
- Replace old jQueryUI datepicker with jQuery Bootstrap datetimepicker ([#2391](https://github.com/railsadminteam/rails_admin/pull/2391))
- Turn Hash#symbolize into a helper to prevent namespace conflict([#2388](https://github.com/railsadminteam/rails_admin/pull/2388))

### Removed

- The L10n translation `admin.misc.filter_date_format` datepicker search filters, has been dropped in favor of field oriented configuration ([#2391](https://github.com/railsadminteam/rails_admin/pull/2391))

### Fixed

- AR#count broke when default-scoped with select([#2129](https://github.com/railsadminteam/rails_admin/pull/2129), [#2447](https://github.com/railsadminteam/rails_admin/issues/2447))
- Datepicker could not handle Spanish date properly([#982](https://github.com/railsadminteam/rails_admin/issues/982), [#2451](https://github.com/railsadminteam/rails_admin/pull/2451))
- Paperclip's `attachment_definitions` does not exist unless `has_attached_file`-ed([#1674](https://github.com/railsadminteam/rails_admin/issues/1674))
- `.btn` class was used without a modifier([#2417](https://github.com/railsadminteam/rails_admin/pull/2417))
- Filtering-multiselect widget ignored order([#2231](https://github.com/railsadminteam/rails_admin/issues/2231), [#2412](https://github.com/railsadminteam/rails_admin/pull/2412))
- Add missing .alert-dismissible class to flash([#2411](https://github.com/railsadminteam/rails_admin/pull/2411))
- Keep field order on changing the existing field's type([#2409](https://github.com/railsadminteam/rails_admin/pull/2409))
- Add button for nested-many form in modal disappeared on click([#2372](https://github.com/railsadminteam/rails_admin/issues/2372), [#2383](https://github.com/railsadminteam/rails_admin/pull/2383))

### Security

- Fix XSS vulnerability in polymorphic select([#2479](https://github.com/railsadminteam/rails_admin/pull/2479))

## [0.7.0](https://github.com/railsadminteam/rails_admin/tree/v0.7.0) - 2015-08-16

[Full Changelog](https://github.com/railsadminteam/rails_admin/compare/v0.6.8...v0.7.0)

### Added

- Support for ActiveRecord::Enum ([#1993](https://github.com/railsadminteam/rails_admin/issues/1993))
- Multiselect-widget shows user friendly message, instead of just being blank ([#1369](https://github.com/railsadminteam/rails_admin/issues/1369), [#2360](https://github.com/railsadminteam/rails_admin/pull/2360))
- Configuration option to turn browser validation off ([#2339](https://github.com/railsadminteam/rails_admin/pull/2339), [#2373](https://github.com/railsadminteam/rails_admin/pull/2373))

### Changed

- Multiselect-widget inserts a new item to the bottom, instead of top ([#2167](https://github.com/railsadminteam/rails_admin/pull/2167))
- Migrated Cerulean theme to Bootstrap3 ([#2352](https://github.com/railsadminteam/rails_admin/pull/2352))
- Better html markup for input fields ([#2336](https://github.com/railsadminteam/rails_admin/pull/2336))
- Update filter dropdown button to Bootstrap3 ([#2277](https://github.com/railsadminteam/rails_admin/pull/2277))
- Improve navbar appearance ([#2310](https://github.com/railsadminteam/rails_admin/pull/2310))
- Do not monkey patch the app's YAML ([#2331](https://github.com/railsadminteam/rails_admin/pull/2331))

### Fixed

- Browser validation prevented saving of persisted upload fields ([#2376](https://github.com/railsadminteam/rails_admin/issues/2376))
- Fix inconsistent styling in static_navigation ([#2378](https://github.com/railsadminteam/rails_admin/pull/2378))
- Fix css regression for has_one and has_many nested form ([#2337](https://github.com/railsadminteam/rails_admin/pull/2337))
- HTML string inputs should not have a size attribute valorized with 0 ([#2335](https://github.com/railsadminteam/rails_admin/pull/2335))

### Security

- Fix XSS vulnerability in filtering-select widget
- Fix XSS vulnerability in association fields ([#2343](https://github.com/railsadminteam/rails_admin/issues/2343))
