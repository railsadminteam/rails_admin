namespace :rails_admin do
  desc "Download CKEditor to your public javascript folder"
  task :ckeditor_download do
    require 'fileutils'
    require 'tempfile'
    ckeditor_url = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5.3/ckeditor_3.5.3.tar.gz"
    ckeditor_file = Tempfile.new('ckeditor').path
    destination_folder = Rails.root.join('public', 'javascripts')

    if File.exists? File.join(destination_folder, 'ckeditor', 'LICENSE.html')
      puts "CKEditor is already installed."
      exit 0
    end
    FileUtils.mkdir_p(destination_folder) unless File.directory? destination_folder

    puts "Downloading CKEditor (you need to have either wget or curl installed)"
    `curl #{ckeditor_url} -o '#{ckeditor_file}' || wget #{ckeditor_url} -O #{ckeditor_file}`
    puts "Deflating to your public javascript folder"
    Dir.chdir(destination_folder) { `tar xvfz #{ckeditor_file}` }
    puts "Finished."
  end
end
