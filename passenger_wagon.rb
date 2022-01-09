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

class PassengerWagonValidator
  include Validate

  validates :reg_number, type: String
  validates :reg_number,
            msg: 'Invalid number format!',
            option: proc { |p| p.reg_number =~ /^\d{8}$/i }
  validates :type_wagon, type: String
  validates :type_wagon,
            msg: 'Wrong train type!',
            option: proc { |p| p.type_wagon == 'пассажирский' }
  validates :capacity, type: Fixnum
  validates :total_seats,
            msg: 'The capacity of cars cannot be less than 0!',
            option: proc { |p| p.total_seats > 0 }
end
