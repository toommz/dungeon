module Dungeon
  class Action
    attr_reader :name

    def initialize(name:, behaviour:, success_message: "Congrats!", failure_message: "Damn!")
      @name, @behaviour, @success_message, @failure_message = name.to_sym, behaviour, success_message, failure_message
    end

    def call
      result = @behaviour.()

      OpenStruct.new(success?: result, message: result ? @success_message : @failure_message)
    end
  end
end
