require 'test_helper'
require 'AuthenticationTicketParser'

class AuthXmlParserTest0001 < ActiveSupport::TestCase
  test "hurrdurr" do

    xml = '<?xml version="1.0" encoding="UTF-8"?>
        <login type="rengastaja">
          <login_id>1234</login_id>
          <expires_at>1281695761</expires_at>
          <auth_for>peto</auth_for>
        </login>'

    foo = AuthenticationTicketParser.new()
    hurr = foo.ParseXmlTicket(xml)

    assert hurr.loginid = 12934
    assert hurr.type = 'rengastaja'
    assert hurr.authfor = 'peto'
  end
end
