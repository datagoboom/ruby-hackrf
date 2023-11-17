require 'hackrf/bindings'
require 'hackrf/device'
require 'hackrf/version'


module HackRF
  def self.open(&block)
    Device.open(&block)
  end
end

HackRF.hackrf_init

at_exit { HackRF.hackrf_exit }
