class AddIndexSourceToStatsFileDownloads < ActiveRecord::Migration[5.2]
  def change
    add_column :stats_file_downloads, :source, :string
    add_index :stats_file_downloads, :work_id
  end
end
