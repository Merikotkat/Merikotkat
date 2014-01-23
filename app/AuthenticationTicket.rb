class AuthenticationTicket
  attr_reader :type, :loginid, :expiresat, :authfor

  def initialize(type, loginid, expiresat, authfor)
    @type = type
    @loginid = loginid
    @expiresat = expiresat
    @authfor = authfor
  end
end