
require './lib/dbdefinitions.rb'
require './lib/botcalculation.rb'

Mongoid.load!("config/mongo.yml", :development)

=begin
FarmBot.where(:active => true).order_by([:name,:asc]).each do |farmbot|
  puts farmbot.inspect
  farmbot.crops.each do |crop|
    puts crop.inspect
  end
end
=end

FarmBot.where(:active => true).order_by([:name,:asc]).each do |farmbot|
  farmbot.crops.each do |crop|
    crop.scheduled_commands.each do |command|
	  command.delete
	end
  end
end



calc = BotScheduleCalculation.new
calc.calculateAllBots()

puts ''

FarmBot.where(:active => true).order_by([:name,:asc]).each do |farmbot|
  farmbot.crops.each do |crop|
    puts "bot: #{farmbot.name}"
    crop.scheduled_commands.each do |command|
	  puts "  command scheduled at #{command.execution_time}"
	  command.scheduled_command_lines.each do |line|
	    puts "    do #{line.action} at #{line.coord_x} / #{line.coord_y} / #{line.coord_z} amount #{line.amount}"
	  end
	end
  end
end

