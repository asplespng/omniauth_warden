class AddUniqueUidToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:uid, :auth_provider], unique: true
  end
end
