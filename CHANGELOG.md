# RailsAdmin Changelog

## [Unreleased](https://github.com/sferik/rails_admin/tree/HEAD)

[Full Changelog](https://github.com/sferik/rails_admin/compare/v2.0.2...HEAD)


## [2.0.2](https://github.com/sferik/rails_admin/tree/v2.0.2) - 2020-03-17

[Full Changelog](https://github.com/sferik/rails_admin/compare/v2.0.1...v2.0.2)

### Fixed
- Fix to use I18n to translate the button 'Reset filters'([#3248](https://github.com/sferik/rails_admin/pull/3248))

### Security
- Fix XSS vulnerability in nested forms([d72090ec](https://github.com/sferik/rails_admin/commit/d72090ec6a07c3b9b7b48ab50f3d405f91ff4375))


## [2.0.1](https://github.com/sferik/rails_admin/tree/v2.0.1) - 2019-12-31

[Full Changelog](https://github.com/sferik/rails_admin/compare/v2.0.0...v2.0.1)

### Fixed
- Fix Zeitwerk incompatible behavior of autoloading constants during initialization([#3190](https://github.com/sferik/rails_admin/issues/3190), [e275012b](https://github.com/sferik/rails_admin/commit/e275012b630453cb1187e71a938382a3c5d3ef39))
- Fix empty fields being hidden regardless of `compact_show_view`([#3213](https://github.com/sferik/rails_admin/pull/3213))
- Fix `filter_scope` not using `default_search_operator` as default([#3212](https://github.com/sferik/rails_admin/pull/3212))
- Fix PaperTrail integration returning `nil` as username instead of `whodunnit`([#3210](https://github.com/sferik/rails_admin/pull/3210))
- Fix Sprockets 4 incompatibility of vendorized Fontawesome([#3204](https://github.com/sferik/rails_admin/issues/3204), [#3207](https://github.com/sferik/rails_admin/pull/3207))

### Security
- Update moment.js to 2.24.0 to address security vulnerability([#3182](https://github.com/sferik/rails_admin/issues/3182), [#3201](https://github.com/sferik/rails_admin/pull/3201))


## [2.0.0](https://github.com/sferik/rails_admin/tree/v2.0.0) - 2019-08-18

[Full Changelog](https://github.com/sferik/rails_admin/compare/v2.0.0.rc...v2.0.0)

### Fixed
- Fix support for belongs_to with custom primary key was broken in 2.0.0.rc([#3184](https://github.com/sferik/rails_admin/issues/3184), [0e92ca43](https://github.com/sferik/rails_admin/commit/0e92ca43fe7782a8d62ae9285a8d3de7857c9853))
- Fix missing translation `en.admin.misc.ago`([#3180](https://github.com/sferik/rails_admin/pull/3180))


## [2.0.0.rc](https://github.com/sferik/rails_admin/tree/v2.0.0.rc) - 2019-08-04

[Full Changelog](https://github.com/sferik/rails_admin/compare/v2.0.0.beta...v2.0.0.rc)

### Added
- Add Support for CarrierWave 2.0 multiple file upload's keep, append and reorder feature([fb093e04](https://github.com/sferik/rails_admin/commit/fb093e04502e7bff30594f5baf1227abb7199384))
- Add ability to configure way how custom actions show up in root/top/sidebar navigation([#2844](https://github.com/sferik/rails_admin/pull/2844))

### Changed
- [BREAKING CHANGE] Stop authorization adapters assigning attributes on create and update, just check for permission instead([#3120](https://github.com/sferik/rails_admin/pull/3120), [c84d1703](https://github.com/sferik/rails_admin/commit/c84d1703b47b396382d152471dac8fc8dc41aefd))
- [BREAKING CHANGE] Do not show tableless models by default([#3157](https://github.com/sferik/rails_admin/issues/3157), [87b38b33](https://github.com/sferik/rails_admin/commit/87b38b336cc668a74803dec4628215e2e2941248))
- [BREAKING CHANGE] Convert empty string into nil for nullable string-like fields to achieve uniqueness-index friendliness([#2099](https://github.com/sferik/rails_admin/issues/2099), [#3172](https://github.com/sferik/rails_admin/issues/3172), [3f9ab1cc](https://github.com/sferik/rails_admin/commit/3f9ab1cc009caa8b466f34da692c3561da2235e4))
- Extract head from application template for ease of customization([#3114](https://github.com/sferik/rails_admin/pull/3114))
- Rename `delete_key` to `delete_value`, used to identify which file to delete in multiple file upload([8b8c3a44](https://github.com/sferik/rails_admin/commit/8b8c3a44177465823128e9b48b11467ccf7db001))
- Get rid of CoffeeScript, use plain JavaScript instead([#3111](https://github.com/sferik/rails_admin/issues/3111), [#3168](https://github.com/sferik/rails_admin/pull/3168))
- Replace sass-rails with sassc-rails([#3156](https://github.com/sferik/rails_admin/pull/3156))

### Removed
- Drop support for CanCan, please use its successor CanCanCan([6b7495f1](https://github.com/sferik/rails_admin/commit/6b7495f1454e30027a9d77b911206cc7703170a3))
- Drop support for CanCanCan legacy `can :dashboard` style dashboard ability notation([5bebac24](https://github.com/sferik/rails_admin/commit/5bebac2488906f3739717108efadedaa091ccaf5))
- Drop Refile support due to maintenance inactivity([25ae06a9](https://github.com/sferik/rails_admin/commit/25ae06a9a6eb534afa4a5f17e64ca346086bb3b8))

### Fixed
- Fix PaperTrail pagination breaks when Kaminari's `page_method_name` is set([#3170](https://github.com/sferik/rails_admin/issues/3170), [136b943c](https://github.com/sferik/rails_admin/commit/136b943ce842eba6b0a13dc2956ddc9ce20d006c))
- Fix failing to pass config location to CKEditor([#3162](https://github.com/sferik/rails_admin/issues/3162), [c38b76d7](https://github.com/sferik/rails_admin/commit/c38b76d707f198be0ac8baa1ff02dde7bd02344f))
- Fix CarrierWave multiple file uploader breaking when used with Fog([#3070](https://github.com/sferik/rails_admin/issues/3070))
- Fix placeholder being picked up as a selection in filtering-multiselect([#2807](https://github.com/sferik/rails_admin/issues/2807), [15502601](https://github.com/sferik/rails_admin/commit/15502601ccd0bbbaeb364a0ee605f360d65c5cbb))
- Fix breaking with has_many and custom primary key([#1878](https://github.com/sferik/rails_admin/issues/1878), [be7d2f4a](https://github.com/sferik/rails_admin/commit/be7d2f4a3ad1fda788f92a0e0dd4a83b98f141f4))
- Fix to choose right LIKE statement in per-model basis([#1676](https://github.com/sferik/rails_admin/issues/1676), [4ea4575e](https://github.com/sferik/rails_admin/commit/4ea4575e934e26cec4a5b214b9fe68cb96b40247))
- Fix polymorphic associations not using STI base classes for polymorphic type([#2136](https://github.com/sferik/rails_admin/pull/2136))

### Security
- Add `rel="noopener"` to all `target="_blank"` links to prevent Reverse tabnabbing([#2960](https://github.com/sferik/rails_admin/issues/2960), [#3169](https://github.com/sferik/rails_admin/pull/3169))


## [2.0.0.beta](https://github.com/sferik/rails_admin/tree/v2.0.0.beta) - 2019-06-08

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.4.2...v2.0.0.beta)

### Added
- Rails 6 support([#3122](https://github.com/sferik/rails_admin/pull/3122))
- ActionText support([#3144](https://github.com/sferik/rails_admin/issues/3144), [Wiki](https://github.com/sferik/rails_admin/wiki/ActionText))
- sass-rails 6 support([#3129](https://github.com/sferik/rails_admin/issues/3129))
- Sidescroll feature([#3017](https://github.com/sferik/rails_admin/pull/3017), [Wiki](https://github.com/sferik/rails_admin/wiki/Horizontally-scrolling-table-with-frozen-columns-in-list-view))
- Custom search feature([#343](https://github.com/sferik/rails_admin/issues/343), [#3019](https://github.com/sferik/rails_admin/pull/3019), [Wiki](https://github.com/sferik/rails_admin/wiki/Custom-Search))
- Filtering-select feature for polymorphic association([#2886](https://github.com/sferik/rails_admin/pull/2886))
- Shrine support([#3081](https://github.com/sferik/rails_admin/pull/3081))
- Flexibility for localication of *time* ago([#3135](https://github.com/sferik/rails_admin/pull/3135), [49add741](https://github.com/sferik/rails_admin/commit/49add7413794e2a1423b86399ef476414d22970f))

### Changed
- Vendorize font-awesome to allow using different version in app([#3039](https://github.com/sferik/rails_admin/issues/3039))
- Stop inlining JavaScripts for CSP friendliness([#3087](https://github.com/sferik/rails_admin/issues/3087))
- Richtext editors now uses CDN-hosted assets([#3126](https://github.com/sferik/rails_admin/issues/3126))

### Removed
- Remove deprecated DSL syntax for richtext editors([e0b390d9](https://github.com/sferik/rails_admin/commit/e0b390d99eab64c99f1f3cccae2029649e90e11c))
- Drop support for Ruby 2.1 and Rails 4.x([dd247804](https://github.com/sferik/rails_admin/commit/dd24780445f4dd676ae033c69a5b64347b80c3bc))

### Fixed
- Fix Mongoid query and filter parsing value twice([#2755](https://github.com/sferik/rails_admin/issues/2755))
- Fix thread-safety issues([#2897](https://github.com/sferik/rails_admin/issues/2897), [#2942](https://github.com/sferik/rails_admin/issues/2942), [1d22bc66](https://github.com/sferik/rails_admin/commit/1d22bc66168ac9ea478ea95b4b3b79f41263c0bd))
- Fix compact_show_view not showing Boolean falses([#2416](https://github.com/sferik/rails_admin/issues/2416))
- Fix PaperTrail fail to fetch versions for STI subclasses([#2865](https://github.com/sferik/rails_admin/pull/2865))
- Fix Dragonfly factory breaks if a model not extending Dragonfly::Model is passed([#2720](https://github.com/sferik/rails_admin/pull/2720))
- Fix PaperTrail adapter not using Kaminari's `page_method_name` for pagination([#2712](https://github.com/sferik/rails_admin/pull/2712))
- Fix #bulk_menu was not using passed `abstract_model` ([#2782](https://github.com/sferik/rails_admin/pull/2782))
- Fix wrong styles when using multiple instances of CodeMirror([#3107](https://github.com/sferik/rails_admin/pull/3107))
- Fix password being cleared when used with Devise 4.6([72bc0373](https://github.com/sferik/rails_admin/commit/72bc03736162ffef8e5b99f42ca605d17fe7e7d0))
- ActiveStorage factory caused const missing for Mongoid([#3088](https://github.com/sferik/rails_admin/pull/3088), [db927687](https://github.com/sferik/rails_admin/commit/db9276879c8e8c5e8772261725ef0e0cdadd9cf1))
- Fix exact matches were using LIKE, which was not index-friendly([#3000](https://github.com/sferik/rails_admin/pull/3000))
- Middleware check failed when using RedisStore([#3076](https://github.com/sferik/rails_admin/issues/3076))
- Fix field being reset to default after an error([#3066](https://github.com/sferik/rails_admin/pull/3066))


## [1.4.2](https://github.com/sferik/rails_admin/tree/v1.4.2) - 2018-09-23

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.4.1...v1.4.2)

### Fixed
- Fix `can't modify frozen Array` error on startup([#3060](https://github.com/sferik/rails_admin/issues/3060))
- Fix deprecation warning with PaperTrail.whodunnit([#3059](https://github.com/sferik/rails_admin/pull/3059))


## [1.4.1](https://github.com/sferik/rails_admin/tree/v1.4.1) - 2018-08-19

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.4.0...v1.4.1)

### Fixed
- Export crashes for models with JSON field([#3056](https://github.com/sferik/rails_admin/pull/3056))
- Middlewares being mangled by engine initializer, causing app's session store configuration to be overwritten([#3048](https://github.com/sferik/rails_admin/issues/3048), [59478af9](https://github.com/sferik/rails_admin/commit/59478af9a05c76bdfe35e94e63c60ba89c27a483))


## [1.4.0](https://github.com/sferik/rails_admin/tree/v1.4.0) - 2018-07-22

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.3.0...v1.4.0)

### Added
- Support for ActiveStorage([#2990](https://github.com/sferik/rails_admin/issues/2990), [#3037](https://github.com/sferik/rails_admin/pull/3037))
- Support for multiple file upload for ActiveStorage and CarrierWave ([5bb2d375](https://github.com/sferik/rails_admin/commit/5bb2d375a236268e51c7e8682c2d110d9e52970f))
- Support for Mongoid 7.0([9ef623f6](https://github.com/sferik/rails_admin/commit/9ef623f6cba73adbf86833d9eb07f1be3924a133), [#3013](https://github.com/sferik/rails_admin/issues/3013))
- Support for CanCanCan 2.0([a32d49e4](https://github.com/sferik/rails_admin/commit/a32d49e4b96944905443588a1216b3362ee64c1a), [#2901](https://github.com/sferik/rails_admin/issues/2901))
- Support for Pundit 2.0([bc60c978](https://github.com/sferik/rails_admin/commit/bc60c978adfebe09cdad2c199878d8ff966374f1))
- Support for jquery-ui-rails 6.0([#2951](https://github.com/sferik/rails_admin/issues/2951), [#3003](https://github.com/sferik/rails_admin/issues/3003))

### Fixed
- Make code reloading work([#3041](https://github.com/sferik/rails_admin/pull/3041))
- Improved support for Rails API mode, requiring needed middlewares in engine's initializer([#2919](https://github.com/sferik/rails_admin/issues/2919), [#3006](https://github.com/sferik/rails_admin/pull/3006))
- Make the link text to uploaded file shorter, instead of showing full url([#2983](https://github.com/sferik/rails_admin/pull/2983))
- Fix duplication of filters on browser back([#2998](https://github.com/sferik/rails_admin/pull/2998))
- Fix "can't modify frozen array" exception on code reload([#2999](https://github.com/sferik/rails_admin/pull/2999))
- Fix incorrectly comparing numeric columns with empty string when handling blank operator([#3007](https://github.com/sferik/rails_admin/pull/3007))


## [1.3.0](https://github.com/sferik/rails_admin/tree/v1.3.0) - 2018-02-18

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.2.0...v1.3.0)

### Added
- Configurability for forgery protection setting([#2989](https://github.com/sferik/rails_admin/pull/2989))
- Configurability for the number of audit records displayed into dashboard([#2982](https://github.com/sferik/rails_admin/pull/2982))
- Add limited pagination mode, which doesn't require count query([#2968](https://github.com/sferik/rails_admin/pull/2968))
- Prettier output of JSON field value([#2937](https://github.com/sferik/rails_admin/pull/2937), [#2973](https://github.com/sferik/rails_admin/pull/2973), [#2980](https://github.com/sferik/rails_admin/pull/2980))
- Add markdown field support through SimpleMDE([#2949](https://github.com/sferik/rails_admin/pull/2949))
- Checkboxes for bulk actions in index page can be turned off now([#2917](https://github.com/sferik/rails_admin/pull/2917))

### Fixed
- Parse JS translations as JSON([#2925](https://github.com/sferik/rails_admin/pull/2925))
- Re-selecting an item after unselecting has no effect in filtering-multiselect([#2912](https://github.com/sferik/rails_admin/issues/2912))
- Stop memoization of datetime parser to handle locale changes([#2824](https://github.com/sferik/rails_admin/pull/2824))
- Filters for ActiveRecord Enum field behaved incorrectly for enums whose labels are different from values([#2971](https://github.com/sferik/rails_admin/pull/2971))
- Client-side required validation was not enforced in filtering-select widget([#2905](https://github.com/sferik/rails_admin/pull/2905))
- Filter refresh button was broken([#2890](https://github.com/sferik/rails_admin/pull/2890))

### Security
- Fix XSS vulnerability in filter and multi-select widget([#2985](https://github.com/sferik/rails_admin/issues/2985), [44f09ed7](https://github.com/sferik/rails_admin/commit/44f09ed72b5e0e917a5d61bd89c48d97c494b41c))


## [1.2.0](https://github.com/sferik/rails_admin/tree/v1.2.0) - 2017-05-31

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.1.1...v1.2.0)

### Added
- Add ILIKE support for PostgreSQL/PostGIS adapter, multibyte downcase for other adapters([#2766](https://github.com/sferik/rails_admin/pull/2766))
- Support for UUID query([#2766](https://github.com/sferik/rails_admin/pull/2766))
- Support for Haml 5([#2840](https://github.com/sferik/rails_admin/pull/2840), [#2870](https://github.com/sferik/rails_admin/pull/2870), [#2877](https://github.com/sferik/rails_admin/pull/2877))
- Add instance option to append a CSS class for rows([#2860](https://github.com/sferik/rails_admin/pull/2860))

### Fixed
- Remove usage of alias_method_chain, deprecated in Rails 5.0([#2864](https://github.com/sferik/rails_admin/pull/2864))
- Load models from eager_load, not autoload_paths([#2771](https://github.com/sferik/rails_admin/pull/2771))
- jQuery 3.0 doesn't have size(), use length instead([#2841](https://github.com/sferik/rails_admin/pull/2841))
- Prepopulation of the new form didn't work with namespaced models([#2701](https://github.com/sferik/rails_admin/pull/2701))


## [1.1.1](https://github.com/sferik/rails_admin/tree/v1.1.1) - 2016-12-25

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.1.0...v1.1.1)

### Fixed
- CSV export broke with empty tables([#2796](https://github.com/sferik/rails_admin/issues/2796), [#2797](https://github.com/sferik/rails_admin/pull/2797))
- ActiveRecord adapter's #encoding did not work with Oracle enhanced adapter([#2789](https://github.com/sferik/rails_admin/pull/2789))
- ActiveRecord 5 belongs_to presence validators were unintentionally disabled due to initialization mishandling([#2785](https://github.com/sferik/rails_admin/issues/2785), [#2786](https://github.com/sferik/rails_admin/issues/2786))
- Destroy failure caused subsequent index action to return 404, instead of 200([#2775](https://github.com/sferik/rails_admin/issues/2775), [#2776](https://github.com/sferik/rails_admin/pull/2776))
- CSVConverter#to_csv now accepts string-keyed hashes([#2740](https://github.com/sferik/rails_admin/issues/2740), [#2741](https://github.com/sferik/rails_admin/pull/2741))

### Security
- Fix CSRF vulnerability([b13e879e](https://github.com/sferik/rails_admin/commit/b13e879eb93b661204e9fb5e55f7afa4f397537a))


## [1.1.0](https://github.com/sferik/rails_admin/tree/v1.1.0) - 2016-10-30

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.0.0...v1.1.0)

### Added
- DSL for association eager-loading([#1325](https://github.com/sferik/rails_admin/issues/1325), [#1342](https://github.com/sferik/rails_admin/issues/1342))

### Fixed
- Fix nested has_many form failing to add items([#2737](https://github.com/sferik/rails_admin/pull/2737))


## [1.0.0](https://github.com/sferik/rails_admin/tree/v1.0.0) - 2016-09-19

[Full Changelog](https://github.com/sferik/rails_admin/compare/v1.0.0.rc...v1.0.0)

### Added
- Introduce setup hook for authorization/auditing adapters([ba2088c6](https://github.com/sferik/rails_admin/commit/ba2088c6ecabd354b4b67c50bb00fccdbd1e6240))
- Add viewport meta tag for mobile layout adjustment([#2664](https://github.com/sferik/rails_admin/pull/2664))
- Support for ActiveRecord::Enum using string columns([#2680](https://github.com/sferik/rails_admin/pull/2680))

### Changed
- Limit children for deletion notice([#2491](https://github.com/sferik/rails_admin/pull/2491))
- [BREAKING CHANGE] Change parent controller to ActionController::Base for out-of-box support of Rails 5 API mode([#2688](https://github.com/sferik/rails_admin/issues/2688))
  - To keep old behavior, add `config.parent_controller = '::ApplicationController'` in your RailsAdmin initializer.

### Fixed
- ActiveRecord Enum fields could not be updated correctly([#2659](https://github.com/sferik/rails_admin/pull/2659), [#2713](https://github.com/sferik/rails_admin/issues/2713))
- Fix performance issue with filtering-multiselect widget([#2715](https://github.com/sferik/rails_admin/pull/2715))
- Restore back rails_admin_controller?([#2268](https://github.com/sferik/rails_admin/issues/2268))
- Duplication of autocomplete fields when using browser back/forward buttons([#2677](https://github.com/sferik/rails_admin/issues/2677), [#2678](https://github.com/sferik/rails_admin/pull/2678))
- Filter refresh button was broken([#2705](https://github.com/sferik/rails_admin/issues/2705), [#2706](https://github.com/sferik/rails_admin/pull/2706))
- Fix presence filtering on boolean columns([#1099](https://github.com/sferik/rails_admin/issues/1099), [#2675](https://github.com/sferik/rails_admin/pull/2675))
- Pundit::AuthorizationNotPerformedError was raised when used with Pundit([#2683](https://github.com/sferik/rails_admin/pull/2683))


## [1.0.0.rc](https://github.com/sferik/rails_admin/tree/v1.0.0.rc) - 2016-07-18

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.8.1...v1.0.0.rc)

### Added
- Rails 5 support
- PaperTrail 5 support([9c42783a](https://github.com/sferik/rails_admin/commit/9c42783aa65b704f4a5d467608c49b746c47b81b))
- Support for multiple configuration blocks([#1781](https://github.com/sferik/rails_admin/pull/1781), [#2670](https://github.com/sferik/rails_admin/pull/2670))
- Default association limit is now configurable([#2508](https://github.com/sferik/rails_admin/pull/2058))

### Changed
- Prefix kaminari bootstrap views with `ra-` to avoid name conflict([#2283](https://github.com/sferik/rails_admin/issues/2283), [#2651](https://github.com/sferik/rails_admin/pull/2651))
- Gravatar icon is now optional([#2570](https://github.com/sferik/rails_admin/pull/2570))
- Improve bootstrap-wysihtml5-rails support([#2650](https://github.com/sferik/rails_admin/pull/2650))
- Explicitly call the #t method on I18n([#2564](https://github.com/sferik/rails_admin/pull/2564))
- Improve dashboard performance by querying with id instead of updated_at([#2514](https://github.com/sferik/rails_admin/issues/2514), [#2551](https://github.com/sferik/rails_admin/pull/2551))
- Improve encoding support in CSV converter([#2508](https://github.com/sferik/rails_admin/pull/2508), [dca8911f](https://github.com/sferik/rails_admin/commit/dca8911f240ea11ebb186c33573188aa9e1b031d))
- Add SVG file extension to the image detection method([#2533](https://github.com/sferik/rails_admin/pull/2533))
- Update linear gradient syntax to make autoprefixer happy([#2531](https://github.com/sferik/rails_admin/pull/2531))
- Improve export layout ([#2505](https://github.com/sferik/rails_admin/pull/2505))

### Removed
- Remove safe_yaml dependency([#2397](https://github.com/sferik/rails_admin/pull/2397))
- Drop support for Ruby < 2.1.0

### Fixed
- Pagination did not work when showing all history([#2553](https://github.com/sferik/rails_admin/pull/2553))
- Make filter-box label clickable([#2573](https://github.com/sferik/rails_admin/pull/2573))
- Colorpicker form did not have the default css class `form-control`([#2571](https://github.com/sferik/rails_admin/pull/2571))
- Stop assuming locale en is available([#2155](https://github.com/sferik/rails_admin/issues/2155))
- Fix undefined method error with nested polymorphics([#1338](https://github.com/sferik/rails_admin/issues/1338), [#2110](https://github.com/sferik/rails_admin/pull/2110))
- Fix issue with nav does not check pjax config from an action([#2309](https://github.com/sferik/rails_admin/pull/2309))
- Model label should be pluralized with locale([#1983](https://github.com/sferik/rails_admin/pull/1983))
- Fix delocalize strftime_format for DateTime.strptime to support minus([#2547](https://github.com/sferik/rails_admin/pull/2547))
- Fix Syntax Error in removal of new nested entity([#2539](https://github.com/sferik/rails_admin/pull/2539))
- Fix momentjs translations for '%-d' format day of the month([#2540](https://github.com/sferik/rails_admin/pull/2540))
- Fix Mongoid BSON object field ([#2495](https://github.com/sferik/rails_admin/issues/2495))
- Make browser ignore validaitons of removed nested child models([#2443](https://github.com/sferik/rails_admin/issues/2443), [#2490](https://github.com/sferik/rails_admin/pull/2490))


## [0.8.1](https://github.com/sferik/rails_admin/tree/v0.8.1) - 2015-11-24

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.8.0...v0.8.1)

### Fixed
- `vendor/` directory was missing from gemspec([#2481](https://github.com/sferik/rails_admin/issues/2481), [#2482](https://github.com/sferik/rails_admin/pull/2482))


## [0.8.0](https://github.com/sferik/rails_admin/tree/v0.8.0) - 2015-11-23

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.7.0...v0.8.0)

### Added
- Feature to deactivate filtering-multiselect widget's remove buttons through `removable?` field option([#2446](https://github.com/sferik/rails_admin/issues/2446))
- Pundit integration([#2399](https://github.com/sferik/rails_admin/pull/2399) by Team CodeBenders, RGSoC'15)
- Refile support([#2385](https://github.com/sferik/rails_admin/pull/2385))

### Changed
- Some UI improvements in export view([#2394](https://github.com/sferik/rails_admin/pull/2394))
- `rails_admin/custom/variables.scss` is now imported first to take advantage of Sass's `default!`([#2404](https://github.com/sferik/rails_admin/pull/2404))
- Proxy classes now inherit from BasicObject([#2434](https://github.com/sferik/rails_admin/issues/2434))
- Show sidebar scrollbar only on demand([#2419](https://github.com/sferik/rails_admin/pull/2419))
- RailsAdmin no longer gets excluded from NewRelic instrumentation by default([#2402](https://github.com/sferik/rails_admin/pull/2402))
- Improve efficiency of filter query in Postgres([#2401](https://github.com/sferik/rails_admin/pull/2401))
- Replace old jQueryUI datepicker with jQuery Bootstrap datetimepicker ([#2391](https://github.com/sferik/rails_admin/pull/2391))
- Turn Hash#symbolize into a helper to prevent namespace conflict([#2388](https://github.com/sferik/rails_admin/pull/2388))

### Removed
- The L10n translation `admin.misc.filter_date_format` datepicker search filters, has been dropped in favor of field oriented configuration ([#2391](https://github.com/sferik/rails_admin/pull/2391))

### Fixed
- AR#count broke when default-scoped with select([#2129](https://github.com/sferik/rails_admin/pull/2129), [#2447](https://github.com/sferik/rails_admin/issues/2447))
- Datepicker could not handle Spanish date properly([#982](https://github.com/sferik/rails_admin/issues/982), [#2451](https://github.com/sferik/rails_admin/pull/2451))
- Paperclip's `attachment_definitions` does not exist unless `has_attached_file`-ed([#1674](https://github.com/sferik/rails_admin/issues/1674))
- `.btn` class was used without a modifier([#2417](https://github.com/sferik/rails_admin/pull/2417))
- Filtering-multiselect widget ignored order([#2231](https://github.com/sferik/rails_admin/issues/2231), [#2412](https://github.com/sferik/rails_admin/pull/2412))
- Add missing .alert-dismissible class to flash([#2411](https://github.com/sferik/rails_admin/pull/2411))
- Keep field order on changing the existing field's type([#2409](https://github.com/sferik/rails_admin/pull/2409))
- Add button for nested-many form in modal disappeared on click([#2372](https://github.com/sferik/rails_admin/issues/2372), [#2383](https://github.com/sferik/rails_admin/pull/2383))

### Security
- Fix XSS vulnerability in polymorphic select([#2479](https://github.com/sferik/rails_admin/pull/2479))


## [0.7.0](https://github.com/sferik/rails_admin/tree/v0.7.0) - 2015-08-16

[Full Changelog](https://github.com/sferik/rails_admin/compare/v0.6.8...v0.7.0)

### Added
- Support for ActiveRecord::Enum ([#1993](https://github.com/sferik/rails_admin/issues/1993))
- Multiselect-widget shows user friendly message, instead of just being blank ([#1369](https://github.com/sferik/rails_admin/issues/1369), [#2360](https://github.com/sferik/rails_admin/pull/2360))
- Configuration option to turn browser validation off ([#2339](https://github.com/sferik/rails_admin/pull/2339), [#2373](https://github.com/sferik/rails_admin/pull/2373))

### Changed
- Multiselect-widget inserts a new item to the bottom, instead of top ([#2167](https://github.com/sferik/rails_admin/pull/2167))
- Migrated Cerulean theme to Bootstrap3 ([#2352](https://github.com/sferik/rails_admin/pull/2352))
- Better html markup for input fields ([#2336](https://github.com/sferik/rails_admin/pull/2336))
- Update filter dropdown button to Bootstrap3 ([#2277](https://github.com/sferik/rails_admin/pull/2277))
- Improve navbar appearance ([#2310](https://github.com/sferik/rails_admin/pull/2310))
- Do not monkey patch the app's YAML ([#2331](https://github.com/sferik/rails_admin/pull/2331))

### Fixed
- Browser validation prevented saving of persisted upload fields ([#2376](https://github.com/sferik/rails_admin/issues/2376))
- Fix inconsistent styling in static_navigation ([#2378](https://github.com/sferik/rails_admin/pull/2378))
- Fix css regression for has_one and has_many nested form ([#2337](https://github.com/sferik/rails_admin/pull/2337))
- HTML string inputs should not have a size attribute valorized with 0 ([#2335](https://github.com/sferik/rails_admin/pull/2335))

### Security
- Fix XSS vulnerability in filtering-select widget
- Fix XSS vulnerability in association fields ([#2343](https://github.com/sferik/rails_admin/issues/2343))
