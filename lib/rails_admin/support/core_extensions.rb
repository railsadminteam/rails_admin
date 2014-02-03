class Hash
  def symbolize
    Hash.symbolize_hash(self)
  end

  def self.symbolize_hash(obj)
    case obj
    when Array
      obj.inject([])do|res, val|
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
      obj.inject({})do|res, (key, val)|
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
