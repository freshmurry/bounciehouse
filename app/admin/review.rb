ActiveAdmin.register Review do
  permit_params :comment, :star, :bouncehouse_id, :guest_id, :host_id, :created_at

  index do
    selectable_column
    id_column
    column :comment
    column :star
    column("Bouncehouse ID") { |review| review.bouncehouse_id }
    column("Guest") { |review| review.guest&.fullname }
    column("Host") { |review| review.host&.fullname }
    column :created_at
    actions
  end

  filter :bouncehouse_id
  filter :guest, collection: proc { User.all.map { |u| [u.fullname, u.id] } }
  filter :host, collection: proc { User.all.map { |u| [u.fullname, u.id] } }
  filter :star
  filter :created_at

  form do |f|
    f.inputs do
      f.input :bouncehouse, as: :select, collection: Bouncehouse.all.map { |b| [b.listing_name, b.id] }, prompt: "Select Bouncehouse"
      f.input :guest, as: :select, collection: User.all.map { |u| [u.fullname, u.id] }, prompt: "Select Guest"
      f.input :host, as: :select, collection: User.all.map { |u| [u.fullname, u.id] }, prompt: "Select Host"
      f.input :star, as: :select, collection: 1..5, prompt: "Select Star Rating"
      f.input :comment
      f.input :created_at, as: :datepicker, label: "Review Date"
    end
    f.actions
  end

  show do
    attributes_table do
      row :bouncehouse
      row("Guest") { |review| review.guest.fullname if review.guest }
      row("Host") { |review| review.host.fullname if review.host }
      row :star
      row :comment
      row :created_at
    end
    active_admin_comments
  end
end
