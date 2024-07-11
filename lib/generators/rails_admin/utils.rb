

module RailsAdmin
  module Generators
    module Utils
      module InstanceMethods
        def display(output, color = :green)
          say("           -  #{output}", color)
        end

        def ask_for(wording, default_value = nil, override_if_present_value = nil)
          if override_if_present_value.present?
            display("Using [#{override_if_present_value}] for question '#{wording}'") && override_if_present_value
          else
            ask("           ?  #{wording} Press <enter> for [#{default_value}] >", :yellow).presence || default_value
          end
        end
      end
    end
  end
end
