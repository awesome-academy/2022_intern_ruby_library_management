require "rails_helper"

RSpec.describe Book, type: :model do
  let(:book){ FactoryBot.create :book }

  describe "when dispay image" do
    context "display image" do
      it "Should display image" do
        expect(book.display_image).to eq("")
      end
    end
  end
end
