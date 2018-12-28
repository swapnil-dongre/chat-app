class ChatroomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chatroom, only: [:show, :edit, :update, :destroy, :info]

  # GET /chatrooms
  # GET /chatrooms.json
  def index
    @chatrooms = Chatroom.public_channels
  end

  # GET /chatrooms/1
  # GET /chatrooms/1.json
  def show
    @messages = @chatroom.messages.order(created_at: :desc).limit(100).reverse
    @chatroom_user = current_user.chatroom_users.find_by(chatroom_id: @chatroom.id)
  end

  # GET /chatrooms/new
  def new
    @chatroom = Chatroom.new
  end

  # GET /chatrooms/1/edit
  def edit
  end

  # POST /chatrooms
  # POST /chatrooms.json
  def create
    @chatroom = Chatroom.new(name: chatroom_params[:name])
    respond_to do |format|

      if @chatroom.save
        image_file = params[:chatroom][:image]
        logo_image = Image.new(image: image_file)
        @chatroom.image = logo_image
        @chatroom.image.save
        @chatroom.chatroom_users.where(user_id: current_user.id).first_or_create
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully created.' }
        format.json { render :show, status: :created, location: @chatroom }
      else
        format.html { render :new }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chatrooms/1
  # PATCH/PUT /chatrooms/1.json
  def update
    image_update
    respond_to do |format|
      if @chatroom.update(chatroom_params)
        format.html { redirect_to @chatroom, notice: 'Chatroom was successfully updated.' }
        format.json { render :show, status: :ok, location: @chatroom }
      else
        format.html { render :edit }
        format.json { render json: @chatroom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chatrooms/1
  # DELETE /chatrooms/1.json
  def destroy
    @chatroom.destroy
    respond_to do |format|
      format.html { redirect_to chatrooms_url, notice: 'Chatroom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def info
    @chatroom_users = @chatroom.users
    @invite_user_name_with_id = (User.all - @chatroom.users).map{|other_user| ["#{other_user.firstname}" + " " +  "#{other_user.lastname}" ,other_user.id]}
  end

  def change_image
    @chatroom = Chatroom.find(params[:chatroom_id])
    @chatroom_users = @chatroom.users
    if @chatroom.direct_message
      other_user = @chatroom.other_user(current_user)
      if other_user.image.nil?
        image_file = params[:logo_image]
        logo_image = Image.new(image: image_file)
        other_user.image = logo_image
        other_user.image.save
      else
        other_user.image.update(image: image_file)
      end
    else
      image_update
    end
  end

  def search_result
    @selected_chatroom = search(params[:search_value])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chatroom
      @chatroom = Chatroom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chatroom_params
      params.require(:chatroom).permit(:name, :image)
    end

    def image_update
      image_file = params[:logo_image]
      image = @chatroom.image
      if image.nil?
        logo_image = Image.new(image: image_file)
        @chatroom.image = logo_image
        @chatroom.image.save
      else
        @chatroom.image.update(image: image_file)
      end
    end

    def search(value)
      result_users = User.where('firstname LIKE ? OR lastname LIKE ?', "%#{value}%", "%#{value}%").distinct
      result_chatrooms = Chatroom.public_channels.where("name LIKE ?", "%#{value}%").distinct
      final_search = {}
      final_search["users"] = result_users
      final_search["chatrooms"] = result_chatrooms
      final_search
    end
end
