ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t("active_admin.dashboard_welcome.welcome")
        small I18n.t("active_admin.dashboard_welcome.call_to_action")
      end
    end

    columns do
      column do
        panel "Recent Bouncehouses" do
          ul do
            Bouncehouse.order(created_at: :desc).limit(5).each do |bouncehouse|
              li link_to(bouncehouse.listing_name, edit_admin_bouncehouse_path(bouncehouse))
            end
          end
        end
      end

      column do
        panel "Statistics" do
          para "Total Bouncehouses: #{Bouncehouse.count}"
          para "Total Users: #{User.count}"
          para "Total Reservations: #{Reservation.count}"
        end
      end
    end

    columns do
      column do
        panel "Recent Reviews" do
          ul do
            Review.order(created_at: :desc).limit(5).each do |review|
              li link_to("Review ##{review.id}", Rails.application.routes.url_helpers.admin_comment_path(review))
            end
          end
        end
      end

      column do
        panel "Recent Reservations" do
          ul do
            Reservation.order(created_at: :desc).limit(5).each do |reservation|
              li link_to("Reservation ##{reservation.id}",
                         Rails.application.routes.url_helpers.bouncehouse_reservation_path(reservation.bouncehouse_id, reservation))
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Active Reservations" do
          ul do
            active_reservations = Reservation.where("start_date <= ? AND end_date >= ?", Date.today, Date.today)
            if active_reservations.any?
              active_reservations.each do |reservation|
                li do
                  link_to("Request ##{reservation.id} - #{reservation.bouncehouse.listing_name}",
                          Rails.application.routes.url_helpers.bouncehouse_reservation_path(reservation.bouncehouse_id, reservation)) +
                  content_tag(:span, " - Status: #{reservation.status}", style: "margin-left: 5px;")
                end
              end
            else
              li "No active reservations at the moment."
            end
          end
        end
      end

      column do
        panel "New Reservation Requests" do
          ul do
            new_reservations = Reservation.where(status: 'pending').order(created_at: :desc).limit(5)
            if new_reservations.any?
              new_reservations.each do |reservation|
                li do
                  link_to("Request ##{reservation.id} - #{reservation.bouncehouse.listing_name}",
                          Rails.application.routes.url_helpers.bouncehouse_reservation_path(reservation.bouncehouse_id, reservation)) +
                  content_tag(:span, " - Status: #{reservation.status}", style: "margin-left: 5px;")
                end
              end
            else
              li "No new reservation requests."
            end
          end
        end
      end
    end
  end
end
