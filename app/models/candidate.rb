class Candidate < ApplicationRecord
  has_and_belongs_to_many :skills, join_table: :candidates_skills

  def self.search(skills)
    skillIds = Skill.where(name: skills).pluck(:id)

    candidates = Candidate.distinct.includes(:skills).where(skills: {id: skillIds}).to_a
    # filter by skills included in the search
    candidates = candidates.map do |c|
      c.skills = c.skills.filter { |s| skillIds.include?(s.id)}
      c
    end
    # sort candidates desc
    candidates = candidates.sort { |a,b| b.skills.length <=> a.skills.length }
  end
end