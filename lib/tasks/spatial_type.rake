namespace :rails_admin do

  @tmp_file = Tempfile.new('all.rb.tmp')
  @all_file = File.open(
      File.join(File.dirname(__FILE__),'..','..','lib','rails_admin','config','fields','types','all.rb'),'r')

  desc 'Add spatial field type for use with PostGIS'
  task :spatial_enable => :environment do
    if ActiveRecord::Base.connection.adapter_name == 'PostGIS'
      loop_through
      @tmp_file.write("require 'rails_admin/config/fields/types/spatial'\n")
      File.rename(@tmp_file, @all_file)
      puts 'Spatial field enabled.'
    else
      puts "Spatial field not enabled; expected 'PostGIS' adapter, but instead found '#{ActiveRecord::Base.connection.adapter_name}'."
    end
  end

  desc 'Remove spatial field type'
  task :spatial_disable => :environment do
    loop_through
    File.rename(@tmp_file, @all_file)
    puts 'Spatial field disabled.'
  end

  def loop_through
    while line = @all_file.gets
      unless line =~ /'rails_admin\/config\/fields\/types\/spatial'/
        @tmp_file.write(line)
      end
    end
  end

end
