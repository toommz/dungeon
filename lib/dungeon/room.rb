module Dungeon
  class Room
    class UnknownAction < StandardError; end

    def initialize(title:, actions: {})
      @title = title
      @actions = actions
    end

    def to_s
      @title
    end

    def available_actions
      @actions.map(&:name)
    end

    def play!(action)
      requested_action = @actions.find { |a| a.name == action }
      raise UnknownAction unless requested_action

      requested_action.call
    end
  end
end
