require "readline"
require "ostruct"

require "dungeon/version"
require "dungeon/engine"
require "dungeon/map"
require "dungeon/room"
require "dungeon/action"

module Dungeon
  class Error < StandardError; end
  # Your code goes here...

  def self.run
    engine = Engine.new(map: build_map)

    loop do
      puts engine.present_room
      input = Readline.readline("> ", true).strip.downcase

      next print_help if input == "help"

      engine.process(input: input)
    rescue Map::KeepOutError, Dungeon::Engine::ActionRequiredError
      puts "Please provide an answer from the ones presented"
      next
    rescue Engine::EndOfGameError
      break
    rescue Engine::GameOverError, Engine::TheEndError => e
      puts e.message
      break
    end
  end

  def self.print_help
    puts "exit: Exit the game"
    puts "help: Print this help"
  end

  def self.build_map
    top_right = Dungeon::Room.new(title: "Oh my god, you're facing Giggly Giggle, your arch enemy, what will you do?", actions: [
      Action.new(name: 'fight', behaviour: -> { (rand 10) > 2 }, success_message: "You have finally won over your arch enemy, he is KO and lying on the floor now", failure_message: "Your arch enemy just kicked your ass!"),
      Action.new(name: 'run', behaviour: -> { (rand 10) > 8 }, success_message: "Giggly Giggle may have tall legs, nothing beats your ability to run out from danger, you are now safe", failure_message: "You tried to run but he kicked your ass anyway")
    ])
    top_center = Dungeon::Room.new(title: "Some old newspapers on the floor, the right door seems to be opened. Where do you want to go?")
    top_left = Dungeon::Room.new(title: "This room is totally empty, where the heck is Giggly Giggle?")
    bottom_right = Dungeon::Room.new(title: "The door going up is widely open. Where do you want to go?")
    bottom_center = Dungeon::Room.new(title: "Let's start exploring the dungeon, where do you want to go?")
    bottom_left = Dungeon::Room.new(title: "Nothing here, only some sort of giggling toys on the floor. Where do you go now?")

    Dungeon::Map.new(rooms: [
      [top_left, top_center, top_right],
      [bottom_left, bottom_center, bottom_right]
    ], start: [1, 1])
  end
end
