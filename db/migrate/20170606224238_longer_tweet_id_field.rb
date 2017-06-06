class LongerTweetIdField < ActiveRecord::Migration[5.1]
  def change
    change_column :tweets, :id, :bigint
  end
end
