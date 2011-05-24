require File.expand_path('../../rails_admin/tasks/ckeditor', __FILE__)

namespace :rails_admin do
  desc "Download CKEditor to your public javascript folder"
  task :ckeditor_download do
    RailsAdmin::Tasks::CKEditor.new.invoke(:download)
  end
end
