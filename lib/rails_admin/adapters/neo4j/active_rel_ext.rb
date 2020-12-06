module Neo4j
  module ActiveRel
    class ActiveRelQueryProxy

      def initialize(model, starting_query = nil)
        @model = model
        @chain = []
        @starting_query = starting_query
      end

      METHODS = %w(where order skip limit)

      METHODS.each do |method|
        define_method(method) { |*args| build_deeper_query_proxy(method.to_sym, args) }
      end

      include Enumerable
      def each(&block)
        query.pluck(rel_var).each(&block)
      end

      def query
        query_as(rel_var)
      end

      NON_PREFIXED_CLAUSES = [:limit, :skip]
      def query_as(var)
        @chain.inject(@starting_query || _session.query) do |query, (clause, args)|
          args.inject(query) do |query2, arg|
            if clause.in?(NON_PREFIXED_CLAUSES)
              query.send(clause, arg)
            else
              query.send(clause, rel_var => arg)
            end
          end
        end
      end

      def size
        self.count
      end

      protected

      def _add_link(clause, args)
        @chain << [clause, args]
      end
 
      private

      def rel_var
        :r1
      end


      def build_deeper_query_proxy(method, args)
        self.clone.tap do |new_query_proxy|
          new_query_proxy.instance_variable_set('@chain', @chain.dup)
          new_query_proxy._add_link(method, args)
        end
      end

      def _session
        @session || (@model && @model.neo4j_session)
      end

    end

    def self.query_proxy
      ActiveRelQueryProxy.new(self)
    end
  end
end



::Neo4j::ActiveRel::ActiveRelQueryProxy.send :include, ::Kaminari::Neo4j::Extension::InstanceMethods
::Neo4j::ActiveRel.send :include, ::Kaminari::Neo4j::Extension::ClassMethods
