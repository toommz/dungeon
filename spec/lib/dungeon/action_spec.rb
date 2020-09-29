RSpec.describe Dungeon::Action do
  let(:name) { :fight }
  let(:behaviour) { -> { true } }
  let(:success_message) { nil }
  let(:failure_message) { nil }

  subject { described_class.new(name: name, behaviour: behaviour) }

  describe "#call" do
    it "calls the behaviour lambda" do
      expect(behaviour).to receive(:call)

      subject.call
    end

    context "on success" do
      it "returns a successful response" do
        expect(subject.call).to be_success
      end

      it "returns a default success message" do
        expect(subject.call.message).to eq("Congrats!")
      end
    end

    context "on failure" do
      let(:behaviour) { -> { false } }

      it "returns a failure response" do
        expect(subject.call).not_to be_success
      end

      it "returns a default failure message" do
        expect(subject.call.message).to eq("Damn!")
      end
    end
  end
end
