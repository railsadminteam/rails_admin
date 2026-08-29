# frozen_string_literal: true

namespace :rails_admin do
  desc 'Compile the precompiled assets shipped with the gem (app/assets/builds)'
  task :build_assets do
    Dir.chdir(File.expand_path('../..', __dir__)) do
      abort 'npm is required to build RailsAdmin assets' unless system('npm --version', out: File::NULL)
      abort 'npm ci failed' unless system('npm ci --silent')
      abort 'Asset build failed' unless system('npm run build')
    end
  end

  desc 'Fail if the committed assets in app/assets/builds are out of date'
  task verify_assets: :build_assets do
    Dir.chdir(File.expand_path('../..', __dir__)) do
      diff = `git diff --stat -- app/assets/builds`
      unless diff.empty?
        warn "app/assets/builds is out of date. Run `npm run build` and commit the result:\n#{diff}"
        abort
      end
    end
  end
end
