class CreateGlacierSnsDownloadRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :glacier_sns_download_requests do |t|
      t.integer :user_id
      t.string :glacier_identifier
      t.boolean :is_complete, default: false

      t.timestamps
    end
  end
end
