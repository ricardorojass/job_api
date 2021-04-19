class CandidatesController < ApplicationController

  def create
    candidate = Candidate.new(candidate_params)

    if candidate.save
      create_skills(candidate)
    end
  end

  def search
    if params[:skills].blank?
      bad_request
    else
      skills_required = params[:skills].split(',')

      candidates = Candidate.search(skills_required)        
      if candidates.empty?
        record_not_found
      else
        candidate = candidates.first
        skills = candidate.skills.map { |s| s.name }

        render json: { data: {
          id: candidate.id,
          name: candidate.name,
          skills: skills
        }, status: 200 }
      end
    end
  end

  private

  def create_skills(candidate)
    skill_params.each do |skill|
      candidate.skills << Skill.find_or_create_by(name: skill)
    end
  end

  protected

  def candidate_params
    params.require(:candidate).permit(:name)
  end
end