class CreateDrafts < ActiveRecord::Migration[6.0]
  def change
    create_table :drafts do |t|
      t.string :year
      t.integer :player_id
      t.integer :team_id
    end
  end
end
