class CreateBillAttendees < ActiveRecord::Migration
  def change
    create_table :bill_attendees do |t|
      t.integer :user_id
      t.integer :bill_id

      t.timestamps
    end
  end
end
