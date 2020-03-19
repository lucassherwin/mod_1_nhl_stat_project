class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.integer :draft_year
      t.integer :draft_num
      t.string :draft_team
      t.string :current_team
    end
  end
end
