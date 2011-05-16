
module RailsAdmin
  module Tasks
    module AssetsCopier

      TYPES = %w( stylesheets images javascripts )
      def copy_assets_files
        puts
        TYPES.each do |directory|
          Dir[File.join(origin, directory, 'rails_admin', '**/*')].each do |file|
            relative  = file.gsub(/^#{origin}\//, '')
            dest_file = File.join(destination, relative)
            dest_dir  = File.dirname(dest_file)

            if !File.exist?(dest_dir)
              FileUtils.mkdir_p(dest_dir)
            end

            copy_file(file, dest_file) unless File.directory?(file)
          end
        end
      end

      private

      def gem_path; File.expand_path('../../..', File.dirname(__FILE__)) end
      def origin; File.join(gem_path, 'public') end
      def destination; Rails.root.join('public') end

    end
  end
end

