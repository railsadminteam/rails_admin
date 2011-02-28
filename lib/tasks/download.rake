namespace :admin do
  desc "Download CKEditor to your public javascript folder"
  task :ckeditor_download do
    require 'fileutils'
    ckeditor_url = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%203.5/ckeditor_3.5.tar.gz"
    ckeditor_file = "/tmp/ckeditor_3.5.tar.gz"
    destination_folder = File.join(FileUtils.pwd, 'public', 'javascripts')

    raise "CKEditor is already installed in your public." if File.exists? File.join(destination_folder, 'ckeditor', 'LICENSE.html')
    raise "Missing public/javascripts folder. Create it." unless File.exists?(destination_folder)

    puts "Downloading CKEditor (you need to have either wget or curl installed)"
    `curl #{ckeditor_url} -o '#{ckeditor_file}' || wget #{ckeditor_url} -O #{ckeditor_file}`
    puts "Deflating to your public javascript folder"
    `cd "#{destination_folder}" && tar xvfz #{ckeditor_file}`
    puts "Finished."
  end
end
