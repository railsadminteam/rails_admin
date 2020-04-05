class ShrineVersioningUploader < Shrine
  plugin :activerecord

  plugin :cached_attachment_data
  plugin :delete_raw
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :processing
  plugin :remove_attachment
  plugin :versions

  process(:store) do |io|
    {
      original: io,
      thumb: FakeIO.another_version(io, :thumb),
    }
  end
end
