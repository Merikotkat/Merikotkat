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

    #todo determine which fields should be searched
    @data = municipalities.select{ |herp| herp['id'].start_with?(filter) || herp['name'][0]['content'].start_with?(filter) }
    render json: {municipalities: { municipality: @data }}
  end

  def getspecies
    species = TipuApiHelper.GetSpecies
    render json: species
  end
end