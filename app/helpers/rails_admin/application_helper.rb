module RailsAdmin
  module ApplicationHelper
    def history_output(t)
      if not t.message.downcase.rindex("changed").nil?
        return t.message.downcase + " for #{t.table.capitalize} ##{t.item}"
      else
        return t.message.downcase
      end
    end

    def sort_arrow_image(up = true)
      image_name = up ? "bullet_arrow_up.png" : "bullet_arrow_down.png"
      image_tag("rails_admin/" + image_name)
    end
  end
end
