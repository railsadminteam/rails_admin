# frozen_string_literal: true

require "spec_helper"
require "open3"
require "rbconfig"
require "tmpdir"

RSpec.describe "bin/stamp-version" do
  let(:root) { File.expand_path("../..", __dir__) }
  let(:script) { File.join(root, "bin/stamp-version") }
  let(:source) { File.read(File.join(root, "lib/rails_admin_next/version.rb")) }

  around do |example|
    Dir.mktmpdir do |dir|
      @target = File.join(dir, "version.rb")
      example.run
    end
  end

  def stamp(version)
    Open3.capture3(RbConfig.ruby, script, version, @target)
  end

  # Loaded in a child process: loading it here would redefine the real constants mid-suite.
  def stamped_version
    out, status = Open3.capture2(RbConfig.ruby, "-e", <<~RUBY, @target)
      load ARGV.fetch(0)
      print RailsAdminNext::Version.to_s, "|", RailsAdminNext::Version::PRE.inspect
    RUBY
    expect(status).to be_success
    out
  end

  it "stamps a three-part version over MAJOR, MINOR and PATCH, leaving PRE alone" do
    File.write(@target, source)

    _, _, status = stamp("3.1.4")

    expect(status).to be_success
    expect(stamped_version).to eq("3.1.4|nil")
  end

  it "fails when PRE is set, since the gem would not build as the tag's version" do
    File.write(@target, source.sub(/^(\s*PRE = ).*$/, '\1"beta"'))
    before = File.binread(@target)

    _, err, status = stamp("3.1.4")

    expect(status).not_to be_success
    expect(err).to include("does not load as")
    expect(File.binread(@target)).to eq(before)
  end

  ["3.1", "4.0.0.beta", "", "3.1.04"].each do |version|
    it "rejects #{version.inspect} and leaves the file unchanged" do
      File.write(@target, source)

      _, err, status = stamp(version)

      expect(status).not_to be_success
      expect(err).to include(version.inspect)
      expect(File.read(@target)).to eq(source)
    end
  end

  [
    ["commented out", "=begin\n    PATCH = 9\n=end"],
    ["real", "    PATCH = 9 # override"]
  ].each do |kind, second|
    it "fails on a #{kind} second PATCH assignment after the placeholder, leaving the file unchanged" do
      File.write(@target, source.sub(/^(\s*PATCH = \d+\n)/) { "#{$1}#{second}\n" })
      before = File.binread(@target)

      _, _, status = stamp("3.1.4")

      expect(status).not_to be_success
      expect(File.binread(@target)).to eq(before)
      expect(File.exist?("#{@target}.stamped")).to be(false)
    end
  end

  it "fails when a constant to stamp is missing, leaving the file unchanged" do
    File.write(@target, source.sub(/^\s*PATCH = \d+\n/, ""))
    before = File.read(@target)

    _, err, status = stamp("3.1.4")

    expect(status).not_to be_success
    expect(err).to include("PATCH")
    expect(File.read(@target)).to eq(before)
  end
end
