# Run this to test db...
require 'oci8'

oci = OCI8.new('lintukuvat_dev','hurr','ltkm')
oci.exec('select * from visitation_forms') do |record|
  puts record.join(',')
end