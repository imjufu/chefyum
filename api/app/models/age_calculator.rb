class AgeCalculator
  attr_reader :birthdate

  def initialize(birthdate)
    @birthdate = birthdate
  end

  def calculate
    ((Time.zone.now - birthdate.to_time) / 1.year.seconds).floor
  end
end
