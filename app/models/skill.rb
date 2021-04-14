class Skill < ApplicationRecord
  belongs_to :candidate, dependent: :destroy
end
