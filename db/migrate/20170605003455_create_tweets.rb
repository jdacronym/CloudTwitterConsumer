class CreateTweets < ActiveRecord::Migration[5.1]
  def change
    create_table :tweets do |t|
      t.string :user_name
      t.integer :user_id
      t.string :text
      t.datetime :timestamp
      t.timestamps
    end
  end
end
