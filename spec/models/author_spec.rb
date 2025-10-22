require 'rails_helper'

RSpec.describe Author, type: :model do
  describe "associations" do
    it { should have_many(:books).dependent(:restrict_with_error) }
  end

  describe "validations" do
    # ВИПРАВЛЕНО: вказуємо кастомне повідомлення
    it { should validate_presence_of(:name).with_message("повинно бути заповнене") }
  end

  describe "scopes" do
    let!(:active_author) { create(:author, active: true) }
    let!(:inactive_author) { create(:author, :inactive) }

    it "active scope повертає тільки активних" do
      expect(Author.active).to include(active_author)
      expect(Author.active).not_to include(inactive_author)
    end
  end
end
