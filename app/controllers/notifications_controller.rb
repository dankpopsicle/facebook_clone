class NotificationsController < ApplicationController
  def index
    @notifications = Notification.where(user_id: current_user.id)
  end
  
  def create
    @notification = Notification.build(notification_params)
    if @notification.save
      redirect_back(fallback_location: root_path)
    else 
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def notification_params
    params.require(:notification).permit(:user_id, :interacting_user_id, :content,
                                         :on_click_url, :sent_at, :notification_type, 
                                         :status)
  end
end
