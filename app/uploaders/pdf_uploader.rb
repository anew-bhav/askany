class PdfUploader < Shrine
  Attacher.validate do
    validate_mime_type %w[application/pdf]
    validate_extension %w[pdf]
  end
end