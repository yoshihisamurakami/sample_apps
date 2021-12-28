class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :category, null: false, defalut: 0
      t.string :message, null: false

      t.timestamps
    end
    add_index :notifications, [:user_id, :created_at]
  end
end
