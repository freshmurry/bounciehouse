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
    column("Reservation Date", :created_at)
    actions
  end

  filter :bouncehouse_id
  filter :guest, collection: proc { User.all.map { |u| [u.fullname, u.id] } }
  filter :host, collection: proc { User.all.map { |u| [u.fullname, u.id] } }
  filter :star
  filter :created_at

  form do |f|
    f.inputs do
      f.input :comment
      f.input :star
      f.input :bouncehouse_id, label: "Bouncehouse ID"
      f.input :guest, label: "Guest", collection: User.all.map { |u| [u.fullname, u.id] }
      f.input :host, label: "Host", collection: User.all.map { |u| [u.fullname, u.id] }
      f.input :created_at, as: :datepicker, label: "Reservation Date"
    end
    f.actions
  end

  show do
    attributes_table do
      row :comment
      row :star
      row("Bouncehouse ID") { |review| review.bouncehouse_id }
      row("Guest") { |review| review.guest&.fullname }
      row("Host") { |review| review.host&.fullname }
      row("Reservation Date") { |review| review.created_at }
      row :updated_at
    end
  end
end
