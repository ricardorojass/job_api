class CreateCandidates < ActiveRecord::Migration[6.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.jsonb :skills

      t.timestamps
    end
  end
end
