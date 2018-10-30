class ShrineUploader < Shrine
  plugin :mongoid
  plugin :cached_attachment_data
  plugin :determine_mime_type
  plugin :remove_attachment
  plugin :pretty_location
end
