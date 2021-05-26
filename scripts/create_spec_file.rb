require 'fileutils'
require 'pathname'

file_path = ARGV[0]
# file_path = '/Users/khietle/portify-api/app/services/cors_whitelist_service.rb'
spec_file_path = file_path.sub(%r{(app/)(.*).rb}, 'spec/\2_spec.rb')
spec_pathname =  Pathname(spec_file_path)

FileUtils.mkdir_p spec_pathname.dirname
FileUtils.cd spec_pathname.dirname
FileUtils.touch spec_pathname.basename
