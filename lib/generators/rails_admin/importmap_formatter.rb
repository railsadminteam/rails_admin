

require 'importmap/packager'

module RailsAdmin
  class ImportmapFormatter
    attr_reader :packager

    def initialize(path = 'config/importmap.rails_admin.rb')
      @packager = Importmap::Packager.new(path)
    end

    def format
      imports = packager.import("rails_admin@#{RailsAdmin::Version.js}", from: 'jspm.io')

      # Use ESM compatible version to work around https://github.com/cljsjs/packages/issues/1579
      imports['@popperjs/core'].gsub!('lib/index.js', 'dist/esm/popper.js')

      # Tidy up jQuery UI dependencies
      jquery_uis = imports.keys.filter { |key, _| key =~ /jquery-ui/ }
      imports['jquery-ui/'] = imports[jquery_uis.first].gsub(%r{(@[^/@]+)/[^@]+$}, '\1/')
      imports.reject! { |key, _| jquery_uis.include? key }

      pins = ['pin "rails_admin", preload: true', packager.pin_for('rails_admin/src/rails_admin/base', imports.delete('rails_admin'))]
      (pins + imports.map { |package, url| packager.pin_for(package, url) }).join("\n")
    end
  end
end
