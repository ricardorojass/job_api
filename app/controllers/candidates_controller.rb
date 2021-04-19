class CandidatesController < ApplicationController
  require 'ostruct'

  def create
    # name = params.fetch[:name]
    # skills = params.fetch[:skills]

    candidates = [
      { name: 'Richi', skills: ['js', 'ruby', 'nodejs'] },
      { name: 'Mochi', skills: ['js', 'python', 'express'] },
      { name: 'Luis', skills: ['js', 'java', 'mongodb'] }
    ]

    # candidates = Rails.cache.instance_variable_get(:@data)
    
    puts "Candidates => #{candidates}"

    id = params[:id]
    name = params[:name]
    skills = params[:skills]

    
    candidate = { id: id,  name: name, skills: skills }
    candidates << candidate
    Rails.cache.write('candidates', candidates)
  end

  def search
    candidates = Rails.cache.read('candidates')
    if params[:skills].blank?
      bad_request
    else
      skills_required = params[:skills].split(',')
      puts skills_required

      candidates = filter(candidates, skills_required)
      puts candidates

      # todo: fix the resulted skills
      candidate = candidates.first
      if (candidate[:skills].length > 0)
        skills = candidate[:skills]
        
        render json: {
          id: candidate[:id],
          name: candidate[:name],
          skills: skills
        }
      else
        record_not_found
      end
    end
  end

  private

  def filter(candidates, skills)
    # filter by skills included in the search
    candidates = candidates.map do |c|
      c[:skills] = c[:skills].filter { |s| skills.include?(s) }
      c
    end
    
    # sort candidates desc
    candidates = candidates.sort { |a,b| b[:skills].length <=> a[:skills].length }
  end

  protected

  def candidate_params
    params.require(:candidate).permit(:name)
  end
end