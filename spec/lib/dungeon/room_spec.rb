RSpec.describe Dungeon::Room do
  let(:title) { "You're about to enter the dungeon, where do we go first?" }
  let(:actions) { [] }

  let(:room) { described_class.new(title: title, actions: actions) }

  describe "#to_s" do
    subject { room.to_s }

    it { is_expected.to eq(title) }
  end

  describe "#available_actions" do
    subject { room.available_actions }

    context "when there are no actions" do
      it { is_expected.to eq([]) }
    end

    context "when there are actions" do
      let(:actions) { [successful_action("fight"), failed_action("run")] }

      it { is_expected.to contain_exactly(:run, :fight) }
    end
  end

  describe "#play!" do
    let(:actions) { [successful_action("fight")] }

    context "when the action is unknown" do
      let(:action) { :bark }

      it "raises a Dungeon::Room::UnknownAction error" do
        expect { room.play!(action) }.
          to raise_error(Dungeon::Room::UnknownAction)
      end
    end

    context "when the action exists" do
      let(:action) { :fight }

      it "calls the action behaviour" do
        expect(actions.first).to receive(:call)

        room.play!(action)
      end
    end
  end
end
