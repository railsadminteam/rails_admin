# frozen_string_literal: true

require_relative "lib/rails_admin_next/version"

Gem::Specification.new do |spec|
  # If you add a dependency, please maintain alphabetical order
  spec.add_dependency "csv"
  spec.add_dependency "geared_pagination"
  spec.add_dependency "importmap-rails", "~> 2.0"
  spec.add_dependency "propshaft", ">= 1.2"
  spec.add_dependency "rails", "~> 8.1"
  spec.add_dependency "stimulus-rails", "~> 1.3"
  spec.add_dependency "turbo-rails", [">= 1.0", "< 3"]
  spec.add_development_dependency "bundler", ">= 1.0"
  spec.authors = ["Daniel López Prat"]
  spec.description = "A Rails engine that auto-generates an easy-to-use admin interface for your ActiveRecord data. A modernized fork of RailsAdmin, originally created by Erik Michaels-Ober, Bogdan Gaza, and contributors."
  spec.email = ["daniel@6temes.cat"]
  spec.files = Dir["Gemfile", "LICENSE.md", "README.md", "Rakefile", "app/**/*", "config/**/*", "docs/*.md", "lib/**/*", "public/**/*", "skills/**/*", "src/**/*", "vendor/**/*"]
  spec.licenses = %w[MIT]
  spec.homepage = "https://github.com/6temes/rails_admin_next"
  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/6temes/rails_admin_next/issues",
    "changelog_uri" => "https://github.com/6temes/rails_admin_next/releases",
    "hyperdrive_targets" => "rails_admin_next",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/6temes/rails_admin_next"
  }
  spec.name = "rails_admin_next"
  spec.require_paths = %w[lib]
  spec.required_ruby_version = ">= 4.0"
  spec.required_rubygems_version = ">= 1.8.11"
  spec.summary = "Admin for Rails"
  spec.version = RailsAdminNext::Version
end
