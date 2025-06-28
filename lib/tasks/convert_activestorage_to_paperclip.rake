require 'open-uri'

namespace :migrate do
  desc "Convert Active Storage S3 images to Paperclip (User model)"
  task convert_user_images: :environment do
    attachment_records = ActiveStorage::Attachment.where(record_type: "User", name: "image")

    puts "Found #{attachment_records.count} Active Storage attachments for User..."

    attachment_records.find_each do |attachment|
      user = User.find_by(id: attachment.record_id)
      next unless user.present?

      begin
        blob = attachment.blob
        service_url = blob.service_url # Temporarily signed S3 URL

        puts "Downloading image for User ##{user.id} from #{service_url}"

        file = URI.open(service_url)
        file.class.class_eval { attr_accessor :original_filename, :content_type }
        file.original_filename = blob.filename.to_s
        file.content_type = blob.content_type

        user.image = file # Paperclip assignment
        user.save!
        puts "✅ User ##{user.id} updated with Paperclip image."

      rescue => e
        puts "⚠️ Failed for User ##{user&.id}: #{e.message}"
      end
    end
  end
end
