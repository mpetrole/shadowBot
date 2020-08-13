require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: '', client_id: , prefix: '/'
dice = []
rolls = {}
player_list = {}

bot.command :roll do |event, num, arg|
  if num == "help"
    event << "'/roll number (e)' rolls number of dice. If e is added, it will use exploding dice."
    break
  end
  dice.clear
  user = event.member.user_name
  rng = Random.new
  for n in (1..num.to_i) 
    dice << rng.rand(1..6)
  end
  crits = dice.count(6)
  if arg == "e"
    for n in (1..crits)
      dice << rng.rand(1..6)
    end
  end
  glitch = dice.count(1) > (dice.length / 2)
  hits = dice.count(5) + dice.count(6)
  if glitch == true && hits == 0
    glitch = "critical"
  end
  rolls[user] = dice
  event << "#{user} rolled #{dice}"
  event << "There were #{hits} hits and #{dice.length - hits} misses"
  event << "Glitch!" if glitch == true
  event << "Critical Glitch!" if glitch == "critical"
  event << "Do /edge to use an edge to reroll the misses."
end

bot.command :edge do |event|
  user = event.member.display_name
  if rolls.has_key?(user)
    dice = rolls[user]
    dice.each_with_index {|val, index| dice[index] = rand(1..6) if val < 5}
    glitch = dice.count(1) > (dice.length / 2)
    hits = dice.count(5) + dice.count(6)
    if glitch == true && hits == 0
      glitch = "critical"
    end
    event << "#{user}'s new rolls are #{dice}"
    event << "There are now #{hits} hits and #{dice.length - hits} misses"
    event << "Glitch!" if glitch == true
    event << "Critical Glitch!" if glitch == "critical"
  else
    event << "#{user} hasn't rolled yet!"
  end
end

bot.command :player do |event, arg1, arg2|
  if arg1 == 'list'
    event << "Current players are:"
    player_list.each {|key, value| event << "#{key} has initiative type #{value}"}
  elsif arg1 == 'remove'
    player_list.delete(arg2) {|pl| event << "#{pl} was not found"}
    event << "Player #{arg2} has been removed from the list."
  elsif arg1 == "help"
    event << "'/player add <player>' adds the player to the list"
    event << "'/player list' displays current players and their initiative types"
    event << "'remove <player>' removes a player. '<player>' <initiative type> sets"
    event << "the given players initiative type."
  elsif arg1 == "add"
    player_list[arg2] = 'none'
    event << "Added player #{arg1}"
  elsif player_list.has_key?(arg1)
    player_list[arg1] = arg2
    event << "#{arg1} is now set to #{player_list[arg1]}"
  else
    event << "I'm not sure what you are trying to do. Try /player help"
  end
end
bot.run
