require "rails_helper"

RSpec.describe Author, type: :model do
  let(:author){ FactoryBot.create :author }

  let(:author_1){ FactoryBot.create :author }

  let(:author_2){ FactoryBot.create :author }

  describe "presence" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:dob) }
    it { is_expected.to validate_presence_of(:description) }
  end

  describe "Associations" do
    it { should have_many(:books).dependent(:destroy) }
  end

  describe "Validations" do
    context "when field name" do
      subject{FactoryBot.build(:author)}
      it {should validate_presence_of(:name)}
      it {is_expected.to validate_length_of(:name).is_at_least(Settings.author.min)}
      it {is_expected.to validate_length_of(:name).is_at_most(Settings.author.max)}
    end

    context "when field description" do
      subject{FactoryBot.build(:author)}
      it {should validate_presence_of(:description)}
      it {is_expected.to validate_length_of(:description).is_at_least(Settings.author.min)}
    end
  end

  describe "check scope" do
    context "orders by created_at descending" do
      it "Should order by created_at" do
        expect(Author.latest).not_to eq([author_1, author_2])
      end
    end
  end

  describe "when dispay image" do
    context "display image" do
      it "Should display image" do
        expect(author.display_image).to eq(Settings.user.avatar_default)
      end
    end
  end
end
