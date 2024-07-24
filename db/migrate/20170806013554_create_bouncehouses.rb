class CreateBouncehouses < ActiveRecord::Migration[5.0]
  def change
    create_table :bouncehouses do |t|
      t.string :bouncehouse_type
      t.string :address
      t.string :listing_name
      t.text :description
      t.string :time_limit
      t.integer :price
      t.integer :tip
      t.string :pickup_type
      t.boolean :is_heated
      t.boolean :is_slide
      t.boolean :is_waterslide
      t.boolean :is_basketball_hoop
      t.boolean :is_lighting
      t.boolean :is_speakers
      t.boolean :is_wall_climb
      t.boolean :is_sprinkler
      t.boolean :active
      t.float :latitude
      t.float :longitude
      t.integer :instant, deafault: 1
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end