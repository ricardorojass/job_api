class Skill < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.references :candidate, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
