namespace :migrate_paperclip do
  desc "Migrate Paperclip images to Active Storage for Photo"
  task photos: :environment do
    Photo.find_each do |photo|
      if photo.respond_to?(:image) && photo.image_file_name.present? && photo.image&.respond_to?(:path) && File.exist?(photo.image.path)
        photo.images.attach(
          io: File.open(photo.image.path),
          filename: photo.image_file_name,
          content_type: photo.image_content_type
        )
        puts "Migrated image for Photo ##{photo.id}"
      end
    end
  end
end