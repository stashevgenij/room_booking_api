class CreateRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :rooms do |t|
      t.integer :number

      t.timestamps
    end
    add_index :rooms, :number, unique: true
  end
end
