module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :year, :model
  @@number_of_vehicles = 0

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def speed_up(number)
    @current_speed += number
    puts "You accelerate #{number} mph."
  end

  def brake(number)
    @current_speed -= number
    puts "You decelerate #{number} mph."
  end

  def current_speed
    puts "Your current speed is #{@current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "You have stopped the vehicle."
  end

  def spray_paint(color)
    self.color = color
    puts "You have spray painted your vehicle #{color}."
  end

  def self.number_of_vehicles
    puts "Total number of vehicles: #{@@number_of_vehicles}"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def age
    "Your #{model} is #{vehicle_age} years old"
  end

  private

  def vehicle_age
    Time.now.year - year
  end
end

class MyCar < Vehicle
  VEHICLE_TYPE = 'car'

  def to_s
    "Your car is a #{color} #{model} from #{year}."
  end
end

class MyTruck < Vehicle
  include Towable

  VEHICLE_TYPE = 'truck'

  def to_s
    "Your truck is a #{color} #{model} from #{year}."
  end
end

mercedes = MyCar.new(2010, 'silver', 'Mercedes B Class')
mercedes.speed_up(20)
mercedes.current_speed
mercedes.speed_up(30)
mercedes.current_speed
mercedes.brake(15)
mercedes.current_speed
mercedes.shut_down
mercedes.current_speed

puts mercedes.color
mercedes.color = 'black'
puts mercedes.color
puts mercedes.year

mercedes.spray_paint('pink')
puts mercedes.color

MyCar.gas_mileage(13, 351)

puts mercedes

Vehicle.number_of_vehicles

p Vehicle.ancestors
p MyCar.ancestors
p MyTruck.ancestors

puts mercedes.age