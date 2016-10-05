class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.text :name, null: false
      t.text :description
      t.references :container, null: false, foreign_key: true
      t.integer :count, default: 1, null: false
      t.datetime :last_used_at

      t.timestamps
    end
  end
end
