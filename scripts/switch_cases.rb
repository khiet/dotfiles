require 'active_support/core_ext/string/inflections'

word = ARGV[0]
modified =
  if word.include?('_')
    word.camelize(:lower)
  else
    word.underscore
  end

print modified
