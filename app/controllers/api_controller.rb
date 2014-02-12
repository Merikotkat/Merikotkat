require 'net/http'

class ApiController < ApplicationController
  def getringer
    data = TipuApiHelper.GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/ringers?format=json&filter=#{params['filter']}"))

    respond_to do |format|
        format.json { render json: data}
    end
  end


  def getmunicipalities
    data = TipuApiHelper.GetApiData(URI("https://h92.it.helsinki.fi/tipu-api/municipalities?format=json"))

    respond_to do |format|
      format.json { render json: data}
    end
  end
end
