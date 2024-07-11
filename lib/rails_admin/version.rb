

module RailsAdmin
  class Version
    MAJOR = 3
    MINOR = 1
    PATCH = 2
    PRE = nil

    class << self
      # @return [String]
      def to_s
        [MAJOR, MINOR, PATCH, PRE].compact.join('.')
      end

      def js
        JSON.parse(File.read("#{__dir__}/../../package.json"))['version']
      end

      def actual_js_version
        case RailsAdmin.config.asset_source
        when :webpacker, :webpack
          js_version_from_node_modules
        else
          js
        end
      end

      def warn_with_js_version
        return unless Rails.env.development? || Rails.env.test?

        case actual_js_version
        when js
          # Good
        when nil
          warn "[Warning] Failed to detect RailsAdmin npm package, did you run 'yarn install'?"
        else
          warn <<~MSG
            [Warning] RailsAdmin npm package version inconsistency detected, expected #{js} but actually used is #{actual_js_version}.
            This may cause partial or total malfunction of RailsAdmin frontend features.
          MSG
        end
      end

    private

      def js_version_from_node_modules
        JSON.parse(File.read(Rails.root.join('node_modules/rails_admin/package.json')))['version']
      rescue StandardError
        nil
      end
    end
  end
end
