ActiveAdmin.register Bouncehouse do
  # Define permitted parameters for the form
  permit_params :user_id, :bouncehouse_type, :time_limit, :pickup_type, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy]

  form do |f|
    f.inputs 'Bouncehouse Details' do
      f.input :user, as: :select, collection: User.all.collect { |user| [user.email, user.id] }
      f.input :bouncehouse_type, as: :select, collection: ["Regular", "Castle", "Waterslide"], include_blank: false
      f.input :time_limit, as: :select, collection: ["4 hrs.", "6 hrs.", "8 hrs."], include_blank: false
      f.input :pickup_type, as: :select, collection: ["Next Day", "Same Day"], include_blank: false
      f.input :listing_name
      f.input :description
      f.input :address
      f.input :price, as: :number
      f.input :active, as: :boolean
    end

    f.inputs 'Upload New Photos' do
      f.input :new_photos, as: :file, input_html: { multiple: true }
    end

    f.inputs 'Photos' do
      f.object.photos.each do |photo|
        f.input :photos, as: :file, hint: photo.image.present? ? image_tag(photo.image.url(:thumb)) : "No Photos Yet"
        f.input :_destroy, as: :boolean, label: 'Remove image' if f.object.persisted?
      end
    end

    f.inputs 'Amenities' do
      f.input :is_heated, label: "Heated"
      f.input :is_slide, label: "Slide"
      f.input :is_waterslide, label: "Water Slide"
      f.input :is_basketball_hoop, label: "Basketball Hoop"
      f.input :is_lighting, label: "Lighting"
      f.input :is_sprinkler, label: "Sprinkler"
      f.input :is_speakers, label: "Speakers"
      f.input :is_wall_climb, label: "Wall Climb"
    end

    f.actions
  end

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

      row "Photos" do |bouncehouse|
        if bouncehouse.photos.any?
          bouncehouse.photos.each do |photo|
            div do
              image_tag(photo.image.url(:thumb)) if photo.image.present?
            end
          end
        else
          "No photos available"
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

  controller do
    before_action :find_bouncehouse, only: [:show, :edit, :update, :destroy]

    def create
      @bouncehouse = Bouncehouse.new(bouncehouse_params)

      if @bouncehouse.save
        handle_new_photos
        redirect_to admin_bouncehouse_path(@bouncehouse), notice: 'Bouncehouse successfully created.'
      else
        render :new
      end
    end

    def update
      if @bouncehouse.update(bouncehouse_params)
        handle_new_photos
        redirect_to admin_bouncehouse_path(@bouncehouse), notice: 'Bouncehouse successfully updated.'
      else
        render :edit
      end
    end

    private

    def find_bouncehouse
      @bouncehouse = Bouncehouse.find(params[:id])
    end

    def bouncehouse_params
      params.require(:bouncehouse).permit(:user_id, :bouncehouse_type, :time_limit, :pickup_type, :listing_name, :description, :address, :price, :is_heated, :is_slide, :is_waterslide, :is_basketball_hoop, :is_lighting, :is_sprinkler, :is_speakers, :is_wall_climb, :active, photos_attributes: [:id, :image, :_destroy])
    end

    def handle_new_photos
      if params[:bouncehouse][:new_photos].present?
        params[:bouncehouse][:new_photos].each do |photo|
          @bouncehouse.photos.create(image: photo)
        end
      end
    end
  end
end
