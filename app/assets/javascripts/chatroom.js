$(document).on('turbolinks:load', function() {
  $('.headind_srch').on('click', function(){
    chatroom = $(this).attr('chatroom-id');
    $.ajax({
      url: "/chatrooms/" + chatroom + "/info",
      type: "GET",
      data: {id: chatroom},
      success: function(data) {
        $('.recent_heading .back_arrow').css("display","inline-block");
      }
    });
  });
});
