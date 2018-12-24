App.chatrooms = App.cable.subscriptions.create "ChatroomsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    active_chatroom = $("[data-behavior='messages'][data-chatroom-id='#{data.chatroom_id}']")
    if active_chatroom.length > 0

      if document.hidden
        if $(".strike").length == 0
          active_chatroom.append("<div class='strike'><span>Unread Messages</span></div>")

        if Notification.permission == "granted"
          new Notification(data.username, {body: data.body})

      else
        App.last_read.update(data.chatroom_id)

      # Insert the message
      current_user = $("[data-behavior='messages']").data("username")
      if data.username != current_user
        active_chatroom.append('<div class="incoming_msg"><div class="incoming_msg_img"> <img src="https://ptetutorials.com/images/user-profile.png" alt="sunil"> </div><div class="received_msg"><div class="received_withd_msg"><p>' + data.body + '<span class="time_date">' + data.time + '</span></p></div></div></div>')
      else
        active_chatroom.append('<div class="outgoing_msg"><div class="sent_msg"><p>' + data.body + '<span class="time_date" style= "color: #fff;">' + data.time + '</span></p></div></div>')
      $('.msg_history').scrollTop($(".msg_history")[0].scrollHeight);

    else
      badge_count =  $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']")
      badge_count.siblings(".badge").css("display","inline-block")
      $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']").css("font-weight", "bold")
      toastr["info"](data.body, data.username)

  send_message: (chatroom_id, message) ->
    @perform "send_message", {chatroom_id: chatroom_id, body: message}
