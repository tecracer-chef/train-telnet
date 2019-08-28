libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require "train-telnet/version"

require "train-telnet/transport"
require "train-telnet/connection"
