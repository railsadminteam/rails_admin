 module RailsAdmin
  class AbstractObject
    # undef almost all of this class's methods so it will pass almost
    # everything through to its delegate using method_missing (below).
    instance_methods.each { |m| undef_method m unless m.to_s =~ /(^__|^send$|^object_id$)/ }
    #                                                  ^^^^^
    # the unnecessary "to_s" above is a workaround for meta_where, see
    # https://github.com/sferik/rails_admin/issues/374

    attr_accessor :object

    def initialize(object)
      self.object = object
    end

    def attributes=(attributes)
      object.send :attributes=, attributes, false
    end

    def method_missing(name, *args, &block)
      self.object.send name, *args, &block
    end

    def save(options = { :validate => true })
      object.save(options)
    end
  end
end
