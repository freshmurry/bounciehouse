if Rails.env.production? && ENV['PAPERCLIP_USE_S3'].present?
  Paperclip::Attachment.default_options.merge!(
    storage: :s3,
    s3_region: ENV['AWS_REGION'],
    s3_credentials: {
      bucket: ENV['S3_BUCKET_NAME'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    },
    s3_protocol: :https,
    url: ':s3_domain_url',
    path: '/:class/:attachment/:id_partition/:style/:filename',
    hash_secret: ENV['PAPERCLIP_HASH_SECRET'],
    s3_permissions: :public_read
  )
else
  Paperclip::Attachment.default_options.merge!(
    url: '/system/:rails_env/:class/:attachment/:id_partition/:style/:filename',
    path: ':rails_root/public:url'
  )
end
