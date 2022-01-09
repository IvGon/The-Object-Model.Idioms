# -------------------------- Class CargoWagon ---------------------------------
require_relative 'wagon'

class CargoWagon < Wagon
  def initialize(reg_number, full_volume)
    super(reg_number, 'грузовой', full_volume.to_f)
  end

  alias full_volume capacity

  alias occupied_volume loading

  alias free_volume free_capacity

  def take_volume(volume)
    raise 'No vacant tables!' if free_volume.zero?
    self.loading += volume
  end

  def unload_volume(volume)
    raise 'Insufficient volume!' if occupied_volume.zero?
    self.loading -= volume
  end
end

class CargoWagonValidator
  include Validate

  validates :reg_number, type: String
  validates :reg_number,
            msg: 'Invalid number format!',
            option: proc { |p| p.reg_number =~ /^\d{8}$/i }
  validates :type_wagon, type: String
  validates :type_wagon,
            msg: 'Wrong train type!',
            option: proc { |p| p.type_wagon == 'грузовой' }
  # validates :capacity, type: Fixnum
  validates :full_volume,
            msg: 'The capacity of cars cannot be less than 0!',
            option: proc { |p| p.full_volume > 0 }
end