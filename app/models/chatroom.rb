class Chatroom < ApplicationRecord
  has_many :chatroom_users, dependent: :destroy
  has_many :users, through: :chatroom_users
  has_many :messages, dependent: :destroy
  has_one :image, as: :imageable, dependent: :destroy

  scope :public_channels, ->{ where(direct_message: false) }
  scope :direct_messages, ->{ where(direct_message: true) }

  def self.direct_message_for_users(users)
    user_ids = users.map(&:id).sort
    name = "DM:#{user_ids.join(":")}"

    if chatroom = direct_messages.where(name: name).first
      chatroom
    else
      # create a new chatroom
      chatroom = new(name: name, direct_message: true)
      chatroom.users = users
      chatroom.save
      chatroom
    end
  end

  def direct_user_name(user)
    users.where.not(username: user).first.username.capitalize
  end

  def get_user_image(user)
    users.where.not(username: user).first.image.image.url(:profile)
  end

  def user_last_seen(user)
    chat_user = users.where.not(username: user).first
    time_diff = (Time.now - chat_user.last_sign_in_at).to_i/1.day
    if time_diff == 0
      time = "last seen today at " + chat_user.last_sign_in_at.strftime("%H:%M %p")
    elsif time_diff <=7
      time = "last seen " + chat_user.last_sign_in_at.strftime("%A")
    else
      time = "last seen " + chat_user.last_sign_in_at.strftime("%d/%m/%Y")
    end
    time
  end
end
