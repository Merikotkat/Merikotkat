# Run this to test db...
require 'oci8'

oci = OCI8.new('lintukuvat_dev','durr','LTKM')
oci.exec('select * from ljesfsefes') do |record|
  puts record.join(',')
end