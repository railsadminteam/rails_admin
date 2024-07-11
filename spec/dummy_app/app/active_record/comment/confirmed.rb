

class Comment
  class Confirmed < Comment
    default_scope { where(content: 'something') }
  end
end
