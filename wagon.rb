class Wagon
  require_relative 'manufacturer'
  require_relative 'instance_counter'

  include Manufacturer
  include InstanceCounter

  attr_accessor :location, :loading
  attr_reader :reg_number, :type_wagon, :capacity

  NUMBER_WAGON_FORMAT = /^\d{8}$/i

  @@list_wagons = []

  # ----------------------------------- Obj wagon list ----------------------

  def self.all
    @@list_wagons
  end

  # ---------------------------------------------------------------------------

  def initialize(reg_number, type_wagon, capacity)
    return unless validate!(reg_number, type_wagon, capacity)

    @reg_number = reg_number
    @type_wagon = type_wagon
    @capacity = capacity
    @loading = 0
    @location = 'NEW'

    @@list_wagons.push(self)
    register_instance
  end

  def free_capacity
    capacity - loading
  end

  # ------------------ attach_wagon_to_train ----------------------------------

  def attach_wagon_to_train(train)
    @location = train.number if train.wagons.include?(self)
  end

  # ------------------ unhook_wagon_from_train -------------------------------

  def unhook_wagon_from_train(train)
    @location = train.curent_station if train.wagons.include?(self)
  end

  # ------------------ assign_type_wagon ---------------------------------

  def assign_type_wagon(type)
    raise 'Wrong type of carriage!' unless %w[пассажирский грузовой].include?(type)
    assign_type_wagon!(type)
  end

  def valid?
    validate!(@reg_number, @type_wagon, @capacity)
    true
  rescue StandardError
    false
  end

  private

  attr_writer :type_wagon, :manufacturer

  def assign_type_wagon!(type)
    self.type_wagon = type
  end

  def validate!(*args)
    raise 'The carriage number is not specified!' if args[0].nil?
    raise 'Number length must be 8 digits!' if args[0].to_s.length != 8
    raise 'Wrong format of number!' if args[0] !~ NUMBER_WAGON_FORMAT
    raise 'Wrong type of carriage!' unless %w[пассажирский грузовой].include?(args[1])
    raise 'The capacity of the carriage cannot be negative!' if args[2] < 0
  rescue StandardError => e
    puts 'e.message ' + e.message
    false
  else
    true
  end
end
