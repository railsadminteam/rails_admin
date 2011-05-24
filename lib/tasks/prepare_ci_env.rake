require File.expand_path('../../rails_admin/tasks/ci', __FILE__)

namespace :rails_admin do
  desc "Prepare Continuous Integration environment"
  task :prepare_ci_env do
    RailsAdmin::Tasks::CI.new.invoke(:prepare_env)
  end
end
