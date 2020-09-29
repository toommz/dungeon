require "simplecov"
SimpleCov.start if ENV['COVERAGE']

require "bundler/setup"
require "dungeon"

module Helpers
  def suppress_errors
    begin
      yield
    rescue Exception
    end
  end

  def successful_action(name)
    Dungeon::Action.new(name: name, behaviour: -> { true })
  end

  def failed_action(name)
    Dungeon::Action.new(name: name, behaviour: -> { false })
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end
