ActiveAdmin.register Review do
  permit_params :comment, :star, :bouncehouse_id, :reservation_id, :guest_id, :host_id, :type

  index do
    selectable_column
    id_column
    column :comment
    column :star
    column :bouncehouse
    column :reservation
    column :guest
    column :host
    column :type
    column :created_at
    actions
  end

  filter :bouncehouse
  filter :reservation
  filter :guest
  filter :host
  filter :star
  filter :created_at

  form do |f|
    f.inputs do
      f.input :comment
      f.input :star
      f.input :bouncehouse
      f.input :reservation
      f.input :guest
      f.input :host
      f.input :type
    end
    f.actions
  end

  show do
    attributes_table do
      row :comment
      row :star
      row :bouncehouse
      row :reservation
      row :guest
      row :host
      row :type
      row :created_at
      row :updated_at
    end
  end
end
