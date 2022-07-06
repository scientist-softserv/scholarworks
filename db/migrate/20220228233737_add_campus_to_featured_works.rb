class AddCampusToFeaturedWorks < ActiveRecord::Migration[5.1]
  def change
    add_column :featured_works, :campus, :string, null: false
  end
end
