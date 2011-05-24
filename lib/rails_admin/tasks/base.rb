require 'rails/generators'

module RailsAdmin
  module Tasks
    class Base < Thor::Group
      include Thor::Actions
      def self.source_root; File.expand_path('../../../..', __FILE__) end

      protected
      TYPES = %w( stylesheets images javascripts )

      def copy_assets_files(args = {:verbose => true})
        TYPES.each do |directory|
          Dir[File.join(origin, directory, 'rails_admin', '**/*')].each do |file|
            relative  = file.gsub(/^#{origin}\//, '')
            dest_file = File.join(destination, relative)
            dest_dir  = File.dirname(dest_file)

            if !File.exist?(dest_dir)
              FileUtils.mkdir_p(dest_dir)
            end

            copy_file(file, dest_file, args) unless File.directory?(file)
          end
        end
      end

      def origin; File.join(self.class.source_root, 'public') end
      def destination; Rails.root.join('public') end
    end
  end
end

