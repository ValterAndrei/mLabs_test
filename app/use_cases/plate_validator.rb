class PlateValidator
  attr_reader :plate

  def initialize(plate)
    @plate = plate
  end

  def run
    plate && !!plate.match(/[a-zA-Z]{3}[-]\d{4}/)
  end
end
