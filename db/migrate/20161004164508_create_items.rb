class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.text :name
      t.text :description
      t.reference :container_reference
      t.integer :count
      t.datetime :last_used_at

      t.timestamps
    end
  end
end
