class AddCampusToStatsFileDownload < ActiveRecord::Migration[5.2]
  def change
    add_column :stats_file_downloads, :campus, :string
    add_column :stats_file_downloads, :latitude, :float
    add_column :stats_file_downloads, :longitude, :float
  end
end
