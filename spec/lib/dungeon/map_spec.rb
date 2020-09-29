RSpec.describe Dungeon::Map do
  let(:rooms) do
    [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9]
    ]
  end

  describe ".directions" do
    subject { described_class.directions }

    it { is_expected.to contain_exactly(:left, :up, :down, :right) }
  end

  describe "#available_moves" do
    let(:map) { described_class.new(rooms: rooms, start: [2, 1]) }

    it "returns all possible moves" do
      expect(map.possible_moves).to contain_exactly(:left, :up, :right)
    end
  end

  describe "#current_room" do
    subject { described_class.new(rooms: rooms, start: [2, 0]).current_room }

    it { is_expected.to eq(7) }
  end

  describe "#room_actions" do
    let(:room) { Dungeon::Room.new(title: '', actions: [successful_action("fight")]) }
    let(:rooms) { [[room]] }

    subject { described_class.new(rooms: rooms, start: [0, 0]).room_actions }

    it { is_expected.to contain_exactly(:fight) }
  end

  describe "#move" do
    let(:map) { described_class.new(rooms: rooms, start: [2, 1]) }

    it "returns the right room" do
      expect(map.move(:left)).to eq(7)
    end

    it "raises a KeepOutError when no room available" do
      expect { map.move(:down) }.to raise_error(Dungeon::Map::KeepOutError)
    end

    it "raises a UnknownDirectionError when the given direction does not exist" do
      expect { map.move(:past) }.to raise_error(Dungeon::Map::UnknownDirectionError)
    end
  end
end
