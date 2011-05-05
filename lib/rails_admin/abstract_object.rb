 module RailsAdmin
  class AbstractObject
    # undef almost all of this class's methods so it will pass almost
    # everything through to its delegate using method_missing (below).
    instance_methods.each { |m| undef_method m unless m.to_s =~ /(^__|^send$|^object_id$)/ }
    #                                                  ^^^^^
    # the unnecessary "to_s" above is a workaround for meta_where, see
    # https://github.com/sferik/rails_admin/issues/374

    attr_accessor :object
    attr_accessor :associations

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
      update_all_associations and object.save(options)
    end

    protected

    def update_all_associations
      return true if associations.nil?

      abstract_model = AbstractModel.new(object.class)

      abstract_model.associations.each do |association|
        if associations.has_key?(association[:name])
          ids = associations[association[:name]]
          begin
            case association[:type]
            when :has_one
              object.save
              update_association(association, ids)
            when :has_many, :has_and_belongs_to_many
              update_associations(association, ids.to_a)
            end
          rescue Exception => e
            object.errors.add association[:name], e.to_s
            return false
          end
        end
      end
    end

    def update_associations(association, ids = [])
      associated_model = RailsAdmin::AbstractModel.new(association[:child_model])
      object.send "#{association[:name]}=", ids.collect{|id| associated_model.get(id)}.compact
    end

    def update_association(association, id = nil)
      associated_model = RailsAdmin::AbstractModel.new(association[:child_model])
      if associated = associated_model.get(id)
        associated.update_attributes(association[:child_key].first => object.id)
      end
    end
  end
end
