#!/usr/bin/env sh
cd spec/dummy_app && bundle install --without development && bundle exec rake rails_admin:prepare_ci_env db:create db:migrate && cd ../.. && bundle exec rake spec
