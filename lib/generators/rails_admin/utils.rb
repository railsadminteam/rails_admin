module RailsAdmin
  module Generators
    module Utils
      module InstanceMethods
        def display(output, color = :green)
          say("           -  #{output}", color)
        end

        def ask_for(wording, default_value = nil, override_if_present_value = nil)
          override_if_present_value.present? ?
            display("Using [#{override_if_present_value}] for question '#{wording}'") && override_if_present_value :
            ask("           ?  #{wording} Press <enter> for [#{default_value}] >", :yellow).presence || default_value
        end
      end

      module ClassMethods
        def next_migration_number(dirname)
          if ActiveRecord::Base.timestamped_migrations
            migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
            migration_number += 1
            migration_number.to_s
          else
            "%.3d" % (current_migration_number(dirname) + 1)
          end
        end
      end
    end
  end
end

