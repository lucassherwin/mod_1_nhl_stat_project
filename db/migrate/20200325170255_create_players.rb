class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.integer :user_id
      t.integer :team_id
      t.string :player_name
      t.integer :goals
      t.integer :assists
    end
  end
end
