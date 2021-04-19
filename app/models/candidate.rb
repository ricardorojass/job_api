class Candidate < ApplicationRecord
  has_and_belongs_to_many :skills, join_table: :candidates_skills
end