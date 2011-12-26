module Foo
  class Engine < Rails::Engine
    isolate_namespace Foo
  end
end
