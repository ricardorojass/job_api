class CandidatesController < ApplicationController

  def create
    candidate = Candidate.new(candidate_params)

    if candidate.save
      create_skills(candidate)
    end
  end

  def search
    if params[:skills].blank?
      render json: { error: "Upps! something went wrong",status: 400 }
    else
      skillsAmount = split_skills_params.length
      skillIds = Skill.where(name: split_skills_params).pluck(:id)

      candidates =
        Candidate.distinct.includes(:skills).where(skills: {id: skillIds}).to_a

      # filter by skills included in the search
      candidates = candidates.map do |c|
        c.skills = c.skills.filter { |s| skillIds.include?(s.id)}
        c
      end

      # sort candidates desc
      candidates = candidates.sort { |a,b| b.skills.length <=> a.skills.length }

      if candidates.empty?
        render json: { error: "upps!", status: 404 }
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

  def skill_params
    params[:skills]
  end

  def split_skills_params
    skill_params.split(',')
  end
end