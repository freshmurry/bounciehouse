ActiveAdmin.register Bouncehouse do
  # Permit params for Bouncehouse and nested Photos
  permit_params :user_id, :bouncehouse_type, :time_limit, :pickup_type, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy]

  # Form for creating/updating Bouncehouse
  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.collect { |user| [user.email, user.id] }
      f.input :bouncehouse_type
      f.input :time_limit
      f.input :pickup_type
      f.input :listing_name
      f.input :description
      f.input :address
      f.input :price, as: :number
      f.input :active, as: :boolean
      
      f.inputs "Images" do
        f.has_many :photos, allow_destroy: true, new_record: true do |pf|
          pf.input :image, as: :file
        end
      end

      f.inputs "Amenities" do
        f.input :is_heated, label: "Heated"
        f.input :is_slide, label: "Slide"
        f.input :is_waterslide, label: "Water Slide"
        f.input :is_basketball_hoop, label: "Basketball Hoop"
        f.input :is_lighting, label: "Lighting"
        f.input :is_sprinkler, label: "Sprinkler"
        f.input :is_speakers, label: "Speakers"
        f.input :is_wall_climb, label: "Wall Climb"
      end
    end
    f.actions
  end

  # Show view for Bouncehouse
  show do
    attributes_table do
      row :user
      row :bouncehouse_type
      row :time_limit
      row :pickup_type
      row :listing_name
      row :description
      row :address
      row :price
      row :active

      row "Images" do |bouncehouse|
        if bouncehouse.photos.any?
          bouncehouse.photos.each do |photo|
            div do
              image_tag photo.image.url(:thumb), size: "200x200" if photo.image.present?
            end
          end
        else
          div "No images available."
        end
      end

      row :is_heated
      row :is_slide
      row :is_waterslide
      row :is_basketball_hoop
      row :is_lighting
      row :is_sprinkler
      row :is_speakers
      row :is_wall_climb
    end
    active_admin_comments
  end
end
