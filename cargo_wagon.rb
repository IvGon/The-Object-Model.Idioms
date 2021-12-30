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
