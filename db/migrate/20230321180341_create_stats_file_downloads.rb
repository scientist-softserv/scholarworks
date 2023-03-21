class CreateStatsFileDownloads < ActiveRecord::Migration[5.2]
  def change
    create_table :stats_file_downloads do |t|
      t.string :file_id
      t.string :work_id
      t.string :ip_address
      t.string :country
      t.string :city
      t.string :user_agent

      t.timestamps
    end
    add_index :stats_file_downloads, :file_id
  end
end
