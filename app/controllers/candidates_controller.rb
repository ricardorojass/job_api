class CandidatesController < ApplicationController
  require 'ostruct'

  def create
    # Get cache or create an empty array
    candidates = Rails.cache.read('candidates').nil? ? [] : Rails.cache.read('candidates')

    # Create object to save
    candidate = { id: params[:id],  name: params[:name], skills: params[:skills] }

    candidates << candidate
    Rails.cache.write('candidates', candidates)
  end

  def search
    # Get cache
    candidates = Rails.cache.read('candidates')
    if params[:skills].blank?
      bad_request
    else
      skills_required = params[:skills].split(',')
      candidates = filter(candidates, skills_required)

      if (candidates.empty?)
        record_not_found
      else
        candidate = candidates.first

        render json: {
          id: candidate[:id],
          name: candidate[:name],
          skills: candidate[:skills]
        }
      end
    end
  end

  private

  def filter(candidates, skills)
    # filter candidates by skills included in the search
    filter_candidates = candidates.select { |c| (c[:skills] - skills) != c[:skills] }

    # sort candidates desc
    sort_candidates = filter_candidates.sort do |a,b|
      skills_a = a[:skills].select { |s| skills.include?(s) }
      skills_b = b[:skills].select { |s| skills.include?(s) }

      skills_b.length <=> skills_a.length
    end

    return sort_candidates
  end

end