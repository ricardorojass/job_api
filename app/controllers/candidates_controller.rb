class CandidatesController < ApplicationController

  def create
    candidate = Candidate.new(candidate_params)

    if candidate.save
      create_skills(candidate.id)
    end
  end

  def search
    if params[:skills].blank?
      render json: { error: "Upps! something went wrong",status: 400 }
    else

      puts "search #{ids}"
      render json:
      {
        data: candidate
      }
    end
  end

  private

  def create_skills(candidateId)
    skill_params.each do |skill|
      Skill.create!(name: skill, candidate_id: candidateId)
    end
  end

  protected

  def candidate_params
    params.require(:candidate).permit(:name)
  end

  def skill_params
    params[:skills]
  end
end