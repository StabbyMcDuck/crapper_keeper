class AddNotificationsToItems < ActiveRecord::Migration[5.0]
  def change
    change_table :items do |t|
      t.string :notification_style, default: false, null: false
      t.string :notification_frequencies, array: true, default: [], null: false
    end
  end
end
