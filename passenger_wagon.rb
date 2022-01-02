require_relative 'wagon'

class PassengerWagon < Wagon
  def initialize(reg_number, total_seats)
    super(reg_number, 'пассажирский', total_seats.to_i)
  end

  alias total_seats capacity

  alias occupied_seats loading

  alias free_seats free_capacity

  def take_a_seat
    raise 'No vacant tables!' if free_seats.zero?
    self.loading += 1
  end

  def refund_a_seat
    raise 'Insufficient volume!' if occupied_seats.zero?
    self.loading -= 1
  end
end
