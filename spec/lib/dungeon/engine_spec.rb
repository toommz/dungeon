RSpec.describe Dungeon::Engine do
  let(:map) { double }

  subject { described_class.new(map: map) }

  describe "#present_room" do
    let(:left_room) { Dungeon::Room.new(title: 'Left room', actions: actions) }
    let(:right_room) { Dungeon::Room.new(title: 'Right room', actions: actions) }

    let(:rooms) { [[left_room, right_room]] }
    let(:map) { Dungeon::Map.new(rooms: rooms, start: [0, 0]) }

    context "when the room has actions" do
      let(:actions) { [successful_action("fight"), successful_action("run")] }

      it "returns the available actions" do
        expect(subject.present_room).to eq("Left room (fight/run)")
      end
    end

    context "when the room has no actions" do
      let(:actions) { [] }

      it "returns the possible moves" do
        expect(subject.present_room).to eq("Left room (right)")
      end
    end
  end

  describe "#process" do
    let(:actions) { [] }
    let(:room) { Dungeon::Room.new(title: '', actions: actions) }
    let(:rooms) { [[room]] }
    let(:map) { Dungeon::Map.new(rooms: rooms, start: [0, 0]) }

    context "when passing exit" do
      it "raises a Dungeon::Engine::EndOfGameError" do
        expect { subject.process(input: "exit") }.to raise_error(Dungeon::Engine::EndOfGameError)
      end
    end

    context "when passing a map direction" do
      %i[left right up down].each do |direction|
        it "delegates #{direction} to the map" do
          expect(map).to receive(:move).with(direction)

          subject.process(input: direction)
        end
      end

      context "when there is a room with actions" do
        let(:actions) { [successful_action("fight"), successful_action("run")] }

        it "raises a Dungeon::Engine::ActionRequiredError" do
          expect { subject.process(input: "left") }.to raise_error(Dungeon::Engine::ActionRequiredError)
        end
      end
    end

    context "when passing a room action" do
      let(:actions) { [successful_action("fight")] }

      it "is expected to delegate to the room" do
        expect(room).to receive(:play!).with(:fight).and_call_original

        suppress_errors do
          subject.process(input: "fight")
        end
      end

      context "when the action returns false" do
        let(:actions) { [failed_action("fight")] }

        it "is expected to raise a Dungeon::Engine::GameOverError" do
          expect { subject.process(input: "fight") }.to raise_error(Dungeon::Engine::GameOverError)
        end
      end

      context "when the action returns true" do
        let(:actions) { [successful_action("fight")] }

        it "is expected to raise a Dungeon::Engine::TheEndError" do
          expect { subject.process(input: "fight") }.to raise_error(Dungeon::Engine::TheEndError)
        end
      end
    end
  end
end
