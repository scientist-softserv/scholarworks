class AddCampusToStatsWorkView < ActiveRecord::Migration[5.2]
  def change
    add_column :stats_work_views, :campus, :string
    add_column :stats_work_views, :latitude, :float
    add_column :stats_work_views, :longitude, :float
  end
end
