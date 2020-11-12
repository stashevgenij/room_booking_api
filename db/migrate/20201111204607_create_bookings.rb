class CreateBookings < ActiveRecord::Migration[6.0]
  def change
    create_table :bookings do |t|
      t.date :start_date
      t.date :end_date
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    ActiveRecord::Base.connection.execute("CREATE EXTENSION IF NOT EXISTS btree_gist;")
    ActiveRecord::Base.connection.execute("ALTER TABLE bookings 
                                             ADD CONSTRAINT unique_bookings_per_room_daterange
                                               EXCLUDE  USING gist
                                               ( room_id WITH =, 
                                                 daterange(start_date, end_date, '(]') WITH && );")
  end  
end