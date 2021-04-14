class CandidatesController < ApplicationController

  def create
    @candidate = Candidate.new(candidate_params)

    @candidate.save
  end

  protected

  def candidate_params
    params.require(:candidate).permit(:name, :skills)
  end
end