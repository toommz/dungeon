RSpec.describe Dungeon do
  it "has a version number" do
    expect(Dungeon::VERSION).not_to be nil
  end

  describe ".run" do
    it "runs in a loop" do
      expect(described_class).to receive(:loop)
      described_class.run
    end

    it "should run smoothly" do
      allow(Readline).to receive(:readline).and_return('help', 'down', 'right', 'up', 'fight')
      expect { described_class.run }.not_to raise_error
    end
  end
end
