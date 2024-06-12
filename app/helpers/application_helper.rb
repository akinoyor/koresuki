module ApplicationHelper
  def formatted_date_jp(date)
    date.in_time_zone("Asia/Tokyo").strftime("%Y年%m月%d日 %H時%M分")
  end
  def simplified_date_jp(date)
    date.in_time_zone("Asia/Tokyo").strftime("%Y/%m/%d %H:%M")
  end
end
