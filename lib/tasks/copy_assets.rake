namespace :admin do
  desc "Copy assets to the public folder of the project"
  task :copy_assets => :environment do
    require 'fileutils'
    source_folder = File.expand_path(File.join(__FILE__, '/../../../public'))
    destination_folder = File.join(Rails.root, 'public')
    puts "Copying files from #{source_folder} to #{destination_folder}"
    Dir.glob(File.join(source_folder, "/*")).each do |item|
      FileUtils.cp_r(item, destination_folder)
    end
    puts "Finished."
  end
end
