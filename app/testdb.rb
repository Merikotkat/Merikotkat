# Run this to test db...
require 'oci8'

oci = OCI8.new('lintukuvat_dev','hurr','ltkm')
oci.exec('select value
  from nls_database_parameters
   where parameter = \'NLS_CHARACTERSET\'') do |record|
  puts record.join(',')
end
