require "shrine"

if Rails.env.production? || Rails.env.staging?
  require 'shrine/storage/s3'

  s3_options = {
    bucket: ENV.fetch('AWS_S3_BUCKET'),
    region: ENV.fetch('AWS_S3_REGION'),
    access_key_id: ENV.fetch('AWS_S3_ACCESS_KEY_ID'),
    secret_access_key: ENV.fetch('AWS_S3_SECRET_KEY')
  }

  Shrine.storages = {
    cache: Shrine::Storage::S3.new(prefix: 'uploads/cache', upload_options: { acl: 'private'}, **s3_options),
    store: Shrine::Storage::S3.new(prefix: 'uploads/store', upload_options: { acl: 'private'}, **s3_options)
  }

elsif Rails.env.test?

  require "shrine/storage/memory"

  Shrine.storages = {
    cache: Shrine::Storage::Memory.new, # temporary
    store: Shrine::Storage::Memory.new, # permanent
  }

else

  require "shrine/storage/file_system"

  Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
  }

end

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
Shrine.plugin :validation_helpers
Shrine.plugin :determine_mime_type, analyser: :marcel