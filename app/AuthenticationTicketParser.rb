require 'rexml/document'
require 'openssl'
require './AuthenticationTicket'
require 'base64'

class AuthenticationTicketParser

  # @param [Object] data Base64 encoded auth ticket encrypted with AES256
  # @param [Object] key Base64 encoded key. Decrypt with server public key
  # @param [Object] iv  Base64 encoded init vector. Decrypt with server public key
  # @param [Object] rsapublickeyfile RSA public key used to decrypt the authentication tickets, pem format
  def parse(data, key, iv, rsapublickeyfile)

    data = base64_decode(data)
    key = base64_decode(key)
    iv = base64_decode(iv)

    public_key = OpenSSL::PKey::RSA.new(rsapublickeyfile)
    decrypted_key = public_key.public_decrypt(key)
    decrypted_iv = public_key.public_decrypt(iv)

    ticket_xml = AES256Decrypt(key, iv, data)

    ParseXmlTicket(ticket_xml)
  end


  # @param [Object] key
  # @param [Object] iv
  # @param [Object] data
  def AES256Decrypt(key, iv, data)
    alg = "AES-256-CBC"
    aes = OpenSSL::Cipher::Cipher.new(alg)
    aes.decrypt
    aes.key = key
    aes.iv = iv
    aes.update(data) + aes.final
  end


  def ParseXmlTicket(ticket_xml)
    xml = REXML::Document.new(ticket_xml)
    root = xml.root

    type = root.attributes["type"]
    login_id = root.elements["login_id"][0]
    expires_at = root.elements["expires_at"][0]
    auth_for = root.elements["auth_for"][0]

    AuthenticationTicket.new(type, login_id, expires_at, auth_for)
  end
end