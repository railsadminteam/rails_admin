

require 'rails_admin/adapters/mongoid'

Paperclip.logger = Logger.new(nil)

class Tableless
  include Mongoid::Document

  class << self
    def column(name, sql_type = 'string', default = nil, _null = true)
      # ignore length
      sql_type = sql_type.to_s.sub(/\(.*\)/, '').to_sym
      field(name, type: {integer: Integer, string: String, text: String, date: Date, datetime: DateTime}[sql_type], default: default)
    end
  end
end
