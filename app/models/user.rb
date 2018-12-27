class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :chatroom_users
  has_many :chatrooms, through: :chatroom_users
  has_many :messages
  has_one :image, as: :imageable, dependent: :destroy

  def active_chatroom
    chatrooms.select{|chatroom| chatroom.messages.present?}
  end

  def get_fullname
    if firstname.present?
      firstname.capitalize + " " + lastname.capitalize
    else
      username.capitalize
    end
  end
end
