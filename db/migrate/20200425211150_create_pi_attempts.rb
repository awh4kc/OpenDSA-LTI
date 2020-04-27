class CreatePiAttempts < ActiveRecord::Migration
  def change
    create_table :pi_attempts do |t|
      t.integer :user_id
      t.string :frame_name
      t.string :question
      t.integer :correct

      t.timestamps null: false
    end
  end
end
