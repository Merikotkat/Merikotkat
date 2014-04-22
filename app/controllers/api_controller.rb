require 'net/http'
require 'unicode_utils/upcase'
require 'erb'
include ERB::Util

class ApiController < ApplicationController
  def getringer
    filter = url_encode(params['filter'])
    data = TipuApiHelper.GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers?format=json&filter=#{filter}"))
    render json: data
  end


  def getmunicipalities
    filter = UnicodeUtils.upcase(params['filter'])
    municipalities = TipuApiHelper.GetMunicipalities
    data = municipalities.select{ |s| s['id'].start_with?(filter) || s['name'].any?{ |s| !s['content'].nil? && UnicodeUtils.upcase(s['content']).start_with?(filter) } }
    render json: {municipalities: { municipality: data }}
  end


  def getspecies
    filter = UnicodeUtils.upcase(params['filter'])
    species = TipuApiHelper.GetSpecies
    data = species['species'].select{ |s| s['id'].start_with?(filter) || s['name'].any?{ |s| UnicodeUtils.upcase(s['content']).start_with?(filter)} }
    render json: { species: data }
  end


  def getcolors
    filter = UnicodeUtils.upcase(params['filter'])
    colors = TipuApiHelper.GetColors
    data = colors['codes']['code'].select{ |s| s['code'].upcase.start_with?(filter) || s['desc'].any?{ |s| UnicodeUtils.upcase(s['content']).start_with?(filter)}}
    render json: { codes: data }
  end
end