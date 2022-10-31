class NotificationsController < ApplicationController
  def create
    @notification = Notification.build(notification_params)
    if @notification.save
      redirect_back(fallback_location: root_path)
    else 
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:user_id, :interacting_user_id, :content,
                                         :on_click_url, :sent_at)
  end
end
