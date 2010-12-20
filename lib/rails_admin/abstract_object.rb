module RailsAdmin
  class AbstractObject
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^send$|^object_id$)/ }
      
    attr_accessor :object
    
    def initialize(object)
      self.object = object
    end
    
    def method_missing(name, *args, &block)
      self.object.send name, *args, &block
    end
  end
end