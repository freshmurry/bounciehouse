# Core Rails pins
pin "@hotwired/turbo-rails", to: "https://cdn.jsdelivr.net/npm/@hotwired/turbo@7.3.0/dist/turbo.min.js", preload: true
pin "turbolinks", to: "https://cdn.jsdelivr.net/npm/turbolinks@5.2.0/dist/turbolinks.js", preload: true

# jQuery and jQuery UI
pin "jquery", to: "https://code.jquery.com/jquery-3.6.0.min.js", preload: true
pin "jquery-ui", to: "https://code.jquery.com/ui/1.12.1/jquery-ui.min.js", preload: true

# jQuery UJS (Rails unobtrusive scripting adapter for jQuery)
pin "jquery_ujs", to: "https://cdn.jsdelivr.net/npm/jquery-ujs@1.2.2/src/rails.js", preload: true

# Bootstrap (JS only, styles should stay in Sprockets or CDN via layout)
pin "bootstrap-sprockets", to: "https://cdn.jsdelivr.net/npm/bootstrap@3.4.1/dist/js/bootstrap.min.js", preload: true

pin "bootstrap", to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"

# Toastr notifications
pin "toastr", to: "https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js", preload: true

# Moment.js (datetime)
pin "moment", to: "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js", preload: true

# FullCalendar
pin "fullcalendar", to: "https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.10.2/fullcalendar.min.js", preload: true

# SortableJS (used in some UIs for drag-and-drop)
pin "sortablejs", to: "https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js", preload: true

# Raty (star rating)
pin "jquery-raty", to: "https://cdnjs.cloudflare.com/ajax/libs/jquery-raty/2.9.0/jquery.raty.min.js", preload: true

# Chart.js and Chartkick
pin "chart.js", to: "https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.bundle.min.js", preload: true
pin "chartkick", to: "https://cdn.jsdelivr.net/npm/chartkick@4.2.0/dist/chartkick.min.js", preload: true

# card.js (credit card forms)
pin "card", to: "https://cdnjs.cloudflare.com/ajax/libs/card/2.5.0/card.js", preload: true

# ActionCable (already handled by Rails via app/javascript/cable.js or similar)
# If needed, you can pin your own cable.js file like this:
pin "cable", to: "cable.js"

pin "application", preload: true