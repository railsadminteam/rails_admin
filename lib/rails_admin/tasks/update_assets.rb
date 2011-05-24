require File.expand_path('base', File.dirname(__FILE__))

module RailsAdmin
  module Tasks
    class UpdateAssets < Base

      def copy_assets_files
        unless yes? 'This will completely overwite your public rails_admin folders. Type "y" or "yes" if you want to proceed: ', :yellow
          say 'Aborting', :green
        else
          TYPES.each {|directory| remove_dir File.join(destination, directory, 'rails_admin'), :verbose => false }
          super({:verbose => false})
          say 'RailsAdmin assets updated.', :green
        end
      end
    end
  end
end
