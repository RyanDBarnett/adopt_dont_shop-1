require 'rails_helper'

describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many :pets }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
