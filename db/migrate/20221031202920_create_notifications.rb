class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :interacting_user_id
      t.text :content
      t.text :on_click_url
      t.time :sent_at

      t.timestamps
    end
  end
end
