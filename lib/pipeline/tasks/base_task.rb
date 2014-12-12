require 'pipeline/finding'
require 'set'

class Pipeline::BaseTask
  attr_reader :findings, :warnings, :trigger, :labels
  attr_accessor :name
  attr_accessor :description
  attr_accessor :stage

  def initialize(trigger)
    @findings = []
    @warnings = []
    @labels = Set.new
    @trigger = trigger
  end

  def report description, detail, source, severity
    finding = Pipeline::Finding.new( description, detail, source, severity )
    @findings << finding
  end

  def warn warning
    @warnings << warning
  end

  def name
    @name
  end

  def description
    @description
  end

  def stage
    @stage
  end


  def run
  end

  def analyze
  end

  def supported?
  end

end
