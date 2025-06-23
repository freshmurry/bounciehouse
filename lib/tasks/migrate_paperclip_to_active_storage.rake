namespace :migrate_paperclip do
  desc "Migrate Paperclip images to Active Storage for Photo"
  task photos: :environment do
    require 'open-uri'
    Photo.find_each do |photo|
      puts "Photo ##{photo.id} - Paperclip: #{photo.image_file_name.inspect} - Already attached? #{photo.images.attached?}"
      next if photo.images.attached?

      if photo.respond_to?(:image) && photo.image.present? && photo.image_file_name.present?
        begin
          file_io =
            if photo.image.respond_to?(:path) && photo.image.path && File.exist?(photo.image.path)
              File.open(photo.image.path)
            elsif photo.image.respond_to?(:expiring_url)
              URI.open(photo.image.expiring_url(3600))
            else
              raise "No image file found for Photo ##{photo.id}"
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