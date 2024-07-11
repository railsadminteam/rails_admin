

require 'forwardable'
require 'stringio'

class FakeIO
  attr_reader :original_filename, :content_type

  def initialize(content, filename: nil, content_type: nil)
    @io = StringIO.new(content)
    @original_filename = filename
    @content_type = content_type
  end

  extend Forwardable
  delegate %i[read rewind eof? close size] => :@io
end
