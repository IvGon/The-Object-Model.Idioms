class Train
  require_relative 'manufacturer'
  require_relative 'passenger_train'
  require_relative 'cargo_train'
  require_relative 'instance_counter'
  require_relative 'validate'

  include Validation
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type, :route_name, :route
  attr_accessor :speed, :curent_station

  attr_reader :condition, :num_of_cars, :wagons

  NUMBER_FORMAT = /^\d{3}-?[а-яА-Я]{2}$/i
  @@trains = []

  #------------------------------------ Obj Train list --------------------

  def self.all
    @@trains
  end

  # --------------------------------------------- find Obj Train by number --

  def find(number)
    @@trains.find { |train| train.number == number }
  end

  # ------------------------------------------------------

  def initialize(number, type, num_of_cars)
    @number = number
    @type = type
    @wagons = []
    @num_of_cars = num_of_cars
    @speed = 0
    @curent_station = 'Харьков'

    @@trains.push(self)
    register_instance
  end

  # ------------------------------------ number of cars ------

  def number_cars
    @wagons.size
  end

  # ---------------------------------------- assign_train_route -----

  def assign_train_route(assign_route)
    @route = assign_route
    @curent_station = @route.station[0]
    @prev_station = nil
    @next_station = assign_route.station[1]
    @condition = @curent_station
    Station.all.find { |item| item.name == route.station[0] }.train_arrival(self)
  end

  def route_name
    @route.name
  end

  def train_curent_station
    @curent_station
  end

  def train_next_station
    @next_station
  end

  def train_prev_station
    @prev_station
  end

  # ----------------------- train_forward ----

  def train_forward(departure_station)
    if @current_station != route.station[-1]

      speed = 60

      @prev_station = @curent_station
      departure_station.train_departure(self)
      @curent_station = @next_station
      ind = route.station.index(@curent_station).to_i + 1
      @next_station = route.station[ind]
    else
      puts 'The train is already at its destination!'
    end
  end

  def train_back(departure_station)
    speed = 60

    if @current_station != @route.station[0]
      @curent_station = @prev_station
      departure_station.train_arrival(self)
      ind = route.station.index(@curent_station).to_i
      @prev_station = route.station[ind + 1]
      @next_station = route.station[ind + 1]
    else
      puts 'The train is already at the point of departure!'
      end
  end

  # ----------------------------- leave_the_station ----------

  def leave_the_station(station)
    @prev_station = station.name if station.trains.include?(self)
    @curent_station = ''
    i = route.station.index(station.name).to_i
    @next_station = route.station[i + 1]
    speed = 60
  end

  # ----------------------------- arrive_at_the_station ---------------

  def arrive_at_the_station(station)
    speed = 0
    @curent_station = station.name if station.trains.include?(self)
    @next_station = ''
  end

  # ----------------------------  train location ------------------

  def condition
    @condition = if speed > 0 && curent_station.empty?
                   "#{@prev_station} - #{@next_station}"
                 else
                   curent_station.to_s
                 end
  end

  # ------------------------------ Train info ------------------------

  def info
    condition
    puts "Train number        - #{@number}"
    puts "Train Obj           - #{self}"
    puts "type_wagon          - #{@type}"
    puts "number of cars      - #{@num_of_cars}"
    puts "Speed               - #{@speed}"
    if @route.nil? == false
      puts "Route Obj         - #{@route}"
      puts "Route name        - #{@route.name}"
      puts "Station           - #{@route.station}"
    end
    puts "Location            - #{@condition}"
    puts "curent station      - #{@curent_station}"
    puts "prev station        - #{@prev_station}"
    puts "next station        - #{@next_station}"
    puts 'Wagon list'

    block = proc { |wagon, i|
      print "#{(i + 1).to_s.rjust 5}  #{(wagon.reg_number.ljust 7)}  "\
                            "#{(wagon.type_wagon.ljust 14)} #{(wagon.location.center 15)}\n"
    }
    wagons_on_train(&block)
  end

  # ------------------------------------------------------------------------

  def wagons_on_train(&block)
    raise 'The composition of the train has not been formed!' if @wagons.empty?

    wagons.each_with_index(&block)
  rescue StandardError => e
    puts e.message
  end

  # ------------------------- attach a carriage to a train -------------------

  def add_car(car)
    raise 'Impossible to unhook the wagon! Stop the train!' unless speed.zero?
    raise 'The type of carriage does not match the type of train!' unless car.type_wagon == @type

    @num_of_cars += 1
    wagons << car
  rescue StandardError => e
    puts e.message
    false
  end

  # ------------------------------ unhook a train car ----------------------

  def del_car(car)
    raise 'Impossible to unhook the wagon! Stop the train!' unless speed.zero?
    raise "There is no such car #{car.reg_number} on the train!" unless wagons.include?(car)

    @num_of_cars -= 1
    wagons.each { |item| wagons.delete(item) if item == car }
  rescue StandardError => e
    puts e.message
    false
  end

  def validate!(number)
    raise ArgumentError, "Invalid train number format: #{number} !" if number !~ NUMBER_FORMAT
  end
end

class TrainValidator
  include Validate

  validates :number, type: String
  validates :number,
            msg: 'Invalid number format!',
            option: proc { |p| p.number =~ /^\d{3}-?[а-яА-Я]{2}$/i }
  validates :type, type: String
  validates :type,
            msg: 'Wrong train type!',
            option: proc { |p| %w[пассажирский грузовой].include? p.type }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'The number of cars cannot be less than 1!',
            option: proc { |p| p.num_of_cars > 0 }
end

class PassengerTrainValidator < TrainValidator
  validates :number, type: String
  validates :number,
            msg: 'Invalid number format!',
            option: proc { |p| p.number =~ /^\d{3}-?[а-яА-Я]{2}$/i }
  validates :type, type: String
  validates :type,
            msg: 'Wrong train type!',
            option: proc { |p| %w[пассажирский грузовой].include? p.type }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'The number of cars cannot be less than 1!',
            option: proc { |p| p.num_of_cars > 0 }
end

class CargoTrainValidator < TrainValidator
  validates :number, type: String
  validates :number,
            msg: 'Invalid number format!',
            option: proc { |p| p.number =~ /^\d{3}-?[а-яА-Я]{2}$/i }
  validates :type, type: String
  validates :type,
            msg: 'Wrong train type!',
            option: proc { |p| %w[пассажирский грузовой].include? p.type }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'The number of cars cannot be less than 1!',
            option: proc { |p| p.num_of_cars > 0 }
end
