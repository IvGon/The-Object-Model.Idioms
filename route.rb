class Route
  require_relative 'instance_counter'
  include InstanceCounter

  attr_reader :name
  attr_accessor :station

  @@list_routes = []

  # ------------------------------------- New route -----------------------

  def initialize(cod_route, begin_station, end_station)
    if validate!(cod_route, begin_station, end_station)
      @name = "#{cod_route}: #{begin_station} - #{end_station}"
      @station = [begin_station, end_station]
      register_instance
      @@list_routes.push(self)
    end
  end

  #--------------------------------- station Obj list ----------------------
  def self.all
    @@list_routes
  end

  # --------------------------------- add_station --------------
  def add_station(name_st, prev_st)
    raise "There is no such station #{prev_st} in the list!" unless station.include?(prev_st)
    @station.insert(@station.index(prev_st) + 1, name_st)
  end

  # -------------------------------- del_station  ----------------

  def del_station(name_st)
    raise "There is no such station #{name_st} in the list!" unless station.include?(name_st)
    raise 'Attempt to delete the beginning of the route!' if name_st == station.first
    raise 'Attempting to delete the destination of the route!' if name_st == station.last
    station.delete(name_st)
  end

  # -------------------------------- clear station -------------------------

  def clear_stations
    beg_st = @station.first
    end_st = @stationх.last
    @station.clear
    @station << beg_st << end_st
  end

  # ------------------------------- show_stations ---------------

  def show_stations
    @station.each { |name_st| print "#{name_st} " }
    puts
  end

  # ------------------------------- Route info ---------------------

  def info
    puts "Route name          - #{@name}"
    puts "Number of stations  - #{@station.size}"
    puts "Starting station    - #{@station[0]}"
    puts "End station         - #{@station[-1]}"
    print 'Route composition    '
    show_stations
  end

  def to_s
    @name.to_s
  end

  def valid?
    raise 'Failure!' unless validate!(@name, @station.first, @station.last)
    true
  rescue StandardError
    false
  end

  protected

  def validate!(*args)
    raise 'Invalid route number!' if args[0].empty?
    raise 'The route cannot have less than 2 stations!' if args[1].empty? || args[2].empty?
  rescue Exception => e
    puts 'e.message ' + e.message
    false
  else
    true
  end
end
