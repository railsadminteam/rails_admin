module RailsAdmin
  module ApplicationHelper
    def history_output(t)
      if not t.message.downcase.rindex("changed").nil?
        return t.message.downcase + " for #{t.table.capitalize} ##{t.item}"
      else
        return t.message.downcase
      end
    end
  end
end
