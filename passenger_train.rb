class PassengerTrain < Train
  def initialize(number, num_of_cars)
    super(number, 'пассажирский', num_of_cars)
  end

  def wagons_on_train
    raise 'The composition of the train has not been formed!' if @wagons.empty?

    print "Train № #{(number.center 15)}\n "\
          "#{('№'.center 5)} "\
          "#{('Total'.center 6)} #{('Occupied'.center 6)} #{('Free'.center 6)} "\
          "#{('Type'.center 14)} #{('Number'.center 10)} \n"

    block = proc do |wagon, i|
      print "#{(i + 1).to_s.rjust 5} #{(wagon.total_seats.to_s.center 6)} "\
            "#{(wagon.occupied_seats.to_s.center 6)} #{(wagon.free_seats.to_s.center 6)} "
      print "#{(wagon.type_wagon.center 14)} #{(wagon.reg_number.center 10)} \n"
    end
    super(&block)
  rescue StandardError => e
    puts e.message
  end
end

class PassengerTrainValidator
  include Validate
  
  validates :number, type: String
  validates :number,
            msg: 'Invalid number format!',
            option: proc { |p| p.number =~ /^\d{3}-?[a-zA-Z]{2}$/i }
  validates :type, type: String
  validates :type,
            msg: 'Wrong train type!',
            option: proc { |p| p.type == 'пассажирский' }
  validates :num_of_cars, type: Integer
  validates :num_of_cars,
            msg: 'The number of cars cannot be less than 1!',
            option: proc { |p| p.num_of_cars > 0 }
end
