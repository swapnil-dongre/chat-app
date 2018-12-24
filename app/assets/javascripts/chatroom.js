$(document).on('turbolinks:load', function() {
  $('.headind_srch').on('click', function(){
    debugger
    chatroom = $(this).attr('chatroom-id');
    $.ajax({
      url: "/chatrooms/" + chatroom + "/info",
      type: "GET",
      data: {id: chatroom}
    });
  });
});
