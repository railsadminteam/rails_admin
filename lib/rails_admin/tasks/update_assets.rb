require File.expand_path('assets_copier', File.dirname(__FILE__))

module RailsAdmin
  module Tasks
    class UpdateAssets
      include AssetsCopier

      def copy_file(original, destination)
        FileUtils.copy(original, destination)
      end

      def run
        puts 'This will completely overwite your public rails_admin folders. Type "yes" if you want to proceed: '
        if $stdin.gets.chomp == 'yes'
          TYPES.each {|directory| FileUtils.remove_dir File.join(destination, directory, 'rails_admin'), true }
          copy_assets_files
          puts "RailsAdmin assets updated."
        else
          puts "Aborting"
        end
      end
    end
  end
end
