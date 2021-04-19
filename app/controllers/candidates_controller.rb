class CandidatesController < ApplicationController
  require 'ostruct'

  def create
    candidates = Rails.cache.read('candidates').nil? ? [] : Rails.cache.read('candidates')
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
      candidates = filter(candidates, skills_required)

      # todo: fix the resulted skills
      if (candidates.empty?)
        record_not_found
      else
        candidate = candidates.first
        skills = candidate[:skills]

        render json: {
          id: candidate[:id],
          name: candidate[:name],
          skills: skills
        }
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
    clean_candidates = candidates.select { |c| !c[:skills].empty?}
    return clean_candidates.empty? ?
    [] :
    # sort candidates desc
    candidates.sort { |a,b| b[:skills].length <=> a[:skills].length }
  end

end