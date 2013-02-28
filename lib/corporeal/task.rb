require 'json'
require 'yaml'

require 'corporeal/config'
require 'corporeal/data'
require 'corporeal/action'
require 'corporeal/template'
require 'corporeal/util'

#
# http://stackoverflow.com/questions/5729071
# /how-to-compose-thor-tasks-in-separate-classes-modules-files
#

require 'corporeal/task/base'
require 'corporeal/task/distro'
require 'corporeal/task/profile'
require 'corporeal/task/system'
require 'corporeal/task/support'
