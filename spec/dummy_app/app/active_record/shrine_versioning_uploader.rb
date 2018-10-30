class ShrineVersioningUploader < Shrine
  plugin :activerecord
  plugin :cached_attachment_data
  plugin :delete_raw
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :versions
  plugin :pretty_location
  plugin :processing

  process(:store) do |io|
    {
      original: io,
      thumb: FakeIO.new("thumb-#{io.read}", )
    }
  end
end
