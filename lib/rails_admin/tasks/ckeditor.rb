require File.expand_path('base', File.dirname(__FILE__))
require 'fileutils'
require 'tempfile'

module RailsAdmin
  module Tasks
    class CKEditor < Base
      def download
        ckeditor_url = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5.3/ckeditor_3.5.3.tar.gz"
        ckeditor_file = Tempfile.new('ckeditor').path
        destination_folder = Rails.root.join('public', 'javascripts')

        if File.exists? File.join(destination_folder, 'ckeditor', 'LICENSE.html')
          say "CKEditor is already installed.", :green
          exit 0
        end
        FileUtils.mkdir_p(destination_folder) unless File.directory? destination_folder

        say "Downloading CKEditor (you need to have either wget or curl installed)", :green
        `curl #{ckeditor_url} -o '#{ckeditor_file}' || wget #{ckeditor_url} -O #{ckeditor_file}`
        say "Deflating to your public javascript folder", :green
        Dir.chdir(destination_folder) { `tar xvfz #{ckeditor_file}` }
        say "Finished.", :green
      end
    end
  end
end
