class CandidatesController < ApplicationController

  def create
    @candidate = Candidate.new(candidate_params)

    @candidate.save
  end

  def search
    if params[:skills].blank?
      render json:
      {
        error: "Upps! something went wrong",
        status: 400
      }
    else
      puts "else"
      splitParams = params[:skills].split
      candidate = Candidate.where("skills LIKE ?", "%#{splitParams[0]}")
      render json:
      {
        data: candidate
      }
    end
  end

  protected

  def candidate_params
    params.require(:candidate).permit(:name, skills: [])
  end
end