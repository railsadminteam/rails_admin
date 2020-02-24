class ShrineVersioningUploader < Shrine
  plugin :activerecord

  plugin :cached_attachment_data
  plugin :determine_mime_type
  plugin :pretty_location
  plugin :remove_attachment
  plugin :derivatives

  Attacher.derivatives_processor do |original|
    {
      thumb: FakeIO.new('', filename: File.basename(original.path), content_type: File.extname(original.path)),
    }
  end
end
