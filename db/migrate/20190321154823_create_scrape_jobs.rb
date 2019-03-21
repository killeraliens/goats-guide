class CreateScrapeJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :scrape_jobs do |t|
      t.string :name

      t.timestamps
    end
  end
end
