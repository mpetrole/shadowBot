require 'discordrb'

bot = Discordrb::Commands::CommandBot.new token: 'MzA3MDI3NjkzMjg1OTMzMDY3.C-Mckg.SB_oT3Wfop1Fhru0XmpJSvfwXTY', client_id: 307027693285933067, prefix: '/'
edge = false
rolls = []
user = nil

bot.command :roll do |event, num, arg|
  rolls.clear
  user = event.user.name
  rng = Random.new
  for n in (1..num.to_i) 
    rolls << rng.rand(1..6)
  end
  glitch = rolls.count(1) > (rolls.length / 2)
  hits = rolls.count(5) + rolls.count(6)
  crits = rolls.count(6)
  if arg == "e"
    for n in (0..crits)
      rolls << rng.rand(1..6)
    end
  end
  if glitch == true && hits == 0
    glitch = "critical"
  end
  event << "You rolled #{rolls}"
  event << "Glitch!" if glitch == true
  event << "Critical Glitch!" if glitch == "critical"
  event << "There were #{hits} hits and #{rolls.length - hits} misses"
  event << "Do /edge to use an edge to reroll the misses."
end

bot.command :edge do |event|
  if event.user.name == user
    rolls.each_with_index {|val, index| rolls[index] = rand(1..6) if val < 5}
    glitches = rolls.count(1)
    hits = rolls.count(5) + rolls.count(6)
    event << "Your new rolls are #{rolls}"
    event << "There are now #{glitches} glitches"
    event << "There are now #{hits} hits"
    user = ""
  else
    event << "You aren't #{user}!"
  end
end

bot.run