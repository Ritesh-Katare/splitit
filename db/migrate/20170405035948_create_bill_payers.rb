class CreateBillPayers < ActiveRecord::Migration
  def change
    create_table :bill_payers do |t|
      t.integer :user_id
      t.integer :bill_id
      t.integer :amount

      t.timestamps
    end
  end
end
