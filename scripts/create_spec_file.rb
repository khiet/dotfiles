require 'fileutils'
require 'pathname'

file_path = ARGV[0]
# file_path = '/Users/khietle/portify-api/app/services/cors_whitelist_service.rb'
spec_file_path = file_path.sub(%r{(app/)(.*).rb}, 'spec/\2_spec.rb')
spec_pathname =  Pathname(spec_file_path)

exit(0) if File.exist?(spec_pathname)

FileUtils.mkdir_p spec_pathname.dirname
FileUtils.cd spec_pathname.dirname
FileUtils.touch spec_pathname.basename

template = <<~HERE
  require 'rails_helper'

  RSpec.describe OBJECT_UNDER_TEST do

  end
HERE

File.open(spec_pathname, 'w') do |file|
  file.write(template)
end
