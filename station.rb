class Station
  require_relative 'instance_counter'
  require_relative 'accessors'
  include Accessors
  include InstanceCounter

  @@stations = []

  attr_reader :name
  # attr_accessor :trains
  attr_accessor_with_history :trains

  #------------------------------------ Station Obj list --------------------

  def self.all
    @@stations
  end

  def self.new_if_valid(*args)
    @errors = InitializationInvalidError.new
    raise 'Invalid arguments!' if validate(*args) == false
  rescue StandardError
    @errors.add(args[0], 'Invalid arguments!')
    raise @errors.all.to_s
    nil
  else
    new(*args)
  end

  def self.validate(*args)
    raise 'Invalid station name!' if args[0].empty? || args[0].empty?
  rescue StandardError
    @errors.add(args[0], "Invalid station name - #{args[0]}!")
    false
  else
    true
  end

  # --------------------------------- New station -------------------------

  def initialize(name_station)
    @name = name_station
    @trains = []
    @@stations.push(self)
    register_instance
  end

#  def to_s
#    name.to_s
#  end

  # --------------------------------------------------------------------------

  def errors
    return {} unless defined?(self)
    @errors
  end
  # ----------------------------------------------------------------------------

  def info(&block)
    raise "There are no trains at  #{self} station!" unless trains.any?

    trains.each(&block)
  end

  # --------------------------------- train arrival at the station -----------

  def train_arrival(train)
    trains << train
    train.arrive_at_the_station(self)
  end

  # ---------------------------- train departure from the station -------------

  def train_departure(train)
    if trains.include?(train)
      train.leave_the_station(self)
      trains.delete(train)
    else
      puts 'There is no such train at the station!'
    end
  end

  # ------------------------------ search Obj station by name ----------------

  def find_obj(name)
    @@stations.find { |station| station.name == name }
  end

  # ------------------------- show the list of trains at the station ----------

  def list_of_trains(type)
    num = 0
    raise "There are no trains at station #{name}!" if trains.empty?
    trains.each do |train|
      next unless train.type == type
      if num.zero?
        print "#{'№'.center 7} #{'Type'.center 16} #{'Route'.center 28} "\
              "#{'Station'.center 15} #{'Wagons'.center 7} #{'ObjTrain'.center 32}\n"
      end

      print "#{(train.number.center 7)} #{(train.type.center 14)} "
      if train.route.nil?
        print "#{(train.route.to_s.center 27)} "
      else
        print "#{(train.route.name.to_s.center 27)} "
      end
      print "#{(train.train_curent_station.to_s.center 15)} "\
            "#{(train.num_of_cars.to_s.center 7)} #{(train.to_s.center 32)} \n"
      num += 1
    end
    num
  rescue StandardError => e
    puts e.message
  end

  # --------------------------- list_of_trains_on_station ----

  def list_of_trains_on_station(name, &block)
    station = Station.all.find { |item| item.name == name }
    raise "There are no trains at #{station}!" if station.trains.empty?
    station.trains.each(&block)
  rescue StandardError => e
    puts e.message
  end

  # --------------------------------------------------------------------------

  def valid?
    raise 'Failure!' unless validate!(self)
    true
  rescue StandardError
    false
  end

  protected

  def validate!(object)
    raise 'Attr_reader :name not defined' unless object.methods.include? :name
    raise 'instance_variables not defined!' if object.instance_variables.size < 2
    raise 'Station name not defined!' if object.instance_variable_get(:@name).empty?
    raise 'Station name less than 1 character!' if object.instance_variable_get(:@name).empty?
    true
  rescue StandardError => e
    puts 'e.message ' + e.message
    false
  end
end

class InitializationInvalidError < StandardError
  attr_accessor :all

  def initialize
    @all = {}
  end

  def add(name, msg)
    (@all[name] ||= []) << msg
  end

  def full_messages
    @all.map do |e|
      "#{e.first.capitalize} #{e.last.join(' & ')}. "
    end.join
  end
end
