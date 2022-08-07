class AddIsDeletedToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :is_deleted, :boolean, :default => false
  end
end
