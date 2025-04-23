$(() ->
App.notifications = App.cable.subscriptions.create {channel: "NotificationChannel", id: $('user_id').val() },
  received: (data) ->
    $('#number_of_unread').html(data.unred)
    $('#notifications').prepend(data.message)
    $('#navbar_num_of_unread').html(data.unread)
)