class Hash
  def symbolize
    Hash.symbolize_hash(self)
  end

  def self.symbolize_hash(obj)
    case obj
    when Array
      obj.each_with_object([]) do |val, res|
        res << case val
        when Hash, Array
          symbolize_hash(val)
        when String
          val.to_sym
        else
          val
        end
        res
      end
    when Hash
      obj.each_with_object({}) do |(key, val), res|
        nkey = case key
        when String
          key.to_sym
        else
          key
        end
        nval = case val
        when Hash, Array
          symbolize_hash(val)
        when String
          val.to_sym
        else
          val
        end
        res[nkey] = nval
        res
      end
    else
      obj
    end
  end
end
