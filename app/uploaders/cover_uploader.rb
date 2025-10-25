class CoverUploader < Shrine
  plugin :validation_helpers
  Attacher.validate do
    validate_max_size 5.megabytes
    validate_mime_type %w[image/jpeg image/png image/gif]
  end

  end

