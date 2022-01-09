require_relative 'accessors'
require_relative 'instance_counter'
require_relative 'station'
require_relative 'route'
require_relative 'manufacturer'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'cargo_wagon'
require_relative 'validate'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'


class Main

  # MENU = [
  #   { index: 1, title: 'create new station', action: :new_station },
  #   { index: 2, title: 'create new route and manage on it', action: :route_action },
  #   { index: 3, title: 'create new train', action: :new_train },
  #   { index: 4, title: 'train menu ', action: :train_menu },
  #   { index: 5, title: 'set route for train', action: :set_route_for_train },
  #   { index: 6, title: 'move train on the route', action: :move_train_menu },
  #   { index: 7, title: 'show stations and trains at the station', action: :train_all_by_station },
  #   { index: 8, title: 'Object_list', action: :object_list },
  #   { index: 0, title: 'for exit', action: :break }
  # ].freeze

  MENU = [
    { index: 1, title: 'Route constructor', action: :route_action },
    { index: 2, title: 'Train constructor', action: :train_menu },
    { index: 3, title: 'Station dispatcher', action: :move_train_menu },
    { index: 4, title: 'Object_list', action: :object_list },
    { index: 0, title: 'for exit', action: :break }
  ].freeze

  MENU_LIST_OBJ = [
    { index: 1, title: 'list of wagons', action: :list_of_wagons },
    { index: 2, title: 'train_list', action: :train_list },
    { index: 3, title: 'station list', action: :station_list },
    { index: 4, title: 'route_list', action: :route_list },
    { index: 0, title: 'Back to Main-menu', action: :break }
  ].freeze

  MENU_ROUTE = [
    { index: 1, title: 'Create new station', action: :new_station },
    { index: 2, title: 'Delete station', action: :delete_station },
    { index: 3, title: 'Create new route', action: :new_route },
    { index: 4, title: 'Add station on route', action: :add_station },
    { index: 5, title: 'Delete station on route', action: :del_station },
    { index: 6, title: 'Show stations from route', action: :show_stations },
    { index: 7, title: 'Route info', action: :curent_route_info },
    { index: 8, title: 'station List', action: :station_list },
    { index: 0, title: 'Back to Main-menu', action: :break }
  ].freeze

  MENU_TRAIN = [
    { index: 1, title: 'create new train', action: :new_train },
    { index: 2, title: 'create new wagon', action: :new_car },
    { index: 3, title: 'delete wagon', action: :del_station },
    { index: 4, title: 'add car to train', action: :add_car_to_train },
    { index: 5, title: 'delete car from train', action: :del_car_from_train },
    { index: 6, title: 'set the route for the train', action: :set_route_for_train },
    { index: 7, title: 'show stations from route', action: :train_route_stations },
    { index: 8, title: 'Train info', action: :current_train_info }, 
    { index: 9, title: 'Select train by number', action: :train_find_by_number }, 
    { index: 10, title: 'list of Wagons', action: :list_of_wagons },
    { index: 11, title: 'Train_list', action: :train_list },
    { index: 0, title: 'Back to Main-menu', action: :break }
  ].freeze

  MENU_MOVE_TRAIN = [
    { index: 1, title: 'Show train at station', action: :show_trains_at_station },
    { index: 2, title: 'Take the train to the station', action: :take_train_to_station },
    { index: 3, title: 'Send a train from the station', action: :send_train_from_station },
    { index: 4, title: 'Take place in carriage', action: :buy_train_ticket },
    { index: 5, title: 'Return train ticket', action: :return_train_ticket },
    { index: 6, title: 'Occupy volume in carriage', action: :load_cargo_on_train },
    { index: 7, title: 'Unload volume from carriage', action: :unload_cargo_on_train },
    { index: 0, title: 'Back to Main-menu', action: :break }
  ].freeze

  attr_accessor :spr_station, :spr_train, :spr_route, :park_wagon
  # attr_reader :train, :station, :route

  def initialize
    @spr_station = Station.all
    @spr_route   = Route.all
    @spr_train   = Train.all
    @park_wagon  = Wagon.all
  end

  def menu_list
    MENU
  end

  def preparation_of_test_data
    name_station  = %w[Харьков Белгород Курск Орел Тула Москва]
    name_station1 = %w[Харьков Лозовая Запорожье Синельниково Новоалексеевка Симферополь]
    number_train  = %w[019-Ps 020-Ps 081-Ps 082-Ps 067-Ps 068-Ps]
    seats_wagons = [12, 54, 36, 18, 12, 12, 36, 54, 54, 54]

    num_wagon = 12_345_600

    # ---------------------------- Let's form a list of stations ------------------------------------

    name_st = name_station + name_station1
    name_st = name_st.uniq
    name_st = name_st.sort

    name_st.each do |name|
      station = Station.new(name)
    end

    # ---------------------------- Let's form a list of routes ------------------------------------

    route = Route.new('019', 'Харьков', 'Москва')
    route.station = name_station

    route = Route.new('020', 'Москва', 'Харьков')
    route.station = name_station.reverse

    route = Route.new('081', 'Харьков', 'Симферополь')
    route.station = name_station1

    route = Route.new('082', 'Симферополь', 'Харьков')
    route.station = name_station1.reverse

    route = Route.new('067', 'Москва', 'Симферополь')
    route.station = name_station.reverse + name_station1
    route.station = route.station.uniq

    route = Route.new('068', 'Симферополь', 'Москва')
    route.station = name_station1.reverse + name_station
    route.station = route.station.uniq

    # ----------------------------- Let's fill the train directory ----------

    number_train.each do |number|
      train = PassengerTrain.new(number, 10)

      # ---------------------------- We will form a train of wagons ---------

      seats_wagons.each do |ind|
        num_wagon += 1
        wagon = PassengerWagon.new(num_wagon.to_s, ind)
        train.wagons << wagon
        wagon.attach_wagon_to_train(train)
      end

      # ---------------------------- Assigning routes to trains --------------

      route = spr_route.find { |item| item.name.include?(number.to_s[0,3]) }
      train.assign_train_route(route)
      station = route.station[0]
      st_obj = spr_station.find { |item| item.name == station }
    end

    @train = spr_train[0]
    @station = spr_station.find { |item| item.name == 'Харьков' }
    @route = train.route unless train.nil?
  end

  # def main_menu

  #   loop do

  #     puts "Enter your choice or '0' for exit"

  #     MENU.each { |item| puts "#{item[:index].to_s.rjust 15} -  #{item[:title]}" }
  #     print '-> '

  #     choice = gets.chomp.to_i
  #     break if choice.zero?

  #     choice_item = MENU.find { |item| item[:index] == choice }
  #     send(choice_item[:action]) unless choice_item.nil?

  #   end
  # end

  def menu(menu)
    loop do
      puts "Enter your choice or '0' for exit"

      menu.each { |item| puts "#{item[:index].to_s.rjust 15} -  #{item[:title]}" }
      print '-> '

      choice = gets.chomp.to_i
      break if choice.zero?

      choice_item = menu.find { |item| item[:index] == choice }
      send(choice_item[:action]) unless choice_item.nil?
    end
  end

  private

  attr_accessor :train, :station, :route

  def route_action
    menu(MENU_ROUTE)
  end

  def object_list
    menu(MENU_LIST_OBJ)
  end

  def train_menu
    menu(MENU_TRAIN)
  end

  def move_train_menu
    menu(MENU_MOVE_TRAIN)
  end

  def list_of_wagons
    print "#{'№'.center 7} #{'Wagon type'.center 14} #{('Total'.center 6)} "\
          "#{('Occupied'.center 6)} #{('Free'.center 6)} "\
          "#{'Location'.center 15} #{'Obj'.center 25}\n"

    Wagon.all.each do |wagon|
      print "#{(wagon.reg_number.center 7)} "\
                                   "#{(wagon.type_wagon.ljust 14)} "\
                                   "#{(wagon.capacity.to_s.center 6)} "\
                                   "#{(wagon.loading.to_s.center 6)} "\
                                   "#{(wagon.location.center 15)} "\
                                   "#{wagon}\n"
    end
    puts
  end

  # ---------------------------------------- Train list -------------------

  def train_list
    print "#{'№'.center 7} #{'Train type'.center 16} #{'Route'.center 28} "\
          "#{'Station'.center 15} #{'Wagons'.center 7} #{'ObjTrain'.center 32}\n"

    Train.all.each do |train|
      print "#{(train.number.center 7)} #{(train.type.center 14)} "
      if train.route.nil?
        print "#{(train.route.to_s.center 27)} "
      else
        print "#{(train.route.name.to_s.center 27)} "
      end
      print "#{(train.train_curent_station.to_s.center 15)} "\
            "#{(train.num_of_cars.to_s.center 7)} #{(train.to_s.center 32)} \n"
    end
  end

  def tr_block
    proc { |tr| puts "Train № #{tr.number} #{tr.type} #{tr.num_of_cars}" }
  end 

  def wg_block
    proc { |w, i| puts "#{(i + 1).to_s.rjust 12} #{w.reg_number}  "\
                       "#{w.type_wagon} #{w.capacity} #{w.loading}"
    }
  end 

  def train_all_by_station

    Station.all.each do |station|
      puts "Station - #{station.name} \n"

      station.trains.each do |train|
        tr_block.call(train)
        train.wagons_on_train(&wg_block)
      end
    end
  end

  # ---------------------------------------- station list -------------------

  def station_list
    print " Obj_Station       Station name\n"
    Station.all.each { |station| print "#{station} #{station.name}  \n" }
  end

  # ---------------------------------------- route list -------------------

  def route_list
    spr_route.each do |route|
      print "#{(route.to_s.ljust 27)} \n"
      puts ' ' * 5 + route.station.to_s
    end
  end

  # ---------------create a new station and add it to the list of stations ----

  def input_string(title)
    print "#{title}: "
    gets.chomp.to_s
  end

  def input_int(title)
    print "#{title}: "
    gets.chomp.to_i
  end

  def find_station(name)
    spr_station.find { |item| item.name == name }
  end

def create_station(name)
    Station.new_if_valid(name)
  end

  def re_enter
    loop do
      print 'Continue input (0 - no, 1 - yes): '
      choice = gets.chomp.to_i
      return choice if [0, 1].include?(choice)
    end
  end

  def new_station
    name_st = input_string('Station name: ')

    st_obj = find_station(name_st)
    raise "The station #{st_obj.name} already exists!" unless st_obj.nil?

    create_station(name_st)
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  else
    puts "Station #{name_st} has been successfully created!"
    return st_obj
  end

  # ---------------- remove station from station list

  def delete_station
    name_st = input_string('Station name: ')

    st_obj = find_station(name_st)
    raise "There is no such station   #{name_st}!" if st_obj.nil?

    spr_station.delete(st_obj)
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  else
    puts "Station #{name_st} has been successfully deleted!"
  end

  # -------------------------------  create a new route -------------
  
  def new_route
    cod = input_string('Route code: ')

    beg_st = input_string('Starting station of the route: ')
    create_station(beg_st) if find_station(beg_st).nil?

    end_st = input_string('End station of the route: ')
    create_station(end_st) if find_station(end_st).nil?

    @route = Route.new(cod, beg_st, end_st)
    raise 'Unsuccessful attempt to create a route!' unless route.valid?
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  else
    puts "Route № #{cod} from #{beg_st} to #{end_st} has been successfully created!"
  end

  # ----------------------------- add station to route ------------------------

  def add_station
    work_st = route.station

    new_st = input_string('Add station to route: ')
    raise  'Such a station is on the list!' if work_st.include?(new_st)

    prev_st = input_string('Paste after station: ')
    raise 'There is no such station on the list!' unless work_st.include?(prev_st)

    raise 'This station is behind the end station!' if work_st.index(prev_st) == work_st.size - 1

    route.add_station(new_st, prev_st)
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  else
    puts "Station #{new_st} has been successfully added!"  
  end

  # ----------------------------- remove station from route -------------------

  def del_station
    new_st = input_string('Remove station from route: ')
    puts "Error while deleting station #{new_st}" if route.del_station(new_st).nil?
  end

  # ----------------------------- clear stations from route -------------------

  def clear_stations
    puts 'Error while deleting station' if route.clear_station.nil?
  end

  # ----------------------------- show stations from route --------------------

  def show_stations
    route.show_stations
  end

  def curent_route_info
    route.info
  end

  # ---------------------------------- create a new train ---------------
  def create_train(num_train, type, num_cars)
    CargoTrain.new(num_train, num_cars) if type == 1
    PassengerTrain.new(num_train, num_cars) if type == 2 
  end 
  
  def new_train
    num_train = input_string('Train number (123-Yz): ')
    raise ArgumentError, 'The number cannot be empty!' if num_train == ''

    type = input_string('Train type (1 - cargo, 2 - passenger): ').to_i
    raise ArgumentError, 'Train type must be - 1 or 2!' unless [1, 2].include? type

    num_cars = input_string('Number of wagons: ').to_i
    raise ArgumentError, 'There will be few wagons!' if num_cars < 1

    new_train = create_train(num_train, type, num_cars)
    raise 'Unsuccessful attempt to create a train!' unless new_train.valid?
    
    @train = new_train
    puts "Train number #{num_train} has been successfully created!"
    puts train
  rescue StandardError => e
    puts 'errors: ' + new_train.valid_errors.to_s unless new_train.nil?
    puts "#{e.class}: #{e.message}"
    retry if re_enter == 1
    puts 'Unsuccessful attempt to create a train!'
  end

  # -------------------------set active train №  --------

  def train_find_by_number
    train_list
    num_train = input_string('Input train number: ')
    find_train = spr_train.find{ |item| item.number == num_train }
    raise 'There is no such train!' if find_train.nil?
    @train = find_train
  #  @train.info
  rescue StandardError => e
    puts e.message
  end

  # ----------------------------------- create a new wagon --------------------
  def find_wagon(number)
    park_wagon.find { |item| item.reg_number == number }
  end  
  
  def new_car
    num_wagon = input_string('Wagon number: ')
    raise 'Such a wagon is on the list!' unless find_wagon(num_wagon).nil?

    type = input_string('Wagon type: (1 - cargo, 2 - passenger): ').to_i
    raise 'Invalid choice: (1, 2) !' unless [1, 2].include?(type)

    if type == 2
      capacity = input_string('Number of seats in the wagon: ').to_i
      wagon = PassengerWagon.new(num_wagon, capacity)
    else
      capacity = input_string('Wagon capacity: ')
      wagon = CargoWagon.new(num_wagon, capacity)
    end

    raise 'Error while creating a wagon!' if wagon.nil?
    puts "Wagon #{num_wagon} has been created!"
  rescue StandardError => e
    puts e.message
  end

  # ----------------------------- car+ - attach a wagon to a train ------

  def add_car_to_train
    raise 'Train not defined!' if train.nil?
    train.speed = 0
    list_of_wagons

    num_wagon = input_string('Wagon number: ')

    next_car = find_wagon(num_wagon)
    raise "There is no such wagon #{num_wagon}!" if next_car.nil?
    raise 'Failure!' unless train.add_car(next_car)
      next_car.attach_wagon_to_train(train)
      puts "Wagon number #{num_wagon} is successfully attached to the train № #{train.number}!"
    #end
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  end

  # -------------------------- - uncouple the wagon from the train ------------

  def del_car_from_train
    raise 'Train not defined!' if train.nil?
    train.speed = 0
    num_wagon = input_string('Uncouple the wagon № from the train: ')
    next_car = find_wagon(num_wagon)
    raise "There is no such wagon #{num_wagon}!" if next_car.nil?
    
    next_car.unhook_wagon_from_train(train)
    train.del_car(next_car)
    puts "Wagon #{num_wagon} is successfully uncoupled from the train #{train.number}!"
  
  rescue StandardError => e
    puts e.message
    retry if re_enter == 1
  end

  # --------------------------------- the number of cars on the train ---------

  def number_cars
    train.num_of_cars unless train.nil?
  end

  # -------------------------- set the route for the train ---------------------

  def set_route_for_train
    raise 'Train not defined!' if train.nil?
    train.assign_train_route(route)
  end

  def train_route_stations
    num_train = input_string('Train number: ')

    train_obj = spr_train.find { |item| item.number == num_train }
    if train_obj.nil?
      puts "There is no such train #{num_train}"
    else
      puts train_obj.route.station
    end
  end

  def train_to_next_stat
    st_obj = spr_station.find { |item| item.name == train.curent_station }
    train.train_forward(st_obj) unless st_obj.nil?
  end

  def train_back
    st_obj = spr_station.find { |item| item.name == train.curent_station }
    train.train_back(st_obj) unless st_obj.nil?
  end

  # ------------------------------- buy a train ticket --------------------

  def buy_train_ticket
    train_obj = train_find_by_number
    raise 'There is no such train!' if train_obj.nil?

    train_obj.wagons_on_train
    max = train_obj.num_of_cars
    
    num = input_string('Select wagon number: ').to_i
    raise "Incorrect wagon number! It should be: 1-#{max}!" unless (1..max).cover? num
    puts "1 ticket for the carriage of #{(num - 1).to_s} trains #{train_obj.number}"
    train_obj.wagons[num - 1].take_a_seat
  rescue StandardError => e
    puts "#{e.class}: #{e.message}"
    retry if re_enter == 1
  end

  # ------------------------------ Return train ticket --------------------

  def return_train_ticket
    train_obj = train_find_by_number
    raise 'There is no such train!' if train_obj.nil?

    train_obj.wagons_on_train
    max = train_obj.num_of_cars
    
    num = input_string('Select wagon number: ').to_i
    raise "Incorrect wagon number! It should be: 1-#{max}!" unless (1..max).cover? num
    puts "Return train ticket for the carriage of #{(num - 1).to_s} trains #{train_obj.number}"
    train_obj.wagons[num - 1].refund_a_seat
  rescue StandardError => e
    puts "#{e.class}: #{e.message}"
    retry if re_enter == 1
  end

  # ------------------------------- Send cargo on the train -----------------

  def load_cargo_on_train
    train_obj = train_find_by_number
    raise 'There is no such train!' if train_obj.nil?

    train_obj.wagons_on_train
    max = train_obj.num_of_cars
    
    num = input_string('Select wagon number: ').to_i
    raise "Incorrect wagon number! It should be: 1-#{max}!" unless (1..max).cover? num

    volume = input_string('Enter cargo volume: ').to_i
    raise 'The volume of the cargo should not be < 0 !' if volume < 0

    puts "Send cargo on the train #{(num - 1).to_s} trains #{train_obj.number}"
    train_obj.wagons[num - 1].take_volume(volume)
  rescue StandardError => e
    puts "#{e.class}: #{e.message}"
    retry if re_enter == 1
  end

  # <------------------------------- Unload the wagon on the train ------------

  def unload_cargo_on_train
    train_obj = train_find_by_number
    raise 'There is no such train!' if train_obj.nil?

    train_obj.wagons_on_train
    max = train_obj.num_of_cars
    
    num = input_string('Select wagon number: ').to_i
    raise "Incorrect wagon number! It should be: 1-#{max}!" unless (1..max).cover? num

    volume = input_string('Enter cargo volume: ').to_i
    raise 'The volume of the cargo should not be < 0 !' if volume < 0

    puts "Unload the wagon on the train #{(num - 1).to_s} trains #{train_obj.number}"
    train_obj.wagons[num - 1].unload_volume(volume)
  rescue StandardError => e
    puts "#{e.class}: #{e.message}"
    retry if re_enter == 1
  end

  # <------------------------------ take a train to station -----------------

  def take_train_to_station
    # train_list
    train_obj =  train_find_by_number
    next_station = train_obj.train_next_station

    if train_obj.nil?
      puts "There is no such train! #{num_train}"
    elsif next_station.nil? == false
      train_obj.speed = 0

      st_obj = spr_station.find { |item| item.name == next_station }
      st_obj.train_arrival(train_obj)
      puts "Train #{train_obj.number} arrived on station: #{train_obj.condition}."
    end
  end

  # <------------------------------ Send a train from the station  -----------

  def send_train_from_station
    # train_list
    train_obj =  train_find_by_number
    if train_obj.nil?
      puts "There is no such train! #{num_train}"
    else
      cur_station = train_obj.curent_station

      if cur_station.nil? == false

        train_obj.speed = 80
        st_obj = spr_station.find { |item| item.name == cur_station }
        st_obj.train_departure(train_obj) if st_obj.nil? == false
        puts "Train #{train_obj.number} sent on the way: #{train_obj.condition}."
      end
    end
  end

  # <------------------------------ show trains at the station ----------------

  def show_trains_at_station
    station_list
    name_station = input_string('Show trains at the station: ')
    st_obj = spr_station.find { |item| item.name == name_station }

    type = input_string('Wagon type (0 - грузовой, 1 - пассажирский): ').to_i

    type_train = 'грузовой' if type.zero?
    type_train = 'пассажирский' if type == 1

    if st_obj.nil?
      puts "here is no such train! #{st_obj.name}!"
    else
      block = proc do |tr|
        puts "#{tr.number}  #{tr.type} #{tr.num_of_cars}" if tr.type == type_train
      end
      st_obj.list_of_trains_on_station(name_station, &block)
    end
  end

  # -------------------------- Train speed -------------------------

  def set_train_speed(speed)
    train.speed = speed
  end

  def show_train_speed
    puts train.speed
  end

  # -------------------------- Train info--------------------------------

  def current_train_info
    train.info
  end
end

main = Main.new
main.preparation_of_test_data
main.menu(main.menu_list)
