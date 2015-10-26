$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'launchd'

def basedir
  Pathname.new(__FILE__).dirname.parent
end
