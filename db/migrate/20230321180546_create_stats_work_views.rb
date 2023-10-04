class CreateStatsWorkViews < ActiveRecord::Migration[5.2]
  def change
    create_table :stats_work_views do |t|
      t.string :work_id
      t.string :ip_address
      t.string :country
      t.string :city
      t.string :user_agent

      t.timestamps
    end
    add_index :stats_work_views, :work_id
  end
end
