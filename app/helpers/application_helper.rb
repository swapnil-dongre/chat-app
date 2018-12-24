module ApplicationHelper
  def chat_date(chatroom)
    time_diff = (Time.now - chatroom.messages.last.created_at).to_i/1.day
    if time_diff == 0
      time = chatroom.messages.last.created_at.strftime("%H:%M")
    elsif time_diff <=7
      time = chatroom.messages.last.created_at.strftime("%a")
    else
      time = chatroom.messages.last.created_at.strftime("%d/%m/%Y")
    end
    time
  end
end
