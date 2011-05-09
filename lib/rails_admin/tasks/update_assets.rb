require 'rails/generators'

module RailsAdmin
  module Tasks
    class UpdateAssets
      class << self

        def run
          origin = File.join(gem_path, 'public')
          destination = Rails.root.join('public')

          puts
          %w( stylesheets images javascripts ).each do |directory|
            FileUtils.remove_dir File.join(destination, directory, 'rails_admin'), true
            Dir[File.join(origin, directory, 'rails_admin', '**/*')].each do |file|
              relative  = file.gsub(/^#{origin}\//, '')
              dest_file = File.join(destination, relative)
              dest_dir  = File.dirname(dest_file)

              if !File.exist?(dest_dir)
                FileUtils.mkdir_p(dest_dir)
              end

              FileUtils.copy(file, dest_file) unless File.directory?(file)
            end
          end
          puts "RailsAdmin assets updated."
        end

        private

        def gem_path
          File.expand_path('../../..', File.dirname(__FILE__))
        end

      end
    end
  end
end
