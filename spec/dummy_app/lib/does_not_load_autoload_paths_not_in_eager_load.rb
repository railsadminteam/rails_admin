

module DoesNotLoadAutoloadPathsNotInEagerLoad
  raise 'This file is in app.paths.autoload but not app.paths.eager_load and ' \
        ' should not be autoloaded by rails_admin'
end
