class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.datetime :res_date
      t.boolean :reserved

      t.timestamps null: false
    end
  end
end
