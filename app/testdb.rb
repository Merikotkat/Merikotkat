# Run this to test db...
require 'oci8'

oci = OCI8.new('lintukuvat_dev','kuvadev3XT','LTKM')
oci.exec('select * from table') do |record|
  puts record.join(',')
end