class AddFollowingRatingsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :following_ratings, :boolean, default: true
  end
end
