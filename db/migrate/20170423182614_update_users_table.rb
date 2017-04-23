class UpdateUsersTable < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :booking, index: true, foreign_key: true
    end
  end
end
