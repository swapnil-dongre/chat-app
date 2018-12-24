class UsersController < ApplicationController
  def upload_image
    user = User.find(params[:user_id])
    image_file = params[:logo_image]
    display_picture = current_user.display_picture
    if display_picture.nil?
      logo_image = Image.new(image: image_file)
      current_user.display_picture = logo_image
      current_user.display_picture.save
    else
      current_user.display_picture.update(image: image_file)
    end
  end
end
