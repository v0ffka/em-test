class CreateFeedItems < ActiveRecord::Migration[6.0]
  def change
    create_table :feed_items, id: :string, primary_key: 'guid' do |t|
      t.string :link
      t.string :title
      t.timestamp :pub_date
      t.integer :feed_id

      t.timestamps
    end
  end
end
