class Comment::Confirmed < Comment
  default_scope where(:content => 'something')
end
