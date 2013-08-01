### Optional bootstrap-wysihtml5 integration

http://jhollingworth.github.com/bootstrap-wysihtml5/

add `gem 'bootstrap-wysihtml5-rails'` to your Gemfile

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      field :description, :text do
        bootstrap_wysihtml5 true
      end
    end
  end
end
```

### Optional CKEditor integration

To use the CKEditor with Upload function, add [Rails-CKEditor](https://github.com/galetahub/ckeditor) to your Gemfile (`gem 'ckeditor'`) and follow [Rails-CKEditor](https://github.com/galetahub/ckeditor) installation instructions.

You can configure more options of CKEditor "config.js" file following the [Api Documentation](http://docs.cksource.com/ckeditor_api/symbols/CKEDITOR.config.html) .

```ruby
RailsAdmin.config do |config|
  config.model Team do
    edit do
      # For RailsAdmin >= 0.5.0
      field :description, :ck_editor
      # For RailsAdmin < 0.5.0
      # field :description do
      #   ckeditor true
      # end
    end
  end
end
```

Note that CKeditor won't appear in AJAX-loaded modals, due to CKeditor limitations with AJAX loading/unloading (basically it's crap).

[[Support for Codemirror|https://github.com/sferik/rails_admin/commit/61a7e0e7ec21e4183777aa8944cc4f6cc89b9bdc]] was also added recently

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/fields/types/text.rb]]