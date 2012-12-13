# Class and methods to work with Pulses
module PulseEngine
  # Basic pulse class
  class Pulse
    attr_accessor :amplitude
    def initialize(amplitude = 1.0)
      @amplitude = amplitude
    end
    def amplify(magnitude)
      @amplitude = @amplitude * magnitude
      self
    end
  end

  # Adds together multiple pulses and creates a new combined pulse
  def aggregate_pulses(pulses)
    amplitude = 0
    amplitude += pulses.pop.amplitude until pulses.empty?
    Pulse.new(amplitude)
  end
end
