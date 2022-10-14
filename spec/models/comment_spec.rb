require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "associations" do
    context "with belongs to" do
      it {is_expected.to belong_to(:user)}
    end
  end
end
