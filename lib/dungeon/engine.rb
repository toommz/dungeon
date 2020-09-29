module Dungeon
  class Engine
    class EndOfGameError < StandardError; end
    class GameOverError < StandardError; end
    class TheEndError < StandardError; end
    class ActionRequiredError < StandardError; end

    EXIT = :exit

    def initialize(map:)
      @map = map
    end

    def present_room
      "#{@map.current_room} (#{actions})"
    end

    def process(input:)
      input = input.to_sym

      case input
      when EXIT
        raise EndOfGameError
      when *Dungeon::Map.directions
        raise ActionRequiredError if room_actions
        @map.move(input)
      when *@map.room_actions
        result = @map.current_room.play!(input)

        if result.success?
          raise TheEndError.new(result.message)
        else
          raise GameOverError.new(result.message)
        end
      end
    end

    private

    def actions
      room_actions || @map.possible_moves.join('/')
    end

    def room_actions
      @map.room_actions.join('/') if @map.room_actions.any?
    end
  end
end
