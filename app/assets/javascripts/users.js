$(document).on('turbolinks:load', function() {
  $('.display_picture').on('change', function(e){
    user = $(this).attr('user_id');
    var file = e.target.files[0];
    var filename = file.name;
    var data = new FormData();
    data.append("logo_image", file);
    $.ajax({
      url: "/users/" + user + "/upload_image",
      type: "POST",
      data: data,
      cache: false,
      contentType: false,
      processData: false
    });
  });
});

