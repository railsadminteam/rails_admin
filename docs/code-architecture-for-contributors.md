Want to get started extending and improving RailsAdmin? Great! If you feel ready to just dive in and get started, have at it! However if you'd like a little rundown of how the library works, including the major components and techniques for painlessly building on to the RailsAdmin code, this guide should help you get acquainted.

## Major Concepts

RailsAdmin is extremely quick and easy to use because it attempts to intelligently determine as much as it possibly can about your application's model (your DB schema) without needing explicit instructions. In many cases, the system's guesses are good enough to do the job without further customization. However some apps (or sometimes certain critical models within your app) require more administrative functionality than basic CRUD operations available through the stock RailsAdmin install.

Luckily, the code is well thought out and easy to build upon once you understand how it works. Here are some things you should know about RailsAdmin's basic design:

## The layers

RailsAdmin does not try to hide the ORM. It tries to keep it in one place.

```
  Config          Model · Section · Field · Factories
    │  says what the admin should show, in its own vocabulary
    ▼
  AbstractModel   the one object the rest of the code talks to
    ├── Reflection    what this model is
    └── Repository    what can be done with it, and how to reach the store
    │
    ▼
  ActiveRecord / Mongoid
```

Two rules fall out of this, and most of the codebase follows them:

- **Facts travel up, intentions travel down.** Config asks `Reflection` what a
  model looks like, and hands `Repository` a description of what it wants. It
  does not write SQL, and it does not write Mongo selectors.
- **Records belong to no layer.** They are passed as arguments and handed back
  unchanged. See [Records are borrowed](#records-are-borrowed).

## AbstractModel

`RailsAdmin::AbstractModel` is the public face of an adapter. There is one per
model:

```ruby
abstract_model = RailsAdmin::AbstractModel.new('Player')
abstract_model.model          # => Player
abstract_model.properties     # => [#<Property name=:id ...>, ...]
abstract_model.all(sort: :id) # => a scope
```

It owns very little itself. What a model _is_ comes from a `Reflection`, what
can be _done_ with it from a `Repository`, and `AbstractModel` forwards to both.
Both are reachable — `abstract_model.reflection`, `abstract_model.repository` —
but calling through `AbstractModel` is the normal thing to do.

`AbstractModel#model` gives you the real class. Configuration blocks use it
constantly and it is not going anywhere.

### Reflection — what the model is

Answers questions. Never reads or writes a record.

|                                                        |                                                                                |
| ------------------------------------------------------ | ------------------------------------------------------------------------------ |
| `properties`, `associations`                           | the attributes and associations, as `Property` and `Association` value objects |
| `primary_key`, `primary_keys`                          | the store's own shape, and always an array of symbols                          |
| `table_name`, `quoted_table_name`, `quote_column_name` | what the store calls things                                                    |
| `base_class`, `embedded?`, `cyclic?`                   | shape of the model                                                             |
| `attribute_required?`, `attribute_length_options`      | what validations say                                                           |
| `human_attribute_name`, `pretty_name`                  | what to call things                                                            |
| `attribute_enum_values`                                | only where the store has enums of its own                                      |

Ask in the plural — `primary_keys` — wherever a composite key could turn up. It
is an array of one for an ordinary model, so a composite key is never a special
case a caller has to notice.

### Repository — what can be done with it

Reaches the store.

|                                                            |                                                                      |
| ---------------------------------------------------------- | -------------------------------------------------------------------- |
| `new`, `get`, `first`, `all`, `count`, `destroy`, `scoped` | reading and writing records                                          |
| `save(record)`                                             | persisting, including whatever else the store needs to call it saved |
| `read(record, name)`                                       | one attribute, as the store holds it                                 |
| `format_id`, `parse_id`                                    | how an id travels through a URL, and back                            |
| `serialize_attribute`, `deserialize_attribute`             | casting a value the way the store would                              |
| `sort_expression`, `search_column`                         | turning a `Criteria::Path` into the store's own terms                |

## Criteria — how Config says what it wants

### `Criteria::Path`

A field says _which attribute_, not _which column_:

```ruby
RailsAdmin::Criteria::Path[:name]         # this model's name
RailsAdmin::Criteria::Path[:team, :name]  # the name of the associated team
```

The adapter decides what to do with it. ActiveRecord qualifies it with the
association's table and adds the join; Mongoid groups conditions by collection
and does a second lookup for ids. Neither choice leaks into `Field`.

A dotted string like `"teams.name"` is **not** the same thing and is never
converted: its prefix is a _table_ name, while a path's first segment is an
_association_ name. Configuration written that way is passed to the store as it
stands, and that is permanent, not a shim.

### `Criteria::Period`

Relative date filters (`today`, `this_week`, …) are resolved into an absolute
range before an adapter sees them, in the application's time zone. Adapters
never learn what "this week" means.

## Property roles and classifiers

Some attributes mean something the store knows nothing about: a Shrine
attachment, a Paperclip attachment, an enum defined on the model. A **classifier**
answers "what is this, in RailsAdmin's terms":

```ruby
RailsAdmin::AbstractModel.register_classifier do |model, property|
  if model.respond_to?("#{property.name}_enum")
    RailsAdmin::AbstractModel::Role.new(kind: :enum, name: property.name)
  end
end
```

A `Role` carries `kind` (what it turned out to be), `name` (the field name it
should be surfaced under) and `children` (the columns that back it, which should
not be shown on their own). Classifiers run last in, first out, and returning
`nil` defers to the next one.

Field factories then match on `properties.try(:role)&.kind` instead of
inspecting the model class themselves. `Property#type` stays the store's own
type — `role` is added alongside it, not in place of it.

Classifiers and factories are different jobs, not duplicates of each other: a
classifier says _what an attribute is_, a factory says _how to show it_, and a
factory may build several fields and hide others.

## Records are borrowed

RailsAdmin owns descriptions and operations. It does not own records. A record
that comes back from `abstract_model.new` or `#get` is the model's own instance,
with nothing added to it.

This is not a stylistic preference. Two attempts to make records smarter both
broke in ways that are hard to see:

- **A proxy** (`AbstractObject`, removed in #2847) can forward every message,
  but `case record when Player` does not send a message: `Module#===` reaches
  `rb_obj_is_kind_of` in C and looks at the real class. ActiveJob's argument
  serializer is a `case/when` over `GlobalID::Identification`, so proxied
  records fell through it — while `#class` was forwarded, so the error message
  still named the right class and told you nothing.
- **A per-record singleton** (the Mongoid `ObjectExtension`, removed later) is a
  genuine instance, so `case/when` is fine — but `Marshal` refuses an object
  carrying a singleton, so `Rails.cache.write(record)` raised for records
  fetched through the Mongoid adapter and worked for ActiveRecord ones.

When you need per-record behaviour, you almost certainly want a **bound field**,
which already exists: `field.with(object: record)`. Commit `91737ab3c` is the
worked example — a patched `has_one` getter and setter moved onto `Field` and
the patch went away.

## Adding an adapter

Adapters are registered, not hardcoded:

```ruby
RailsAdmin::Adapters.register(
  :sequel,
  require_path: 'rails_admin/adapters/sequel',
  reflection: 'RailsAdmin::Adapters::Sequel::Reflection',
  repository: 'RailsAdmin::Adapters::Sequel::Repository',
) do |model|
  model.ancestors.collect(&:to_s).include?('Sequel::Model')
end
```

Two things about the shape of this are deliberate:

- The classes are **named rather than referred to**, and loaded only once a
  model matches. Registration runs at startup, before any model is looked at, so
  writing the constant would load the adapter — and with it the ORM. An
  application must never have the ORM it does not use required on its behalf.
- The detector matches on **ancestor names**, for the same reason.

If your adapter is already loaded, you can pass the classes themselves. The most
recently registered adapter is asked first, so a registration can take over from
a built-in one.

## The conformance suite

`spec/shared_examples/shared_examples_for_adapters.rb` is the contract both
adapters answer to:

```ruby
it_behaves_like 'a RailsAdmin adapter'
```

The including group supplies `adapter_record_type`, `adapter_property_type`,
`adapter_association_type` and `adapter_missing_id`.

It exists because a fix applied to one adapter has repeatedly failed to reach
the other — `config.default_search_operator` was honoured by ActiveRecord and
ignored by Mongoid for six years, and a guard against unknown field names
existed only in Mongoid. If you change adapter behaviour, put the expectation
here rather than in one of the per-adapter suites, unless the two genuinely need
different APIs to observe it.

## Rules that are checked

Three of the rules above are enforced, by custom RuboCop cops in `rubocop/`.
They cover the templates too, through
[rubocop-erb](https://github.com/r7kamura/rubocop-erb) -- most of the violations
found so far were in a view.

| cop                           | rule                                                                                                         |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `RailsAdmin/RawModelAccess`   | Ask the abstract model for what it already answers, rather than `abstract_model.model.<the store's own API>` |
| `RailsAdmin/RecordDecoration` | Do not `extend` a record or touch its singleton, in an adapter                                               |
| `RailsAdmin/AdapterReference` | Do not name `RailsAdmin::Adapters::…` from Config or a view                                                  |

`RawModelAccess` lists the methods the facade answers, and nothing else.
Reaching the model class is not wrong in itself — calling a method the
application defined, using it as a Ruby class, handing it to another library —
and those uses are left alone. If a legitimate one is flagged, disable it on the
line with a reason:

```ruby
# rubocop:disable RailsAdmin/RawModelAccess -- CanCanCan wants the class
abstract_model.model.accessible_by(ability, action)
# rubocop:enable RailsAdmin/RawModelAccess
```

The templates are checked, not corrected. The styling cops are excluded from
`**/*.erb` in `.rubocop.yml`, both because they have never run on the views and
because autocorrect through rubocop-erb does not always produce valid Ruby --
`count = count + n` came back as `count ++= n`, and 216 specs with it. Leave
`rubocop -A` alone where the views are concerned.

One rule from the same list is **not** enforced: an adapter should not read
`RailsAdmin::Config`, and nine places still do — the fields a search or a filter
runs over come from `config.list`, and the composite key serializer and the
default search operator are read globally. Getting rid of those means the
criteria carrying the fields with them, which has not been done.

## The monkey patches that remain

`config/initializers/active_record_extensions.rb` and
`config/initializers/mongoid_extensions.rb` used to carry a good deal. What is
left is:

- **`Model.rails_admin`** — the entry point of the configuration DSL. Intended,
  and staying.
- **`#safe_send`** — reads an attribute in preference to a method of the same
  name. RailsAdmin no longer calls it; `Repository#read` does that job now. It
  is kept because extensions and applications may call it.
- **Mongoid's `accepts_nested_attributes_for`** — intercepted to keep the
  options, because Mongoid does not (checked against 9.1). RailsAdmin needs
  `allow_destroy` to decide whether a nested form offers to remove a record, and
  getting it wrong is invisible: Mongoid removes `_destroy` from the attributes
  before finding out it may not destroy, so the row the user removed is simply
  still there after saving, with nothing raised.

If you are tempted to remove one of these, find out first why it is there. Every
awkward-looking piece of this codebase that has been dug into so far turned out
to have a reason, and the reason was usually not written down.
