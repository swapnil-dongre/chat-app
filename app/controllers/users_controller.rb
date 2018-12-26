class UsersController < ApplicationController
  def upload_image
    user = User.find(params[:user_id])
    image_file = params[:logo_image]
    image = current_user.image
    if image.nil?
      logo_image = Image.new(image: image_file)
      current_user.image = logo_image
      current_user.image.save
    else
      current_user.image.update(image: image_file)
    end
  end
end
