namespace :migrate_paperclip do
  desc "Migrate Paperclip images to Active Storage for Photo"
  task photos: :environment do
    Photo.find_each do |photo|
      if photo.respond_to?(:image) && photo.image_file_name.present?
        begin
          file_io =
            if photo.image.path && File.exist?(photo.image.path)
              File.open(photo.image.path)
            else
              # Download from S3 if not on disk
              open(photo.image.expiring_url(3600))
            end

          photo.images.attach(
            io: file_io,
            filename: photo.image_file_name,
            content_type: photo.image_content_type
          )
          puts "Migrated image for Photo ##{photo.id}"
        rescue => e
          puts "Failed to migrate Photo ##{photo.id}: #{e.message}"
        end
      end
    end
  end
end