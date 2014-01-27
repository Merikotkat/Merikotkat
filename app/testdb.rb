# Run this to test db...
require 'oci8'

oci = OCI8.new('username','password','salkku.it.helsinki.fi')
oci.exec('select * from table') do |record|
  puts record.join(',')
end