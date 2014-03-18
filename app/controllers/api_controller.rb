require 'net/http'
require 'unicode_utils/upcase'

class ApiController < ApplicationController
  def getringer
    data = TipuApiHelper.GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers?format=json&filter=#{params['filter']}"))

    respond_to do |format|
      format.json { render json: data}
    end
  end


  def getmunicipalities
    # Updated to get the municipalities from the cache instead and do the filtering afterwards
    #todo wtf ascii only? ORLY? YARLY!
    filter = UnicodeUtils.upcase(params['filter'])
    puts filter
    municipalities = TipuApiHelper.GetMunicipalities

    #todo determine which fields should be searched
    @data = municipalities.select{ |herp| herp['id'].start_with?(filter) || herp['name'][0]['content'].start_with?(filter) }
    render json: {municipalities: { municipality: @data }}
  end
end