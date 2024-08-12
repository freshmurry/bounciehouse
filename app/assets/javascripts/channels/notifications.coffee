# $(() ->
# App.notifications = App.cable.subscriptions.create {channel: "NotificationsChannel", id: $('user_id').val() },
#   received: (data) ->
#     $('#number_of_unread').html(data.unred)
#     $('#notifications').prepend(data.message)
#     $('#navbar_num_of_unread').html(data.unread)
# )

$ ->
  userId = $('#user_id').val()
  App.notifications = App.cable.subscriptions.create 
    channel: "NotificationsChannel"
    id: userId

  received: (data) ->
    $('#number_of_unread').html(data.unread)  # Ensure the correct key is used
    $('#notifications').prepend(data.message)
    $('#navbar_num_of_unread').html(data.unread)