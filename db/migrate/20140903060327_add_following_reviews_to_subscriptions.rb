class AddFollowingReviewsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :following_reviews, :boolean, default: true
  end
end
