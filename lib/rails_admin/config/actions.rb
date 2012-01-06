module RailsAdmin
  module Config
    class Actions
      @@registry = []
      
      def self.register(name, klass = nil)
        if klass == nil && name.kind_of?(Class)
          klass = name
          name = klass.key
        end
        @@registry[name.to_sym] = klass
      end
      
      def self.initialize
        @actions = []
        @@registry.each do |name, klass|
          send(:define_method, name) do |&block|
            action = klass.new
            action = action.instance_eval &block if &block
            @actions << action
            action
          end
        end
      end
    end
  end
end