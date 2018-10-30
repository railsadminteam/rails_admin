class ShrineVersioningUploader < Shrine
  plugin :mongoid
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
      thumb: FakeIO.another_version(io, :thumb),
    }
  end
end
