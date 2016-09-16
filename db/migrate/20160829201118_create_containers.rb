class CreateContainers < ActiveRecord::Migration[5.0]
  def change
    create_table :containers do |t|
      t.string :name, null: false
      t.text :description, null: true
      t.references :parent, null: true, index: true, foreign_key: false
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.integer :depth, null: false, default: 0
      t.references :user, null: false, index: true, foreign_key: true

      t.timestamps
    end

    add_foreign_key :containers, :containers, column: :parent_id
  end

  def self.down
    drop_table :containers
  end
end
