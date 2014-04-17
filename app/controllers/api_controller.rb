require 'net/http'
require 'unicode_utils/upcase'
require 'erb'
include ERB::Util

class ApiController < ApplicationController
  def getringer
    filter = url_encode(params['filter'])
    data = TipuApiHelper.GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers?format=json&filter=#{filter}"))

    respond_to do |format|
      format.json { render json: data}
    end
  end


  def getmunicipalities
    # Updated to get the municipalities from the cache instead and do the filtering afterwards
    filter = UnicodeUtils.upcase(params['filter'])
    municipalities = TipuApiHelper.GetMunicipalities

    #todo determine which fields should be searched, should it depend on locale?
    data = municipalities.select{ |herp| herp['id'].start_with?(filter) || herp['name'][0]['content'].start_with?(filter) }
    render json: {municipalities: { municipality: data }}
  end

  def getspecies
    filter = UnicodeUtils.upcase(params['filter'])
    species = TipuApiHelper.GetSpecies
    data = species['species'].select{ |herp| herp['id'].start_with?(filter) || herp['name'][0]['content'].upcase.start_with?(filter) }
    render json: { species: data }
  end

  def getcolors
    filter = UnicodeUtils.downcase(params['filter'])
    colors = TipuApiHelper.GetColors
    data = colors['codes']['code'].select{ |herp| herp['code'].downcase.start_with?(filter) || herp['desc'][0]['content'].downcase.start_with?(filter)}
    render json: { codes: data }
  end
end