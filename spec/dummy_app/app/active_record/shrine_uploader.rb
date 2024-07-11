

class ShrineUploader < Shrine
  plugin :activerecord

  plugin :cached_attachment_data
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_attachment
end
