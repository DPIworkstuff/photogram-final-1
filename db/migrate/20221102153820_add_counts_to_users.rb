class AddCountsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sent_request_count, :integer, default: 0
    add_column :users, :recipient_request_count, :integer, default: 0
  end
end
