class AddSkillsToCandidates < ActiveRecord::Migration[6.1]
  def change
    add_column :candidates, :skills, :text, array: true, default: []
  end
end
