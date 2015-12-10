# encoding: UTF-8
require 'csv'

module RailsAdmin
  class CSVConverter
    class DbEncodingMap
      # The mapping from canonical encoding names in PostgreSQL to ones in Ruby.
      # Taken from here:
      #   https://bitbucket.org/ged/ruby-pg/src/master/ext/pg.c
      PG_ENCODINGS = {
        'BIG5'           => Encoding::Big5,
        'EUC_CN'         => Encoding::GB2312,
        'EUC_JP'         => Encoding::EUC_JP,
        'EUC_JIS_2004'   => Encoding::EUC_JP,
        'EUC_KR'         => Encoding::EUC_KR,
        'EUC_TW'         => Encoding::EUC_TW,
        'GB18030'        => Encoding::GB18030,
        'GBK'            => Encoding::GBK,
        'ISO_8859_5'     => Encoding::ISO_8859_5,
        'ISO_8859_6'     => Encoding::ISO_8859_6,
        'ISO_8859_7'     => Encoding::ISO_8859_7,
        'ISO_8859_8'     => Encoding::ISO_8859_8,
        'KOI8'           => Encoding::KOI8_R,
        'KOI8R'          => Encoding::KOI8_R,
        'KOI8U'          => Encoding::KOI8_U,
        'LATIN1'         => Encoding::ISO_8859_1,
        'LATIN2'         => Encoding::ISO_8859_2,
        'LATIN3'         => Encoding::ISO_8859_3,
        'LATIN4'         => Encoding::ISO_8859_4,
        'LATIN5'         => Encoding::ISO_8859_9,
        'LATIN6'         => Encoding::ISO_8859_10,
        'LATIN7'         => Encoding::ISO_8859_13,
        'LATIN8'         => Encoding::ISO_8859_14,
        'LATIN9'         => Encoding::ISO_8859_15,
        'LATIN10'        => Encoding::ISO_8859_16,
        'MULE_INTERNAL'  => Encoding::Emacs_Mule,
        'SJIS'           => Encoding::Windows_31J,
        'SHIFT_JIS_2004' => Encoding::Windows_31J,
        'SQL_ASCII'      => nil,
        'UHC'            => Encoding::CP949,
        'UTF8'           => Encoding::UTF_8,
        'WIN866'         => Encoding::IBM866,
        'WIN874'         => Encoding::Windows_874,
        'WIN1250'        => Encoding::Windows_1250,
        'WIN1251'        => Encoding::Windows_1251,
        'WIN1252'        => Encoding::Windows_1252,
        'WIN1253'        => Encoding::Windows_1253,
        'WIN1254'        => Encoding::Windows_1254,
        'WIN1255'        => Encoding::Windows_1255,
        'WIN1256'        => Encoding::Windows_1256,
        'WIN1257'        => Encoding::Windows_1257,
        'WIN1258'        => Encoding::Windows_1258,
      }

      # The mapping from canonical encoding names in MySQL to ones in Ruby.
      # Taken from here:
      #   https://github.com/tmtm/ruby-mysql/blob/master/lib/mysql/charset.rb
      # Author: TOMITA Masahiro <tommy@tmtm.org>
      MYSQL_ENCODINGS = {
        'armscii8' => nil,
        'ascii'    => Encoding::US_ASCII,
        'big5'     => Encoding::Big5,
        'binary'   => Encoding::ASCII_8BIT,
        'cp1250'   => Encoding::Windows_1250,
        'cp1251'   => Encoding::Windows_1251,
        'cp1256'   => Encoding::Windows_1256,
        'cp1257'   => Encoding::Windows_1257,
        'cp850'    => Encoding::CP850,
        'cp852'    => Encoding::CP852,
        'cp866'    => Encoding::IBM866,
        'cp932'    => Encoding::Windows_31J,
        'dec8'     => nil,
        'eucjpms'  => Encoding::EucJP_ms,
        'euckr'    => Encoding::EUC_KR,
        'gb2312'   => Encoding::EUC_CN,
        'gbk'      => Encoding::GBK,
        'geostd8'  => nil,
        'greek'    => Encoding::ISO_8859_7,
        'hebrew'   => Encoding::ISO_8859_8,
        'hp8'      => nil,
        'keybcs2'  => nil,
        'koi8r'    => Encoding::KOI8_R,
        'koi8u'    => Encoding::KOI8_U,
        'latin1'   => Encoding::ISO_8859_1,
        'latin2'   => Encoding::ISO_8859_2,
        'latin5'   => Encoding::ISO_8859_9,
        'latin7'   => Encoding::ISO_8859_13,
        'macce'    => Encoding::MacCentEuro,
        'macroman' => Encoding::MacRoman,
        'sjis'     => Encoding::SHIFT_JIS,
        'swe7'     => nil,
        'tis620'   => Encoding::TIS_620,
        'ucs2'     => Encoding::UTF_16BE,
        'ujis'     => Encoding::EucJP_ms,
        'utf8'     => Encoding::UTF_8,
        'utf8mb4'  => Encoding::UTF_8,
      }

      def self.encodings
        @_encodings ||= PG_ENCODINGS.merge MYSQL_ENCODINGS
      end
    end

    def initialize(objects = [], schema = {})
      return self if (@objects = objects).blank?

      @model = objects.dup.first.class
      @abstract_model = RailsAdmin::AbstractModel.new(@model)
      @model_config = @abstract_model.config
      @methods = [(schema[:only] || []) + (schema[:methods] || [])].flatten.compact
      @fields = @methods.collect { |m| export_fields_for(m).first }
      @empty = ::I18n.t('admin.export.empty_value_for_associated_objects')
      schema_include = schema.delete(:include) || {}

      @associations = schema_include.each_with_object({}) do |(key, values), hash|
        association = association_for(key)
        model_config = association.associated_model_config
        abstract_model = model_config.abstract_model
        methods = [(values[:only] || []) + (values[:methods] || [])].flatten.compact

        hash[key] = {
          association: association,
          model: abstract_model.model,
          abstract_model: abstract_model,
          model_config: model_config,
          fields: methods.collect { |m| export_fields_for(m, model_config).first },
        }
        hash
      end
    end

    def to_csv(options = {})
      # encoding shenanigans first
      encoding_from = DbEncodingMap.encodings[@abstract_model.encoding] || Encoding::UTF_8
      encoding_to =
        if options[:encoding_to].present?
          Encoding.find(options[:encoding_to])
        else
          encoding_from
        end

      csv_string = generate_csv_string(options)

      if encoding_to != encoding_from
        csv_string = csv_string.encode(encoding_to, encoding_from, invalid: :replace, undef: :replace, replace: '?')
      end
      # Add a BOM for utf8 encodings, helps with utf8 auto-detect for some versions of Excel.
      # Don't add if utf8 but user don't want to touch input encoding:
      # If user chooses utf8, they will open it in utf8 and BOM will disappear at reading.
      # But that way "English" users who don't bother and chooses to let utf8 by default won't get BOM added
      # and will not see it if Excel opens the file with a different encoding.
      if options[:encoding_to].present? && encoding_to == Encoding::UTF_8
        csv_string = "\xEF\xBB\xBF#{csv_string}"
      end
      [!options[:skip_header], encoding_to.to_s, csv_string]
    end

  private

    def association_for(key)
      export_fields_for(key).detect(&:association?)
    end

    def export_fields_for(method, model_config = @model_config)
      model_config.export.fields.select { |f| f.name == method }
    end

    def generate_csv_string(options)
      generator_options = (options[:generator] || {}).symbolize_keys.delete_if { |_, value| value.blank? }
      method = @objects.respond_to?(:find_each) ? :find_each : :each

      CSV.generate(generator_options) do |csv|
        csv << generate_csv_header unless options[:skip_header]

        @objects.send(method) do |object|
          csv << generate_csv_row(object)
        end
      end
    end

    def generate_csv_header
      @fields.collect do |field|
        ::I18n.t('admin.export.csv.header_for_root_methods', name: field.label, model: @abstract_model.pretty_name)
      end +
        @associations.flat_map do |_association_name, option_hash|
          option_hash[:fields].collect do |field|
            ::I18n.t('admin.export.csv.header_for_association_methods', name: field.label, association: option_hash[:association].label)
          end
        end
    end

    def generate_csv_row(object)
      @fields.collect do |field|
        field.with(object: object).export_value
      end +
        @associations.flat_map do |association_name, option_hash|
          associated_objects = [object.send(association_name)].flatten.compact
          option_hash[:fields].collect do |field|
            associated_objects.collect { |ao| field.with(object: ao).export_value.presence || @empty }.join(',')
          end
        end
    end
  end
end
