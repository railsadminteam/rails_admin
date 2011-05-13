require 'csv'
require 'fastercsv' if RUBY_VERSION =~ /^1\.8\./
Mime::Type.register 'text/csv', :csv
