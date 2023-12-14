class AddSourceToStatsWorkViews < ActiveRecord::Migration[5.2]
  def change
    add_column :stats_work_views, :source, :string
  end
end
