module Dungeon
  class Map
    class KeepOutError < StandardError; end
    class UnknownDirectionError < StandardError; end

    MOVES = {
      left: [0, -1],
      up: [-1, 0],
      right: [0, 1],
      down: [1, 0],
    }.freeze

    attr_reader :current_room

    def initialize(rooms:, start:)
      @rooms, @current = rooms, start
      @current_room = @rooms.dig(start.first, start.last)
    end

    def self.directions
      MOVES.keys
    end

    def room_actions
      current_room.available_actions
    end

    def possible_moves
      MOVES.reduce([]) do |ary, (move_name, move_value)|
        next_move = move_coordinates!(@current, move_value)
        next ary unless @rooms.dig(next_move.first, next_move.last)

        ary.push(move_name)
      rescue KeepOutError
        next ary
      end
    end

    def move(direction)
      raise UnknownDirectionError unless self.class.directions.include?(direction)

      next_coordinates = move_coordinates!(@current, MOVES[direction])
      next_room = @rooms.dig(next_coordinates.first, next_coordinates.last)

      raise KeepOutError unless next_room

      @current = next_coordinates
      @current_room = next_room
    end

    private

    def move_coordinates!(from, to)
      move_coordinates(from, to).tap { |coordinates| raise KeepOutError if coordinates.any?(&:negative?) }
    end

    def move_coordinates(from, to)
      [from, to].transpose.map { |indexes| indexes.reduce(&:+) }
    end
  end
end
